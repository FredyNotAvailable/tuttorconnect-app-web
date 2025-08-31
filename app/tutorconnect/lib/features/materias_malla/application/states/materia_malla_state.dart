import 'package:tutorconnect/features/materias_malla/data/models/materia_malla_model.dart';

class MateriaMallaState {
  final List<MateriaMallaModel>? materiasMalla;
  final MateriaMallaModel? materiaMalla;
  final bool loading;
  final String? error;

  MateriaMallaState({
    this.materiasMalla,
    this.materiaMalla,
    this.loading = false,
    this.error,
  });

  MateriaMallaState copyWith({
    List<MateriaMallaModel>? materiasMalla,
    MateriaMallaModel? materiaMalla,
    bool? loading,
    String? error,
  }) {
    return MateriaMallaState(
      materiasMalla: materiasMalla ?? this.materiasMalla,
      materiaMalla: materiaMalla ?? this.materiaMalla,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
