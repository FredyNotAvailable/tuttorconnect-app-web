import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/mallas_curriculares/application/providers/malla_curricular_provider.dart';
import 'package:tutorconnect/features/mallas_curriculares/data/models/malla_curricular_model.dart';

/// Devuelve la malla curricular completa dado su ID, o una malla por defecto si no se encuentra
MallaCurricularModel getMallaCurricularById(WidgetRef ref, String id) {
  final state = ref.read(mallaCurricularProvider);

  if (state.mallas == null || state.mallas!.isEmpty) {
    return MallaCurricularModel(
      id: '',
      carreraId: '',
      ciclo: 0,
      anio: 0,
    );
  }

  final malla = state.mallas!.firstWhere(
    (m) => m.id == id,
    orElse: () => MallaCurricularModel(
      id: '',
      carreraId: '',
      ciclo: 0,
      anio: 0,
    ),
  );

  return malla;
}

/// Devuelve todas las mallas de una carrera dado el ID de la carrera
List<MallaCurricularModel> getMallasByCarreraId(WidgetRef ref, String carreraId) {
  final state = ref.read(mallaCurricularProvider);
  final mallas = state.mallas ?? [];

  return mallas.where((m) => m.carreraId == carreraId).toList();
}

/// Devuelve todas las mallas de un ciclo específico
List<MallaCurricularModel> getMallasByCiclo(WidgetRef ref, int ciclo) {
  final state = ref.read(mallaCurricularProvider);
  final mallas = state.mallas ?? [];

  return mallas.where((m) => m.ciclo == ciclo).toList();
}
