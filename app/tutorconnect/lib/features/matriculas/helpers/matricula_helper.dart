import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/mallas_curriculares/application/providers/malla_curricular_provider.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/materias_malla/application/providers/materia_malla_provider.dart';
import 'package:tutorconnect/features/matriculas/application/providers/matricula_provider.dart';
import 'package:tutorconnect/features/matriculas/data/models/matricula_model.dart';

/// Devuelve la matrícula completa dado su ID, o una matrícula por defecto si no se encuentra
MatriculaModel getMatriculaById(WidgetRef ref, String id) {
  final state = ref.read(matriculaProvider);

  if (state.matriculas == null || state.matriculas!.isEmpty) {
    return MatriculaModel(
      id: '',
      estudianteId: '',
      mallaId: '',
    );
  }

  final matricula = state.matriculas!.firstWhere(
    (m) => m.id == id,
    orElse: () => MatriculaModel(
      id: '',
      estudianteId: '',
      mallaId: '',
    ),
  );

  return matricula;
}

/// Devuelve todas las matrículas de un estudiante dado el ID del estudiante
List<MatriculaModel> getAllMatriculasByEstudiante(WidgetRef ref, String estudianteId) {
  final state = ref.read(matriculaProvider);
  final matriculas = state.matriculas ?? [];

  return matriculas.where((m) => m.estudianteId == estudianteId).toList();
}

/// Devuelve todas las matrículas de una malla dado el ID de la malla
List<MatriculaModel> getAllMatriculasByMalla(WidgetRef ref, String mallaId) {
  final state = ref.read(matriculaProvider);
  final matriculas = state.matriculas ?? [];

  return matriculas.where((m) => m.mallaId == mallaId).toList();
}

/// Devuelve todas las materias completas en las que un estudiante está matriculado
List<MateriaModel> getMateriasByEstudianteId(WidgetRef ref, String estudianteId) {
  print("=== getMateriasByEstudianteId ===");

  // 1️⃣ Obtener todas las matrículas
  final matriculas = ref.read(matriculaProvider).matriculas ?? [];
  
  // 2️⃣ Filtrar matrículas del estudiante
  final matriculasEstudiante = matriculas.where((m) => m.estudianteId == estudianteId).toList();
  print("Matriculas del estudiante: ${matriculasEstudiante.map((m) => m.id).toList()}");

  if (matriculasEstudiante.isEmpty) return [];

  // 3️⃣ Obtener mallas curriculares correspondientes
  final mallas = ref.read(mallaCurricularProvider).mallas ?? [];
  final mallasEstudiante = mallas
      .where((m) => matriculasEstudiante.any((mat) => mat.mallaId == m.id))
      .toList();
  print("Mallas del estudiante: ${mallasEstudiante.map((m) => m.id).toList()}");

  // 4️⃣ Obtener todas las materias-malla
  final materiasMalla = ref.read(materiaMallaProvider).materiasMalla ?? [];

  // 5️⃣ Filtrar materias que pertenecen a las mallas del estudiante
  final materiaIds = materiasMalla
      .where((mm) => mallasEstudiante.any((m) => m.id == mm.mallaId))
      .map((mm) => mm.materiaId)
      .toSet()
      .toList();
  print("IDs de materias: $materiaIds");

  // 6️⃣ Obtener las materias completas
  final materias = materiaIds.map((id) => getMateriaById(ref, id)).whereType<MateriaModel>().toList();
  print("Materias completas: ${materias.map((m) => m.nombre).toList()}");

  return materias;
}


/// Devuelve todas las matrículas registradas en el estado
List<MatriculaModel> getAllMatriculas(WidgetRef ref) {
  final state = ref.read(matriculaProvider);
  return state.matriculas ?? [];
}
