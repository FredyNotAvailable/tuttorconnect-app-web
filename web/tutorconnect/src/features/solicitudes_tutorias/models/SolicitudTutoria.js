// src/features/solicitudes/models/SolicitudTutoria.js

// Enum para el estado de la solicitud
export const SolicitudTutoriaEstado = Object.freeze({
  PENDIENTE: "pendiente",
  ACEPTADO: "aceptado",
  RECHAZADO: "rechazado",
});

export class SolicitudTutoria {
  constructor({ id = '', tutoriaId, estudianteId, fechaEnvio, fechaRespuesta, estado = SolicitudTutoriaEstado.PENDIENTE }) {
    this.id = id;
    this.tutoriaId = tutoriaId;
    this.estudianteId = estudianteId;
    this.fechaEnvio = fechaEnvio;
    this.fechaRespuesta = fechaRespuesta;
    this.estado = estado;
  }

  static fromFirestore(doc) {
    const data = doc.data();
    return new SolicitudTutoria({
      id: doc.id,
      tutoriaId: data.tutoriaId,
      estudianteId: data.estudianteId,
      fechaEnvio: data.fechaEnvio ? data.fechaEnvio.toDate() : null,
      fechaRespuesta: data.fechaRespuesta ? data.fechaRespuesta.toDate() : null,
      estado: data.estado || SolicitudTutoriaEstado.PENDIENTE,
    });
  }

  toFirestore() {
    return {
      tutoriaId: this.tutoriaId,
      estudianteId: this.estudianteId,
      fechaEnvio: this.fechaEnvio,
      fechaRespuesta: this.fechaRespuesta,
      estado: this.estado,
    };
  }
}
