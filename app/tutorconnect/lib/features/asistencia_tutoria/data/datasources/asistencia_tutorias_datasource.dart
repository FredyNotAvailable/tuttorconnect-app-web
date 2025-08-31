import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/asistencia_tutoria_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class AsistenciaTutoriasDatasource {
  final FirebaseFirestore _db;

  AsistenciaTutoriasDatasource(this._db);

  CollectionReference get _collection => _db.collection('asistencia_tutorias');

  /// Leer todas las asistencias
  Future<List<AsistenciaTutoriaModel>> getAllAsistencias() async {
    try {
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => AsistenciaTutoriaModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de asistencias: $e');
    }
  }

  /// Obtener asistencia por ID
  Future<AsistenciaTutoriaModel?> getAsistenciaById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return AsistenciaTutoriaModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw DatasourceException('Error al obtener asistencia por ID: $e');
    }
  }

  /// Obtener asistencias por tutoría
  Future<List<AsistenciaTutoriaModel>> getAsistenciasByTutoria(String tutoriaId) async {
    try {
      final snapshot = await _collection.where('tutoriaId', isEqualTo: tutoriaId).get();
      return snapshot.docs
          .map((doc) => AsistenciaTutoriaModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener asistencias por tutoría: $e');
    }
  }

  /// Crear asistencia
  Future<AsistenciaTutoriaModel> createAsistencia(AsistenciaTutoriaModel asistencia) async {
    try {
      final docRef = await _collection.add(asistencia.toJson());
      return asistencia.copyWith(id: docRef.id);
    } catch (e) {
      throw DatasourceException('Error al crear asistencia: $e');
    }
  }

  /// Actualizar asistencia
  Future<void> updateAsistencia(AsistenciaTutoriaModel asistencia) async {
    try {
      await _collection.doc(asistencia.id).update(asistencia.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar asistencia: $e');
    }
  }

  /// Eliminar asistencia
  Future<void> deleteAsistencia(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar asistencia: $e');
    }
  }
}
