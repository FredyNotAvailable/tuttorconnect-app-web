// lib/features/tutorias/data/models/solicitud_tutoria_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum EstadoSolicitud { pendiente, aceptado, rechazado }

extension EstadoSolicitudExtension on EstadoSolicitud {
  String get value {
    switch (this) {
      case EstadoSolicitud.pendiente:
        return 'pendiente';
      case EstadoSolicitud.aceptado:
        return 'aceptado';
      case EstadoSolicitud.rechazado:
        return 'rechazado';
    }
  }

  static EstadoSolicitud fromString(String estado) {
    switch (estado) {
      case 'aceptado':
        return EstadoSolicitud.aceptado;
      case 'rechazado':
        return EstadoSolicitud.rechazado;
      case 'pendiente':
      default:
        return EstadoSolicitud.pendiente;
    }
  }
}

class SolicitudTutoriaModel {
  final String id;               
  final String tutoriaId;        
  final String estudianteId;     
  final Timestamp? fechaEnvio;   
  final Timestamp? fechaRespuesta;
  final EstadoSolicitud estado;  

  SolicitudTutoriaModel({
    required this.id,
    required this.tutoriaId,
    required this.estudianteId,
    this.fechaEnvio,
    this.fechaRespuesta,
    this.estado = EstadoSolicitud.pendiente,
  });

  /// Convierte de JSON (o Map) a modelo
  factory SolicitudTutoriaModel.fromJson(Map<String, dynamic> json, String id) {
    return SolicitudTutoriaModel(
      id: id,
      tutoriaId: json['tutoriaId'] ?? '',
      estudianteId: json['estudianteId'] ?? '',
      fechaEnvio: json['fechaEnvio'] as Timestamp?,
      fechaRespuesta: json['fechaRespuesta'] as Timestamp?,
      estado: json['estado'] != null
          ? EstadoSolicitudExtension.fromString(json['estado'])
          : EstadoSolicitud.pendiente,
    );
  }

  /// Convierte de modelo a JSON (para Firestore/Supabase)
  Map<String, dynamic> toJson() {
    return {
      'tutoriaId': tutoriaId,
      'estudianteId': estudianteId,
      'fechaEnvio': fechaEnvio,
      'fechaRespuesta': fechaRespuesta,
      'estado': estado.value,
    };
  }

  /// Método copyWith para crear una copia modificando algunos campos
  SolicitudTutoriaModel copyWith({
    String? id,
    String? tutoriaId,
    String? estudianteId,
    Timestamp? fechaEnvio,
    Timestamp? fechaRespuesta,
    EstadoSolicitud? estado,
  }) {
    return SolicitudTutoriaModel(
      id: id ?? this.id,
      tutoriaId: tutoriaId ?? this.tutoriaId,
      estudianteId: estudianteId ?? this.estudianteId,
      fechaEnvio: fechaEnvio ?? this.fechaEnvio,
      fechaRespuesta: fechaRespuesta ?? this.fechaRespuesta,
      estado: estado ?? this.estado,
    );
  }
}
