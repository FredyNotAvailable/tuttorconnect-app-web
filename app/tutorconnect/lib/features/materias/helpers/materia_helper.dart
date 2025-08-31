import 'package:tutorconnect/features/materias/application/providers/materia_provider.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/tutoria_estudiante/helper/tutoria_estudiante_helper.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';
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


/// Devuelve todos los estudiantes inscritos en una materia
List<UsuarioModel> getAllEstudiantesByMateria(WidgetRef ref, String materiaId) {
  // Obtener todas las tutorías de esta materia
  final List<TutoriaModel> tutorias = getAllTutoriasByMateriaId(ref, materiaId);

  // Usar Set para evitar duplicados
  final Set<UsuarioModel> estudiantesSet = {};

  for (var tutoria in tutorias) {
    final List<UsuarioModel> estudiantes = getAllEstudiantesByTutoria(ref, tutoria.id);
    estudiantesSet.addAll(estudiantes); 
  }

  return estudiantesSet.toList();
}