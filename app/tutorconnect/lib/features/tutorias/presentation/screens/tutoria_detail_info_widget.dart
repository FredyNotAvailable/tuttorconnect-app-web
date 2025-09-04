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
    // Hora actual en UTC-5
    final ahoraUTC5 = DateTime.now().toUtc().subtract(const Duration(hours: 5));

    // Hora de inicio y fin combinadas con la fecha de la tutoría
    final fecha = tutoria.fecha.toDate();
    final inicioParts = tutoria.horaInicio.split(':');
    final finParts = tutoria.horaFin.split(':');

    final fechaInicio = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      int.parse(inicioParts[0]),
      int.parse(inicioParts[1]),
    );
    final fechaFin = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      int.parse(finParts[0]),
      int.parse(finParts[1]),
    );

    // Determinar si estamos dentro del horario de la tutoría
    final dentroDelHorario = ahoraUTC5.isAfter(fechaInicio) && ahoraUTC5.isBefore(fechaFin);

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
          _buildInfoRow(
            'Estado',
            '${tutoria.estado.name[0].toUpperCase()}${tutoria.estado.name.substring(1).toLowerCase()}',
          ),

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
                      estado: AsistenciaEstado.sinRegistro,
                      fecha: Timestamp.now(),
                    );

                // Texto del botón según estado
                String botonTexto;
                switch (asistencia.estado) {
                  case AsistenciaEstado.presente:
                    botonTexto = 'Presente';
                    break;
                  case AsistenciaEstado.ausente:
                    botonTexto = 'Ausente';
                    break;
                  case AsistenciaEstado.sinRegistro:
                    botonTexto = 'Marcar';
                }

                // Color del botón según estado
                Color botonColor;
                switch (asistencia.estado) {
                  case AsistenciaEstado.presente:
                    botonColor = Colors.green;
                    break;
                  case AsistenciaEstado.ausente:
                    botonColor = Colors.red;
                    break;
                  case AsistenciaEstado.sinRegistro:
                    botonColor = AppColors.primary;
                }

                // Botón activo solo si:
                // 1️⃣ Docente
                // 2️⃣ Tutoría confirmada
                // 3️⃣ Dentro del horario de inicio y fin
                // 4️⃣ Tutoría no terminada
                final botonActivo = isDocente &&
                    tutoria.estado == TutoriaEstado.confirmada &&
                    dentroDelHorario;

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
                        onPressed: botonActivo
                            ? () => TutoriaActions.mostrarModalAsistencia(
                                  context,
                                  ref,
                                  estudiante.id,
                                  asistencia,
                                )
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: botonActivo ? botonColor : Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          minimumSize: const Size(70, 30),
                        ),
                        child: Text(
                          botonTexto,
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
