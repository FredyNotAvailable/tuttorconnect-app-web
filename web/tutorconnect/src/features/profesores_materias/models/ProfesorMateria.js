// src/features/profesores_materias/models/ProfesorMateria.js
export class ProfesorMateria {
  constructor({ id, profesorId, materiaId, mallaId }) {
    this.id = id;
    this.profesorId = profesorId;
    this.materiaId = materiaId; // materia específica
    this.mallaId = mallaId;     // malla/ciclo a la que pertenece esa materia
  }

  static fromFirestore(doc) {
    const data = doc.data();
    return new ProfesorMateria({
      id: doc.id,
      profesorId: data.profesorId,
      materiaId: data.materiaId,
      mallaId: data.mallaId,
    });
  }

  toFirestore() {
    return {
      profesorId: this.profesorId,
      materiaId: this.materiaId,
      mallaId: this.mallaId,
    };
  }
}
