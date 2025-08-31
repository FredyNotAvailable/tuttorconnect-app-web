// lib/features/aulas/data/models/aula_model.dart

enum AulaEstado { disponible, noDisponible }

class AulaModel {
  final String id;       // ID del documento en Firestore/Supabase
  final String nombre;   // Nombre del aula
  final String tipo;     // Tipo de aula (teórica, laboratorio, etc.)
  final AulaEstado estado; // Estado del aula

  AulaModel({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.estado,
  });

  /// Convierte de JSON (o Map) a modelo
  factory AulaModel.fromJson(Map<String, dynamic> json, String id) {
    AulaEstado estado = AulaEstado.disponible; // valor por defecto
    if (json['estado'] != null) {
      switch (json['estado'].toString().toLowerCase()) {
        case 'disponible':
          estado = AulaEstado.disponible;
          break;
        case 'nodisponible':
        case 'no disponible':
          estado = AulaEstado.noDisponible;
          break;
      }
    }

    return AulaModel(
      id: id,
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? '',
      estado: estado,
    );
  }

  /// Convierte de modelo a JSON (para Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'tipo': tipo,
      'estado': estado == AulaEstado.disponible ? 'disponible' : 'noDisponible',
    };
  }

  /// Permite crear una copia con valores modificados
  AulaModel copyWith({
    String? id,
    String? nombre,
    String? tipo,
    AulaEstado? estado,
  }) {
    return AulaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      estado: estado ?? this.estado,
    );
  }
}
