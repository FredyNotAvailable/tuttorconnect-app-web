import 'package:flutter/material.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';

class ClaseCard extends StatelessWidget {
  final MateriaModel materia;

  const ClaseCard({super.key, required this.materia});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.claseDetalle,
            arguments: materia,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            materia.nombre,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
