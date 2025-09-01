import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/carreras/helpers/carrera_helper.dart';
import 'package:tutorconnect/features/mallas_curriculares/application/providers/malla_curricular_provider.dart';
import 'package:tutorconnect/features/mallas_curriculares/helpers/malla_curricular_helper.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/materias_malla/application/providers/materia_malla_provider.dart';
import 'package:tutorconnect/features/matriculas/helpers/matricula_helper.dart';
import 'package:tutorconnect/features/matriculas/application/providers/matricula_provider.dart';
import 'package:tutorconnect/features/carreras/application/providers/carrera_provider.dart';
import 'package:tutorconnect/features/materias_malla/helpers/materia_malla_helper.dart';

class InfoAcademicaWidget extends ConsumerStatefulWidget {
  final String estudianteId;

  const InfoAcademicaWidget({super.key, required this.estudianteId});

  @override
  ConsumerState<InfoAcademicaWidget> createState() => _InfoAcademicaWidgetState();
}

class _InfoAcademicaWidgetState extends ConsumerState<InfoAcademicaWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(matriculaProvider.notifier).getAllMatriculas();
      ref.read(carreraProvider.notifier).getAllCarreras();
      ref.read(mallaCurricularProvider.notifier).getAllMallas();
      ref.read(materiaMallaProvider.notifier).getAllMateriasMalla();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matriculaState = ref.watch(matriculaProvider);

    if (matriculaState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (matriculaState.error != null) {
      return Center(child: Text('Error: ${matriculaState.error}'));
    }

    final matriculas = getAllMatriculasByEstudiante(ref, widget.estudianteId);

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

        // Recorremos las matrículas
        ...matriculas.map((m) {
          final malla = getMallaCurricularById(ref, m.mallaId);
          final carrera = getCarreraById(ref, malla.carreraId);

          print("Carrera: ${carrera?.nombre}, Ciclo: ${malla.ciclo}, Año: ${malla.anio}");


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
                  // Carrera y ciclo
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

                  // Malla curricular y año
                  Text(
                    'Malla Curricular: ${malla.anio}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  // Listado de materias
                  const SizedBox(height: 4),
                  ...getMateriasByMallaId(ref, malla.id).map((matMalla) {
                    final materia = getMateriaById(ref, matMalla.materiaId);
                    print("Materia: ${materia?.nombre}");
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
        }).toList(),
      ],
    );
  }
}

