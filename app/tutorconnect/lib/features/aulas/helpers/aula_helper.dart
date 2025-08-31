import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/aulas/application/providers/aula_provider.dart';
import 'package:tutorconnect/features/aulas/data/models/aula_model.dart';

/// Devuelve la aula completa dado su ID, o una aula por defecto si no se encuentra
AulaModel getAulaById(WidgetRef ref, String id) {
  final aulasState = ref.read(aulaProvider);

  if (aulasState.aulas == null || aulasState.aulas!.isEmpty) {
    return AulaModel(
      id: '',
      nombre: 'Aula desconocida',
      tipo: '',
      estado: AulaEstado.noDisponible,
    );
  }

  final aula = aulasState.aulas!.firstWhere(
    (a) => a.id == id,
    orElse: () => AulaModel(
      id: '',
      nombre: 'Aula desconocida',
      tipo: '',
      estado: AulaEstado.noDisponible,
    ),
  );

  return aula;
}

/// Devuelve todas las aulas disponibles
List<AulaModel> getAulasDisponibles(WidgetRef ref) {
  final aulasState = ref.read(aulaProvider);
  final aulas = aulasState.aulas ?? [];

  return aulas.where((a) => a.estado == AulaEstado.disponible).toList();
}

/// Devuelve todas las aulas de un tipo específico (ej: "laboratorio", "teórica")
List<AulaModel> getAulasByTipo(WidgetRef ref, String tipo) {
  final aulasState = ref.read(aulaProvider);
  final aulas = aulasState.aulas ?? [];

  return aulas.where((a) => a.tipo.toLowerCase() == tipo.toLowerCase()).toList();
}
