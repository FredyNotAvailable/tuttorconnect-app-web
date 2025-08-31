import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/mallas_curriculares/application/notifiers/malla_notifier.dart';
import 'package:tutorconnect/features/mallas_curriculares/application/states/malla_state.dart';
import 'package:tutorconnect/features/mallas_curriculares/data/datasources/mallas_datasource.dart';
import 'package:tutorconnect/features/mallas_curriculares/data/repositories_impl/mallas_repository_impl.dart';

final mallaCurricularProvider = StateNotifierProvider<MallaNotifier, MallaState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = MallasDatasource(firestore);
  final repository = MallasRepositoryImpl(datasource);
  return MallaNotifier(repository);
});
