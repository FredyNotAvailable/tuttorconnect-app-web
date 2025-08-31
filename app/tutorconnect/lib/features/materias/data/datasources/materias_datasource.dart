import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class MateriasDatasource {
  final FirebaseFirestore _db;

  MateriasDatasource(this._db);

  /// Crear materia
  Future<MateriaModel> createMateria(MateriaModel materia) async {
    try {
      final docRef = _db.collection('materias').doc();
      final materiaConId = MateriaModel(id: docRef.id, nombre: materia.nombre);
      await docRef.set(materiaConId.toJson());
      return materiaConId;
    } catch (e) {
      throw DatasourceException('Error al crear materia: $e');
    }
  }

  /// Obtener materia por ID
  Future<MateriaModel?> getMateriaById(String id) async {
    try {
      final doc = await _db.collection('materias').doc(id).get();
      if (doc.exists) {
        return MateriaModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw DatasourceException('Error al obtener materia: $e');
    }
  }

  /// Obtener todas las materias
  Future<List<MateriaModel>> getAllMaterias() async {
    try {
      final snapshot = await _db.collection('materias').get();
      return snapshot.docs.map((doc) => MateriaModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de materias: $e');
    }
  }

  /// Actualizar materia
  Future<void> updateMateria(MateriaModel materia) async {
    try {
      await _db.collection('materias').doc(materia.id).update(materia.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar materia: $e');
    }
  }

  /// Eliminar materia
  Future<void> deleteMateria(String id) async {
    try {
      await _db.collection('materias').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar materia: $e');
    }
  }
}
