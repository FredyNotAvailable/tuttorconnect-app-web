import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/features/materias/data/repositories_impl/materias_repository_impl.dart';
import 'package:tutorconnect/features/materias/application/states/materia_state.dart';

class MateriaNotifier extends StateNotifier<MateriaState> {
  final MateriasRepositoryImpl repository;

  MateriaNotifier(this.repository) : super(MateriaState());

  /// Obtener todas las materias
  Future<List<MateriaModel>> getAllMaterias() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final materias = await repository.getAllMaterias();
      state = state.copyWith(materias: materias, loading: false);
      return materias;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return [];
    }
  }

  /// Obtener materia por ID
  Future<void> getMateriaById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final materia = await repository.getMateriaById(id);
      state = state.copyWith(materia: materia, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Crear materia
  Future<void> createMateria(MateriaModel materia) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final created = await repository.createMateria(materia);
      state = state.copyWith(materia: created, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Actualizar materia
  Future<void> updateMateria(MateriaModel materia) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateMateria(materia);
      state = state.copyWith(materia: materia, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Eliminar materia
  Future<void> deleteMateria(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteMateria(id);
      state = state.copyWith(materia: null, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
