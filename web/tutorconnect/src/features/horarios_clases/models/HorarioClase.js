// src/features/horarios_clases/models/HorarioClase.js
export class HorarioClase {
  constructor({ id, profesorId, materiaId, aulaId, diaSemana, horaInicio, horaFin }) {
    this.id = id;
    this.profesorId = profesorId;
    this.materiaId = materiaId;
    this.aulaId = aulaId;
    this.diaSemana = diaSemana;
    this.horaInicio = horaInicio;
    this.horaFin = horaFin;
  }

  static fromFirestore(doc) {
    const data = doc.data();
    return new HorarioClase({
      id: doc.id,
      profesorId: data.profesorId,
      materiaId: data.materiaId,
      aulaId: data.aulaId,
      diaSemana: data.diaSemana,
      horaInicio: data.horaInicio,
      horaFin: data.horaFin,
    });
  }

  toFirestore() {
    return {
      profesorId: this.profesorId,
      materiaId: this.materiaId,
      aulaId: this.aulaId,
      diaSemana: this.diaSemana,
      horaInicio: this.horaInicio,
      horaFin: this.horaFin,
    };
  }
}
