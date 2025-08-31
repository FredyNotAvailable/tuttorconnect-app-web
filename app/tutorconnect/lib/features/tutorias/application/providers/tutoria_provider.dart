import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/tutorias/application/notifiers/tutoria_notifier.dart';
import 'package:tutorconnect/features/tutorias/application/states/tutoria_state.dart';
import 'package:tutorconnect/features/tutorias/data/datasources/tutorias_datasource.dart';
import 'package:tutorconnect/features/tutorias/data/repositories_impl/tutorias_repository_impl.dart';

final tutoriaProvider = StateNotifierProvider<TutoriaNotifier, TutoriaState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = TutoriasDatasource(firestore);
  final repository = TutoriasRepositoryImpl(datasource);
  return TutoriaNotifier(repository);
});
