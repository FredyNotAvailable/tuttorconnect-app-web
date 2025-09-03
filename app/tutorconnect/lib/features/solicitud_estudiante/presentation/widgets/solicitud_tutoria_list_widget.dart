// features/solicitud_estudiante/presentation/widgets/solicitud_tutoria_lista.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/themes/app_constants.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/solicitud_estudiante/presentation/widgets/solicitud_tutoria_card.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'solicitud_tutoria_filtro_fecha_ui_widget.dart'; // <-- nuevo widget de filtro

class SolicitudTutoriaListWidget extends ConsumerStatefulWidget {
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
  ConsumerState<SolicitudTutoriaListWidget> createState() => _SolicitudTutoriaListWidgetState();
}

class _SolicitudTutoriaListWidgetState extends ConsumerState<SolicitudTutoriaListWidget> {
  DateTimeRange? _rangoSeleccionado;

  @override
  Widget build(BuildContext context) {
    // 🔹 Filtrar solo solicitudes relacionadas con el usuario
    final solicitudesFiltradas = widget.solicitudes
        .where((s) =>
            s.estudianteId == widget.currentUserId || widget.currentUserRol == UsuarioRol.docente)
        .toList();

    // 🔹 Aplicar filtro de fechas
    final solicitudesFiltradasPorFecha = _rangoSeleccionado == null
        ? solicitudesFiltradas
        : solicitudesFiltradas.where((s) {
            final fecha = s.fechaEnvio?.toDate();
            if (fecha == null) return false;
            return !fecha.isBefore(_rangoSeleccionado!.start) &&
                   !fecha.isAfter(_rangoSeleccionado!.end);
          }).toList();

    // 🔹 Agrupar por materia
    final Map<String, List<SolicitudTutoriaModel>> solicitudesPorMateria = {};
    for (var s in solicitudesFiltradasPorFecha) {
      final tutoria = getTutoriaById(ref, s.tutoriaId);
      solicitudesPorMateria.putIfAbsent(tutoria.materiaId, () => []).add(s);
    }

    return Column(
      children: [
        // 🔹 Filtro de fechas siempre visible
        Padding(
          padding: const EdgeInsets.all(16),
          child: SolicitudTutoriaFiltroFechaUiWidget(
            rangoSeleccionado: _rangoSeleccionado,
            onChanged: (nuevoRango) {
              setState(() {
                _rangoSeleccionado = nuevoRango;
              });
            },
          ),
        ),

        // 🔹 Lista de solicitudes o mensaje si no hay
        Expanded(
          child: solicitudesPorMateria.isEmpty
              ? const Center(child: Text('No hay solicitudes de tutoría en el rango seleccionado'))
              : ListView(
                  padding: const EdgeInsets.all(AppPaddingConstants.global),
                  children: solicitudesPorMateria.entries.map((entry) {
                    final materia = getMateriaById(ref, entry.key);
                    final solicitudesMateria = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          materia.nombre,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppPaddingConstants.global),
                        ...solicitudesMateria.map((solicitud) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppPaddingConstants.global),
                            child: SolicitudTutoriaCard(
                              solicitud: solicitud,
                              currentUserId: widget.currentUserId ?? '',
                              currentUserRol: widget.currentUserRol,
                            ),
                          );
                        }),
                        const SizedBox(height: AppPaddingConstants.global * 2),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
