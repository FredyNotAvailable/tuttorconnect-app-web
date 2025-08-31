import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/carreras/data/models/carrera_model.dart';
import 'package:tutorconnect/features/carreras/data/repositories_impl/carreras_repository_impl.dart';
import 'package:tutorconnect/features/carreras/application/states/carrera_state.dart';

class CarreraNotifier extends StateNotifier<CarreraState> {
  final CarrerasRepositoryImpl repository;

  CarreraNotifier(this.repository) : super(CarreraState());

  /// Obtener todas las carreras
  Future<List<CarreraModel>> getAllCarreras() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final carreras = await repository.getAllCarreras();
      state = state.copyWith(carreras: carreras, loading: false);
      return carreras;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return [];
    }
  }

  /// Obtener carrera por ID
  Future<void> getCarreraById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final carrera = await repository.getCarreraById(id);
      state = state.copyWith(carrera: carrera, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Crear carrera
  Future<void> createCarrera(CarreraModel carrera) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final created = await repository.createCarrera(carrera);
      state = state.copyWith(carrera: created, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Actualizar carrera
  Future<void> updateCarrera(CarreraModel carrera) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateCarrera(carrera);
      state = state.copyWith(carrera: carrera, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  /// Eliminar carrera
  Future<void> deleteCarrera(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteCarrera(id);
      state = state.copyWith(carrera: null, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
