import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/features/asistencia_tutoria/application/providers/asistencia_tutoria_provider.dart';
import 'package:tutorconnect/features/tutorias/application/providers/tutoria_provider.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/aulas/helpers/aula_helper.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/usuarios/helpers/usuario_helper.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/models/asistencia_tutoria_model.dart';
import 'package:tutorconnect/features/tutoria_estudiante/helper/tutoria_estudiante_helper.dart';
import 'package:tutorconnect/features/asistencia_tutoria/helpers/asistencia_tutoria_helper.dart';

class DetalleTutoriaScreen extends ConsumerWidget {
  final TutoriaModel tutoria;

  const DetalleTutoriaScreen({super.key, required this.tutoria});

  String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;
    final isDocente = currentUser?.rol == UsuarioRol.docente;

    final tutoriaState = ref.watch(tutoriaProvider);
    TutoriaModel currentTutoria = tutoriaState.tutorias?.firstWhere(
        (t) => t.id == tutoria.id,
        orElse: () => tutoria,
    ) ?? tutoria;

    final aula = getAulaById(ref, tutoria.aulaId);
    final materia = getMateriaById(ref, tutoria.materiaId);
    final profesor = getUsuarioById(ref, tutoria.profesorId);

    // Escuchar cambios de asistencias para refrescar la UI automáticamente
    ref.watch(asistenciaTutoriaProvider);

    final estudiantes = getAllEstudiantesByTutoria(ref, tutoria.id);

    // ==========================
    // Verificar si la tutoría terminó
    // ==========================
    final ahora = DateTime.now();
    final horaFinParts = currentTutoria.horaFin.split(':');
    final horaFin = DateTime(
      currentTutoria.fecha.toDate().year,
      currentTutoria.fecha.toDate().month,
      currentTutoria.fecha.toDate().day,
      int.parse(horaFinParts[0]),
      int.parse(horaFinParts[1]),
    );

    final tutoriaTerminada = ahora.isAfter(horaFin) && currentTutoria.estado != TutoriaEstado.cancelada;

    // Actualizar estado a finalizada si corresponde
    if (tutoriaTerminada && currentTutoria.estado != TutoriaEstado.finalizada) {
      currentTutoria = currentTutoria.copyWith(estado: TutoriaEstado.finalizada);
      ref.read(tutoriaProvider.notifier).updateTutoria(currentTutoria);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la Tutoría')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Tema: ${currentTutoria.tema}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Descripción: ${currentTutoria.descripcion.isNotEmpty ? currentTutoria.descripcion : "-"}'),
            const SizedBox(height: 8),
            Text('Profesor: ${profesor.nombreCompleto}'),
            const SizedBox(height: 8),
            Text('Materia: ${materia.nombre}'),
            const SizedBox(height: 8),
            Text('Aula: ${aula.nombre} - ${aula.tipo}'),
            const SizedBox(height: 8),
            Text('Fecha y Hora: ${formatDate(currentTutoria.fecha.toDate())} | ${currentTutoria.horaInicio} - ${currentTutoria.horaFin}'),
            const SizedBox(height: 8),
            Text('Estado: ${currentTutoria.estado.name}'),
            const SizedBox(height: 16),
            const Text('Estudiantes inscritos:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),


...estudiantes.map((estudiante) {
  final asistencias = getAllAsistenciaByEstudiante(ref, estudiante.id, tutoriaId: currentTutoria.id);

  // Determinar si existe asistencia
  final asistenciaExiste = asistencias.isNotEmpty;
  final asistencia = asistenciaExiste
      ? asistencias.first
      : AsistenciaTutoriaModel(
          id: '',
          estudianteId: estudiante.id,
          tutoriaId: currentTutoria.id,
          estado: AsistenciaEstado.ausente, // temporal
          fecha: Timestamp.now(),
        );

  print("Asistencia estudiante ${estudiante.nombreCompleto}: ${asistencia.id} (${asistencia.estado})");

  return ListTile(
    leading: const Icon(Icons.person),
    title: Text(estudiante.nombreCompleto),
    trailing: ElevatedButton(
      child: Text(
        asistenciaExiste
            ? (asistencia.estado == AsistenciaEstado.presente ? 'Presente' : 'Ausente')
            : 'Marcar', // <-- si no existe, mostrar Marcar
      ),
      onPressed: (isDocente && !tutoriaTerminada)
          ? () => _mostrarModalAsistencia(context, ref, estudiante.id, asistencia)
          : null,
    ),
  );
}).toList(),



          ],
        ),
      ),

      floatingActionButton: isDocente && !tutoriaTerminada
          ? FloatingActionButton(
              child: const Icon(Icons.edit),
              onPressed: () async {
                final updatedTutoria = await Navigator.pushNamed(
                  context,
                  AppRoutes.editarTutoria,
                  arguments: currentTutoria,
                ) as TutoriaModel?;

                if (updatedTutoria != null) {
                  ref.read(tutoriaProvider.notifier).updateTutoria(updatedTutoria);
                }
              },
            )
          : null,
    );
  }

  void _mostrarModalAsistencia(BuildContext context, WidgetRef ref, String estudianteId, AsistenciaTutoriaModel asistencia) {
    showModalBottomSheet(
      context: context,
      builder: (modalContext) {
        AsistenciaEstado? estadoSeleccionado = asistencia.estado;

        return StatefulBuilder(
          builder: (context, setStateModal) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Marcar asistencia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

                      if (asistencia.id.isEmpty) {
                        await createAsistenciaHelper(ref, nuevaAsistencia);
                      } else {
                        await updateAsistenciaHelper(ref, nuevaAsistencia);
                      }

                      Navigator.pop(modalContext); // cerrar modal
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
