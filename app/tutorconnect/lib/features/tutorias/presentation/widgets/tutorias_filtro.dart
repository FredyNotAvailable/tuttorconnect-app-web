import 'package:flutter/material.dart';

extension IterableExtensions<T> on Iterable<T> {
  /// Agrupa los elementos por una clave
  Map<K, List<T>> groupBy<K>(K Function(T) key) {
    final map = <K, List<T>>{};
    for (var element in this) {
      final k = key(element);
      map.putIfAbsent(k, () => []).add(element);
    }
    return map;
  }
}

/// Función genérica para filtrar y agrupar cualquier lista
Map<K, List<T>> agruparTutoriasPorMateria<T, K>({
  required List<T> items,
  bool Function(T)? filtro, // filtro adicional opcional
  required K Function(T) agruparPor, // clave de agrupamiento
  DateTimeRange? rangoFechas, // 🔹 filtro de rango de fechas opcional
  DateTime? Function(T)? obtenerFecha, // 🔹 cómo obtener la fecha del item
}) {
  var filtradas = items;

  // 🔹 aplicar filtro genérico si lo hay
  if (filtro != null) {
    filtradas = filtradas.where(filtro).toList();
  }

  // 🔹 aplicar filtro de fechas si corresponde
  if (rangoFechas != null && obtenerFecha != null) {
    filtradas = filtradas.where((item) {
      final fecha = obtenerFecha(item);
      if (fecha == null) return false;
      return fecha.isAfter(rangoFechas.start.subtract(const Duration(days: 1))) &&
             fecha.isBefore(rangoFechas.end.add(const Duration(days: 1)));
    }).toList();
  }

  return filtradas.groupBy(agruparPor);
}
