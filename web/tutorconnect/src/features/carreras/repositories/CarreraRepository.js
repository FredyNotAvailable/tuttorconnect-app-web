import { CarreraDatasource } from "../datasources/CarreraDatasource";
import { Carrera } from "../models/Carrera";

export const CarreraRepository = {
  getAllCarreras: async () => {
    return await CarreraDatasource.getAllCarreras();
  },

  getCarreraById: async (id) => {
    return await CarreraDatasource.getCarreraById(id);
  },

  createCarrera: async ({ nombre }) => {
    const nuevaCarrera = new Carrera({ nombre });
    return await CarreraDatasource.createCarrera(nuevaCarrera);
  },

  updateCarrera: async ({ id, nombre }) => {
    const carrera = new Carrera({ id, nombre });
    return await CarreraDatasource.updateCarrera(carrera);
  },

  deleteCarrera: async (id) => {
    await CarreraDatasource.deleteCarrera(id);
  }
};
