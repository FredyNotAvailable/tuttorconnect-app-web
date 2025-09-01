// src/features/aulas/repositories/AulaRepository.js
import { AulaDatasource } from "../datasources/AulaDatasource";
import { Aula } from "../models/Aula";

export const AulaRepository = {
  getAllAulas: async () => {
    return await AulaDatasource.getAllAulas();
  },

  getAulaById: async (id) => {
    return await AulaDatasource.getAulaById(id);
  },

  createAula: async (aulaData) => {
    const nuevaAula = new Aula(aulaData);
    return await AulaDatasource.createAula(nuevaAula);
  },

  updateAula: async (aulaData) => {
    const aula = new Aula(aulaData);
    return await AulaDatasource.updateAula(aula);
  },

  deleteAula: async (id) => {
    await AulaDatasource.deleteAula(id);
  },
};