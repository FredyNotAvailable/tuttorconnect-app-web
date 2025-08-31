import 'package:cloud_firestore/cloud_firestore.dart';

enum TutoriaEstado {
  pendiente,
  confirmada,
  cancelada,
  finalizada,
  desconocido,
}

// ✅ Función helper para mostrar el estado como String
String estadoToString(TutoriaEstado estado) {
  switch (estado) {
    case TutoriaEstado.pendiente:
      return 'Pendiente';
    case TutoriaEstado.confirmada:
      return 'Confirmada';
    case TutoriaEstado.cancelada:
      return 'Cancelada';
    case TutoriaEstado.finalizada:
      return 'Finalizada';
    case TutoriaEstado.desconocido:
      return 'Desconocido';
  }
}

extension TutoriaEstadoExtension on TutoriaEstado {
  String get name {
    switch (this) {
      case TutoriaEstado.pendiente:
        return 'pendiente';
      case TutoriaEstado.confirmada:
        return 'confirmada';
      case TutoriaEstado.cancelada:
        return 'cancelada';
      case TutoriaEstado.finalizada:
        return 'finalizada';
      case TutoriaEstado.desconocido:
        return 'desconocido';
    }
  }

  static TutoriaEstado fromString(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return TutoriaEstado.pendiente;
      case 'confirmada':
        return TutoriaEstado.confirmada;
      case 'cancelada':
        return TutoriaEstado.cancelada;
      case 'finalizada':
        return TutoriaEstado.finalizada;
      case 'desconocido':
        return TutoriaEstado.desconocido;
      default:
        return TutoriaEstado.desconocido; // valor por defecto
    }
  }
}

class TutoriaModel {
  final String id;
  final String profesorId;
  final String materiaId;
  final String aulaId;
  final Timestamp fecha;
  final String horaInicio;
  final String horaFin;
  final TutoriaEstado estado; // 🔹 ahora es enum
  final String tema;
  final String descripcion;

  TutoriaModel({
    required this.id,
    required this.profesorId,
    required this.materiaId,
    required this.aulaId,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.estado,
    required this.tema,
    required this.descripcion,
  });

  factory TutoriaModel.fromJson(Map<String, dynamic> json, String id) {
    return TutoriaModel(
      id: id,
      profesorId: json['profesorId'] ?? '',
      materiaId: json['materiaId'] ?? '',
      aulaId: json['aulaId'] ?? '',
      fecha: json['fecha'] is Timestamp ? json['fecha'] as Timestamp : Timestamp.now(),
      horaInicio: json['horaInicio'] ?? '',
      horaFin: json['horaFin'] ?? '',
      estado: TutoriaEstadoExtension.fromString(json['estado'] ?? 'pendiente'),
      tema: json['tema'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profesorId': profesorId,
      'materiaId': materiaId,
      'aulaId': aulaId,
      'fecha': fecha,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'estado': estado.name, // 🔹 guardar como string en Firestore
      'tema': tema,
      'descripcion': descripcion,
    };
  }
}

extension TutoriaModelCopy on TutoriaModel {
  TutoriaModel copyWith({
    String? id,
    String? profesorId,
    String? materiaId,
    String? aulaId,
    Timestamp? fecha,
    String? horaInicio,
    String? horaFin,
    TutoriaEstado? estado,
    String? tema,
    String? descripcion,
  }) {
    return TutoriaModel(
      id: id ?? this.id,
      profesorId: profesorId ?? this.profesorId,
      materiaId: materiaId ?? this.materiaId,
      aulaId: aulaId ?? this.aulaId,
      fecha: fecha ?? this.fecha,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      estado: estado ?? this.estado,
      tema: tema ?? this.tema,
      descripcion: descripcion ?? this.descripcion,
    );
  }
}
