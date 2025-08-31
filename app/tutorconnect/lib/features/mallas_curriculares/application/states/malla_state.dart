
import 'package:tutorconnect/features/mallas_curriculares/data/models/malla_curricular_model.dart';

class MallaState {
  final List<MallaCurricularModel>? mallas;
  final MallaCurricularModel? malla;
  final bool loading;
  final String? error;

  MallaState({
    this.mallas,
    this.malla,
    this.loading = false,
    this.error,
  });

  MallaState copyWith({
    List<MallaCurricularModel>? mallas,
    MallaCurricularModel? malla,
    bool? loading,
    String? error,
  }) {
    return MallaState(
      mallas: mallas ?? this.mallas,
      malla: malla ?? this.malla,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
