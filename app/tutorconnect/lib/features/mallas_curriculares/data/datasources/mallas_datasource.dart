import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/mallas_curriculares/data/models/malla_curricular_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class MallasDatasource {
  final FirebaseFirestore _db;

  MallasDatasource(this._db);

  /// Leer todas las mallas
  Future<List<MallaCurricularModel>> getAllMallas() async {
    try {
      final snapshot = await _db.collection('mallas_curriculares').get();
      return snapshot.docs
          .map((doc) => MallaCurricularModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de mallas: $e');
    }
  }

  /// Obtener malla por ID
  Future<MallaCurricularModel?> getMallaById(String id) async {
    try {
      final doc = await _db.collection('mallas_curriculares').doc(id).get();
      if (!doc.exists) return null;
      return MallaCurricularModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw DatasourceException('Error al obtener malla por ID: $e');
    }
  }

  /// Crear malla
  Future<MallaCurricularModel> createMalla(MallaCurricularModel malla) async {
    try {
      final docRef = await _db.collection('mallas_curriculares').add(malla.toJson());
      return malla.copyWith(id: docRef.id);
    } catch (e) {
      throw DatasourceException('Error al crear malla: $e');
    }
  }

  /// Actualizar malla
  Future<void> updateMalla(MallaCurricularModel malla) async {
    try {
      await _db.collection('mallas_curriculares').doc(malla.id).update(malla.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar malla: $e');
    }
  }

  /// Eliminar malla
  Future<void> deleteMalla(String id) async {
    try {
      await _db.collection('mallas_curriculares').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar malla: $e');
    }
  }
}
