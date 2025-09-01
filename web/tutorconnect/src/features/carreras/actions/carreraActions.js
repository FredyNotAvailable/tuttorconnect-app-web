// carreraActions.js
import { CarreraRepository } from "../repositories/CarreraRepository";

export const CarreraActions = {
  crearCarrera: async (carrera, toast) => {
    try {
      await CarreraRepository.createCarrera(carrera);
      toast({
        title: "Carrera creada",
        description: `${carrera.nombre} ha sido creada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear carrera",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },
  editarCarrera: async (carrera, toast) => {
    try {
      await CarreraRepository.updateCarrera(carrera);
      toast({
        title: "Carrera actualizada",
        description: `${carrera.nombre} ha sido actualizada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar carrera",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },
  eliminarCarrera: async (id, nombre, toast) => {
    try {
      await CarreraRepository.deleteCarrera(id);
      toast({
        title: "Carrera eliminada",
        description: `${nombre} ha sido eliminada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar carrera",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  }
};
