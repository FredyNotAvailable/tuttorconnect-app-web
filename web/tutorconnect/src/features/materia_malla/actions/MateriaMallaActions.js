import { MateriaMallaRepository } from "../repositories/MateriaMallaRepository";

export const MateriaMallaActions = {
  crearMateriaMalla: async (materiaMalla, toast) => {
    try {
      await MateriaMallaRepository.createMateriaMalla(materiaMalla);
      toast({
        title: "Materia añadida",
        description: `La materia ha sido añadida a la malla correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al añadir materia",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  actualizarMateriaMalla: async (materiaMalla, toast) => {
    try {
      await MateriaMallaRepository.updateMateriaMalla(materiaMalla);
      toast({
        title: "Materia actualizada",
        description: `La materia en la malla ha sido actualizada correctamente.`,
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

  eliminarMateriaMalla: async (id, toast) => {
    try {
      await MateriaMallaRepository.deleteMateriaMalla(id);
      toast({
        title: "Materia eliminada",
        description: `La materia ha sido eliminada de la malla correctamente.`,
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
  },
};
