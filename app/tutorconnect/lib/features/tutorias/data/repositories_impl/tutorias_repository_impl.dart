import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import '../datasources/tutorias_datasource.dart';

class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

class TutoriasRepositoryImpl {
  final TutoriasDatasource datasource;

  TutoriasRepositoryImpl(this.datasource);

  /// Crear tutoría
  Future<TutoriaModel> createTutoria(TutoriaModel tutoria) async {
    try {
      final createdTutoria = await datasource.createTutoria(tutoria);
      return createdTutoria;
    } catch (e) {
      throw RepositoryException('Error al crear tutoría: $e');
    }
  }

  /// Obtener tutoría por ID
  Future<TutoriaModel?> getTutoriaById(String id) async {
    try {
      return await datasource.getTutoriaById(id);
    } catch (e) {
      throw RepositoryException('Error al obtener tutoría: $e');
    }
  }

  /// Obtener todas las tutorías
  Future<List<TutoriaModel>> getAllTutorias() async {
    try {
      return await datasource.getAllTutorias();
    } catch (e) {
      throw RepositoryException('Error al obtener lista de tutorías: $e');
    }
  }

  /// Actualizar tutoría
  Future<void> updateTutoria(TutoriaModel tutoria) async {
    try {
      await datasource.updateTutoria(tutoria);
    } catch (e) {
      throw RepositoryException('Error al actualizar tutoría: $e');
    }
  }

  /// Eliminar tutoría
  Future<void> deleteTutoria(String id) async {
    try {
      await datasource.deleteTutoria(id);
    } catch (e) {
      throw RepositoryException('Error al eliminar tutoría: $e');
    }
  }
}
