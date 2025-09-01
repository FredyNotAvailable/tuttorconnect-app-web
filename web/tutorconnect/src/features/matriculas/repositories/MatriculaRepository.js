// src/features/matriculas/repositories/MatriculaRepository.js
import { MatriculaDatasource } from "../datasources/MatriculaDatasource";
import { Matricula } from "../models/Matricula";

export const MatriculaRepository = {
  getAllMatriculas: async () => {
    return await MatriculaDatasource.getAllMatriculas();
  },

  getMatriculaById: async (id) => {
    return await MatriculaDatasource.getMatriculaById(id);
  },

  createMatricula: async (matriculaData) => {
    const nuevaMatricula = new Matricula(matriculaData);
    return await MatriculaDatasource.createMatricula(nuevaMatricula);
  },

  updateMatricula: async (matriculaData) => {
    const matricula = new Matricula(matriculaData);
    return await MatriculaDatasource.updateMatricula(matricula);
  },

  deleteMatricula: async (id) => {
    await MatriculaDatasource.deleteMatricula(id);
  },
};