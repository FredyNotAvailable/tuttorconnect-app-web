// lib/features/tutorias/data/datasources/solicitudes_tutorias_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/solicitud_tutoria_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class SolicitudesTutoriasDatasource {
  final FirebaseFirestore _db;

  SolicitudesTutoriasDatasource(this._db);

  /// Crear solicitud de tutoria
  Future<SolicitudTutoriaModel> createSolicitud(SolicitudTutoriaModel solicitud) async {
    try {
      final docRef = _db.collection('solicitudes_tutorias').doc();
      final solicitudConId = SolicitudTutoriaModel(
        id: docRef.id,
        tutoriaId: solicitud.tutoriaId,
        estudianteId: solicitud.estudianteId,
        fechaEnvio: solicitud.fechaEnvio,
        fechaRespuesta: solicitud.fechaRespuesta,
        estado: solicitud.estado,
      );
      await docRef.set(solicitudConId.toJson());
      return solicitudConId;
    } catch (e) {
      throw DatasourceException('Error al crear solicitud de tutoria: $e');
    }
  }

  /// Obtener por ID
  Future<SolicitudTutoriaModel?> getSolicitudById(String id) async {
    try {
      final doc = await _db.collection('solicitudes_tutorias').doc(id).get();
      if (doc.exists) {
        return SolicitudTutoriaModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw DatasourceException('Error al obtener solicitud de tutoria: $e');
    }
  }

  /// Obtener todas las solicitudes
  Future<List<SolicitudTutoriaModel>> getAllSolicitudes() async {
    try {
      final snapshot = await _db.collection('solicitudes_tutorias').get();
      return snapshot.docs
          .map((doc) => SolicitudTutoriaModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de solicitudes: $e');
    }
  }

  /// Actualizar solicitud
  Future<void> updateSolicitud(SolicitudTutoriaModel solicitud) async {
    try {
      await _db.collection('solicitudes_tutorias').doc(solicitud.id).update(solicitud.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar solicitud de tutoria: $e');
    }
  }

  /// Eliminar solicitud
  Future<void> deleteSolicitud(String id) async {
    try {
      await _db.collection('solicitudes_tutorias').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar solicitud de tutoria: $e');
    }
  }
}
