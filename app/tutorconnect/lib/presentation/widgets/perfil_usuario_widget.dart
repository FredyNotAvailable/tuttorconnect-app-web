import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/presentation/widgets/boton_restablecer_password.dart';
import 'package:tutorconnect/presentation/widgets/info_academica_widget.dart';

class PerfilUsuarioWidget extends ConsumerWidget {
  final UsuarioModel usuario;

  const PerfilUsuarioWidget({super.key, required this.usuario});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ===========================
          // Avatar del usuario
          // ===========================
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

          // ===========================
          // Nombre completo
          // ===========================
          Text(
            usuario.nombreCompleto,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // ===========================
          // Correo
          // ===========================
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.email, size: 16, color: theme.colorScheme.onSurface),
              const SizedBox(width: 4),
              Text(usuario.correo, style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),

          // ===========================
          // Rol
          // ===========================
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.person, size: 16, color: theme.colorScheme.onSurface),
              const SizedBox(width: 4),
              Text(usuario.rolNombre, style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 16),

          // ===========================
          // Información académica (solo estudiantes)
          // ===========================
          if (usuario.rol == UsuarioRol.estudiante)
            InfoAcademicaWidget(estudianteId: usuario.id),

            
          // ===========================
          // Botón de restablecer contraseña
          // ===========================
          BotonRestablecerContrasena(correo: usuario.correo),
          const SizedBox(height: 24),

        ],
        
      ),
    );
  }
}
