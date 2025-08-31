import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/horarios_clases/data/models/horario_clase_model.dart';
import 'package:tutorconnect/features/horarios_clases/helper/horario_helper.dart';
import 'package:tutorconnect/features/horarios_clases/application/providers/horarios_clases_provider.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/features/aulas/helpers/aula_helper.dart';
import 'package:tutorconnect/features/tutoria_estudiante/helper/tutoria_estudiante_helper.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';
import 'package:tutorconnect/features/usuarios/helpers/usuario_helper.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class ClaseDetalleScreen extends ConsumerStatefulWidget {
  final MateriaModel materia;

  const ClaseDetalleScreen({super.key, required this.materia});

  @override
  ConsumerState<ClaseDetalleScreen> createState() => _ClaseDetailScreenState();
}

class _ClaseDetailScreenState extends ConsumerState<ClaseDetalleScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(horariosClasesProvider.notifier).getAllHorarios());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    final List<HorarioClaseModel> horarios = getHorariosByMateria(ref, widget.materia.id);
    final List<TutoriaModel> tutorias = getAllTutoriasByMateriaId(ref, widget.materia.id);
    final List<UsuarioModel> estudiantes = getAllEstudiantesByMateria(ref, widget.materia.id);

    final bool isDocente = currentUser?.rol == UsuarioRol.docente;
    final bool isEstudiante = currentUser?.rol == UsuarioRol.estudiante;

    return Scaffold(
      appBar: AppBar(title: Text(widget.materia.nombre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.materia.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),

              // 🔹 Horarios
              if (horarios.isEmpty)
                const Text('No hay horarios asignados.')
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: horarios.map((horario) {
                    final aula = getAulaById(ref, horario.aulaId);
                    final profesor = getUsuarioById(ref, horario.profesorId);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Día: ${horario.diaSemana.name.toUpperCase()}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('Hora: ${horario.horaInicio} - ${horario.horaFin}', style: const TextStyle(fontSize: 14)),
                          Text('Aula: ${aula.nombre} - ${aula.tipo}', style: const TextStyle(fontSize: 14)),
                          if (isEstudiante)
                            Text('Profesor: ${profesor.nombreCompleto}', style: const TextStyle(fontSize: 14)),
                          const Divider(),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 16),

              // 🔹 Estudiantes (solo si el usuario es docente)
              if (isDocente) ...[
                const Text('Estudiantes inscritos:', style: TextStyle(fontWeight: FontWeight.bold)),
                if (estudiantes.isEmpty)
                  const Text('No hay estudiantes inscritos.')
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: estudiantes.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(e.nombreCompleto, style: const TextStyle(fontSize: 14)),
                    )).toList(),
                  ),
                const SizedBox(height: 16),
              ],

          // 🔹 Tutorías en formato lista vertical con navegación
          if (tutorias.isEmpty)
            const Text('No hay tutorías asignadas.')
          else
            Column(
              children: tutorias.map((tutoria) {
                return Container(
                  width: double.infinity, // Ocupa todo el ancho disponible
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detalleTutoria, // Ruta de detalle
                        arguments: tutoria,        // Pasamos la tutoría
                      );
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tema
                            Text(
                              tutoria.tema,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Text(
                              'Fecha: ${DateFormat('dd/MM/yyyy').format(tutoria.fecha.toDate())}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              'Hora: ${tutoria.horaInicio} - ${tutoria.horaFin}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),


          ],
        ),
      ),
    );
  }
}
