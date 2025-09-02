import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/solicitud_estudiante/helpers/solicitud_tutoria_helper.dart';
import 'package:tutorconnect/features/tutoria_estudiante/helper/tutoria_estudiante_helper.dart';

class SolicitudTutoriaActions {
  /// Muestra un diálogo de confirmación antes de ejecutar la acción
  static Future<void> showConfirmAction({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
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

    if (result == true) onConfirm();
  }

  /// Acepta una solicitud de tutoría y asigna al estudiante
  static Future<void> aceptarSolicitud({
    required WidgetRef ref,
    required SolicitudTutoriaModel solicitud,
  }) async {
    final updated = solicitud.copyWith(
      estado: EstadoSolicitud.aceptado,
      fechaRespuesta: Timestamp.now(),
    );
    await updateSolicitudHelper(ref, updated);
    await asignarEstudianteATutoria(ref, solicitud.tutoriaId, solicitud.estudianteId);
  }

  /// Rechaza una solicitud de tutoría
  static Future<void> rechazarSolicitud({
    required WidgetRef ref,
    required SolicitudTutoriaModel solicitud,
  }) async {
    final updated = solicitud.copyWith(
      estado: EstadoSolicitud.rechazado,
      fechaRespuesta: Timestamp.now(),
    );
    await updateSolicitudHelper(ref, updated);
  }
}
