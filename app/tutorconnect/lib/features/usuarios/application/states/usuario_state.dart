import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class UsuarioState {
  final List<UsuarioModel>? usuarios; // lista de todos los usuarios
  final UsuarioModel? usuario;       // usuario individual
  final bool loading;
  final String? error;

  UsuarioState({
    this.usuarios,
    this.usuario,
    this.loading = false,
    this.error,
  });

  UsuarioState copyWith({
    List<UsuarioModel>? usuarios,
    UsuarioModel? usuario,
    bool? loading,
    String? error,
  }) {
    return UsuarioState(
      usuarios: usuarios ?? this.usuarios,
      usuario: usuario ?? this.usuario,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
