import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/materias/application/notifiers/materia_notifier.dart';
import 'package:tutorconnect/features/materias/application/states/materia_state.dart';
import 'package:tutorconnect/features/materias/data/datasources/materias_datasource.dart';
import 'package:tutorconnect/features/materias/data/repositories_impl/materias_repository_impl.dart';

final materiaProvider = StateNotifierProvider<MateriaNotifier, MateriaState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = MateriasDatasource(firestore);
  final repository = MateriasRepositoryImpl(datasource);
  return MateriaNotifier(repository);
});
