import { SolicitudTutoriaDatasource } from "../datasources/SolicitudTutoriaDatasource";
import { SolicitudTutoria } from "../models/SolicitudTutoria";

export const SolicitudTutoriaRepository = {
  getAllSolicitudesTutorias: async () => {
    return await SolicitudTutoriaDatasource.getAllSolicitudesTutorias();
  },

  getSolicitudTutoriaById: async (id) => {
    return await SolicitudTutoriaDatasource.getSolicitudTutoriaById(id);
  },

  createSolicitudTutoria: async (solicitudTutoriaData) => {
    const nuevaSolicitudTutoria = new SolicitudTutoria(solicitudTutoriaData);
    return await SolicitudTutoriaDatasource.createSolicitudTutoria(nuevaSolicitudTutoria);
  },

  updateSolicitudTutoria: async (solicitudTutoriaData) => {
    const solicitudTutoria = new SolicitudTutoria(solicitudTutoriaData);
    return await SolicitudTutoriaDatasource.updateSolicitudTutoria(solicitudTutoria);
  },

  deleteSolicitudTutoria: async (id) => {
    await SolicitudTutoriaDatasource.deleteSolicitudTutoria(id);
  },
};