
import 'package:tutorconnect/features/tutoria_estudiante/data/models/tutoria_estudiante_model.dart';

class TutoriaEstudianteState {
  final List<TutoriaEstudianteModel>? tutoriasEstudiantes;
  final TutoriaEstudianteModel? tutoriaEstudiante;
  final bool loading;
  final String? error;

  TutoriaEstudianteState({
    this.tutoriasEstudiantes,
    this.tutoriaEstudiante,
    this.loading = false,
    this.error,
  });

  TutoriaEstudianteState copyWith({
    List<TutoriaEstudianteModel>? tutoriasEstudiantes,
    TutoriaEstudianteModel? tutoriaEstudiante,
    bool? loading,
    String? error,
  }) {
    return TutoriaEstudianteState(
      tutoriasEstudiantes: tutoriasEstudiantes ?? this.tutoriasEstudiantes,
      tutoriaEstudiante: tutoriaEstudiante ?? this.tutoriaEstudiante,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
