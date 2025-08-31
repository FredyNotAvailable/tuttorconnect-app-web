// lib/features/mallas/data/models/malla_curricular_model.dart

class MallaCurricularModel {
  final String id;        // ID del documento en Firestore/Supabase
  final String carreraId; // FK → carreras.id
  final int ciclo;
  final int anio;

  MallaCurricularModel({
    required this.id,
    required this.carreraId,
    required this.ciclo,
    required this.anio,
  });

  /// Convierte de JSON (o Map) a modelo
  factory MallaCurricularModel.fromJson(Map<String, dynamic> json, String id) {
    return MallaCurricularModel(
      id: id,
      carreraId: json['carreraId'] ?? '',
      ciclo: json['ciclo'] != null ? int.tryParse(json['ciclo'].toString()) ?? 0 : 0,
      anio: json['anio'] != null ? int.tryParse(json['anio'].toString()) ?? 0 : 0,
    );
  }

  /// Convierte de modelo a JSON (para Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'carreraId': carreraId,
      'ciclo': ciclo,
      'anio': anio,
    };
  }

  /// Permite crear una copia con valores modificados
  MallaCurricularModel copyWith({
    String? id,
    String? carreraId,
    int? ciclo,
    int? anio,
  }) {
    return MallaCurricularModel(
      id: id ?? this.id,
      carreraId: carreraId ?? this.carreraId,
      ciclo: ciclo ?? this.ciclo,
      anio: anio ?? this.anio,
    );
  }
}
