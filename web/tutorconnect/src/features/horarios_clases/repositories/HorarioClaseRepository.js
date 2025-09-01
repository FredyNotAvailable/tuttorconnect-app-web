// src/features/horarios_clases/repositories/HorarioClaseRepository.js
import { HorarioClaseDatasource } from "../datasources/HorarioClaseDatasource";
import { HorarioClase } from "../models/HorarioClase";

export const HorarioClaseRepository = {
  getAllHorariosClases: async () => {
    return await HorarioClaseDatasource.getAllHorariosClases();
  },

  getHorarioClaseById: async (id) => {
    return await HorarioClaseDatasource.getHorarioClaseById(id);
  },

  createHorarioClase: async (horarioData) => {
    const nuevoHorarioClase = new HorarioClase(horarioData);
    return await HorarioClaseDatasource.createHorarioClase(nuevoHorarioClase);
  },

  updateHorarioClase: async (horarioData) => {
    const horarioClase = new HorarioClase(horarioData);
    return await HorarioClaseDatasource.updateHorarioClase(horarioClase);
  },

  deleteHorarioClase: async (id) => {
    await HorarioClaseDatasource.deleteHorarioClase(id);
  },
};