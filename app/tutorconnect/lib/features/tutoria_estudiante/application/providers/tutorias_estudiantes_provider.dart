import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/tutoria_estudiante/application/notifiers/tutorias_estudiantes_notifier.dart';
import 'package:tutorconnect/features/tutoria_estudiante/application/states/tutorias_estudiantes_state.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/datasources/tutorias_estudiantes_datasource.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/repositories_impl/tutorias_estudiantes_repository_impl.dart';

final tutoriasEstudiantesProvider =
    StateNotifierProvider<TutoriaEstudianteNotifier, TutoriaEstudianteState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = TutoriasEstudiantesDatasource(firestore);
  final repository = TutoriasEstudiantesRepositoryImpl(datasource);
  return TutoriaEstudianteNotifier(repository);
});
