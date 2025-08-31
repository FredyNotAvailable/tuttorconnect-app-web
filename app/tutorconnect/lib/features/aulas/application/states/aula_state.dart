import 'package:tutorconnect/features/aulas/data/models/aula_model.dart';

class AulaState {
  final List<AulaModel>? aulas;
  final AulaModel? aula;
  final bool loading;
  final String? error;

  AulaState({
    this.aulas,
    this.aula,
    this.loading = false,
    this.error,
  });

  AulaState copyWith({
    List<AulaModel>? aulas,
    AulaModel? aula,
    bool? loading,
    String? error,
  }) {
    return AulaState(
      aulas: aulas ?? this.aulas,
      aula: aula ?? this.aula,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
