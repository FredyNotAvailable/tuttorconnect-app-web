import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/materias_malla/application/providers/materia_malla_provider.dart';
import 'package:tutorconnect/features/materias_malla/data/models/materia_malla_model.dart';

/// Devuelve la relación completa dado su ID, o una relación por defecto si no se encuentra
MateriaMallaModel getMateriaMallaById(WidgetRef ref, String id) {
  final state = ref.read(materiaMallaProvider);

  if (state.materiasMalla == null || state.materiasMalla!.isEmpty) {
    return MateriaMallaModel(
      id: '',
      mallaId: '',
      materiaId: '',
    );
  }

  final mm = state.materiasMalla!.firstWhere(
    (m) => m.id == id,
    orElse: () => MateriaMallaModel(
      id: '',
      mallaId: '',
      materiaId: '',
    ),
  );

  return mm;
}

/// Devuelve todas las materias de una malla dado el ID de la malla
List<MateriaMallaModel> getMateriasByMallaId(WidgetRef ref, String mallaId) {
  final state = ref.read(materiaMallaProvider);
  final list = state.materiasMalla ?? [];

  return list.where((m) => m.mallaId == mallaId).toList();
}

/// Devuelve todas las mallas que contienen una materia dado el ID de la materia
List<MateriaMallaModel> getMallasByMateriaId(WidgetRef ref, String materiaId) {
  final state = ref.read(materiaMallaProvider);
  final list = state.materiasMalla ?? [];

  return list.where((m) => m.materiaId == materiaId).toList();
}
