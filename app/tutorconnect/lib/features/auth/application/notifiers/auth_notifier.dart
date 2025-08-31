// auth_notifier.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/states/auth_state.dart';
import 'package:tutorconnect/features/auth/data/repositories_impl/auth_repository_impl.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryImpl repository;
  final FirebaseAuth _auth;

  AuthNotifier(this.repository, this._auth) : super(AuthState(loading: true)) {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userModel = await repository.getUser(user.uid);
        state = state.copyWith(user: userModel, loading: false);
      } catch (e) {
        // User is authenticated but not found in firestore, so log them out
        await repository.logout();
        state = AuthState(loading: false);
      }
    } else {
      state = AuthState(loading: false);
    }
  }

  /// Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final user = await repository.login(email, password);
      state = state.copyWith(user: user, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Enviar correo para restablecer contraseña
  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final userExists = await repository.checkUserExistsByEmail(email);
      if (!userExists) {
        state = state.copyWith(loading: false, error: 'El correo electrónico no está registrado.');
        return false;
      }
      await repository.sendPasswordResetEmail(email);
      state = state.copyWith(loading: false);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await repository.logout();
    state = AuthState();
  }
}
