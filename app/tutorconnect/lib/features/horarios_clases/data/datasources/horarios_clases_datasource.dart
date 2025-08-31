// lib/features/horarios/data/datasources/horarios_clases_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/horario_clase_model.dart';

class DatasourceException implements Exception {
  final String message;
  DatasourceException(this.message);

  @override
  String toString() => 'DatasourceException: $message';
}

class HorariosClasesDatasource {
  final FirebaseFirestore _db;

  HorariosClasesDatasource(this._db);

  /// Crear un horario de clase
  Future<HorarioClaseModel> createHorarioClase(HorarioClaseModel horario) async {
    try {
      final docRef = _db.collection('horarios_clases').doc();
      final horarioConId = HorarioClaseModel(
        id: docRef.id,
        profesorId: horario.profesorId,
        materiaId: horario.materiaId,
        aulaId: horario.aulaId,
        diaSemana: horario.diaSemana,
        horaInicio: horario.horaInicio,
        horaFin: horario.horaFin,
      );
      await docRef.set(horarioConId.toJson());
      return horarioConId;
    } catch (e) {
      throw DatasourceException('Error al crear horario: $e');
    }
  }

  /// Obtener por ID
  Future<HorarioClaseModel?> getHorarioClaseById(String id) async {
    try {
      final doc = await _db.collection('horarios_clases').doc(id).get();
      if (doc.exists) {
        return HorarioClaseModel.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw DatasourceException('Error al obtener horario: $e');
    }
  }

  /// Obtener todos los horarios
  Future<List<HorarioClaseModel>> getAllHorarios() async {
    try {
      final snapshot = await _db.collection('horarios_clases').get();
      return snapshot.docs
          .map((doc) => HorarioClaseModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw DatasourceException('Error al obtener lista de horarios: $e');
    }
  }

  /// Actualizar horario
  Future<void> updateHorarioClase(HorarioClaseModel horario) async {
    try {
      await _db.collection('horarios_clases').doc(horario.id).update(horario.toJson());
    } catch (e) {
      throw DatasourceException('Error al actualizar horario: $e');
    }
  }

  /// Eliminar horario
  Future<void> deleteHorarioClase(String id) async {
    try {
      await _db.collection('horarios_clases').doc(id).delete();
    } catch (e) {
      throw DatasourceException('Error al eliminar horario: $e');
    }
  }
}
