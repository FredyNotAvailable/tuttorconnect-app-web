import 'package:tutorconnect/features/materias/application/providers/materia_provider.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/materias_malla/application/providers/materia_malla_provider.dart';
import 'package:tutorconnect/features/matriculas/application/providers/matricula_provider.dart';
import 'package:tutorconnect/features/usuarios/application/providers/usuario_provider.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

/// Devuelve una materia completa dado su ID, o una materia por defecto si no se encuentra
MateriaModel getMateriaById(WidgetRef ref, String id) {
  final materiasState = ref.read(materiaProvider);
  final materias = materiasState.materias ?? [];

  final materia = materias.firstWhere(
    (m) => m.id == id,
    orElse: () => MateriaModel(
      id: '',
      nombre: 'Materia desconocida',
    ),
  );

  return materia;
}

/// Devuelve todas las materias cuyo nombre contiene un texto específico
List<MateriaModel> getMateriasByNombre(WidgetRef ref, String nombre) {
  final materiasState = ref.read(materiaProvider);
  final materias = materiasState.materias ?? [];

  return materias.where((m) => m.nombre.toLowerCase().contains(nombre.toLowerCase())).toList();
}

/// Devuelve todas las materias de una lista de IDs
List<MateriaModel> getMateriasByIds(WidgetRef ref, List<String> ids) {
  final materiasState = ref.read(materiaProvider);
  final materias = materiasState.materias ?? [];

  return materias.where((m) => ids.contains(m.id)).toList();
}


/// Devuelve todos los estudiantes inscritos en una materia según la malla
List<UsuarioModel> getAllEstudiantesByMateria(WidgetRef ref, String materiaId) {
  final matriculasState = ref.read(matriculaProvider);
  // final mallaState = ref.read(mallaCurricularProvider);
  final materiasMallaState = ref.read(materiaMallaProvider);
  final usuariosState = ref.read(usuarioProvider);

  final matriculas = matriculasState.matriculas ?? [];
  // final mallas = mallaState.mallas ?? [];
  final materiasMalla = materiasMallaState.materiasMalla ?? [];
  final usuarios = usuariosState.usuarios ?? [];

  // 1️⃣ Obtener los IDs de mallas que contienen la materia
  final mallasQueIncluyenMateria = materiasMalla
      .where((mm) => mm.materiaId == materiaId)
      .map((mm) => mm.mallaId)
      .toSet();

  // 2️⃣ Filtrar las matriculas que correspondan a esas mallas
  final matriculasFiltradas = matriculas
      .where((m) => mallasQueIncluyenMateria.contains(m.mallaId))
      .toList();

  // 3️⃣ Obtener los IDs de estudiantes de esas matriculas
  final estudianteIds = matriculasFiltradas.map((m) => m.estudianteId).toSet();

  // 4️⃣ Buscar los usuarios correspondientes
  final estudiantes = usuarios
      .where((u) => estudianteIds.contains(u.id) && u.rol == UsuarioRol.estudiante)
      .toList();

  return estudiantes;
}
