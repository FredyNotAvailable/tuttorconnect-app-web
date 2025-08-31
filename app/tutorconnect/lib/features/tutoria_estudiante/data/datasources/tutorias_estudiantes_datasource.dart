// lib/features/tutorias/data/datasources/tutorias_estudiantes_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tutoria_estudiante_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class TutoriasEstudiantesDatasource {
  final FirebaseFirestore _db;

  TutoriasEstudiantesDatasource(this._db);

  /// Crear relación tutoria-estudiante
  Future<TutoriaEstudianteModel> createTutoriaEstudiante(TutoriaEstudianteModel te) async {
    try {
      final docRef = _db.collection('tutorias_estudiantes').doc();
      final teConId = TutoriaEstudianteModel(
        id: docRef.id,
        tutoriaId: te.tutoriaId,
        estudianteId: te.estudianteId,
      );
      await docRef.set(teConId.toJson());
      return teConId;
    } catch (e) {
      throw DatasourceException('Error al crear tutoria-estudiante: $e');
    }
  }

  /// Obtener por ID
  Future<TutoriaEstudianteModel?> getTutoriaEstudianteById(String id) async {
    try {
      final doc = await _db.collection('tutorias_estudiantes').doc(id).get();
      if (doc.exists) {
        return TutoriaEstudianteModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw DatasourceException('Error al obtener tutoria-estudiante: $e');
    }
  }

  /// Obtener todas las relaciones
  Future<List<TutoriaEstudianteModel>> getAllTutoriasEstudiantes() async {
    try {
      final snapshot = await _db.collection('tutorias_estudiantes').get();
      return snapshot.docs
          .map((doc) => TutoriaEstudianteModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de tutoria-estudiante: $e');
    }
  }

  /// Actualizar relación
  Future<void> updateTutoriaEstudiante(TutoriaEstudianteModel te) async {
    try {
      await _db.collection('tutorias_estudiantes').doc(te.id).update(te.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar tutoria-estudiante: $e');
    }
  }

  /// Eliminar relación
  Future<void> deleteTutoriaEstudiante(String id) async {
    try {
      await _db.collection('tutorias_estudiantes').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar tutoria-estudiante: $e');
    }
  }
}
