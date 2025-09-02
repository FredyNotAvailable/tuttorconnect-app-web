import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/core/themes/app_text_styles.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class TutoriaCard extends StatelessWidget {
  final TutoriaModel tutoria;
  final MateriaModel materia;
  final UsuarioModel docente;
  final VoidCallback? onTap;
  final String Function(Timestamp?) formatDate;

  const TutoriaCard({
    super.key,
    required this.tutoria,
    required this.materia,
    required this.docente,
    this.onTap,
    required this.formatDate,
  });

@override
Widget build(BuildContext context) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
      child: Card(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 6), // solo margen vertical
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la tutoría
              Text(
                tutoria.tema,
                style: AppTextStyles.heading2.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),

              // Docente
              Text(
                docente.nombreCompleto,
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),

              // Materia
              Text(
                materia.nombre,
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 6),

              // Fecha y hora
              Text(
                'Fecha: ${formatDate(tutoria.fecha)} | ${tutoria.horaInicio} - ${tutoria.horaFin}',
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
