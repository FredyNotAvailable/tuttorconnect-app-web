import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/materias_malla/data/models/materia_malla_model.dart';
import 'package:tutorconnect/features/materias_malla/data/repositories_impl/materias_malla_repository_impl.dart';
import 'package:tutorconnect/features/materias_malla/application/states/materia_malla_state.dart';

class MateriaMallaNotifier extends StateNotifier<MateriaMallaState> {
  final MateriasMallaRepositoryImpl repository;

  MateriaMallaNotifier(this.repository) : super(MateriaMallaState());

  /// Obtener todas las materias_malla
  Future<List<MateriaMallaModel>> getAllMateriasMalla() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final materiasMalla = await repository.getAllMateriasMalla();
      state = state.copyWith(materiasMalla: materiasMalla, loading: false);
      return materiasMalla;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return [];
    }
  }

  /// Obtener materia_malla por ID
  Future<void> getMateriaMallaById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final materiaMalla = await repository.getMateriaMallaById(id);
      state = state.copyWith(materiaMalla: materiaMalla, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Crear materia_malla
  Future<void> createMateriaMalla(MateriaMallaModel materiaMalla) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final created = await repository.createMateriaMalla(materiaMalla);
      state = state.copyWith(materiaMalla: created, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Actualizar materia_malla
  Future<void> updateMateriaMalla(MateriaMallaModel materiaMalla) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateMateriaMalla(materiaMalla);
      state = state.copyWith(materiaMalla: materiaMalla, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Eliminar materia_malla
  Future<void> deleteMateriaMalla(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteMateriaMalla(id);
      state = state.copyWith(materiaMalla: null, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
