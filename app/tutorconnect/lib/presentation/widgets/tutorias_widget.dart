import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/features/aulas/application/providers/aula_provider.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/tutoria_estudiante/application/providers/tutorias_estudiantes_provider.dart';
import 'package:tutorconnect/features/tutorias/application/providers/tutoria_provider.dart';
import 'package:tutorconnect/features/materias/application/providers/materia_provider.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/usuarios/application/providers/usuario_provider.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class TutoriasWidget extends ConsumerStatefulWidget {
  const TutoriasWidget({super.key});

  @override
  ConsumerState<TutoriasWidget> createState() => _TutoriasWidgetState();
}

class _TutoriasWidgetState extends ConsumerState<TutoriasWidget> {
  DateTimeRange? filtroFecha; // rango de fechas seleccionado

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(tutoriaProvider.notifier).getAllTutorias());
    Future.microtask(() => ref.read(materiaProvider.notifier).getAllMaterias());
    Future.microtask(() => ref.read(usuarioProvider.notifier).getAllUsuarios());
    Future.microtask(() => ref.read(aulaProvider.notifier).getAllAulas());
    Future.microtask(() => ref.read(tutoriasEstudiantesProvider.notifier).getAllTutoriasEstudiantes());
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '-';
    final date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: filtroFecha,
    );
    if (picked != null) {
      setState(() {
        filtroFecha = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tutoriaProvider);
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    if (state.loading) return const Center(child: CircularProgressIndicator());
    if (state.error != null) return Center(child: Text('Error: ${state.error}'));

    final allTutorias = state.tutorias ?? [];

    // Filtrar por rango de fechas si se seleccionó
    var tutoriasFiltradas = allTutorias;
    if (filtroFecha != null) {
      tutoriasFiltradas = allTutorias.where((t) {
        final fecha = t.fecha.toDate();
        return !fecha.isBefore(filtroFecha!.start) &&
               !fecha.isAfter(filtroFecha!.end);
      }).toList();
    }

    // Agrupar por materia
    final Map<String, List<TutoriaModel>> tutoriasPorMateria = {};
    for (var t in tutoriasFiltradas) {
      if (!tutoriasPorMateria.containsKey(t.materiaId)) {
        tutoriasPorMateria[t.materiaId] = [];
      }
      tutoriasPorMateria[t.materiaId]!.add(t);
    }

    return Scaffold(
      body: Column(
        children: [
          // Botón de filtro de fechas horizontal y ancho completo
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      filtroFecha != null
                          ? '${filtroFecha!.start.day}/${filtroFecha!.start.month}/${filtroFecha!.start.year} - '
                            '${filtroFecha!.end.day}/${filtroFecha!.end.month}/${filtroFecha!.end.year}'
                          : 'Filtrar por fechas',
                      textAlign: TextAlign.center,
                    ),
                    onPressed: _pickDateRange,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                if (filtroFecha != null) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filtroFecha = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    child: const Icon(Icons.clear),
                  ),
                ],
              ],
            ),
          ),


          
            // Lista de tutorías o mensaje "No hay tutorías"
            Expanded(
              child: tutoriasPorMateria.isEmpty
                  ? const Center(child: Text('No hay tutorías en el rango seleccionado'))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: tutoriasPorMateria.entries.map((entry) {
                        final materia = getMateriaById(ref, entry.key);
                        final tutorias = entry.value;

                        return Container(
                          width: double.infinity, // ocupa todo el ancho
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                materia.nombre,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...tutorias.map((tutoria) {
                                return SizedBox(
                                  width: double.infinity, // ocupa todo el ancho disponible
                                  child: InkWell(
                                    onTap: () async {
                                      final updatedTutoria = await Navigator.pushNamed(
                                        context,
                                        AppRoutes.detalleTutoria,
                                        arguments: tutoria,
                                      ) as TutoriaModel?;

                                      if (updatedTutoria != null) {
                                        ref.read(tutoriaProvider.notifier).updateTutoria(updatedTutoria);
                                      }
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.symmetric(vertical: 4), // solo margen vertical
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tema: ${tutoria.tema}',
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Fecha: ${formatDate(tutoria.fecha)} | Hora: ${tutoria.horaInicio} - ${tutoria.horaFin}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),



        ],
      ),
      floatingActionButton: currentUser?.rol == UsuarioRol.docente
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.crearTutoria);
              },
              tooltip: 'Crear nueva tutoría',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
