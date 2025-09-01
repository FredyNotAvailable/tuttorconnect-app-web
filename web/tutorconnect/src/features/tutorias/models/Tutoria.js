// Enum para los estados de la tutoría
export const TutoriaEstado = Object.freeze({
  PENDIENTE: "pendiente",
  CONFIRMADA: "confirmada",
  CANCELADA: "cancelada",
  FINALIZADA: "finalizada",
  DESCONOCIDO: "desconocido",
});

export class Tutoria {
  constructor({
    id = '',
    profesorId,
    materiaId,
    aulaId,
    fecha,
    horaInicio,
    horaFin,
    estado = TutoriaEstado.DESCONOCIDO,
    tema,
    descripcion,
  }) {
    this.id = id;
    this.profesorId = profesorId;
    this.materiaId = materiaId;
    this.aulaId = aulaId;
    this.fecha = fecha;
    this.horaInicio = horaInicio;
    this.horaFin = horaFin;
    this.estado = estado;
    this.tema = tema;
    this.descripcion = descripcion;
  }

  static fromFirestore(doc) {
    const data = doc.data();
    return new Tutoria({
      id: doc.id,
      profesorId: data.profesorId,
      materiaId: data.materiaId,
      aulaId: data.aulaId,
      fecha: data.fecha ? data.fecha.toDate() : null,
      horaInicio: data.horaInicio,
      horaFin: data.horaFin,
      estado: data.estado || TutoriaEstado.DESCONOCIDO,
      tema: data.tema,
      descripcion: data.descripcion,
    });
  }

  toFirestore() {
    return {
      profesorId: this.profesorId,
      materiaId: this.materiaId,
      aulaId: this.aulaId,
      fecha: this.fecha,
      horaInicio: this.horaInicio,
      horaFin: this.horaFin,
      estado: this.estado,
      tema: this.tema,
      descripcion: this.descripcion,
    };
  }
}
