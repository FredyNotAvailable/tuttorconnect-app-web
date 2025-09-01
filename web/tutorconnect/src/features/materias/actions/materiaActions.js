import { MateriaRepository } from "../repositories/MateriaRepository";

export const MateriaActions = {
  crearMateria: async (materia, toast) => {
    try {
      await MateriaRepository.createMateria(materia);
      toast({
        title: "Materia creada",
        description: `${materia.nombre} ha sido creada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear materia",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  editarMateria: async (materia, toast) => {
    try {
      await MateriaRepository.updateMateria(materia);
      toast({
        title: "Materia actualizada",
        description: `${materia.nombre} ha sido actualizada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar materia",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarMateria: async (id, nombre, toast) => {
    try {
      await MateriaRepository.deleteMateria(id);
      toast({
        title: "Materia eliminada",
        description: `${nombre} ha sido eliminada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar materia",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  }
};
