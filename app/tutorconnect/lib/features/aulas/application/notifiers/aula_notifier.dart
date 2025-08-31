import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/aulas/data/models/aula_model.dart';
import 'package:tutorconnect/features/aulas/data/repositories_impl/aulas_repository_impl.dart';
import 'package:tutorconnect/features/aulas/application/states/aula_state.dart';

class AulaNotifier extends StateNotifier<AulaState> {
  final AulasRepositoryImpl repository;

  AulaNotifier(this.repository) : super(AulaState());

  /// Obtener todas las aulas
  Future<List<AulaModel>> getAllAulas() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final aulas = await repository.getAllAulas();
      state = state.copyWith(aulas: aulas, loading: false);
      return aulas;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return [];
    }
  }

  /// Obtener aula por ID
  Future<void> getAulaById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final aula = await repository.getAulaById(id);
      state = state.copyWith(aula: aula, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Crear aula
  Future<void> createAula(AulaModel aula) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final created = await repository.createAula(aula);
      state = state.copyWith(aula: created, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Actualizar aula
  Future<void> updateAula(AulaModel aula) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateAula(aula);
      state = state.copyWith(aula: aula, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Eliminar aula
  Future<void> deleteAula(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteAula(id);
      state = state.copyWith(aula: null, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
