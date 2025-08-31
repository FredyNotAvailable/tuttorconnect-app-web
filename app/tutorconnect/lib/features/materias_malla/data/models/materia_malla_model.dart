// lib/features/materias_malla/data/models/materia_malla_model.dart

class MateriaMallaModel {
  final String id;       // ID del documento en Firestore/Supabase
  final String mallaId;  // FK → mallas_curriculares.id
  final String materiaId; // FK → materias.id

  MateriaMallaModel({
    required this.id,
    required this.mallaId,
    required this.materiaId,
  });

  /// Convierte de JSON (o Map) a modelo
  factory MateriaMallaModel.fromJson(Map<String, dynamic> json, String id) {
    return MateriaMallaModel(
      id: id,
      mallaId: json['mallaId'] ?? '',
      materiaId: json['materiaId'] ?? '',
    );
  }

  /// Convierte de modelo a JSON (para Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'mallaId': mallaId,
      'materiaId': materiaId,
    };
  }

  /// Permite crear una copia con valores modificados
  MateriaMallaModel copyWith({
    String? id,
    String? mallaId,
    String? materiaId,
  }) {
    return MateriaMallaModel(
      id: id ?? this.id,
      mallaId: mallaId ?? this.mallaId,
      materiaId: materiaId ?? this.materiaId,
    );
  }
}
