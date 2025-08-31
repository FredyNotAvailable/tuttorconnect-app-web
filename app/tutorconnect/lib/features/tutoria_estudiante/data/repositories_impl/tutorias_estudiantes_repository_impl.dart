// lib/features/tutorias/data/repositories_impl/tutorias_estudiantes_repository_impl.dart

import '../datasources/tutorias_estudiantes_datasource.dart';
import '../models/tutoria_estudiante_model.dart';

class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

class TutoriasEstudiantesRepositoryImpl {
  final TutoriasEstudiantesDatasource datasource;

  TutoriasEstudiantesRepositoryImpl(this.datasource);

  Future<TutoriaEstudianteModel> createTutoriaEstudiante(TutoriaEstudianteModel te) async {
    try {
      return await datasource.createTutoriaEstudiante(te);
    } catch (e) {
      throw RepositoryException('Error al crear tutoria-estudiante: $e');
    }
  }

  Future<TutoriaEstudianteModel?> getTutoriaEstudianteById(String id) async {
    try {
      return await datasource.getTutoriaEstudianteById(id);
    } catch (e) {
      throw RepositoryException('Error al obtener tutoria-estudiante: $e');
    }
  }

  Future<List<TutoriaEstudianteModel>> getAllTutoriasEstudiantes() async {
    try {
      return await datasource.getAllTutoriasEstudiantes();
    } catch (e) {
      throw RepositoryException('Error al obtener lista de tutoria-estudiante: $e');
    }
  }

  Future<void> updateTutoriaEstudiante(TutoriaEstudianteModel te) async {
    try {
      await datasource.updateTutoriaEstudiante(te);
    } catch (e) {
      throw RepositoryException('Error al actualizar tutoria-estudiante: $e');
    }
  }

  Future<void> deleteTutoriaEstudiante(String id) async {
    try {
      await datasource.deleteTutoriaEstudiante(id);
    } catch (e) {
      throw RepositoryException('Error al eliminar tutoria-estudiante: $e');
    }
  }
}
