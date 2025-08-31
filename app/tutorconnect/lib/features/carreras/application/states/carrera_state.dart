import 'package:tutorconnect/features/carreras/data/models/carrera_model.dart';

class CarreraState {
  final List<CarreraModel>? carreras;
  final CarreraModel? carrera;
  final bool loading;
  final String? error;

  CarreraState({
    this.carreras,
    this.carrera,
    this.loading = false,
    this.error,
  });

  CarreraState copyWith({
    List<CarreraModel>? carreras,
    CarreraModel? carrera,
    bool? loading,
    String? error,
  }) {
    return CarreraState(
      carreras: carreras ?? this.carreras,
      carrera: carrera ?? this.carrera,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
