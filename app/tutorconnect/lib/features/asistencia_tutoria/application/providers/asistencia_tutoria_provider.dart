import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/asistencia_tutoria/application/notifiers/asistencia_tutoria_notifier.dart';
import 'package:tutorconnect/features/asistencia_tutoria/application/states/asistencia_tutoria_state.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/datasources/asistencia_tutorias_datasource.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/repositories_impl/asistencia_tutorias_repository_impl.dart';

final asistenciaTutoriaProvider = StateNotifierProvider<AsistenciaTutoriaNotifier, AsistenciaTutoriaState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = AsistenciaTutoriasDatasource(firestore);
  final repository = AsistenciaTutoriasRepositoryImpl(datasource);
  return AsistenciaTutoriaNotifier(repository);
});
