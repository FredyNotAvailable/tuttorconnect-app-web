import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/data/repositories_impl/tutorias_repository_impl.dart';
import 'package:tutorconnect/features/tutorias/application/states/tutoria_state.dart';

class TutoriaNotifier extends StateNotifier<TutoriaState> {
  final TutoriasRepositoryImpl repository;

  TutoriaNotifier(this.repository) : super(TutoriaState());

  /// Obtener todas las tutorías
  Future<void> getAllTutorias() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final tutorias = await repository.getAllTutorias();
      state = state.copyWith(loading: false, tutorias: tutorias); // ← actualizar el state
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Cargar tutoría por ID
  Future<void> getTutoriaById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final tutoria = await repository.getTutoriaById(id);
      state = state.copyWith(tutoria: tutoria, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Crear tutoría
  Future<TutoriaModel> createTutoria(TutoriaModel tutoria) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final created = await repository.createTutoria(tutoria);

      // Actualiza la lista completa de tutorías
      final actuales = List<TutoriaModel>.from(state.tutorias ?? []);
      actuales.add(created);

      state = state.copyWith(tutoria: created, tutorias: actuales, loading: false);
      return created;
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
      throw Exception('Error al crear tutoría: $e');
    }
  }

  /// Actualizar tutoría
  Future<TutoriaModel?> updateTutoria(TutoriaModel tutoria) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateTutoria(tutoria);

      // Actualizar la lista completa
      final actuales = List<TutoriaModel>.from(state.tutorias ?? []);
      final index = actuales.indexWhere((t) => t.id == tutoria.id);
      if (index != -1) {
        actuales[index] = tutoria;
      }

      state = state.copyWith(tutoria: tutoria, tutorias: actuales, loading: false);
      return tutoria;
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
      return null;
    }
  }


  /// Eliminar tutoría
  Future<void> deleteTutoria(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteTutoria(id);
      state = state.copyWith(tutoria: null, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
