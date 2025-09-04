import 'package:flutter/material.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';

class ClaseCard extends StatelessWidget {
  final MateriaModel materia;

  const ClaseCard({super.key, required this.materia});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.claseDetalle,
            arguments: materia,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 🔹 Ícono decorativo
              CircleAvatar(
                radius: 26,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                child: Icon(
                  Icons.book,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // 🔹 Información de la materia
              Expanded(
                child: Text(
                  materia.nombre,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 🔹 Flecha de navegación
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
