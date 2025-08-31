// lib/features/tutorias/data/repositories_impl/solicitudes_tutorias_repository_impl.dart

import '../datasources/solicitudes_tutorias_datasource.dart';
import '../models/solicitud_tutoria_model.dart';

class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

class SolicitudesTutoriasRepositoryImpl {
  final SolicitudesTutoriasDatasource datasource;

  SolicitudesTutoriasRepositoryImpl(this.datasource);

  Future<SolicitudTutoriaModel> createSolicitud(SolicitudTutoriaModel solicitud) async {
    try {
      return await datasource.createSolicitud(solicitud);
    } catch (e) {
      throw RepositoryException('Error al crear solicitud de tutoria: $e');
    }
  }

  Future<SolicitudTutoriaModel?> getSolicitudById(String id) async {
    try {
      return await datasource.getSolicitudById(id);
    } catch (e) {
      throw RepositoryException('Error al obtener solicitud de tutoria: $e');
    }
  }

  Future<List<SolicitudTutoriaModel>> getAllSolicitudes() async {
    try {
      return await datasource.getAllSolicitudes();
    } catch (e) {
      throw RepositoryException('Error al obtener lista de solicitudes: $e');
    }
  }

  Future<void> updateSolicitud(SolicitudTutoriaModel solicitud) async {
    try {
      await datasource.updateSolicitud(solicitud);
    } catch (e) {
      throw RepositoryException('Error al actualizar solicitud de tutoria: $e');
    }
  }

  Future<void> deleteSolicitud(String id) async {
    try {
      await datasource.deleteSolicitud(id);
    } catch (e) {
      throw RepositoryException('Error al eliminar solicitud de tutoria: $e');
    }
  }
}
