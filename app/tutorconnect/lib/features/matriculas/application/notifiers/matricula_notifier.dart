import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/matriculas/data/models/matricula_model.dart';
import 'package:tutorconnect/features/matriculas/application/states/matricula_state.dart';
import 'package:tutorconnect/features/matriculas/data/repositories_impl/matriculas_repository_impl.dart';

class MatriculaNotifier extends StateNotifier<MatriculaState> {
  final MatriculasRepositoryImpl repository;

  MatriculaNotifier(this.repository) : super(MatriculaState());

  /// Obtener todas las matriculas
  Future<List<MatriculaModel>> getAllMatriculas() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final matriculas = await repository.getAllMatriculas();
      state = state.copyWith(matriculas: matriculas, loading: false);
      return matriculas;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return [];
    }
  }

  /// Obtener matricula por ID
  Future<void> getMatriculaById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final matricula = await repository.getMatriculaById(id);
      state = state.copyWith(matricula: matricula, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Crear matricula
  Future<void> createMatricula(MatriculaModel matricula) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final created = await repository.createMatricula(matricula);
      state = state.copyWith(matricula: created, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Actualizar matricula
  Future<void> updateMatricula(MatriculaModel matricula) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateMatricula(matricula);
      state = state.copyWith(matricula: matricula, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Eliminar matricula
  Future<void> deleteMatricula(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteMatricula(id);
      state = state.copyWith(matricula: null, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
