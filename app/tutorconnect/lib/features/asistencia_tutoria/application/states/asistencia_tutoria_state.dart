
import 'package:tutorconnect/features/asistencia_tutoria/data/models/asistencia_tutoria_model.dart';

class AsistenciaTutoriaState {
  final List<AsistenciaTutoriaModel>? asistencias;
  final AsistenciaTutoriaModel? asistencia;
  final bool loading;
  final String? error;

  AsistenciaTutoriaState({
    this.asistencias,
    this.asistencia,
    this.loading = false,
    this.error,
  });

  AsistenciaTutoriaState copyWith({
    List<AsistenciaTutoriaModel>? asistencias,
    AsistenciaTutoriaModel? asistencia,
    bool? loading,
    String? error,
  }) {
    return AsistenciaTutoriaState(
      asistencias: asistencias ?? this.asistencias,
      asistencia: asistencia ?? this.asistencia,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
