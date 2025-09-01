// src/features/mallas_curriculares/models/MallaCurricular.js
export class MallaCurricular {
  constructor({ id = "", carreraId, ciclo, anio }) {
    this.id = id;
    this.carreraId = carreraId;
    this.ciclo = ciclo;
    this.anio = anio;
  }
}
