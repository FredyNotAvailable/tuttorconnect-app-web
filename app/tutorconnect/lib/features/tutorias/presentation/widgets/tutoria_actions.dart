// lib/features/tutorias/application/tutoria_actions.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/features/asistencia_tutoria/application/providers/asistencia_tutoria_provider.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/models/asistencia_tutoria_model.dart';
import 'package:tutorconnect/features/auth/presentation/modals/custom_status_modal.dart';
import 'package:tutorconnect/features/solicitud_estudiante/application/providers/solicitudes_tutorias_provider.dart';
import 'package:tutorconnect/features/tutoria_estudiante/application/providers/tutorias_estudiantes_provider.dart';
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
                ListTile(
                  title: const Text('Sin registro'),
                  leading: Radio<AsistenciaEstado>(
                    value: AsistenciaEstado.sinRegistro,
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


  static Future<void> eliminarTutoria(
    BuildContext context,
    WidgetRef ref,
    TutoriaModel tutoria,
  ) async {
    // 🔹 Primero preguntar confirmación
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Confirmar eliminación"),
        content: const Text(
          "¿Seguro que deseas eliminar esta tutoría? "
          "Se eliminarán también las solicitudes y asistencias asociadas.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // cancelar
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true), // confirmar
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirm != true) return; // si cancela, no hacer nada

    try {
      // 🔹 Mostrar modal de "Eliminando..."
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const CustomStatusModal(
          status: StatusModal.loading,
          message: "Eliminando tutoría...",
        ),
      );

      // 1️⃣ Eliminar solicitudes asociadas
      // 1️⃣ Obtener todas las solicitudes desde la DB
      await ref.read(solicitudesTutoriasProvider.notifier).getAllSolicitudes();
      final solicitudesState = ref.read(solicitudesTutoriasProvider);
      final solicitudes = solicitudesState.solicitudes ?? [];

      // 2️⃣ Eliminar solicitudes asociadas
      final tareas = solicitudes
          .where((s) => s.tutoriaId == tutoria.id)
          .map((s) => ref.read(solicitudesTutoriasProvider.notifier).deleteSolicitud(s.id));
      await Future.wait(tareas); // eliminar en paralelo

      // 🔹 2️⃣ Eliminar tutorías-estudiantes asociadas
      await ref.read(tutoriasEstudiantesProvider.notifier).getAllTutoriasEstudiantes();
      final teState = ref.read(tutoriasEstudiantesProvider);
      final tutoriasEstudiantes = teState.tutoriasEstudiantes ?? [];
      final tareasTE = tutoriasEstudiantes
          .where((t) => t.tutoriaId == tutoria.id)
          .map((t) => ref.read(tutoriasEstudiantesProvider.notifier).deleteTutoriaEstudiante(t.id));
      await Future.wait(tareasTE);

      // 🔹 3️⃣ Eliminar asistencias asociadas
      await ref.read(asistenciaTutoriaProvider.notifier).getAllAsistencias();
      final asistenciasState = ref.read(asistenciaTutoriaProvider);
      final asistencias = asistenciasState.asistencias ?? [];
      final tareasAsistencias = asistencias
          .where((a) => a.tutoriaId == tutoria.id)
          .map((a) => ref.read(asistenciaTutoriaProvider.notifier).deleteAsistencia(a.id));
      await Future.wait(tareasAsistencias);


      // 4️⃣ Eliminar la tutoría
      await ref.read(tutoriaProvider.notifier).deleteTutoria(tutoria.id);

      // 🔹 Reemplazar modal por "Éxito"
      Navigator.pop(context); // cerrar loading
      showDialog(
        context: context,
        builder: (_) => const CustomStatusModal(
          status: StatusModal.success,
          message: "Tutoría eliminada con éxito",
        ),
      ).then((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (route) => route.isFirst,
        );
      });
    } catch (e) {
      // 🔹 Reemplazar modal por "Error"
      Navigator.pop(context); // cerrar loading si estaba abierto
      showDialog(
        context: context,
        builder: (_) => CustomStatusModal(
          status: StatusModal.error,
          message: "Error al eliminar: $e",
        ),
      );
    }
  }




}
