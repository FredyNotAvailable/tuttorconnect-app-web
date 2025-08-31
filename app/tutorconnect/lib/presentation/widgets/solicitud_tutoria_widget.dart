import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/solicitud_estudiante/application/providers/solicitudes_tutorias_provider.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/solicitud_estudiante/helpers/solicitud_tutoria_helper.dart';
import 'package:tutorconnect/features/tutoria_estudiante/helper/tutoria_estudiante_helper.dart';
import 'package:tutorconnect/features/tutorias/application/providers/tutoria_provider.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';
import 'package:tutorconnect/features/usuarios/application/providers/usuario_provider.dart';
import 'package:tutorconnect/features/usuarios/helpers/usuario_helper.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class SolicitudesTutoriasWidget extends ConsumerStatefulWidget {
  const SolicitudesTutoriasWidget({super.key});

  @override
  ConsumerState<SolicitudesTutoriasWidget> createState() => _SolicitudesTutoriasWidgetState();
}

class _SolicitudesTutoriasWidgetState extends ConsumerState<SolicitudesTutoriasWidget> {
  DateTimeRange? filtroFecha;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(solicitudesTutoriasProvider.notifier).getAllSolicitudes());
    Future.microtask(() => ref.read(usuarioProvider.notifier).getAllUsuarios());
    Future.microtask(() => ref.read(tutoriaProvider.notifier).getAllTutorias());
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '-';
    final date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
  }

  Future<void> _confirmAction(BuildContext context, String title, String message, VoidCallback onConfirm) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    if (result == true) {
      onConfirm();
    }
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
  final state = ref.watch(solicitudesTutoriasProvider);
  final authState = ref.watch(authProvider);
  final currentUser = authState.user;

  if (state.loading) return const Center(child: CircularProgressIndicator());
  if (state.error != null) return Center(child: Text('Error: ${state.error}'));

  // Filtrar solicitudes según permisos
  var solicitudes = (state.solicitudes ?? []).where((solicitud) {
    return (currentUser?.id == solicitud.estudianteId) ||
           (currentUser?.rol == UsuarioRol.docente);
  }).toList();

  // Filtrar por rango de fechas usando la fecha de la tutoria
  if (filtroFecha != null) {
    solicitudes = solicitudes.where((s) {
      final tutoria = getTutoriaById(ref, s.tutoriaId);
      if (tutoria.fecha == null) return false;
      final fechaTutoria = tutoria.fecha!.toDate();
      return !fechaTutoria.isBefore(filtroFecha!.start) &&
             !fechaTutoria.isAfter(filtroFecha!.end);
    }).toList();
  }

  // Agrupar por materia
  final Map<String, List<SolicitudTutoriaModel>> solicitudesPorMateria = {};
  for (var s in solicitudes) {
    final tutoria = getTutoriaById(ref, s.tutoriaId);
    if (!solicitudesPorMateria.containsKey(tutoria.materiaId)) {
      solicitudesPorMateria[tutoria.materiaId] = [];
    }
    solicitudesPorMateria[tutoria.materiaId]!.add(s);
  }

  return Column(
    children: [
      // Botón de filtro de fechas siempre visible
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


      
      Expanded(
  child: solicitudesPorMateria.isEmpty
      ? const Center(child: Text('No hay solicitudes de tutoría en el rango seleccionado'))
      : ListView(
          padding: const EdgeInsets.all(16),
          children: solicitudesPorMateria.entries.map((entry) {
            final materia = getMateriaById(ref, entry.key);
            final solicitudesMateria = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  materia.nombre,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...solicitudesMateria.map((solicitud) {
                  final estudiante = getUsuarioById(ref, solicitud.estudianteId);
                  final tutoria = getTutoriaById(ref, solicitud.tutoriaId);
                  final puedeActuar = (currentUser?.id == solicitud.estudianteId) ||
                                      (currentUser?.rol == UsuarioRol.docente);

                  return SizedBox(
                    width: double.infinity, // ocupa todo el ancho disponible
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 4), // solo margen vertical
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tutoría: ${tutoria.tema}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 6),
                            Text('Estudiante: ${estudiante.nombreCompleto}'),
                            Text('Fecha de envío: ${formatDate(solicitud.fechaEnvio)}'),
                            Text('Fecha de respuesta: ${formatDate(solicitud.fechaRespuesta)}'),
                            Text('Estado: ${solicitud.estado.value[0].toUpperCase()}${solicitud.estado.value.substring(1)}'),
                            const SizedBox(height: 8),
                            if (puedeActuar && solicitud.estado == EstadoSolicitud.pendiente)
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _confirmAction(
                                        context,
                                        'Aceptar solicitud',
                                        '¿Estás seguro de aceptar esta solicitud?',
                                        () async {
                                          final updated = solicitud.copyWith(
                                            estado: EstadoSolicitud.aceptado,
                                            fechaRespuesta: Timestamp.now(),
                                          );
                                          await updateSolicitudHelper(ref, updated);
                                          await asignarEstudianteATutoria(ref, solicitud.tutoriaId, solicitud.estudianteId);
                                        },
                                      );
                                    },
                                    child: const Text('Aceptar'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                    onPressed: () {
                                      _confirmAction(
                                        context,
                                        'Rechazar solicitud',
                                        '¿Estás seguro de rechazar esta solicitud?',
                                        () async {
                                          final updated = solicitud.copyWith(
                                            estado: EstadoSolicitud.rechazado,
                                            fechaRespuesta: Timestamp.now(),
                                          );
                                          await updateSolicitudHelper(ref, updated);
                                        },
                                      );
                                    },
                                    child: const Text('Rechazar'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
),




    ],
  );
}

}
