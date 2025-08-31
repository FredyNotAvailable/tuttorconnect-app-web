import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/asistencia_tutoria/application/states/asistencia_tutoria_state.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/models/asistencia_tutoria_model.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/repositories_impl/asistencia_tutorias_repository_impl.dart';

class AsistenciaTutoriaNotifier extends StateNotifier<AsistenciaTutoriaState> {
  final AsistenciaTutoriasRepositoryImpl repository;

  AsistenciaTutoriaNotifier(this.repository) : super(AsistenciaTutoriaState());

  /// Obtener todas las asistencias
  Future<List<AsistenciaTutoriaModel>> getAllAsistencias() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final asistencias = await repository.getAllAsistencias();
      state = state.copyWith(asistencias: asistencias, loading: false);
      return asistencias;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return [];
    }
  }

  /// Obtener asistencia por ID
  Future<void> getAsistenciaById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final asistencia = await repository.getAsistenciaById(id);
      state = state.copyWith(asistencia: asistencia, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> createAsistencia(AsistenciaTutoriaModel asistencia) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final created = await repository.createAsistencia(asistencia);
      // Actualiza la lista completa de asistencias
      final actuales = List<AsistenciaTutoriaModel>.from(state.asistencias ?? []);
      actuales.add(created);
      state = state.copyWith(asistencia: created, asistencias: actuales, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> updateAsistencia(AsistenciaTutoriaModel asistencia) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateAsistencia(asistencia);
      // Actualiza la lista completa
      final actuales = List<AsistenciaTutoriaModel>.from(state.asistencias ?? []);
      final index = actuales.indexWhere((a) => a.id == asistencia.id);
      if (index != -1) {
        actuales[index] = asistencia;
      }
      state = state.copyWith(asistencia: asistencia, asistencias: actuales, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }


  /// Eliminar asistencia
  Future<void> deleteAsistencia(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteAsistencia(id);
      state = state.copyWith(asistencia: null, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
