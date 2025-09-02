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
  bool Function(T)? filtro,  // filtro opcional
  required K Function(T) agruparPor, // clave de agrupamiento
}) {
  final filtradas = filtro == null ? items : items.where(filtro).toList();
  return filtradas.groupBy(agruparPor);
}
