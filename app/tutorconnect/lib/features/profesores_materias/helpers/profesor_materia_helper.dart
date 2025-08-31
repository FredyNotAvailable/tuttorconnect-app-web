import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/profesores_materias/application/providers/profesor_materia_provider.dart';
import 'package:tutorconnect/features/profesores_materias/data/models/profesor_materia_model.dart';

/// Devuelve la relación completa dado su ID, o una relación por defecto si no se encuentra
ProfesorMateriaModel getProfesorMateriaById(WidgetRef ref, String id) {
  final state = ref.read(profesorMateriaProvider);

  if (state.profesoresMaterias == null || state.profesoresMaterias!.isEmpty) {
    return ProfesorMateriaModel(
      id: '',
      profesorId: '',
      materiaId: '',
    );
  }

  final pm = state.profesoresMaterias!.firstWhere(
    (p) => p.id == id,
    orElse: () => ProfesorMateriaModel(
      id: '',
      profesorId: '',
      materiaId: '',
    ),
  );

  return pm;
}

/// Devuelve todas las materias de un profesor dado el ID del profesor
List<ProfesorMateriaModel> getMateriasByProfesorId(WidgetRef ref, String profesorId) {
  final state = ref.read(profesorMateriaProvider);

  final list = state.profesoresMaterias ?? [];

  final materiasProfesor = list.where((p) => p.profesorId == profesorId).toList();

  // Debug prints
  print('ID del profesor: $profesorId');
  print('Materias totales disponibles: ${list.length}');
  print('Materias asignadas al profesor: ${materiasProfesor.length}');
  for (var pm in materiasProfesor) {
    print('Materia asignada: ${pm.materiaId}');
  }

  return materiasProfesor;
}

/// Devuelve todos los profesores que dictan una materia dado el ID de la materia
List<ProfesorMateriaModel> getProfesoresByMateriaId(WidgetRef ref, String materiaId) {
  final state = ref.read(profesorMateriaProvider);

  final list = state.profesoresMaterias ?? [];

  return list.where((p) => p.materiaId == materiaId).toList();
}
