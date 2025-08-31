// lib/features/usuarios/application/notifiers/usuario_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/usuarios/application/states/usuario_state.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/usuarios/data/repositories_impl/usuarios_repository_impl.dart';

class UsuarioNotifier extends StateNotifier<UsuarioState> {
  final UsuariosRepositoryImpl repository;

  UsuarioNotifier(this.repository) : super(UsuarioState());

  /// Cargar todos los usuarios (opcional: podrías tener un listado aparte)
  Future<void> getAllUsuarios() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final usuarios = await repository.getAllUsuarios();
      state = state.copyWith(usuarios: usuarios, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }



  /// Crear un usuario
  Future<void> createUsuario(UsuarioModel usuario) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.createUsuario(usuario);
      state = state.copyWith(usuario: usuario, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Obtener un usuario por ID
  Future<void> getUsuarioById(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final usuario = await repository.getUsuarioById(id);
      state = state.copyWith(usuario: usuario, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Actualizar usuario
  Future<void> updateUsuario(UsuarioModel usuario) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.updateUsuario(usuario);
      state = state.copyWith(usuario: usuario, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Eliminar usuario
  Future<void> deleteUsuario(String id) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await repository.deleteUsuario(id);
      state = state.copyWith(usuario: null, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }
}
