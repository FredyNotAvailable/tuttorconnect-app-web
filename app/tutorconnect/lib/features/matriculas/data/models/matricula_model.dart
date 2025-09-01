// lib/features/matriculas/data/models/matricula_model.dart

class MatriculaModel {
  final String id;           // ID del documento en Firestore/Supabase
  final String estudianteId; // FK → usuarios.id
  final String mallaId;      // FK → mallas.id

  MatriculaModel({
    required this.id,
    required this.estudianteId,
    required this.mallaId,
  });

  /// Convierte de JSON (o Map) a modelo
  factory MatriculaModel.fromJson(Map<String, dynamic> json, String id) {
    return MatriculaModel(
      id: id,
      estudianteId: json['estudianteId'] ?? '',
      mallaId: json['mallaId'] ?? '',
    );
  }

  /// Convierte de modelo a JSON (para Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'estudianteId': estudianteId,
      'mallaId': mallaId,
    };
  }

  /// Permite crear una copia con valores modificados
  MatriculaModel copyWith({
    String? id,
    String? estudianteId,
    String? mallaId,
  }) {
    return MatriculaModel(
      id: id ?? this.id,
      estudianteId: estudianteId ?? this.estudianteId,
      mallaId: mallaId ?? this.mallaId,
    );
  }
}
