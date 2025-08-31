import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/matriculas/application/notifiers/matricula_notifier.dart';
import 'package:tutorconnect/features/matriculas/application/states/matricula_state.dart';
import 'package:tutorconnect/features/matriculas/data/datasources/matriculas_datasource.dart';
import 'package:tutorconnect/features/matriculas/data/repositories_impl/matriculas_repository_impl.dart';

final matriculaProvider = StateNotifierProvider<MatriculaNotifier, MatriculaState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = MatriculasDatasource(firestore);
  final repository = MatriculasRepositoryImpl(datasource);
  return MatriculaNotifier(repository);
});
