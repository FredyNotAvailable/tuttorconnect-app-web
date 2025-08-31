import 'package:tutorconnect/features/materias_malla/data/models/materia_malla_model.dart';
import 'package:tutorconnect/features/materias_malla/data/datasources/materias_malla_datasource.dart';

class MateriasMallaRepositoryImpl {
  final MateriasMallaDatasource datasource;

  MateriasMallaRepositoryImpl(this.datasource);

  Future<List<MateriaMallaModel>> getAllMateriasMalla() async {
    return await datasource.getAllMateriasMalla();
  }

  Future<MateriaMallaModel?> getMateriaMallaById(String id) async {
    return await datasource.getMateriaMallaById(id);
  }

  Future<MateriaMallaModel> createMateriaMalla(MateriaMallaModel materiaMalla) async {
    return await datasource.createMateriaMalla(materiaMalla);
  }

  Future<void> updateMateriaMalla(MateriaMallaModel materiaMalla) async {
    return await datasource.updateMateriaMalla(materiaMalla);
  }

  Future<void> deleteMateriaMalla(String id) async {
    return await datasource.deleteMateriaMalla(id);
  }
}
