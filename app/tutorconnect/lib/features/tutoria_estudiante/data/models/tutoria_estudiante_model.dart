// lib/features/tutorias/data/models/tutoria_estudiante_model.dart

class TutoriaEstudianteModel {
  final String id;           // ID del documento en Firestore/Supabase
  final String tutoriaId;    // FK → tutorias.id
  final String estudianteId; // FK → usuarios.id

  TutoriaEstudianteModel({
    required this.id,
    required this.tutoriaId,
    required this.estudianteId,
  });

  /// Convierte de JSON (o Map) a modelo
  factory TutoriaEstudianteModel.fromJson(Map<String, dynamic> json, String id) {
    return TutoriaEstudianteModel(
      id: id,
      tutoriaId: json['tutoriaId'] ?? '',
      estudianteId: json['estudianteId'] ?? '',
    );
  }

  /// Convierte de modelo a JSON (para Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'tutoriaId': tutoriaId,
      'estudianteId': estudianteId,
    };
  }

  /// Método copyWith para crear una copia modificando algunos campos
  TutoriaEstudianteModel copyWith({
    String? id,
    String? tutoriaId,
    String? estudianteId,
  }) {
    return TutoriaEstudianteModel(
      id: id ?? this.id,
      tutoriaId: tutoriaId ?? this.tutoriaId,
      estudianteId: estudianteId ?? this.estudianteId,
    );
  }
}
