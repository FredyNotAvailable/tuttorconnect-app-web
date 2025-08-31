import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/solicitud_estudiante/application/states/solicitudes_tutorias_state.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/repositories_impl/solicitudes_tutorias_repository_impl.dart';

class SolicitudesTutoriasNotifier extends StateNotifier<SolicitudTutoriaState> {
  final SolicitudesTutoriasRepositoryImpl repository;

  SolicitudesTutoriasNotifier(this.repository) : super(SolicitudTutoriaState());

  Future<void> getAllSolicitudes() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final list = await repository.getAllSolicitudes();
      state = state.copyWith(solicitudes: list, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> getSolicitudById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final solicitud = await repository.getSolicitudById(id);
      state = state.copyWith(solicitud: solicitud, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> createSolicitud(SolicitudTutoriaModel solicitud) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final nuevaSolicitud = await repository.createSolicitud(solicitud);
      final updatedList = [...?state.solicitudes, nuevaSolicitud];
      state = state.copyWith(solicitudes: updatedList, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> updateSolicitud(SolicitudTutoriaModel solicitud) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateSolicitud(solicitud);
      final updatedList = state.solicitudes?.map((s) =>
          s.id == solicitud.id ? solicitud : s
      ).toList();
      state = state.copyWith(solicitudes: updatedList, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> deleteSolicitud(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteSolicitud(id);
      final updatedList = state.solicitudes?.where((s) => s.id != id).toList();
      state = state.copyWith(solicitudes: updatedList, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
