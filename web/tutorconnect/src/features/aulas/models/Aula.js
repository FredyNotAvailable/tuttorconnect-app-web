// src/features/aulas/models/Aula.js

// Enum para el tipo de aula
export const AulaTipo = Object.freeze({
  AULA: "Aula de clase",
  LABORATORIO: "Laboratorio",
});

// Enum para el estado de aula
export const AulaEstado = Object.freeze({
  DISPONIBLE: "disponible",
  NO_DISPONIBLE: "noDisponible",
});

export class Aula {
  constructor({ id, nombre, tipo, estado }) {
    this.id = id;
    this.nombre = nombre;
    this.tipo = tipo;
    this.estado = estado;
  }

  static fromFirestore(doc) {
    const data = doc.data();
    return new Aula({
      id: doc.id,
      nombre: data.nombre,
      tipo: data.tipo,
      estado: data.estado,
    });
  }

  toFirestore() {
    return {
      nombre: this.nombre,
      tipo: this.tipo,
      estado: this.estado,
    };
  }
}
