// src/core/utils/date_utils.dart

import 'package:cloud_firestore/cloud_firestore.dart';

/// Convierte un Timestamp a string formateado YYYY-MM-DD
String formatDate(Timestamp? timestamp) {
  if (timestamp == null) return '-';
  final date = timestamp.toDate();
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// Formatea un DateTime a DD/MM/YYYY
String formatDateDMY(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
         '${date.month.toString().padLeft(2, '0')}/'
         '${date.year}';
}

