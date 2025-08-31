import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/profesores_materias/data/models/profesor_materia_model.dart';
import 'package:tutorconnect/features/profesores_materias/data/repositories_impl/profesores_materias_repository_impl.dart';
import 'package:tutorconnect/features/profesores_materias/application/states/profesor_materia_state.dart';

class ProfesorMateriaNotifier extends StateNotifier<ProfesorMateriaState> {
  final ProfesoresMateriasRepositoryImpl repository;

  ProfesorMateriaNotifier(this.repository) : super(ProfesorMateriaState());

  /// Obtener todas las relaciones
  Future<List<ProfesorMateriaModel>> getAllProfesoresMaterias() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final list = await repository.getAllProfesoresMaterias();
      state = state.copyWith(profesoresMaterias: list, loading: false);
      return list;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return [];
    }
  }

  /// Obtener relación por ID
  Future<void> getProfesorMateriaById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final pm = await repository.getProfesorMateriaById(id);
      state = state.copyWith(profesorMateria: pm, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Crear relación
  Future<void> createProfesorMateria(ProfesorMateriaModel pm) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final created = await repository.createProfesorMateria(pm);
      state = state.copyWith(profesorMateria: created, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Actualizar relación
  Future<void> updateProfesorMateria(ProfesorMateriaModel pm) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateProfesorMateria(pm);
      state = state.copyWith(profesorMateria: pm, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Eliminar relación
  Future<void> deleteProfesorMateria(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteProfesorMateria(id);
      state = state.copyWith(profesorMateria: null, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
