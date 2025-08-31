import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/materias_malla/application/notifiers/materia_malla_notifier.dart';
import 'package:tutorconnect/features/materias_malla/application/states/materia_malla_state.dart';
import 'package:tutorconnect/features/materias_malla/data/datasources/materias_malla_datasource.dart';
import 'package:tutorconnect/features/materias_malla/data/repositories_impl/materias_malla_repository_impl.dart';

final materiaMallaProvider = StateNotifierProvider<MateriaMallaNotifier, MateriaMallaState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = MateriasMallaDatasource(firestore);
  final repository = MateriasMallaRepositoryImpl(datasource);
  return MateriaMallaNotifier(repository);
});
