import 'package:tutorconnect/features/usuarios/application/providers/usuario_provider.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Devuelve el usuario completo dado su ID, o un usuario por defecto si no se encuentra
UsuarioModel getUsuarioById(WidgetRef ref, String id) {
  final usuariosState = ref.read(usuarioProvider);

  if (usuariosState.usuarios == null || usuariosState.usuarios!.isEmpty) {
    return UsuarioModel(
      id: '',
      nombreCompleto: 'Usuario desconocido',
      correo: '',
      rol: UsuarioRol.estudiante,
      fcmToken: '',
    );
  }

  final usuario = usuariosState.usuarios!.firstWhere(
    (u) => u.id == id,
    orElse: () => UsuarioModel(
      id: '',
      nombreCompleto: 'Usuario desconocido',
      correo: '',
      rol: UsuarioRol.estudiante,
      fcmToken: '',
    ),
  );

  return usuario;
}

/// Devuelve todos los usuarios de un rol específico
List<UsuarioModel> getUsuariosByRol(WidgetRef ref, UsuarioRol rol) {
  final usuariosState = ref.read(usuarioProvider);
  final usuarios = usuariosState.usuarios ?? [];

  return usuarios.where((u) => u.rol == rol).toList();
}

/// Devuelve todos los usuarios excepto uno (por ID)
List<UsuarioModel> getUsuariosExcepto(WidgetRef ref, String id) {
  final usuariosState = ref.read(usuarioProvider);
  final usuarios = usuariosState.usuarios ?? [];

  return usuarios.where((u) => u.id != id).toList();
}
