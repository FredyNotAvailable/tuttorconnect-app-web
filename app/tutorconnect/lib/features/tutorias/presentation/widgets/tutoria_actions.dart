// lib/features/tutorias/application/tutoria_actions.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/features/asistencia_tutoria/application/providers/asistencia_tutoria_provider.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/models/asistencia_tutoria_model.dart';
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

  static Future<void> mostrarModalAsistencia( BuildContext context, WidgetRef ref, String estudianteId, AsistenciaTutoriaModel asistencia) async { showModalBottomSheet(
      context: context,
      builder: (modalContext) {
        AsistenciaEstado? estadoSeleccionado = asistencia.estado;

        return StatefulBuilder(
          builder: (context, setStateModal) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Marcar asistencia',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Presente'),
                  leading: Radio<AsistenciaEstado>(
                    value: AsistenciaEstado.presente,
                    groupValue: estadoSeleccionado,
                    onChanged: (val) => setStateModal(() => estadoSeleccionado = val),
                  ),
                ),
                ListTile(
                  title: const Text('Ausente'),
                  leading: Radio<AsistenciaEstado>(
                    value: AsistenciaEstado.ausente,
                    groupValue: estadoSeleccionado,
                    onChanged: (val) => setStateModal(() => estadoSeleccionado = val),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  child: const Text('Guardar'),
                  onPressed: () async {
                    if (estadoSeleccionado != null) {
                      final nuevaAsistencia = asistencia.copyWith(
                        estado: estadoSeleccionado!,
                        estudianteId: estudianteId,
                        tutoriaId: asistencia.tutoriaId,
                        fecha: Timestamp.now(),
                      );

                      final asistenciaProvider =
                          ref.read(asistenciaTutoriaProvider.notifier);

                      if (asistencia.id.isEmpty) {
                        await asistenciaProvider.createAsistencia(nuevaAsistencia);
                      } else {
                        await asistenciaProvider.updateAsistencia(nuevaAsistencia);
                      }

                      Navigator.pop(modalContext);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
