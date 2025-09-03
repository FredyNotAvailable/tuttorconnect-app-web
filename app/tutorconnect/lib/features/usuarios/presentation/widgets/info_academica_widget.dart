import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/mallas_curriculares/helpers/malla_curricular_helper.dart';
import 'package:tutorconnect/features/carreras/helpers/carrera_helper.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/materias_malla/helpers/materia_malla_helper.dart';

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
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('Error: $error'));
    }

    if (matriculas.isEmpty) {
      return const Text('No tienes matrículas registradas.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Información Académica',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...matriculas.map((m) {
          final malla = getMallaCurricularById(ref, m.mallaId);
          final carrera = getCarreraById(ref, malla.carreraId);

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: theme.colorScheme.surface,
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              carrera?.nombre ?? 'Carrera desconocida',
                              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text('Ciclo: ${malla.ciclo}', style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Malla Curricular: ${malla.anio}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...getMateriasByMallaId(ref, malla.id).map((matMalla) {
                    final materia = getMateriaById(ref, matMalla.materiaId);
                    return Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 2),
                      child: Text(
                        '• ${materia.nombre}',
                        style: theme.textTheme.bodySmall,
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
