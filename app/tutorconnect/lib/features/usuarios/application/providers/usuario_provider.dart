// lib/features/usuarios/application/providers/usuario_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/usuarios/application/notifiers/usuario_notifier.dart';
import 'package:tutorconnect/features/usuarios/application/states/usuario_state.dart';
import 'package:tutorconnect/features/usuarios/data/datasources/usuarios_datasource.dart';
import 'package:tutorconnect/features/usuarios/data/repositories_impl/usuarios_repository_impl.dart';

final usuarioProvider =
    StateNotifierProvider<UsuarioNotifier, UsuarioState>((ref) {
  // Instancia de Firestore
  final firestore = FirebaseFirestore.instance;

  // Datasource
  final datasource = UsuariosDatasource(firestore);

  // Repositorio concreto
  final repository = UsuariosRepositoryImpl(datasource);

  // Si usas UseCase, instanciarlo aquí:
  // final obtenerUsuariosUsecase = ObtenerUsuariosUsecase(repository);

  // Notifier con Repository (o UseCase)
  return UsuarioNotifier(repository);
});
