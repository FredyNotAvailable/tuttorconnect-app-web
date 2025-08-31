import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class TutoriasDatasource {
  final FirebaseFirestore _db;

  TutoriasDatasource(this._db);

  /// Crear una tutoría
  Future<TutoriaModel> createTutoria(TutoriaModel tutoria) async {
    try {
      final docRef = _db.collection('tutorias').doc(); // ID generado por Firebase
      final tutoriaConId = TutoriaModel(
        id: docRef.id,
        profesorId: tutoria.profesorId,
        materiaId: tutoria.materiaId,
        aulaId: tutoria.aulaId,
        fecha: tutoria.fecha,
        horaInicio: tutoria.horaInicio,
        horaFin: tutoria.horaFin,
        estado: tutoria.estado,
        tema: tutoria.tema,
        descripcion: tutoria.descripcion,
      );
      await docRef.set(tutoriaConId.toJson());
      return tutoriaConId;
    } catch (e) {
      throw DatasourceException('Error al crear tutoría: $e');
    }
  }

  /// Leer una tutoría por ID
  Future<TutoriaModel?> getTutoriaById(String id) async {
    try {
      final doc = await _db.collection('tutorias').doc(id).get();
      if (doc.exists) {
        return TutoriaModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw DatasourceException('Error al obtener tutoría: $e');
    }
  }

  /// Leer todas las tutorías
  Future<List<TutoriaModel>> getAllTutorias() async {
    try {
      final snapshot = await _db.collection('tutorias').get();
      return snapshot.docs
          .map((doc) => TutoriaModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de tutorías: $e');
    }
  }

  /// Actualizar tutoría
  Future<void> updateTutoria(TutoriaModel tutoria) async {
    try {
      await _db.collection('tutorias').doc(tutoria.id).update(tutoria.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar tutoría: $e');
    }
  }

  /// Eliminar tutoría
  Future<void> deleteTutoria(String id) async {
    try {
      await _db.collection('tutorias').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar tutoría: $e');
    }
  }
}
