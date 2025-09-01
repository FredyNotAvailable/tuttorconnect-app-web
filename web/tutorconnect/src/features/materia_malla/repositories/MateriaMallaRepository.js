// src/features/mallas_curriculares/repositories/MateriaMallaRepository.js
import { MateriaMallaDatasource } from "../datasources/MateriaMallaDatasource";
import { MateriaMalla } from "../models/MateriaMalla";

export const MateriaMallaRepository = {
  getAllMateriasMalla: async () => {
    return await MateriaMallaDatasource.getAllMateriasMalla();
  },

  getMateriaMallaById: async (id) => {
    return await MateriaMallaDatasource.getMateriaMallaById(id);
  },

  createMateriaMalla: async ({ mallaId, materiaId }) => {
    const nuevaMateriaMalla = new MateriaMalla({ mallaId, materiaId });
    return await MateriaMallaDatasource.createMateriaMalla(nuevaMateriaMalla);
  },

  updateMateriaMalla: async ({ id, mallaId, materiaId }) => {
    const materiaMalla = new MateriaMalla({ id, mallaId, materiaId });
    return await MateriaMallaDatasource.updateMateriaMalla(materiaMalla);
  },

  deleteMateriaMalla: async (id) => {
    await MateriaMallaDatasource.deleteMateriaMalla(id);
  },
};
