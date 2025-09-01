import { MateriaDatasource } from "../datasources/MateriaDatasource";
import { Materia } from "../models/Materia";

export const MateriaRepository = {
  getAllMaterias: async () => {
    return await MateriaDatasource.getAllMaterias();
  },

  getMateriaById: async (id) => {
    return await MateriaDatasource.getMateriaById(id);
  },

  createMateria: async ({ nombre }) => {
    const nuevaMateria = new Materia({ nombre });
    return await MateriaDatasource.createMateria(nuevaMateria);
  },

  updateMateria: async ({ id, nombre }) => {
    const materia = new Materia({ id, nombre });
    return await MateriaDatasource.updateMateria(materia);
  },

  deleteMateria: async (id) => {
    await MateriaDatasource.deleteMateria(id);
  }
};
