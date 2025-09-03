// lib/features/solicitud_estudiante/helpers/solicitud_tutoria_helper.dart
import 'package:flutter/material.dart';
import 'package:tutorconnect/features/solicitud_estudiante/data/models/solicitud_tutoria_model.dart';

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
