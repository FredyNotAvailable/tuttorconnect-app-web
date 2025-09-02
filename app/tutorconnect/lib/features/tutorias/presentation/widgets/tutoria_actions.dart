// lib/features/tutorias/application/tutoria_actions.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/features/tutorias/application/providers/tutoria_provider.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';

class TutoriaActions {
  // Abrir detalle de tutoría y actualizar si hubo cambios
  static Future<void> abrirDetalleTutoria(
      BuildContext context, WidgetRef ref, TutoriaModel tutoria) async {
    final updatedTutoria = await Navigator.pushNamed(
      context,
      AppRoutes.detalleTutoria,
      arguments: tutoria,
    ) as TutoriaModel?;

    if (updatedTutoria != null) {
      ref.read(tutoriaProvider.notifier).updateTutoria(updatedTutoria);
    }
  }

  // Aquí podrías agregar más acciones, por ejemplo:
  // static Future<void> eliminarTutoria(...) {...}
  // static Future<void> crearTutoria(...) {...}

    // Crear nueva tutoría
  static Future<void> crearNuevaTutoria(BuildContext context) async {
    await Navigator.pushNamed(context, AppRoutes.crearTutoria);
  }
}
