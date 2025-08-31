// lib/features/horarios/data/repositories_impl/horarios_clases_repository_impl.dart

import '../datasources/horarios_clases_datasource.dart';
import '../models/horario_clase_model.dart';

class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => 'RepositoryException: $message';
}

class HorariosClasesRepositoryImpl {
  final HorariosClasesDatasource datasource;

  HorariosClasesRepositoryImpl(this.datasource);

  Future<HorarioClaseModel> createHorarioClase(HorarioClaseModel horario) async {
    try {
      return await datasource.createHorarioClase(horario);
    } catch (e) {
      throw RepositoryException('Error al crear horario: $e');
    }
  }

  Future<HorarioClaseModel?> getHorarioClaseById(String id) async {
    try {
      return await datasource.getHorarioClaseById(id);
    } catch (e) {
      throw RepositoryException('Error al obtener horario: $e');
    }
  }

  Future<List<HorarioClaseModel>> getAllHorarios() async {
    try {
      return await datasource.getAllHorarios();
    } catch (e) {
      throw RepositoryException('Error al obtener lista de horarios: $e');
    }
  }

  Future<void> updateHorarioClase(HorarioClaseModel horario) async {
    try {
      await datasource.updateHorarioClase(horario);
    } catch (e) {
      throw RepositoryException('Error al actualizar horario: $e');
    }
  }

  Future<void> deleteHorarioClase(String id) async {
    try {
      await datasource.deleteHorarioClase(id);
    } catch (e) {
      throw RepositoryException('Error al eliminar horario: $e');
    }
  }
}
