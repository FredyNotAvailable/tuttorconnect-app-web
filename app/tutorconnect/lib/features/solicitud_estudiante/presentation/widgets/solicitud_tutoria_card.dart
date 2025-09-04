import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:tutorconnect/core/themes/app_constants.dart';
import 'package:tutorconnect/core/themes/app_text_styles.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/solicitud_estudiante/presentation/actions/solicitud_tutoria_actions.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';
import 'package:tutorconnect/features/usuarios/helpers/usuario_helper.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class SolicitudTutoriaCard extends ConsumerWidget {
  final SolicitudTutoriaModel solicitud;
  final String currentUserId;
  final UsuarioRol? currentUserRol;

  const SolicitudTutoriaCard({
    super.key,
    required this.solicitud,
    required this.currentUserId,
    required this.currentUserRol,
  });

  // Colores según estado
  Color _estadoColor(EstadoSolicitud estado) {
    switch (estado) {
      case EstadoSolicitud.aceptado:
        return AppColors.success;
      case EstadoSolicitud.rechazado:
        return AppColors.error;
      case EstadoSolicitud.pendiente:
        return AppColors.warning;
    }
  }

  @override
Widget build(BuildContext context, WidgetRef ref) {
  final estudiante = getUsuarioById(ref, solicitud.estudianteId);
  final tutoria = getTutoriaById(ref, solicitud.tutoriaId);

  // Verificar si la tutoría existe
  if (tutoria == null) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: AppPaddingConstants.global,
      ),
      elevation: 3,
      shadowColor: AppColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(AppPaddingConstants.global),
        child: Text(
          'Tutoría no encontrada.',
          style: AppTextStyles.subtitle.copyWith(color: AppColors.error),
        ),
      ),
    );
  }

  // 1️⃣ Fecha de la tutoría desde Firestore (solo fecha)
  // Fecha/hora de inicio de la tutoría
  final fechaFirestore = tutoria.fecha.toDate();
  final inicioParts = tutoria.horaInicio.split(':');
  final hora = int.parse(inicioParts[0]);
  final minuto = int.parse(inicioParts[1]);

  final fechaInicio = DateTime(
    fechaFirestore.year,
    fechaFirestore.month,
    fechaFirestore.day,
    hora,
    minuto,
  );

  // Hora actual en UTC-5
  final ahoraUTC5 = DateTime.now().toUtc().subtract(const Duration(hours: 5));

  // Verificar si la tutoría aún no ha iniciado
  final bool puedeAccion = ahoraUTC5.isBefore(fechaInicio);

  // Fecha relativa
  final fechaRelativa = solicitud.fechaEnvio != null
      ? timeago.format(
          (solicitud.fechaEnvio as Timestamp).toDate(),
          locale: 'es',
        )
      : 'Fecha no disponible';

return Card(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  margin: const EdgeInsets.symmetric(
    vertical: 8,
    horizontal: AppPaddingConstants.global,
  ),
  elevation: 3,
  shadowColor: AppColors.lightGrey,
  child: Padding(
    padding: const EdgeInsets.all(AppPaddingConstants.global),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: AppPaddingConstants.global),
          child: Icon(Icons.assignment, size: 40, color: AppColors.primary),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tema de la tutoría
              Text(
                tutoria.tema,
                style: AppTextStyles.heading2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 6),

              // Estudiante
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Estudiante: ',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: estudiante.nombreCompleto,
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Fecha de envío
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Enviado: ',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: fechaRelativa,
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Fecha y hora de inicio de la tutoría
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Inicio: ',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${fechaInicio.day}/${fechaInicio.month}/${fechaInicio.year} ${fechaInicio.hour.toString().padLeft(2, '0')}:${fechaInicio.minute.toString().padLeft(2, '0')}',
                      style: AppTextStyles.subtitle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Estado de la solicitud (siempre visible)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Estado: ',
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${solicitud.estado.value[0].toUpperCase()}${solicitud.estado.value.substring(1)}',
                      style: AppTextStyles.subtitle.copyWith(
                        color: _estadoColor(solicitud.estado),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Botones de acción solo si la tutoría aún no ha iniciado
              if (solicitud.estado == EstadoSolicitud.pendiente)
                puedeAccion
                    ? Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () {
                              SolicitudTutoriaActions.showConfirmAction(
                                context: context,
                                title: 'Aceptar solicitud',
                                message:
                                    '¿Estás seguro de aceptar esta solicitud?',
                                onConfirm: () =>
                                    SolicitudTutoriaActions.aceptarSolicitud(
                                  ref: ref,
                                  solicitud: solicitud,
                                ),
                              );
                            },
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('Aceptar'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () {
                              SolicitudTutoriaActions.showConfirmAction(
                                context: context,
                                title: 'Rechazar solicitud',
                                message:
                                    '¿Estás seguro de rechazar esta solicitud?',
                                onConfirm: () =>
                                    SolicitudTutoriaActions.rechazarSolicitud(
                                  ref: ref,
                                  solicitud: solicitud,
                                ),
                              );
                            },
                            icon: const Icon(Icons.close, size: 18),
                            label: const Text('Rechazar'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.darkGrey,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        '⚠️ Esta tutoría ya comenzó o la hora de inicio pasó. No se puede aceptar ni rechazar.',
                        style: AppTextStyles.subtitle
                            .copyWith(color: AppColors.darkGrey),
                      ),
            ],
          ),
        ),
      ],
    ),
  ),
);

  }
}
