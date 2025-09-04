import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/tutorias/application/providers/tutoria_provider.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Devuelve la tutoría completa dado su ID
TutoriaModel getTutoriaById(WidgetRef ref, String id) {
  final tutoriaState = ref.read(tutoriaProvider);

  if (tutoriaState.tutorias == null || tutoriaState.tutorias!.isEmpty) {
    return TutoriaModel(
      id: '',
      tema: 'Tema desconocido',
      descripcion: '',
      profesorId: '',
      materiaId: '',
      aulaId: '',
      fecha: Timestamp.now(),
      horaInicio: '',
      horaFin: '',
      estado: TutoriaEstado.cancelada,
    );
  }

  final tutoria = tutoriaState.tutorias!.firstWhere(
    (t) => t.id == id,
    orElse: () => TutoriaModel(
      id: '',
      tema: 'Tema desconocido',
      descripcion: '',
      profesorId: '',
      materiaId: '',
      aulaId: '',
      fecha: Timestamp.now(),
      horaInicio: '',
      horaFin: '',
      estado: TutoriaEstado.cancelada,
    ),
  );

  return tutoria;
}

/// Devuelve todas las tutorías de un profesor
List<TutoriaModel> getAllTutoriasByProfesorId(WidgetRef ref, String profesorId) {
  final tutoriaState = ref.read(tutoriaProvider);
  final tutorias = tutoriaState.tutorias ?? [];

  return tutorias.where((t) => t.profesorId == profesorId).toList();
}

/// Devuelve todas las tutorías de una materia
List<TutoriaModel> getAllTutoriasByMateriaId(WidgetRef ref, String materiaId) {
  final tutoriaState = ref.read(tutoriaProvider);
  final tutorias = tutoriaState.tutorias ?? [];

  return tutorias.where((t) => t.materiaId == materiaId).toList();
}



/// Devuelve todas las tutorías de un aula
List<TutoriaModel> getAllTutoriasByAulaId(WidgetRef ref, String aulaId) {
  final tutoriaState = ref.read(tutoriaProvider);
  final tutorias = tutoriaState.tutorias ?? [];

  return tutorias.where((t) => t.aulaId == aulaId).toList();
}

/// Crea una tutoría y la añade al estado local, devolviendo la creada
Future<TutoriaModel> createTutoriaHelper(WidgetRef ref, TutoriaModel tutoria) async {
  final notifier = ref.read(tutoriaProvider.notifier);
  final nuevaTutoria = await notifier.createTutoria(tutoria);
  return nuevaTutoria;
}

/// Actualiza una tutoría existente y devuelve la tutoría actualizada
Future<TutoriaModel?> updateTutoriaHelper(WidgetRef ref, TutoriaModel tutoriaActualizada) async {
  final notifier = ref.read(tutoriaProvider.notifier);

  try {
    // Llamamos al método del provider/notifier para actualizar
    final updatedTutoria = await notifier.updateTutoria(tutoriaActualizada);

    // Retornamos la tutoría actualizada
    return updatedTutoria;
  } catch (e) {
    // Opcional: manejar error si es necesario
    return null;
  }
}


/// Devuelve todas las tutorías creadas localmente (ya está en tu getAllTutorias)
List<TutoriaModel> getAllTutoriasLocal(WidgetRef ref) {
  final tutoriaState = ref.read(tutoriaProvider);
  return tutoriaState.tutorias ?? [];
}