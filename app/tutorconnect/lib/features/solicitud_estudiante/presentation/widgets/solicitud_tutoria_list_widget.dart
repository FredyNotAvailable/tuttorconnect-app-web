import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/themes/app_constants.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/solicitud_estudiante/presentation/widgets/solicitud_tutoria_card.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class SolicitudTutoriaListWidget extends ConsumerWidget {
  final List<SolicitudTutoriaModel> solicitudes;
  final String? currentUserId;
  final UsuarioRol? currentUserRol;

  const SolicitudTutoriaListWidget({
    super.key,
    required this.solicitudes,
    required this.currentUserId,
    required this.currentUserRol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filtrar solo las solicitudes relacionadas con el usuario actual
    final solicitudesFiltradas = solicitudes
        .where((s) => s.estudianteId == currentUserId || currentUserRol == UsuarioRol.docente)
        .toList();

    // Agrupar por materia
    final Map<String, List<SolicitudTutoriaModel>> solicitudesPorMateria = {};
    for (var s in solicitudesFiltradas) {
      final tutoria = getTutoriaById(ref, s.tutoriaId);
      solicitudesPorMateria.putIfAbsent(tutoria.materiaId, () => []).add(s);
    }

    if (solicitudesPorMateria.isEmpty) {
      return const Center(
        child: Text('No hay solicitudes de tutoría relacionadas con este usuario'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppPaddingConstants.global),
      children: solicitudesPorMateria.entries.map((entry) {
        final materia = getMateriaById(ref, entry.key);
        final solicitudesMateria = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              materia.nombre,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppPaddingConstants.global),
            ...solicitudesMateria.map((solicitud) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppPaddingConstants.global),
                child: SolicitudTutoriaCard(
                  solicitud: solicitud,
                  currentUserId: currentUserId ?? '',
                  currentUserRol: currentUserRol,
                ),
              );
            }),
            const SizedBox(height: AppPaddingConstants.global * 2),
          ],
        );
      }).toList(),
    );
  }
}
