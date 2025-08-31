import 'package:tutorconnect/features/matriculas/data/models/matricula_model.dart';
import 'package:tutorconnect/features/matriculas/data/datasources/matriculas_datasource.dart';

class MatriculasRepositoryImpl {
  final MatriculasDatasource datasource;

  MatriculasRepositoryImpl(this.datasource);

  Future<List<MatriculaModel>> getAllMatriculas() async {
    return await datasource.getAllMatriculas();
  }

  Future<MatriculaModel?> getMatriculaById(String id) async {
    return await datasource.getMatriculaById(id);
  }

  Future<MatriculaModel> createMatricula(MatriculaModel matricula) async {
    return await datasource.createMatricula(matricula);
  }

  Future<void> updateMatricula(MatriculaModel matricula) async {
    return await datasource.updateMatricula(matricula);
  }

  Future<void> deleteMatricula(String id) async {
    return await datasource.deleteMatricula(id);
  }
}
