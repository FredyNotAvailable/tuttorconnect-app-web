// lib/features/usuarios/presentation/widgets/perfil_card.dart
import 'package:flutter/material.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class PerfilCard extends StatelessWidget {
  final UsuarioModel usuario;

  const PerfilCard({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        CircleAvatar(
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
        ),
        const SizedBox(height: 16),

        // Nombre
        Text(
          usuario.nombreCompleto,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Correo
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.email, size: 16, color: theme.colorScheme.onSurface),
            const SizedBox(width: 4),
            Text(usuario.correo, style: theme.textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 4),

        // Rol
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.person, size: 16, color: theme.colorScheme.onSurface),
            const SizedBox(width: 4),
            Text(usuario.rolNombre, style: theme.textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}
