// lib/features/matriculas/data/models/matricula_model.dart

class MatriculaModel {
  final String id;          // ID del documento en Firestore/Supabase
  final String estudianteId; // FK → usuarios.id
  final String carreraId;    // FK → carreras.id
  final int ciclo;           // Ciclo académico

  MatriculaModel({
    required this.id,
    required this.estudianteId,
    required this.carreraId,
    required this.ciclo,
  });

  /// Convierte de JSON (o Map) a modelo
  factory MatriculaModel.fromJson(Map<String, dynamic> json, String id) {
    return MatriculaModel(
      id: id,
      estudianteId: json['estudianteId'] ?? '',
      carreraId: json['carreraId'] ?? '',
      ciclo: json['ciclo'] != null ? int.tryParse(json['ciclo'].toString()) ?? 0 : 0,
    );
  }

  /// Convierte de modelo a JSON (para Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'estudianteId': estudianteId,
      'carreraId': carreraId,
      'ciclo': ciclo,
    };
  }

  /// Permite crear una copia con valores modificados
  MatriculaModel copyWith({
    String? id,
    String? estudianteId,
    String? carreraId,
    int? ciclo,
  }) {
    return MatriculaModel(
      id: id ?? this.id,
      estudianteId: estudianteId ?? this.estudianteId,
      carreraId: carreraId ?? this.carreraId,
      ciclo: ciclo ?? this.ciclo,
    );
  }
}
