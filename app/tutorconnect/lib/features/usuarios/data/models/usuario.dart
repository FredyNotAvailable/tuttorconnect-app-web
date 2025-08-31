// lib/features/usuarios/data/models/usuario_model.dart

enum UsuarioRol { estudiante, docente, admin }

class UsuarioModel {
  final String id;             
  final String nombreCompleto; 
  final String correo;         
  final UsuarioRol rol;        
  final String fcmToken;       

  UsuarioModel({
    required this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.rol,
    required this.fcmToken,
  });

  /// Convierte de JSON a modelo
  factory UsuarioModel.fromJson(Map<String, dynamic> json, String id) {
    return UsuarioModel(
      id: id,
      nombreCompleto: json['nombreCompleto'] ?? '',
      correo: json['correo'] ?? '',
      rol: _rolFromString(json['rol'] ?? ''),
      fcmToken: json['fcmToken'] ?? '',
    );
  }

  /// Convierte de modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'nombreCompleto': nombreCompleto,
      'correo': correo,
      'rol': _rolToString(rol),
      'fcmToken': fcmToken,
    };
  }

  /// Convierte string a enum
  static UsuarioRol _rolFromString(String rol) {
    switch (rol.toLowerCase()) {
      case 'estudiante':
        return UsuarioRol.estudiante;
      case 'docente':
        return UsuarioRol.docente;
      case 'admin':
        return UsuarioRol.admin;
      default:
        return UsuarioRol.estudiante; 
    }
  }

  /// Convierte enum a string para almacenamiento
  static String _rolToString(UsuarioRol rol) {
    switch (rol) {
      case UsuarioRol.estudiante:
        return 'estudiante';
      case UsuarioRol.docente:
        return 'docente';
      case UsuarioRol.admin:
        return 'admin';
    }
  }

  /// 🔹 Nombre bonito del rol para mostrar en UI
  String get rolNombre {
    switch (rol) {
      case UsuarioRol.estudiante:
        return 'Estudiante';
      case UsuarioRol.docente:
        return 'Docente';
      case UsuarioRol.admin:
        return 'Administrador';
    }
  }
}
