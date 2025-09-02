// lib/features/auth/data/repositories_impl/auth_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

class AuthRepositoryImpl {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._auth, this._firestore);

  Future<UsuarioModel> getUser(String uid) async {
    try {
      final userDoc = await _firestore.collection('usuarios').doc(uid).get();
      if (!userDoc.exists) {
        throw RepositoryException('Usuario no encontrado en Firestore');
      }
      return UsuarioModel.fromJson(userDoc.data()!, uid);
    } catch (e) {
      throw RepositoryException('Error al obtener usuario: $e');
    }
  }

  Future<bool> checkUserExistsByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('usuarios')
          .where('correo', isEqualTo: email)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw RepositoryException('Error al verificar existencia de usuario: $e');
    }
  }

  /// Login con email y password
  Future<UsuarioModel> login(String email, String password) async {
    try {
      print('Iniciando sesión para el correo: $email');
      final credential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      final userDoc =
          await _firestore.collection('usuarios').doc(credential.user!.uid).get();

      if (!userDoc.exists) {
        print('Error: Usuario no encontrado en Firestore para el uid: ${credential.user!.uid}');
        throw RepositoryException('Usuario no encontrado en Firestore');
      }

      print('Inicio de sesión exitoso para: $email');
      // Pasar el Map de datos y el uid del documento
      return UsuarioModel.fromJson(userDoc.data()!, credential.user!.uid);
    } catch (e) {
      print('Error al iniciar sesión para $email: $e');
      throw RepositoryException('Error al iniciar sesión: $e');
    }
  }

  /// Enviar correo de restablecimiento de contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Configurar idioma a español
      _auth.setLanguageCode('es'); // 'es' para español

      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw RepositoryException('Error al enviar correo de recuperación: $e');
    }
  }


  /// Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw RepositoryException('Error al cerrar sesión: $e');
    }
  }
}
