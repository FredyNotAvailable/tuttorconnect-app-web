// lib/features/aulas/data/datasources/aulas_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/aulas/data/models/aula_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class AulasDatasource {
  final FirebaseFirestore _db;

  AulasDatasource(this._db);

  /// Leer todas las aulas
  Future<List<AulaModel>> getAllAulas() async {
    try {
      final snapshot = await _db.collection('aulas').get();
      return snapshot.docs
          .map((doc) => AulaModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de aulas: $e');
    }
  }

  /// Obtener aula por ID
  Future<AulaModel?> getAulaById(String id) async {
    try {
      final doc = await _db.collection('aulas').doc(id).get();
      if (!doc.exists) return null;
      return AulaModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw DatasourceException('Error al obtener aula por ID: $e');
    }
  }

  /// Crear aula
  Future<AulaModel> createAula(AulaModel aula) async {
    try {
      final docRef = await _db.collection('aulas').add(aula.toJson());
      return aula.copyWith(id: docRef.id); // Necesitas copyWith en el modelo
    } catch (e) {
      throw DatasourceException('Error al crear aula: $e');
    }
  }

  /// Actualizar aula
  Future<void> updateAula(AulaModel aula) async {
    try {
      await _db.collection('aulas').doc(aula.id).update(aula.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar aula: $e');
    }
  }

  /// Eliminar aula
  Future<void> deleteAula(String id) async {
    try {
      await _db.collection('aulas').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar aula: $e');
    }
  }
}
