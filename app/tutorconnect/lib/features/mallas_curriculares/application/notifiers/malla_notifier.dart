import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/mallas_curriculares/application/states/malla_state.dart';
import 'package:tutorconnect/features/mallas_curriculares/data/models/malla_curricular_model.dart';
import 'package:tutorconnect/features/mallas_curriculares/data/repositories_impl/mallas_repository_impl.dart';

class MallaNotifier extends StateNotifier<MallaState> {
  final MallasRepositoryImpl repository;

  MallaNotifier(this.repository) : super(MallaState());

  /// Obtener todas las mallas
  Future<List<MallaCurricularModel>> getAllMallas() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final mallas = await repository.getAllMallas();
      state = state.copyWith(mallas: mallas, loading: false);
      return mallas;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return [];
    }
  }

  /// Obtener malla por ID
  Future<void> getMallaById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final malla = await repository.getMallaById(id);
      state = state.copyWith(malla: malla, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Crear malla
  Future<void> createMalla(MallaCurricularModel malla) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final created = await repository.createMalla(malla);
      state = state.copyWith(malla: created, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Actualizar malla
  Future<void> updateMalla(MallaCurricularModel malla) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateMalla(malla);
      state = state.copyWith(malla: malla, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Eliminar malla
  Future<void> deleteMalla(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteMalla(id);
      state = state.copyWith(malla: null, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
