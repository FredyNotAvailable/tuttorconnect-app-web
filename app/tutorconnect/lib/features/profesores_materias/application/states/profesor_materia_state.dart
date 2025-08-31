import 'package:tutorconnect/features/profesores_materias/data/models/profesor_materia_model.dart';

class ProfesorMateriaState {
  final List<ProfesorMateriaModel>? profesoresMaterias;
  final ProfesorMateriaModel? profesorMateria;
  final bool loading;
  final String? error;

  ProfesorMateriaState({
    this.profesoresMaterias,
    this.profesorMateria,
    this.loading = false,
    this.error,
  });

  ProfesorMateriaState copyWith({
    List<ProfesorMateriaModel>? profesoresMaterias,
    ProfesorMateriaModel? profesorMateria,
    bool? loading,
    String? error,
  }) {
    return ProfesorMateriaState(
      profesoresMaterias: profesoresMaterias ?? this.profesoresMaterias,
      profesorMateria: profesorMateria ?? this.profesorMateria,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
