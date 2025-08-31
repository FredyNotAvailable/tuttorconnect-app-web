import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/tutoria_estudiante/application/providers/tutorias_estudiantes_provider.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/models/tutoria_estudiante_model.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';
import 'package:tutorconnect/features/usuarios/helpers/usuario_helper.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';

/// Devuelve la lista completa de estudiantes asignados a una tutoría
List<UsuarioModel> getAllEstudiantesByTutoria(WidgetRef ref, String tutoriaId) {
  final tutoriasEstudiantesState = ref.read(tutoriasEstudiantesProvider);
  final tutoriasEstudiantes = tutoriasEstudiantesState.tutoriasEstudiantes ?? [];

  final estudiantesAsignados = tutoriasEstudiantes
      .where((te) => te.tutoriaId == tutoriaId)
      .map((te) => getUsuarioById(ref, te.estudianteId))
      .toList();

  return estudiantesAsignados;
}

/// Devuelve la lista completa de tutorías asignadas a un estudiante
List<TutoriaModel> getAllTutoriasByEstudiante(WidgetRef ref, String estudianteId) {
  final tutoriasEstudiantesState = ref.read(tutoriasEstudiantesProvider);
  final tutoriasEstudiantes = tutoriasEstudiantesState.tutoriasEstudiantes ?? [];

  final tutoriasAsignadas = tutoriasEstudiantes
      .where((te) => te.estudianteId == estudianteId)
      .map((te) => getTutoriaById(ref, te.tutoriaId))
      .toList();

  return tutoriasAsignadas;
}

/// Devuelve todos los estudiantes inscritos en una materia
List<UsuarioModel> getAllEstudiantesByMateria(WidgetRef ref, String materiaId) {
  final List<TutoriaModel> tutorias = getAllTutoriasByMateriaId(ref, materiaId);

  final Set<UsuarioModel> estudiantesSet = {};

  for (var tutoria in tutorias) {
    final List<UsuarioModel> estudiantes = getAllEstudiantesByTutoria(ref, tutoria.id);
    estudiantesSet.addAll(estudiantes); // Evitar duplicados
  }

  return estudiantesSet.toList();
}

/// Asigna un estudiante a una tutoría
Future<void> asignarEstudianteATutoria(WidgetRef ref, String tutoriaId, String estudianteId) async {
  final notifier = ref.read(tutoriasEstudiantesProvider.notifier);

  // Creamos el objeto de relación
  final nuevaRelacion = TutoriaEstudianteModel(
    id: '', // Firebase asignará el ID automáticamente
    tutoriaId: tutoriaId,
    estudianteId: estudianteId,
  );

  // Guardamos la relación
  await notifier.createTutoriaEstudiante(nuevaRelacion);
}