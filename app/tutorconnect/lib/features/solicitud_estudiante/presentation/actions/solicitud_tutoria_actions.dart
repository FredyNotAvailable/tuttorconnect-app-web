import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/solicitud_estudiante/helpers/solicitud_tutoria_helper.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/datasources/tutorias_estudiantes_datasource.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/models/tutoria_estudiante_model.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/repositories_impl/tutorias_estudiantes_repository_impl.dart';

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

    // Crear relación directamente en Firestore
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
