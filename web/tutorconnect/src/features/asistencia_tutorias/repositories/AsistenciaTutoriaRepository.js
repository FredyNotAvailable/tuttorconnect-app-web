import { AsistenciaTutoriaDatasource } from "../datasources/AsistenciaTutoriaDatasource";
import { AsistenciaTutoria } from "../models/AsistenciaTutoria";

export const AsistenciaTutoriaRepository = {
  getAllAsistenciaTutorias: async () => {
    return await AsistenciaTutoriaDatasource.getAllAsistenciaTutorias();
  },

  getAsistenciaTutoriaById: async (id) => {
    return await AsistenciaTutoriaDatasource.getAsistenciaTutoriaById(id);
  },

  createAsistenciaTutoria: async (asistenciaTutoriaData) => {
    const nuevaAsistenciaTutoria = new AsistenciaTutoria(asistenciaTutoriaData);
    return await AsistenciaTutoriaDatasource.createAsistenciaTutoria(nuevaAsistenciaTutoria);
  },

  updateAsistenciaTutoria: async (asistenciaTutoriaData) => {
    const asistenciaTutoria = new AsistenciaTutoria(asistenciaTutoriaData);
    return await AsistenciaTutoriaDatasource.updateAsistenciaTutoria(asistenciaTutoria);
  },

  deleteAsistenciaTutoria: async (id) => {
    await AsistenciaTutoriaDatasource.deleteAsistenciaTutoria(id);
  },
};