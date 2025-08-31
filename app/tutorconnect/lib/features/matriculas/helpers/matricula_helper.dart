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
      carreraId: '',
      ciclo: 0,
    );
  }

  final matricula = state.matriculas!.firstWhere(
    (m) => m.id == id,
    orElse: () => MatriculaModel(
      id: '',
      estudianteId: '',
      carreraId: '',
      ciclo: 0,
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

/// Devuelve todas las matrículas de una carrera dado el ID de la carrera
List<MatriculaModel> getAllMatriculasByCarrera(WidgetRef ref, String carreraId) {
  final state = ref.read(matriculaProvider);
  final matriculas = state.matriculas ?? [];

  return matriculas.where((m) => m.carreraId == carreraId).toList();
}

/// Devuelve todas las materias completas en las que un estudiante está matriculado
List<MateriaModel> getMateriasByEstudianteId(WidgetRef ref, String estudianteId) {
  print("=== getMateriasByEstudianteId ===");
  print("Estudiante ID: $estudianteId");

  // 1️⃣ Obtener todas las matrículas
  final matriculasState = ref.read(matriculaProvider);
  final matriculas = matriculasState.matriculas ?? [];
  print("Todas las matriculas: ${matriculas.map((m) => m.id).toList()}");

  // 2️⃣ Filtrar las matrículas del estudiante
  final matriculasEstudiante = matriculas.where((m) => m.estudianteId == estudianteId).toList();
  print("Matriculas del estudiante: ${matriculasEstudiante.map((m) => m.id).toList()}");

  // 3️⃣ Obtener mallas curriculares
  final mallaState = ref.read(mallaCurricularProvider);
  final mallas = mallaState.mallas ?? [];
  print("Todas las mallas curriculares: ${mallas.map((m) => m.id).toList()}");

  // 4️⃣ Filtrar mallas del estudiante según matrícula
  final mallasEstudiante = mallas.where(
    (m) => matriculasEstudiante.any((mat) => mat.carreraId == m.carreraId && mat.ciclo == m.ciclo)
  ).toList();
  print("Mallas curriculares del estudiante: ${mallasEstudiante.map((m) => m.id).toList()}");

  // 5️⃣ Obtener relaciones materias-malla
  final materiasMallaState = ref.read(materiaMallaProvider);
  final materiasMalla = materiasMallaState.materiasMalla ?? [];
  print("Todas las materiasMalla: ${materiasMalla.map((mm) => mm.materiaId).toList()}");

  // 6️⃣ Filtrar IDs de materias según mallas del estudiante
  final materiasIds = materiasMalla
      .where((mm) => mallasEstudiante.any((m) => m.id == mm.mallaId))
      .map((mm) => mm.materiaId)
      .toSet()
      .toList();
  print("IDs de materias del estudiante: $materiasIds");

  // 7️⃣ Obtener las materias completas
  final materias = materiasIds.map((id) => getMateriaById(ref, id)).toList();
  print("Materias completas del estudiante: ${materias.map((m) => m.nombre).toList()}");

  return materias;
}


/// Devuelve todas las matrículas registradas en el estado
List<MatriculaModel> getAllMatriculas(WidgetRef ref) {
  final state = ref.read(matriculaProvider);
  return state.matriculas ?? [];
}