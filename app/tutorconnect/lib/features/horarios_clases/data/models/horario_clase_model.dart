// lib/features/horarios/data/models/horario_clase_model.dart

enum DiaSemana { lunes, martes, miercoles, jueves, viernes, sabado, domingo }

class HorarioClaseModel {
  final String id;          // ID del documento en Firestore/Supabase
  final String profesorId;  // FK → usuarios.id
  final String materiaId;   // FK → materias.id
  final String aulaId;      // FK → aulas.id
  final DiaSemana diaSemana;
  final String horaInicio;  // HH:mm
  final String horaFin;     // HH:mm

  HorarioClaseModel({
    required this.id,
    required this.profesorId,
    required this.materiaId,
    required this.aulaId,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
  });

  /// Convierte de JSON (o Map) a modelo
  factory HorarioClaseModel.fromJson(Map<String, dynamic> json, String id) {
    return HorarioClaseModel(
      id: id,
      profesorId: json['profesorId'] ?? '',
      materiaId: json['materiaId'] ?? '',
      aulaId: json['aulaId'] ?? '',
      diaSemana: _diaSemanaFromString(json['diaSemana'] ?? ''),
      horaInicio: json['horaInicio'] ?? '',
      horaFin: json['horaFin'] ?? '',
    );
  }

  /// Convierte de modelo a JSON (para Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'profesorId': profesorId,
      'materiaId': materiaId,
      'aulaId': aulaId,
      'diaSemana': diaSemana.name,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
    };
  }

  /// Método copyWith para crear una copia modificando algunos campos
  HorarioClaseModel copyWith({
    String? id,
    String? profesorId,
    String? materiaId,
    String? aulaId,
    DiaSemana? diaSemana,
    String? horaInicio,
    String? horaFin,
  }) {
    return HorarioClaseModel(
      id: id ?? this.id,
      profesorId: profesorId ?? this.profesorId,
      materiaId: materiaId ?? this.materiaId,
      aulaId: aulaId ?? this.aulaId,
      diaSemana: diaSemana ?? this.diaSemana,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
    );
  }

  /// Helper para convertir string a enum DiaSemana
  static DiaSemana _diaSemanaFromString(String dia) {
    switch (dia.toLowerCase()) {
      case 'lunes':
        return DiaSemana.lunes;
      case 'martes':
        return DiaSemana.martes;
      case 'miercoles':
        return DiaSemana.miercoles;
      case 'jueves':
        return DiaSemana.jueves;
      case 'viernes':
        return DiaSemana.viernes;
      case 'sabado':
        return DiaSemana.sabado;
      case 'domingo':
        return DiaSemana.domingo;
      default:
        throw Exception('Día de semana inválido: $dia');
    }
  }
}
