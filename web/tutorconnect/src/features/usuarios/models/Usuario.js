// Feature/usuarios/models/Usuario.js
import { Roles } from "./UsuarioRoles";

export class Usuario {
  constructor({ id = "", nombreCompleto = "", correo = "", rol = Roles.ESTUDIANTE, fcmToken = "" } = {}) {
    this.id = id;
    this.nombreCompleto = nombreCompleto;
    this.correo = correo;
    this.rol = rol;
    this.fcmToken = fcmToken;
  }

  static fromFirestore(doc) {
    const data = doc.data();
    return new Usuario({
      id: doc.id,
      nombreCompleto: data.nombreCompleto || "",
      correo: data.correo || "",
      rol: data.rol || Roles.ESTUDIANTE,
      fcmToken: data.fcmToken || "",
    });
  }

  toFirestore() {
    return {
      nombreCompleto: this.nombreCompleto,
      correo: this.correo,
      rol: this.rol,
      fcmToken: this.fcmToken,
    };
  }
}
