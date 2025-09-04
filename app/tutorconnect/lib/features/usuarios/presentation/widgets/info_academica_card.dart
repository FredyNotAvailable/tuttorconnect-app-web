import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/mallas_curriculares/helpers/malla_curricular_helper.dart';
import 'package:tutorconnect/features/carreras/helpers/carrera_helper.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/materias_malla/helpers/materia_malla_helper.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/core/themes/app_text_styles.dart';

class InfoAcademicaCard extends StatelessWidget {
  final List matriculas;
  final bool loading;
  final String? error;
  final WidgetRef ref;

  const InfoAcademicaCard({
    super.key,
    required this.matriculas,
    required this.loading,
    required this.error,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (error != null) {
      return Center(
        child: Text(
          'Error: $error',
          style: AppTextStyles.body.copyWith(color: AppColors.error),
        ),
      );
    }

    if (matriculas.isEmpty) {
      return Text(
        'No tienes matrículas registradas.',
        style: AppTextStyles.body,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información Académica',
          style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 12),
        ...matriculas.map((m) {
          final malla = getMallaCurricularById(ref, m.mallaId);
          final carrera = getCarreraById(ref, malla.carreraId);

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: AppColors.surface,
            elevation: 4,
            shadowColor: AppColors.primary.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.school,
                          size: 28,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              carrera?.nombre ?? 'Carrera desconocida',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Ciclo: ${malla.ciclo}',
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Malla Curricular: ${malla.anio}',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...getMateriasByMallaId(ref, malla.id).map((matMalla) {
                    final materia = getMateriaById(ref, matMalla.materiaId);
                    return Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 6,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            materia.nombre,
                            style: AppTextStyles.body.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
