import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/carreras/application/notifiers/carrera_notifier.dart';
import 'package:tutorconnect/features/carreras/application/states/carrera_state.dart';
import 'package:tutorconnect/features/carreras/data/datasources/carreras_datasource.dart';
import 'package:tutorconnect/features/carreras/data/repositories_impl/carreras_repository_impl.dart';

final carreraProvider = StateNotifierProvider<CarreraNotifier, CarreraState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = CarrerasDatasource(firestore);
  final repository = CarrerasRepositoryImpl(datasource);
  return CarreraNotifier(repository);
});
