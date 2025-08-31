import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import '../datasources/materias_datasource.dart';

class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

class MateriasRepositoryImpl {
  final MateriasDatasource datasource;

  MateriasRepositoryImpl(this.datasource);

  Future<MateriaModel> createMateria(MateriaModel materia) async {
    try {
      return await datasource.createMateria(materia);
    } catch (e) {
      throw RepositoryException('Error al crear materia: $e');
    }
  }

  Future<MateriaModel?> getMateriaById(String id) async {
    try {
      return await datasource.getMateriaById(id);
    } catch (e) {
      throw RepositoryException('Error al obtener materia: $e');
    }
  }

  Future<List<MateriaModel>> getAllMaterias() async {
    try {
      return await datasource.getAllMaterias();
    } catch (e) {
      throw RepositoryException('Error al obtener lista de materias: $e');
    }
  }

  Future<void> updateMateria(MateriaModel materia) async {
    try {
      await datasource.updateMateria(materia);
    } catch (e) {
      throw RepositoryException('Error al actualizar materia: $e');
    }
  }

  Future<void> deleteMateria(String id) async {
    try {
      await datasource.deleteMateria(id);
    } catch (e) {
      throw RepositoryException('Error al eliminar materia: $e');
    }
  }
}
