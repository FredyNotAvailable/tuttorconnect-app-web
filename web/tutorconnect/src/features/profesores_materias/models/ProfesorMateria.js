// src/features/profesores_materias/models/ProfesorMateria.js
export class ProfesorMateria {
  constructor({ id, profesorId, materiaId }) {
    this.id = id;
    this.profesorId = profesorId;
    this.materiaId = materiaId;
  }

  static fromFirestore(doc) {
    const data = doc.data();
    return new ProfesorMateria({
      id: doc.id,
      profesorId: data.profesorId,
      materiaId: data.materiaId,
    });
  }

  toFirestore() {
    return {
      profesorId: this.profesorId,
      materiaId: this.materiaId,
    };
  }
}
