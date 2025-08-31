import 'package:tutorconnect/features/carreras/application/providers/carrera_provider.dart';
import 'package:tutorconnect/features/carreras/data/models/carrera_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Devuelve una carrera por ID, o null si no existe
CarreraModel? getCarreraById(WidgetRef ref, String id) {
  final carrerasState = ref.read(carreraProvider);
  final carreras = carrerasState.carreras ?? [];

  try {
    return carreras.firstWhere((c) => c.id == id);
  } catch (_) {
    return null;
  }
}

/// Devuelve todas las carreras cuyo nombre contiene un texto específico
List<CarreraModel> getCarrerasByNombre(WidgetRef ref, String nombre) {
  final carrerasState = ref.read(carreraProvider);
  final carreras = carrerasState.carreras ?? [];

  return carreras.where((c) => c.nombre.toLowerCase().contains(nombre.toLowerCase())).toList();
}

/// Devuelve todas las carreras de una lista de IDs
List<CarreraModel> getCarrerasByIds(WidgetRef ref, List<String> ids) {
  final carrerasState = ref.read(carreraProvider);
  final carreras = carrerasState.carreras ?? [];

  return carreras.where((c) => ids.contains(c.id)).toList();
}
