import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/solicitud_estudiante/application/notifiers/solicitudes_tutorias_notifier.dart';
import 'package:tutorconnect/features/solicitud_estudiante/application/states/solicitudes_tutorias_state.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/datasources/solicitudes_tutorias_datasource.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/repositories_impl/solicitudes_tutorias_repository_impl.dart';

final solicitudesTutoriasProvider =
    StateNotifierProvider<SolicitudesTutoriasNotifier, SolicitudTutoriaState>((ref) {
  final firestore = FirebaseFirestore.instance;
  final datasource = SolicitudesTutoriasDatasource(firestore);
  final repository = SolicitudesTutoriasRepositoryImpl(datasource);
  return SolicitudesTutoriasNotifier(repository);
});
