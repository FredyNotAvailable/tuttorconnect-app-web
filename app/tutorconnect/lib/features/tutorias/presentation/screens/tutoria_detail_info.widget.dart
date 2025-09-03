import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/models/asistencia_tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/core/utils/date_utils.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutoria_actions.dart';

class TutoriaDetailInfoWidget extends ConsumerWidget {
  final TutoriaModel tutoria;
  final List<UsuarioModel> estudiantes;
  final Map<String, AsistenciaTutoriaModel> asistencias;
  final bool isDocente;
  final bool tutoriaTerminada;
  final String aulaNombre;
  final String aulaTipo;
  final String materiaNombre;
  final String profesorNombre;

  const TutoriaDetailInfoWidget({
    super.key,
    required this.tutoria,
    required this.estudiantes,
    required this.asistencias,
    required this.isDocente,
    required this.tutoriaTerminada,
    required this.aulaNombre,
    required this.aulaTipo,
    required this.materiaNombre,
    required this.profesorNombre,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Tema: ${tutoria.tema}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Descripción: ${tutoria.descripcion.isNotEmpty ? tutoria.descripcion : "-"}'),
        const SizedBox(height: 8),
        Text('Profesor: $profesorNombre'),
        const SizedBox(height: 8),
        Text('Materia: $materiaNombre'),
        const SizedBox(height: 8),
        Text('Aula: $aulaNombre - $aulaTipo'),
        const SizedBox(height: 8),
        Text('Fecha y Hora: ${formatDate(tutoria.fecha)} | ${tutoria.horaInicio} - ${tutoria.horaFin}'),
        const SizedBox(height: 8),
        Text('Estado: ${tutoria.estado.name}'),
        const SizedBox(height: 16),
        const Text('Estudiantes inscritos:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        if (estudiantes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: Text("No hay estudiantes inscritos.")),
          )
        else
          ...estudiantes.map((estudiante) {
            final asistencia = asistencias[estudiante.id] ??
                AsistenciaTutoriaModel(
                  id: '',
                  estudianteId: estudiante.id,
                  tutoriaId: tutoria.id,
                  estado: AsistenciaEstado.ausente,
                  fecha: Timestamp.now(),
                );

            final asistenciaExiste = asistencias.containsKey(estudiante.id);

            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(estudiante.nombreCompleto),
              trailing: ElevatedButton(
                child: Text(
                  asistenciaExiste
                      ? (asistencia.estado == AsistenciaEstado.presente
                          ? 'Presente'
                          : 'Ausente')
                      : 'Marcar',
                ),
                onPressed: (isDocente && !tutoriaTerminada)
                    ? () => TutoriaActions.mostrarModalAsistencia(
                        context, ref, estudiante.id, asistencia)
                    : null,
              ),
            );
          }),
      ],
    );
  }
}
