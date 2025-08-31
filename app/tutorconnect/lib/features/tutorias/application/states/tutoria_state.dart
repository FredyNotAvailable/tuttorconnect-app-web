import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';

class TutoriaState {
  final List<TutoriaModel>? tutorias;
  final TutoriaModel? tutoria;
  final bool loading;
  final String? error;

  TutoriaState({this.tutorias, this.tutoria, this.loading = false, this.error});

  TutoriaState copyWith({
    List<TutoriaModel>? tutorias,
    TutoriaModel? tutoria,
    bool? loading,
    String? error,
  }) {
    return TutoriaState(
      tutorias: tutorias ?? this.tutorias,
      tutoria: tutoria ?? this.tutoria,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

