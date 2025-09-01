// src/features/mallas_curriculares/repositories/MallaCurricularRepository.js
import { MallaCurricularDatasource } from "../datasources/MallaCurricularDatasource";
import { MallaCurricular } from "../models/MallaCurricular";

export const MallaCurricularRepository = {
  getAllMallas: async () => {
    return await MallaCurricularDatasource.getAllMallas();
  },

  getMallaById: async (id) => {
    return await MallaCurricularDatasource.getMallaById(id);
  },

  createMalla: async ({ carreraId, ciclo, anio }) => {
    const nuevaMalla = new MallaCurricular({ carreraId, ciclo, anio });
    return await MallaCurricularDatasource.createMalla(nuevaMalla);
  },

  updateMalla: async ({ id, carreraId, ciclo, anio }) => {
    const malla = new MallaCurricular({ id, carreraId, ciclo, anio });
    return await MallaCurricularDatasource.updateMalla(malla);
  },

  deleteMalla: async (id) => {
    await MallaCurricularDatasource.deleteMalla(id);
  },
};
