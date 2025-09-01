// src/features/mallas_curriculares/models/MateriaMalla.js
export class MateriaMalla {
  constructor({ id = "", mallaId, materiaId }) {
    this.id = id;
    this.mallaId = mallaId;
    this.materiaId = materiaId;
  }
}
