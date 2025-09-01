import { AulaRepository } from "../repositories/AulaRepository";

export const AulaActions = {
  crearAula: async (aula, toast) => {
    try {
      await AulaRepository.createAula(aula);
      toast({
        title: "Aula creada",
        description: `${aula.nombre} ha sido creada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear aula",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  editarAula: async (aula, toast) => {
    try {
      await AulaRepository.updateAula(aula);
      toast({
        title: "Aula actualizada",
        description: `${aula.nombre} ha sido actualizada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar aula",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarAula: async (id, nombre, toast) => {
    try {
      await AulaRepository.deleteAula(id);
      toast({
        title: "Aula eliminada",
        description: `${nombre} ha sido eliminada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar aula",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  }
};