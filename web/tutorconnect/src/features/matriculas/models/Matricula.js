// src/features/matriculas/models/Matricula.js
export class Matricula {
  constructor({ id, estudianteId, mallaId }) {
    this.id = id;
    this.estudianteId = estudianteId;
    this.mallaId = mallaId; // referencia directa a la malla curricular
  }

  static fromFirestore(doc) {
    const data = doc.data();
    return new Matricula({
      id: doc.id,
      estudianteId: data.estudianteId,
      mallaId: data.mallaId,
    });
  }

  toFirestore() {
    return {
      estudianteId: this.estudianteId,
      mallaId: this.mallaId,
    };
  }
}
