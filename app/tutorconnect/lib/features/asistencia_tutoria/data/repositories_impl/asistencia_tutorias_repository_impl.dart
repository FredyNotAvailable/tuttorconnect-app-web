import 'package:tutorconnect/features/asistencia_tutoria/data/datasources/asistencia_tutorias_datasource.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/models/asistencia_tutoria_model.dart';

class AsistenciaTutoriasRepositoryImpl {
  final AsistenciaTutoriasDatasource datasource;

  AsistenciaTutoriasRepositoryImpl(this.datasource);

  /// Obtener todas las asistencias
  Future<List<AsistenciaTutoriaModel>> getAllAsistencias() async {
    try {
      return await datasource.getAllAsistencias();
    } catch (e) {
      rethrow;
    }
  }

  /// Obtener asistencia por ID
  Future<AsistenciaTutoriaModel?> getAsistenciaById(String id) async {
    try {
      return await datasource.getAsistenciaById(id);
    } catch (e) {
      rethrow;
    }
  }

  /// Obtener asistencias por tutoría
  Future<List<AsistenciaTutoriaModel>> getAsistenciasByTutoria(String tutoriaId) async {
    try {
      return await datasource.getAsistenciasByTutoria(tutoriaId);
    } catch (e) {
      rethrow;
    }
  }

  /// Crear asistencia
  Future<AsistenciaTutoriaModel> createAsistencia(AsistenciaTutoriaModel asistencia) async {
    try {
      return await datasource.createAsistencia(asistencia);
    } catch (e) {
      rethrow;
    }
  }

  /// Actualizar asistencia
  Future<void> updateAsistencia(AsistenciaTutoriaModel asistencia) async {
    try {
      await datasource.updateAsistencia(asistencia);
    } catch (e) {
      rethrow;
    }
  }

  /// Eliminar asistencia
  Future<void> deleteAsistencia(String id) async {
    try {
      await datasource.deleteAsistencia(id);
    } catch (e) {
      rethrow;
    }
  }
}
