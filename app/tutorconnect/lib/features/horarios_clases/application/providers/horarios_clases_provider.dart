// lib/features/horarios/application/providers/horarios_clases_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/horarios_clases/application/notifiers/horarios_clases_notifier.dart';
import 'package:tutorconnect/features/horarios_clases/application/states/horarios_clases_state.dart';
import 'package:tutorconnect/features/horarios_clases/data/datasources/horarios_clases_datasource.dart';
import 'package:tutorconnect/features/horarios_clases/data/repositories_impl/horarios_clases_repository_impl.dart';

final horariosClasesProvider =
    StateNotifierProvider<HorarioClaseNotifier, HorarioClaseState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = HorariosClasesDatasource(firestore);
  final repository = HorariosClasesRepositoryImpl(datasource);
  return HorarioClaseNotifier(repository);
});
