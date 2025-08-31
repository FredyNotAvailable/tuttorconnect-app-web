import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/carreras/data/models/carrera_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class CarrerasDatasource {
  final FirebaseFirestore _db;

  CarrerasDatasource(this._db);

  /// Crear carrera
  Future<CarreraModel> createCarrera(CarreraModel carrera) async {
    try {
      final docRef = _db.collection('carreras').doc();
      final carreraConId = CarreraModel(id: docRef.id, nombre: carrera.nombre);
      await docRef.set(carreraConId.toJson());
      return carreraConId;
    } catch (e) {
      throw DatasourceException('Error al crear carrera: $e');
    }
  }

  /// Obtener carrera por ID
  Future<CarreraModel?> getCarreraById(String id) async {
    try {
      final doc = await _db.collection('carreras').doc(id).get();
      if (doc.exists) {
        return CarreraModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw DatasourceException('Error al obtener carrera: $e');
    }
  }

  /// Obtener todas las carreras
  Future<List<CarreraModel>> getAllCarreras() async {
    try {
      final snapshot = await _db.collection('carreras').get();
      return snapshot.docs.map((doc) => CarreraModel.fromJson(doc.data(), doc.id)).toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de carreras: $e');
    }
  }

  /// Actualizar carrera
  Future<void> updateCarrera(CarreraModel carrera) async {
    try {
      await _db.collection('carreras').doc(carrera.id).update(carrera.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar carrera: $e');
    }
  }

  /// Eliminar carrera
  Future<void> deleteCarrera(String id) async {
    try {
      await _db.collection('carreras').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar carrera: $e');
    }
  }
}
