import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/tutoria_estudiante/application/states/tutorias_estudiantes_state.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/models/tutoria_estudiante_model.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/repositories_impl/tutorias_estudiantes_repository_impl.dart';

class TutoriaEstudianteNotifier extends StateNotifier<TutoriaEstudianteState> {
  final TutoriasEstudiantesRepositoryImpl repository;

  TutoriaEstudianteNotifier(this.repository) : super(TutoriaEstudianteState());

  /// Obtener todas las relaciones
  Future<List<TutoriaEstudianteModel>> getAllTutoriasEstudiantes() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final list = await repository.getAllTutoriasEstudiantes();
      state = state.copyWith(tutoriasEstudiantes: list, loading: false);
      return list;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return [];
    }
  }

  /// Obtener relación por ID
  Future<void> getTutoriaEstudianteById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final te = await repository.getTutoriaEstudianteById(id);
      state = state.copyWith(tutoriaEstudiante: te, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> createTutoriaEstudiante(TutoriaEstudianteModel te) async {
    state = state.copyWith(loading: true, error: null);
    try {
      print('Intentando crear relación: ${te.toJson()}');
      final created = await repository.createTutoriaEstudiante(te);
      print('Creación exitosa: ${created.toJson()}');
      state = state.copyWith(tutoriaEstudiante: created, loading: false);
    } catch (e) {
      print('Error en createTutoriaEstudiante: $e'); // <- ver el error real
      state = state.copyWith(loading: false, error: e.toString());
    }
  }


  /// Actualizar relación
  Future<void> updateTutoriaEstudiante(TutoriaEstudianteModel te) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateTutoriaEstudiante(te);
      state = state.copyWith(tutoriaEstudiante: te, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Eliminar relación
  Future<void> deleteTutoriaEstudiante(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteTutoriaEstudiante(id);
      state = state.copyWith(tutoriaEstudiante: null, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
