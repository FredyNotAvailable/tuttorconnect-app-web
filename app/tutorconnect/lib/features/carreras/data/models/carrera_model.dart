class CarreraModel {
  final String id;      // Document ID en Firestore/Supabase
  final String nombre;  // Nombre de la carrera

  CarreraModel({
    required this.id,
    required this.nombre,
  });

  /// Convierte de JSON (o Map) a modelo
  factory CarreraModel.fromJson(Map<String, dynamic> json, String id) {
    return CarreraModel(
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
