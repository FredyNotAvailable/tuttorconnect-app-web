import 'package:tutorconnect/features/profesores_materias/data/models/profesor_materia_model.dart';
import 'package:tutorconnect/features/profesores_materias/data/datasources/profesores_materias_datasource.dart';

class ProfesoresMateriasRepositoryImpl {
  final ProfesoresMateriasDatasource datasource;

  ProfesoresMateriasRepositoryImpl(this.datasource);

  Future<List<ProfesorMateriaModel>> getAllProfesoresMaterias() async {
    return await datasource.getAllProfesoresMaterias();
  }

  Future<ProfesorMateriaModel?> getProfesorMateriaById(String id) async {
    return await datasource.getProfesorMateriaById(id);
  }

  Future<ProfesorMateriaModel> createProfesorMateria(ProfesorMateriaModel pm) async {
    return await datasource.createProfesorMateria(pm);
  }

  Future<void> updateProfesorMateria(ProfesorMateriaModel pm) async {
    return await datasource.updateProfesorMateria(pm);
  }

  Future<void> deleteProfesorMateria(String id) async {
    return await datasource.deleteProfesorMateria(id);
  }
}
