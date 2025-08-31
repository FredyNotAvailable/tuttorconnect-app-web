import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';

class SolicitudTutoriaState {
  final List<SolicitudTutoriaModel>? solicitudes;
  final SolicitudTutoriaModel? solicitud;
  final bool loading;
  final String? error;

  SolicitudTutoriaState({
    this.solicitudes,
    this.solicitud,
    this.loading = false,
    this.error,
  });

  SolicitudTutoriaState copyWith({
    List<SolicitudTutoriaModel>? solicitudes,
    SolicitudTutoriaModel? solicitud,
    bool? loading,
    String? error,
  }) {
    return SolicitudTutoriaState(
      solicitudes: solicitudes ?? this.solicitudes,
      solicitud: solicitud ?? this.solicitud,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
