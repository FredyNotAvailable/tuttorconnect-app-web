// lib/features/horarios/application/states/horarios_clases_state.dart


import 'package:tutorconnect/features/horarios_clases/data/models/horario_clase_model.dart';

class HorarioClaseState {
  final List<HorarioClaseModel>? horarios;
  final HorarioClaseModel? horario;
  final bool loading;
  final String? error;

  HorarioClaseState({
    this.horarios,
    this.horario,
    this.loading = false,
    this.error,
  });

  HorarioClaseState copyWith({
    List<HorarioClaseModel>? horarios,
    HorarioClaseModel? horario,
    bool? loading,
    String? error,
  }) {
    return HorarioClaseState(
      horarios: horarios ?? this.horarios,
      horario: horario ?? this.horario,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
