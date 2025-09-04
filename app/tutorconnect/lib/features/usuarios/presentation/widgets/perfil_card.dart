// lib/features/usuarios/presentation/widgets/perfil_card.dart
import 'package:flutter/material.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/core/themes/app_text_styles.dart';

class PerfilCard extends StatelessWidget {
  final UsuarioModel usuario;

  const PerfilCard({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar circular con inicial
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary,
            child: Text(
              usuario.nombreCompleto.isNotEmpty
                  ? usuario.nombreCompleto[0].toUpperCase()
                  : '?',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.onPrimary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Nombre completo
          Text(
            usuario.nombreCompleto,
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Correo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, size: 16, color: AppColors.darkGrey),
              const SizedBox(width: 4),
              Text(usuario.correo, style: AppTextStyles.body),
            ],
          ),
          const SizedBox(height: 4),

          // Rol
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 16, color: AppColors.darkGrey),
              const SizedBox(width: 4),
              Text(usuario.rolNombre, style: AppTextStyles.body),
            ],
          ),
        ],
      ),
    );
  }
}
