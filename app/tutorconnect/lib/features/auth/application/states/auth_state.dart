// auth_state.dart


import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class AuthState {
  final UsuarioModel? user;
  final bool loading;
  final String? error;
  final String? lastAttemptedEmail;

  AuthState({this.user, this.loading = false, this.error, this.lastAttemptedEmail});

  AuthState copyWith({
    UsuarioModel? user,
    bool? loading,
    String? error,
    String? lastAttemptedEmail,
  }) {
    return AuthState(
      user: user ?? this.user,
      loading: loading ?? this.loading,
      error: error,
      lastAttemptedEmail: lastAttemptedEmail ?? this.lastAttemptedEmail,
    );
  }
}
