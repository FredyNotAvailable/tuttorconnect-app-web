
import 'package:tutorconnect/features/mallas_curriculares/data/datasources/mallas_datasource.dart';
import 'package:tutorconnect/features/mallas_curriculares/data/models/malla_curricular_model.dart';

class MallasRepositoryImpl {
  final MallasDatasource datasource;

  MallasRepositoryImpl(this.datasource);

  Future<List<MallaCurricularModel>> getAllMallas() async {
    return await datasource.getAllMallas();
  }

  Future<MallaCurricularModel?> getMallaById(String id) async {
    return await datasource.getMallaById(id);
  }

  Future<MallaCurricularModel> createMalla(MallaCurricularModel malla) async {
    return await datasource.createMalla(malla);
  }

  Future<void> updateMalla(MallaCurricularModel malla) async {
    return await datasource.updateMalla(malla);
  }

  Future<void> deleteMalla(String id) async {
    return await datasource.deleteMalla(id);
  }
}
