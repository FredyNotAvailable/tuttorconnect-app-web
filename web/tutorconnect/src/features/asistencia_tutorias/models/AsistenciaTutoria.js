export class AsistenciaTutoria {
  constructor({ id = '', tutoriaId, estudianteId, fecha, estado }) {
    this.id = id;
    this.tutoriaId = tutoriaId;
    this.estudianteId = estudianteId;
    this.fecha = fecha;
    this.estado = estado;
  }

  static fromFirestore(doc) {
    const data = doc.data();
    return new AsistenciaTutoria({
      id: doc.id,
      tutoriaId: data.tutoriaId,
      estudianteId: data.estudianteId,
      fecha: data.fecha ? data.fecha.toDate() : null,
      estado: data.estado,
    });
  }

  toFirestore() {
    return {
      tutoriaId: this.tutoriaId,
      estudianteId: this.estudianteId,
      fecha: this.fecha,
      estado: this.estado,
    };
  }
}