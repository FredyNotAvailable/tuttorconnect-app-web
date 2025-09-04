import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/models/asistencia_tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutoria_actions.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/core/themes/app_text_styles.dart';

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

  String _formatDateTime(Timestamp fecha, String horaInicio, String horaFin) {
    final date = fecha.toDate();
    final formattedDate = DateFormat('EEEE, d MMMM yyyy', 'es').format(date);
    return '$formattedDate | $horaInicio - $horaFin';
  }

  Color _estadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'aceptado':
        return Colors.green;
      case 'rechazado':
        return Colors.red;
      default:
        return AppColors.darkGrey;
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.body.copyWith(color: AppColors.darkGrey),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tutoria.tema, style: AppTextStyles.heading2),
          const SizedBox(height: 12),

          _buildInfoRow(
            'Descripción',
            tutoria.descripcion.isNotEmpty ? tutoria.descripcion : '-',
          ),
          _buildInfoRow('Profesor', profesorNombre),
          _buildInfoRow('Materia', materiaNombre),
          _buildInfoRow('Aula', '$aulaNombre - $aulaTipo'),
          _buildInfoRow(
            'Fecha y Hora',
            _formatDateTime(tutoria.fecha, tutoria.horaInicio, tutoria.horaFin),
          ),
          _buildInfoRow('Estado', tutoria.estado.name.toUpperCase()),
          const SizedBox(height: 16),

          Text('Estudiantes inscritos:', style: AppTextStyles.heading2),
          const SizedBox(height: 8),

          if (estudiantes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: Text("No hay estudiantes inscritos.")),
            )
          else
            Column(
              children: estudiantes.map((estudiante) {
                final asistencia =
                    asistencias[estudiante.id] ??
                    AsistenciaTutoriaModel(
                      id: '',
                      estudianteId: estudiante.id,
                      tutoriaId: tutoria.id,
                      estado: AsistenciaEstado.ausente,
                      fecha: Timestamp.now(),
                    );

                final asistenciaExiste = asistencias.containsKey(estudiante.id);

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          estudiante.nombreCompleto,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: (isDocente && !tutoriaTerminada)
                            ? () => TutoriaActions.mostrarModalAsistencia(
                                context,
                                ref,
                                estudiante.id,
                                asistencia,
                              )
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: asistenciaExiste
                              ? (asistencia.estado == AsistenciaEstado.presente
                                    ? Colors.green
                                    : Colors.red)
                              : AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          minimumSize: const Size(70, 30),
                        ),
                        child: Text(
                          asistenciaExiste
                              ? (asistencia.estado == AsistenciaEstado.presente
                                    ? 'Presente'
                                    : 'Ausente')
                              : 'Marcar',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
