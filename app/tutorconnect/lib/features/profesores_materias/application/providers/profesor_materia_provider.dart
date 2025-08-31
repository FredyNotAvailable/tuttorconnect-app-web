import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/profesores_materias/application/notifiers/profesor_materia_notifier.dart';
import 'package:tutorconnect/features/profesores_materias/application/states/profesor_materia_state.dart';
import 'package:tutorconnect/features/profesores_materias/data/datasources/profesores_materias_datasource.dart';
import 'package:tutorconnect/features/profesores_materias/data/repositories_impl/profesores_materias_repository_impl.dart';

final profesorMateriaProvider = StateNotifierProvider<ProfesorMateriaNotifier, ProfesorMateriaState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = ProfesoresMateriasDatasource(firestore);
  final repository = ProfesoresMateriasRepositoryImpl(datasource);
  return ProfesorMateriaNotifier(repository);
});
