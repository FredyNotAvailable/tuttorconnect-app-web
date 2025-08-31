import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/aulas/application/notifiers/aula_notifier.dart';
import 'package:tutorconnect/features/aulas/application/states/aula_state.dart';
import 'package:tutorconnect/features/aulas/data/datasources/aulas_datasource.dart';
import 'package:tutorconnect/features/aulas/data/repositories_impl/aulas_repository_impl.dart';

final aulaProvider = StateNotifierProvider<AulaNotifier, AulaState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = AulasDatasource(firestore);
  final repository = AulasRepositoryImpl(datasource);
  return AulaNotifier(repository);
});
