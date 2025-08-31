// lib/features/horarios/helpers/horario_helper.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/horarios_clases/application/providers/horarios_clases_provider.dart';
import 'package:tutorconnect/features/horarios_clases/data/models/horario_clase_model.dart';

/// Devuelve todos los horarios de un profesor específico
List<HorarioClaseModel> getHorariosByProfesor(WidgetRef ref, String profesorId) {
  final horariosState = ref.read(horariosClasesProvider);
  final horarios = horariosState.horarios ?? [];

  return horarios.where((h) => h.profesorId == profesorId).toList();
}

/// Devuelve todos los horarios de un aula específica
List<HorarioClaseModel> getHorariosByAula(WidgetRef ref, String aulaId) {
  final horariosState = ref.read(horariosClasesProvider);
  final horarios = horariosState.horarios ?? [];

  return horarios.where((h) => h.aulaId == aulaId).toList();
}

/// Devuelve todos los horarios de una materia específica
List<HorarioClaseModel> getHorariosByMateria(WidgetRef ref, String materiaId) {
  final horariosState = ref.read(horariosClasesProvider);
  final horarios = horariosState.horarios ?? [];

  return horarios.where((h) => h.materiaId == materiaId).toList();
}

/// Devuelve los horarios de un profesor en un día específico
List<HorarioClaseModel> getHorariosByProfesorAndDia(WidgetRef ref, String profesorId, DiaSemana dia) {
  final horariosState = ref.read(horariosClasesProvider);
  final horarios = horariosState.horarios ?? [];

  return horarios.where((h) => h.profesorId == profesorId && h.diaSemana == dia).toList();
}
