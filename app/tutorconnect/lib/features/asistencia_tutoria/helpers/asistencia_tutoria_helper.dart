import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/asistencia_tutoria/application/providers/asistencia_tutoria_provider.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/models/asistencia_tutoria_model.dart';

/// Devuelve la asistencia completa dado su ID, o una asistencia por defecto si no se encuentra
AsistenciaTutoriaModel getAsistenciaById(WidgetRef ref, String id) {
  final state = ref.read(asistenciaTutoriaProvider);

  if (state.asistencias == null || state.asistencias!.isEmpty) {
    return AsistenciaTutoriaModel(
      id: '',
      tutoriaId: '',
      estudianteId: '',
      fecha: Timestamp.now(), // Timestamp en Firestore
      estado: AsistenciaEstado.sinRegistro,
    );
  }

  final asistencia = state.asistencias!.firstWhere(
    (a) => a.id == id,
    orElse: () => AsistenciaTutoriaModel(
      id: '',
      tutoriaId: '',
      estudianteId: '',
      fecha: Timestamp.now() as dynamic,
      estado: AsistenciaEstado.sinRegistro,
    ),
  );

  return asistencia;
}

/// Devuelve todas las asistencias de una tutoría dado el ID de la tutoría
List<AsistenciaTutoriaModel> getAllAsistenciaTutoria(WidgetRef ref, String tutoriaId) {
  final state = ref.read(asistenciaTutoriaProvider);
  final asistencias = state.asistencias ?? [];

  return asistencias.where((a) => a.tutoriaId == tutoriaId).toList();
}

/// Devuelve todas las asistencias de un estudiante dado su ID
/// Si se pasa [tutoriaId], solo devuelve las asistencias de esa tutoría
List<AsistenciaTutoriaModel> getAllAsistenciaByEstudiante(WidgetRef ref, String estudianteId, {String? tutoriaId}) {
  final state = ref.read(asistenciaTutoriaProvider);
  final asistencias = state.asistencias ?? [];

  // Filtra por estudiante
  var resultado = asistencias.where((a) => a.estudianteId == estudianteId);

  // Si se pasó tutoriaId, filtra también por tutoría
  if (tutoriaId != null) {
    resultado = resultado.where((a) => a.tutoriaId == tutoriaId);
  }

  final lista = resultado.toList();

  // Debug: muestra cuántas asistencias encontró
  print('Estudiante $estudianteId - Tutoría $tutoriaId: ${lista.length} asistencia(s)');

  return lista;
}

/// Devuelve todas las asistencias por estado (presente, ausente, etc.)
List<AsistenciaTutoriaModel> getAllAsistenciaByEstado(WidgetRef ref, AsistenciaEstado estado) {
  final state = ref.read(asistenciaTutoriaProvider);
  final asistencias = state.asistencias ?? [];

  return asistencias.where((a) => a.estado == estado).toList();
}

/// Devuelve todas las asistencias de los estudiantes para la tutoría actual
List<AsistenciaTutoriaModel> getAsistenciasPorTutoriaActual(WidgetRef ref, String tutoriaId) {
  final state = ref.read(asistenciaTutoriaProvider);
  final asistencias = state.asistencias ?? [];

  // Filtra únicamente las asistencias que pertenecen a la tutoría actual
  final resultado = asistencias.where((a) => a.tutoriaId == tutoriaId).toList();

  // Debug opcional
  print('Tutoría $tutoriaId: ${resultado.length} asistencia(s) encontradas');

  return resultado;
}

/// Crea una nueva asistencia de tutoría y actualiza el estado local
Future<void> createAsistenciaHelper(WidgetRef ref, AsistenciaTutoriaModel nuevaAsistencia) async {
  final notifier = ref.read(asistenciaTutoriaProvider.notifier);
  await notifier.createAsistencia(nuevaAsistencia);
}

/// Actualiza una asistencia existente y actualiza el estado local
Future<void> updateAsistenciaHelper(WidgetRef ref, AsistenciaTutoriaModel asistenciaActualizada) async {
  final notifier = ref.read(asistenciaTutoriaProvider.notifier);
  await notifier.updateAsistencia(asistenciaActualizada);
}