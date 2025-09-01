import { TutoriaDatasource } from "../datasources/TutoriaDatasource";
import { Tutoria } from "../models/Tutoria";

export const TutoriaRepository = {
  getAllTutorias: async () => {
    return await TutoriaDatasource.getAllTutorias();
  },

  getTutoriaById: async (id) => {
    return await TutoriaDatasource.getTutoriaById(id);
  },

  createTutoria: async (tutoriaData) => {
    const nuevaTutoria = new Tutoria(tutoriaData);
    return await TutoriaDatasource.createTutoria(nuevaTutoria);
  },

  updateTutoria: async (tutoriaData) => {
    const tutoria = new Tutoria(tutoriaData);
    return await TutoriaDatasource.updateTutoria(tutoria);
  },

  deleteTutoria: async (id) => {
    await TutoriaDatasource.deleteTutoria(id);
  },
};