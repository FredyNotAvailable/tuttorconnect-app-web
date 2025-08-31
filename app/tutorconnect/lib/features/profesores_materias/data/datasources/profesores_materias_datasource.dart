import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/profesores_materias/data/models/profesor_materia_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class ProfesoresMateriasDatasource {
  final FirebaseFirestore _db;

  ProfesoresMateriasDatasource(this._db);

  /// Leer todas las relaciones profesor-materia
  Future<List<ProfesorMateriaModel>> getAllProfesoresMaterias() async {
    try {
      final snapshot = await _db.collection('profesores_materias').get();
      return snapshot.docs
          .map((doc) => ProfesorMateriaModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de profesores_materias: $e');
    }
  }

  /// Obtener relación por ID
  Future<ProfesorMateriaModel?> getProfesorMateriaById(String id) async {
    try {
      final doc = await _db.collection('profesores_materias').doc(id).get();
      if (!doc.exists) return null;
      return ProfesorMateriaModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw DatasourceException('Error al obtener profesor_materia por ID: $e');
    }
  }

  /// Crear relación profesor-materia
  Future<ProfesorMateriaModel> createProfesorMateria(ProfesorMateriaModel pm) async {
    try {
      final docRef = await _db.collection('profesores_materias').add(pm.toJson());
      return pm.copyWith(id: docRef.id);
    } catch (e) {
      throw DatasourceException('Error al crear profesor_materia: $e');
    }
  }

  /// Actualizar relación
  Future<void> updateProfesorMateria(ProfesorMateriaModel pm) async {
    try {
      await _db.collection('profesores_materias').doc(pm.id).update(pm.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar profesor_materia: $e');
    }
  }

  /// Eliminar relación
  Future<void> deleteProfesorMateria(String id) async {
    try {
      await _db.collection('profesores_materias').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar profesor_materia: $e');
    }
  }
}
