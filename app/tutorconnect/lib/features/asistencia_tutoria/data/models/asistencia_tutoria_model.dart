import 'package:cloud_firestore/cloud_firestore.dart';

enum AsistenciaEstado { presente, ausente, sinRegistro }

class AsistenciaTutoriaModel {
  final String id;           // ID del documento
  final String tutoriaId;    // FK → tutorias.id
  final String estudianteId; // FK → usuarios.id
  final Timestamp fecha;     // Timestamp
  final AsistenciaEstado estado;

  AsistenciaTutoriaModel({
    required this.id,
    required this.tutoriaId,
    required this.estudianteId,
    required this.fecha,
    required this.estado,
  });

  /// Convierte de JSON (o Map) a modelo
factory AsistenciaTutoriaModel.fromJson(Map<String, dynamic> json, String id) {
  AsistenciaEstado parseEstado(String estado) {
    switch (estado) {
      case 'presente':
        return AsistenciaEstado.presente;
      case 'ausente':
        return AsistenciaEstado.ausente;
      case 'sinRegistro':
        return AsistenciaEstado.sinRegistro;
      default:
        return AsistenciaEstado.sinRegistro;
    }
  }

  return AsistenciaTutoriaModel(
    id: id,
    tutoriaId: json['tutoriaId'] ?? '',
    estudianteId: json['estudianteId'] ?? '',
    fecha: json['fecha'] ?? Timestamp.now(),
    estado: parseEstado(json['estado'] ?? 'sinRegistro'),
  );
}


  /// Convierte de modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'tutoriaId': tutoriaId,
      'estudianteId': estudianteId,
      'fecha': fecha,
      'estado': estado.name, // 'presente' o 'ausente'
    };
  }

  /// Copia el modelo modificando solo los campos que se pasen
  AsistenciaTutoriaModel copyWith({
    String? id,
    String? tutoriaId,
    String? estudianteId,
    Timestamp? fecha,
    AsistenciaEstado? estado,
  }) {
    return AsistenciaTutoriaModel(
      id: id ?? this.id,
      tutoriaId: tutoriaId ?? this.tutoriaId,
      estudianteId: estudianteId ?? this.estudianteId,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
    );
  }

}
