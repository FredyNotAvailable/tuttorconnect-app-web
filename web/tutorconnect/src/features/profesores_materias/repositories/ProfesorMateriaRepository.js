// src/features/profesores_materias/repositories/ProfesorMateriaRepository.js
import { ProfesorMateriaDatasource } from "../datasources/ProfesorMateriaDatasource";
import { ProfesorMateria } from "../models/ProfesorMateria";

export const ProfesorMateriaRepository = {
  getAllProfesoresMaterias: async () => {
    return await ProfesorMateriaDatasource.getAllProfesoresMaterias();
  },

  getProfesorMateriaById: async (id) => {
    return await ProfesorMateriaDatasource.getProfesorMateriaById(id);
  },

  createProfesorMateria: async ({ profesorId, materiaId }) => {
    const nuevoProfesorMateria = new ProfesorMateria({ profesorId, materiaId });
    return await ProfesorMateriaDatasource.createProfesorMateria(nuevoProfesorMateria);
  },

  updateProfesorMateria: async ({ id, profesorId, materiaId }) => {
    const profesorMateria = new ProfesorMateria({ id, profesorId, materiaId });
    return await ProfesorMateriaDatasource.updateProfesorMateria(profesorMateria);
  },

  deleteProfesorMateria: async (id) => {
    await ProfesorMateriaDatasource.deleteProfesorMateria(id);
  },
};