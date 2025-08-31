import 'package:tutorconnect/features/carreras/data/models/carrera_model.dart';
import '../datasources/carreras_datasource.dart';

class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

class CarrerasRepositoryImpl {
  final CarrerasDatasource datasource;

  CarrerasRepositoryImpl(this.datasource);

  Future<CarreraModel> createCarrera(CarreraModel carrera) async {
    try {
      return await datasource.createCarrera(carrera);
    } catch (e) {
      throw RepositoryException('Error al crear carrera: $e');
    }
  }

  Future<CarreraModel?> getCarreraById(String id) async {
    try {
      return await datasource.getCarreraById(id);
    } catch (e) {
      throw RepositoryException('Error al obtener carrera: $e');
    }
  }

  Future<List<CarreraModel>> getAllCarreras() async {
    try {
      return await datasource.getAllCarreras();
    } catch (e) {
      throw RepositoryException('Error al obtener lista de carreras: $e');
    }
  }

  Future<void> updateCarrera(CarreraModel carrera) async {
    try {
      await datasource.updateCarrera(carrera);
    } catch (e) {
      throw RepositoryException('Error al actualizar carrera: $e');
    }
  }

  Future<void> deleteCarrera(String id) async {
    try {
      await datasource.deleteCarrera(id);
    } catch (e) {
      throw RepositoryException('Error al eliminar carrera: $e');
    }
  }
}
