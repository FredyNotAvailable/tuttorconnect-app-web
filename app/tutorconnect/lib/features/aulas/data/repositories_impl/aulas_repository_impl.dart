// lib/features/aulas/data/repositories_impl/aulas_repository_impl.dart

import 'package:tutorconnect/features/aulas/data/models/aula_model.dart';
import 'package:tutorconnect/features/aulas/data/datasources/aulas_datasource.dart';

class AulasRepositoryImpl {
  final AulasDatasource datasource;

  AulasRepositoryImpl(this.datasource);

  Future<List<AulaModel>> getAllAulas() async {
    return await datasource.getAllAulas();
  }

  Future<AulaModel?> getAulaById(String id) async {
    return await datasource.getAulaById(id);
  }

  Future<AulaModel> createAula(AulaModel aula) async {
    return await datasource.createAula(aula);
  }

  Future<void> updateAula(AulaModel aula) async {
    return await datasource.updateAula(aula);
  }

  Future<void> deleteAula(String id) async {
    return await datasource.deleteAula(id);
  }
}
