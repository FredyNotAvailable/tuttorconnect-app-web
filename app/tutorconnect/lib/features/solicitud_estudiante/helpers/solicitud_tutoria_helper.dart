import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/solicitud_estudiante/application/providers/solicitudes_tutorias_provider.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';

/// Devuelve la solicitud completa dado su ID, o una por defecto si no se encuentra
SolicitudTutoriaModel getSolicitudById(WidgetRef ref, String id) {
  final state = ref.read(solicitudesTutoriasProvider);

  if (state.solicitudes == null || state.solicitudes!.isEmpty) {
    return SolicitudTutoriaModel(
      id: '',
      tutoriaId: '',
      estudianteId: '',
      fechaEnvio: Timestamp.now(),
      fechaRespuesta: null,
      estado: EstadoSolicitud.pendiente,
    );
  }

  final solicitud = state.solicitudes!.firstWhere(
    (s) => s.id == id,
    orElse: () => SolicitudTutoriaModel(
      id: '',
      tutoriaId: '',
      estudianteId: '',
      fechaEnvio: Timestamp.now(),
      fechaRespuesta: null,
      estado: EstadoSolicitud.pendiente,
    ),
  );

  return solicitud;
}

/// Devuelve todas las solicitudes de una tutoría
List<SolicitudTutoriaModel> getAllSolicitudesByTutoria(WidgetRef ref, String tutoriaId) {
  final state = ref.read(solicitudesTutoriasProvider);
  final solicitudes = state.solicitudes ?? [];

  return solicitudes.where((s) => s.tutoriaId == tutoriaId).toList();
}

/// Devuelve todas las solicitudes de un estudiante
List<SolicitudTutoriaModel> getAllSolicitudesByEstudiante(WidgetRef ref, String estudianteId) {
  final state = ref.read(solicitudesTutoriasProvider);
  final solicitudes = state.solicitudes ?? [];

  return solicitudes.where((s) => s.estudianteId == estudianteId).toList();
}

/// Devuelve todas las solicitudes de una tutoría por estado
List<SolicitudTutoriaModel> getSolicitudesByEstado(WidgetRef ref, String tutoriaId, EstadoSolicitud estado) {
  final state = ref.read(solicitudesTutoriasProvider);
  final solicitudes = state.solicitudes ?? [];

  return solicitudes.where((s) => s.tutoriaId == tutoriaId && s.estado == estado).toList();
}

/// Crea una nueva solicitud de tutoría y actualiza el estado
Future<void> createSolicitudHelper(WidgetRef ref, SolicitudTutoriaModel solicitud) async {
  final notifier = ref.read(solicitudesTutoriasProvider.notifier);
  await notifier.createSolicitud(solicitud);
}


/// Actualiza una solicitud de tutoría y refresca el estado en el provider
Future<void> updateSolicitudHelper(WidgetRef ref, SolicitudTutoriaModel solicitud) async {
  final notifier = ref.read(solicitudesTutoriasProvider.notifier);
  await notifier.updateSolicitud(solicitud);
}
