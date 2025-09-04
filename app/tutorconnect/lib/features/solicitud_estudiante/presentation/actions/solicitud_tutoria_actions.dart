import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/solicitud_estudiante/helpers/solicitud_tutoria_helper.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/datasources/tutorias_estudiantes_datasource.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/models/tutoria_estudiante_model.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/repositories_impl/tutorias_estudiantes_repository_impl.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/core/themes/app_text_styles.dart';

class SolicitudTutoriaActions {
  /// 🔹 Diálogo de confirmación más bonito con colores y estilos personalizados
  static Future<void> showConfirmAction({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: AppTextStyles.body.copyWith(color: AppColors.grey),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.darkGrey,
              side: BorderSide(color: AppColors.darkGrey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (result == true) onConfirm();
  }

  /// 🔹 Acepta una solicitud de tutoría y crea la relación en Firestore
  static Future<void> aceptarSolicitud({
    required WidgetRef ref,
    required SolicitudTutoriaModel solicitud,
  }) async {
    final updated = solicitud.copyWith(
      estado: EstadoSolicitud.aceptado, // 🔹 corregido
      fechaRespuesta: Timestamp.now(),
    );

    final firestore = FirebaseFirestore.instance;
    final datasource = TutoriasEstudiantesDatasource(firestore);
    final repository = TutoriasEstudiantesRepositoryImpl(datasource);

    final nuevaRelacion = TutoriaEstudianteModel(
      id: '',
      tutoriaId: solicitud.tutoriaId,
      estudianteId: solicitud.estudianteId,
    );

    await updateSolicitudHelper(ref, updated);
    await repository.createTutoriaEstudiante(nuevaRelacion);
  }

  /// 🔹 Rechaza una solicitud de tutoría
  static Future<void> rechazarSolicitud({
    required WidgetRef ref,
    required SolicitudTutoriaModel solicitud,
  }) async {
    final updated = solicitud.copyWith(
      estado: EstadoSolicitud.rechazado, // 🔹 corregido
      fechaRespuesta: Timestamp.now(),
    );
    await updateSolicitudHelper(ref, updated);
  }
}
