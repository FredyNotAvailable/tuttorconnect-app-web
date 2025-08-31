import 'package:tutorconnect/features/matriculas/data/models/matricula_model.dart';

class MatriculaState {
  final List<MatriculaModel>? matriculas;
  final MatriculaModel? matricula;
  final bool loading;
  final String? error;

  MatriculaState({
    this.matriculas,
    this.matricula,
    this.loading = false,
    this.error,
  });

  MatriculaState copyWith({
    List<MatriculaModel>? matriculas,
    MatriculaModel? matricula,
    bool? loading,
    String? error,
  }) {
    return MatriculaState(
      matriculas: matriculas ?? this.matriculas,
      matricula: matricula ?? this.matricula,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
