import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/materias_malla/data/models/materia_malla_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class MateriasMallaDatasource {
  final FirebaseFirestore _db;

  MateriasMallaDatasource(this._db);

  /// Leer todas las materias_malla
  Future<List<MateriaMallaModel>> getAllMateriasMalla() async {
    try {
      final snapshot = await _db.collection('materias_malla').get();
      return snapshot.docs
          .map((doc) => MateriaMallaModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de materias_malla: $e');
    }
  }

  /// Obtener materia_malla por ID
  Future<MateriaMallaModel?> getMateriaMallaById(String id) async {
    try {
      final doc = await _db.collection('materias_malla').doc(id).get();
      if (!doc.exists) return null;
      return MateriaMallaModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw DatasourceException('Error al obtener materia_malla por ID: $e');
    }
  }

  /// Crear materia_malla
  Future<MateriaMallaModel> createMateriaMalla(MateriaMallaModel materiaMalla) async {
    try {
      final docRef = await _db.collection('materias_malla').add(materiaMalla.toJson());
      return materiaMalla.copyWith(id: docRef.id);
    } catch (e) {
      throw DatasourceException('Error al crear materia_malla: $e');
    }
  }

  /// Actualizar materia_malla
  Future<void> updateMateriaMalla(MateriaMallaModel materiaMalla) async {
    try {
      await _db.collection('materias_malla').doc(materiaMalla.id).update(materiaMalla.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar materia_malla: $e');
    }
  }

  /// Eliminar materia_malla
  Future<void> deleteMateriaMalla(String id) async {
    try {
      await _db.collection('materias_malla').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar materia_malla: $e');
    }
  }
}
