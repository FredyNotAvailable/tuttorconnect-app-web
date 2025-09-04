// lib/features/solicitud_estudiante/helpers/solicitud_tutoria_helper.dart
import 'package:flutter/material.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';

/// Filtra solicitudes de tutoría por un rango de fechas
List<SolicitudTutoriaModel> filtrarSolicitudesPorFecha({
  required List<SolicitudTutoriaModel> solicitudes,
  required DateTimeRange rangoSeleccionado,
}) {
  return solicitudes.where((s) {
    final fecha = s.fechaEnvio?.toDate();
    if (fecha == null) return false;
    return fecha.isAfter(rangoSeleccionado.start.subtract(const Duration(days: 1))) &&
           fecha.isBefore(rangoSeleccionado.end.add(const Duration(days: 1)));
  }).toList();
}

/// Filtra solicitudes de tutoría que aún no han comenzado según la fecha y hora de la tutoría
List<SolicitudTutoriaModel> filtrarSolicitudesNoIniciadas({
  required List<SolicitudTutoriaModel> solicitudes,
  required List<TutoriaModel> tutorias,
}) {
  return solicitudes.where((solicitud) {
    // Buscar tutoría correspondiente
    final tutoriaEncontrada = tutorias.where((t) => t.id == solicitud.tutoriaId);
    if (tutoriaEncontrada.isEmpty) return false;

    final tutoria = tutoriaEncontrada.first;

    // Calcula fecha y hora de inicio de la tutoría
    final fechaInicioTutoria = DateTime(
      tutoria.fecha.toDate().year,
      tutoria.fecha.toDate().month,
      tutoria.fecha.toDate().day,
      int.parse(tutoria.horaInicio.split(':')[0]),
      int.parse(tutoria.horaInicio.split(':')[1]),
    );

    // Solo incluir si la tutoría aún no ha comenzado
    return DateTime.now().isBefore(fechaInicioTutoria);
  }).toList();
}
