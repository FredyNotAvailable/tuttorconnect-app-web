import { TutoriaEstudianteDatasource } from "../datasources/TutoriaEstudianteDatasource";
import { TutoriaEstudiante } from "../models/TutoriaEstudiante";

export const TutoriaEstudianteRepository = {
  getAllTutoriasEstudiantes: async () => {
    return await TutoriaEstudianteDatasource.getAllTutoriasEstudiantes();
  },

  getTutoriaEstudianteById: async (id) => {
    return await TutoriaEstudianteDatasource.getTutoriaEstudianteById(id);
  },

  createTutoriaEstudiante: async (tutoriaEstudianteData) => {
    const nuevaTutoriaEstudiante = new TutoriaEstudiante(tutoriaEstudianteData);
    return await TutoriaEstudianteDatasource.createTutoriaEstudiante(nuevaTutoriaEstudiante);
  },

  updateTutoriaEstudiante: async (tutoriaEstudianteData) => {
    const tutoriaEstudiante = new TutoriaEstudiante(tutoriaEstudianteData);
    return await TutoriaEstudianteDatasource.updateTutoriaEstudiante(tutoriaEstudiante);
  },

  deleteTutoriaEstudiante: async (id) => {
    await TutoriaEstudianteDatasource.deleteTutoriaEstudiante(id);
  },
};