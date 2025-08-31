// lib/features/usuarios/data/repositories_impl/usuarios_repository_impl.dart

import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

import '../datasources/usuarios_datasource.dart';

class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

class UsuariosRepositoryImpl {
  final UsuariosDatasource datasource;

  UsuariosRepositoryImpl(this.datasource);

  /// Crear usuario
  Future<UsuarioModel> createUsuario(UsuarioModel usuario) async {
    try {
      // datasource.createUsuario devuelve el UsuarioModel con ID asignado
      final createdUsuario = await datasource.createUsuario(usuario);
      return createdUsuario;
    } catch (e) {
      throw RepositoryException('Error al crear usuario: $e');
    }
  }

  /// Obtener un usuario por ID
  Future<UsuarioModel?> getUsuarioById(String id) async {
    try {
      return await datasource.getUsuarioById(id);
    } catch (e) {
      throw RepositoryException('Error al obtener usuario: $e');
    }
  }

  /// Obtener todos los usuarios
  Future<List<UsuarioModel>> getAllUsuarios() async {
    try {
      return await datasource.getAllUsuarios();
    } catch (e) {
      throw RepositoryException('Error al obtener lista de usuarios: $e');
    }
  }

  /// Actualizar usuario
  Future<void> updateUsuario(UsuarioModel usuario) async {
    try {
      await datasource.updateUsuario(usuario);
    } catch (e) {
      throw RepositoryException('Error al actualizar usuario: $e');
    }
  }

  /// Eliminar usuario
  Future<void> deleteUsuario(String id) async {
    try {
      await datasource.deleteUsuario(id);
    } catch (e) {
      throw RepositoryException('Error al eliminar usuario: $e');
    }
  }
}
