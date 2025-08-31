import 'package:tutorconnect/features/materias/data/models/materia_model.dart';

class MateriaState {
  final List<MateriaModel>? materias;
  final MateriaModel? materia;
  final bool loading;
  final String? error;

  MateriaState({
    this.materias,
    this.materia,
    this.loading = false,
    this.error,
  });

  MateriaState copyWith({
    List<MateriaModel>? materias,
    MateriaModel? materia,
    bool? loading,
    String? error,
  }) {
    return MateriaState(
      materias: materias ?? this.materias,
      materia: materia ?? this.materia,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
