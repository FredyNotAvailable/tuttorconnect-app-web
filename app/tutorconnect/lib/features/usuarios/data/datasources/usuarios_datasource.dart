// lib/features/usuarios/data/datasources/usuarios_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class UsuariosDatasource {
  final FirebaseFirestore _db;

  UsuariosDatasource(this._db);

  /// Crear un usuario
  Future<UsuarioModel> createUsuario(UsuarioModel usuario) async {
    try {
      final docRef = _db.collection('usuarios').doc(); // ID generado por Firebase
      final usuarioConId = UsuarioModel(
        id: docRef.id,
        nombreCompleto: usuario.nombreCompleto,
        correo: usuario.correo,
        rol: usuario.rol,
        fcmToken: usuario.fcmToken,
      );
      await docRef.set(usuarioConId.toJson());
      return usuarioConId;
    } catch (e) {
      throw DatasourceException('Error al crear usuario: $e');
    }
  }

  /// Leer un usuario por ID
  Future<UsuarioModel?> getUsuarioById(String id) async {
    try {
      final doc = await _db.collection('usuarios').doc(id).get();
      if (doc.exists) {
        return UsuarioModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) 
    {
      throw DatasourceException('Error al obtener usuario: $e');
    }
  }

  /// Leer todos los usuarios
  Future<List<UsuarioModel>> getAllUsuarios() async {
    try {
      final snapshot = await _db.collection('usuarios').get();
      return snapshot.docs
          .map((doc) => UsuarioModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) 
    {
      throw DatasourceException('Error al obtener lista de usuarios: $e');
    }
  }

  /// Actualizar usuario
  Future<void> updateUsuario(UsuarioModel usuario) async {
    try {
      await _db.collection('usuarios').doc(usuario.id).update(usuario.toJson());
    } catch (e) 
    {
      throw DatasourceException('Error al actualizar usuario: $e');
    }
  }

  /// Eliminar usuario
  Future<void> deleteUsuario(String id) async {
    try {
      await _db.collection('usuarios').doc(id).delete();
    } catch (e) 
    {
      throw DatasourceException('Error al eliminar usuario: $e');
    }
  }
}
