import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/themes/app_constants.dart';
import 'package:tutorconnect/core/utils/date_utils.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estudiante = getUsuarioById(ref, solicitud.estudianteId);
    final tutoria = getTutoriaById(ref, solicitud.tutoriaId);

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: AppPaddingConstants.global,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPaddingConstants.global),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección izquierda: icono
            const Padding(
              padding: EdgeInsets.only(right: AppPaddingConstants.global),
              child: Icon(Icons.assignment, size: 40, color: Colors.blue),
            ),

            // Sección derecha: información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tutoría: ${tutoria.tema}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Estudiante: ${estudiante.nombreCompleto}'),
                  const SizedBox(height: 2),
                  Text('Enviado: ${formatDate(solicitud.fechaEnvio)}'),
                  const SizedBox(height: 2),
                  Text(
                    'Estado: ${solicitud.estado.value[0].toUpperCase()}${solicitud.estado.value.substring(1)}',
                  ),
                  const SizedBox(height: 6),
                  // Botones visibles si el estado es pendiente
                  if (solicitud.estado == EstadoSolicitud.pendiente)
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            SolicitudTutoriaActions.showConfirmAction(
                              context: context,
                              title: 'Aceptar solicitud',
                              message:
                                  '¿Estás seguro de aceptar esta solicitud?',
                              onConfirm: () => SolicitudTutoriaActions
                                  .aceptarSolicitud(
                                ref: ref,
                                solicitud: solicitud,
                              ),
                            );
                          },
                          child: const Text('Aceptar'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                          onPressed: () {
                            SolicitudTutoriaActions.showConfirmAction(
                              context: context,
                              title: 'Rechazar solicitud',
                              message:
                                  '¿Estás seguro de rechazar esta solicitud?',
                              onConfirm: () => SolicitudTutoriaActions
                                  .rechazarSolicitud(
                                ref: ref,
                                solicitud: solicitud,
                              ),
                            );
                          },
                          child: const Text('Rechazar'),
                        ),
                      ],
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
