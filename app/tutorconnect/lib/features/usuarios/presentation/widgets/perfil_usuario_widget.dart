import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/auth/presentation/screens/boton_restablecer_password.dart';
import 'package:tutorconnect/features/usuarios/presentation/widgets/info_academica_widget.dart';

class PerfilUsuarioWidget extends ConsumerWidget {
  final UsuarioModel usuario;

  const PerfilUsuarioWidget({super.key, required this.usuario});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarUsuario(usuario: usuario),
          const SizedBox(height: 16),
          NombreUsuario(usuario: usuario),
          const SizedBox(height: 8),
          CorreoUsuario(usuario: usuario),
          const SizedBox(height: 4),
          RolUsuario(usuario: usuario),
          const SizedBox(height: 16),
          if (usuario.rol == UsuarioRol.estudiante)
            InfoAcademicaWidget(estudianteId: usuario.id),
          const SizedBox(height: 16),
          BotonRestablecerContrasena(correo: usuario.correo),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ===========================
// Subcomponentes
// ===========================
class AvatarUsuario extends StatelessWidget {
  final UsuarioModel usuario;

  const AvatarUsuario({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: 40,
      backgroundColor: theme.colorScheme.primary,
      child: Text(
        usuario.nombreCompleto.isNotEmpty
            ? usuario.nombreCompleto[0].toUpperCase()
            : '?',
        style: theme.textTheme.displayMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
      ),
    );
  }
}

class NombreUsuario extends StatelessWidget {
  final UsuarioModel usuario;

  const NombreUsuario({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      usuario.nombreCompleto,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class CorreoUsuario extends StatelessWidget {
  final UsuarioModel usuario;

  const CorreoUsuario({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.email, size: 16, color: theme.colorScheme.onSurface),
        const SizedBox(width: 4),
        Text(usuario.correo, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class RolUsuario extends StatelessWidget {
  final UsuarioModel usuario;

  const RolUsuario({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.person, size: 16, color: theme.colorScheme.onSurface),
        const SizedBox(width: 4),
        Text(usuario.rolNombre, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
