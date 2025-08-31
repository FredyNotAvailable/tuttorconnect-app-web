// lib/features/profesores_materias/data/models/profesor_materia_model.dart

class ProfesorMateriaModel {
  final String id;         // ID del documento en Firestore/Supabase
  final String profesorId; // FK → usuarios.id
  final String materiaId;  // FK → materias.id

  ProfesorMateriaModel({
    required this.id,
    required this.profesorId,
    required this.materiaId,
  });

  /// Convierte de JSON (o Map) a modelo
  factory ProfesorMateriaModel.fromJson(Map<String, dynamic> json, String id) {
    return ProfesorMateriaModel(
      id: id,
      profesorId: json['profesorId'] ?? '',
      materiaId: json['materiaId'] ?? '',
    );
  }

  /// Convierte de modelo a JSON (para Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'profesorId': profesorId,
      'materiaId': materiaId,
    };
  }

  /// Permite crear una copia con valores modificados
  ProfesorMateriaModel copyWith({
    String? id,
    String? profesorId,
    String? materiaId,
  }) {
    return ProfesorMateriaModel(
      id: id ?? this.id,
      profesorId: profesorId ?? this.profesorId,
      materiaId: materiaId ?? this.materiaId,
    );
  }
}
