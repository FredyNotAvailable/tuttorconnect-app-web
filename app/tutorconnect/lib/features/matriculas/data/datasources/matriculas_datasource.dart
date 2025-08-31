import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/matriculas/data/models/matricula_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class MatriculasDatasource {
  final FirebaseFirestore _db;

  MatriculasDatasource(this._db);

  /// Leer todas las matrículas
  Future<List<MatriculaModel>> getAllMatriculas() async {
    try {
      final snapshot = await _db.collection('matriculas').get();
      return snapshot.docs
          .map((doc) => MatriculaModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de matriculas: $e');
    }
  }

  /// Obtener matrícula por ID
  Future<MatriculaModel?> getMatriculaById(String id) async {
    try {
      final doc = await _db.collection('matriculas').doc(id).get();
      if (!doc.exists) return null;
      return MatriculaModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw DatasourceException('Error al obtener matrícula por ID: $e');
    }
  }

  /// Crear matrícula
  Future<MatriculaModel> createMatricula(MatriculaModel matricula) async {
    try {
      final docRef = await _db.collection('matriculas').add(matricula.toJson());
      return matricula.copyWith(id: docRef.id);
    } catch (e) {
      throw DatasourceException('Error al crear matrícula: $e');
    }
  }

  /// Actualizar matrícula
  Future<void> updateMatricula(MatriculaModel matricula) async {
    try {
      await _db.collection('matriculas').doc(matricula.id).update(matricula.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar matrícula: $e');
    }
  }

  /// Eliminar matrícula
  Future<void> deleteMatricula(String id) async {
    try {
      await _db.collection('matriculas').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar matrícula: $e');
    }
  }
}
