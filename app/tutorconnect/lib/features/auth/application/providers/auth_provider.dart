// lib/features/auth/application/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/features/auth/application/notifiers/auth_notifier.dart';
import 'package:tutorconnect/features/auth/application/states/auth_state.dart';
import 'package:tutorconnect/features/auth/data/repositories_impl/auth_repository_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Instancias de Firebase
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // Repositorio
  final repository = AuthRepositoryImpl(firebaseAuth, firestore);

  // Notifier
  return AuthNotifier(repository, firebaseAuth);
});
