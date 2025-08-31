class MateriaModel {
  final String id;      // Document ID en Firestore/Supabase
  final String nombre;  // Nombre de la materia

  MateriaModel({
    required this.id,
    required this.nombre,
  });

  /// Convierte de JSON (o Map) a modelo
  factory MateriaModel.fromJson(Map<String, dynamic> json, String id) {
    return MateriaModel(
      id: id,
      nombre: json['nombre'] ?? '',
    );
  }

  /// Convierte de modelo a JSON (para Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
    };
  }
}
