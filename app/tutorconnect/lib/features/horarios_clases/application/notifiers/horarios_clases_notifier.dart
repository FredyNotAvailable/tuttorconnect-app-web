// lib/features/horarios/application/notifiers/horarios_clases_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/horarios_clases/application/states/horarios_clases_state.dart';
import 'package:tutorconnect/features/horarios_clases/data/models/horario_clase_model.dart';
import 'package:tutorconnect/features/horarios_clases/data/repositories_impl/horarios_clases_repository_impl.dart';

class HorarioClaseNotifier extends StateNotifier<HorarioClaseState> {
  final HorariosClasesRepositoryImpl repository;

  HorarioClaseNotifier(this.repository) : super(HorarioClaseState());

  /// Obtener todos los horarios
  Future<List<HorarioClaseModel>> getAllHorarios() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final list = await repository.getAllHorarios();
      state = state.copyWith(horarios: list, loading: false);
      return list;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return [];
    }
  }

  /// Obtener horario por ID
  Future<void> getHorarioById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final h = await repository.getHorarioClaseById(id);
      state = state.copyWith(horario: h, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Crear horario
  Future<void> createHorario(HorarioClaseModel h) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final created = await repository.createHorarioClase(h);
      state = state.copyWith(horario: created, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Actualizar horario
  Future<void> updateHorario(HorarioClaseModel h) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateHorarioClase(h);
      state = state.copyWith(horario: h, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Eliminar horario
  Future<void> deleteHorario(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteHorarioClase(id);
      state = state.copyWith(horario: null, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
