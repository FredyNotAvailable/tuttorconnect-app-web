import { MatriculaRepository } from "../repositories/MatriculaRepository";

export const MatriculaActions = {
  crearMatricula: async (matricula, toast) => {
    try {
      await MatriculaRepository.createMatricula(matricula);
      toast({
        title: "Matrícula creada",
        description: `La matrícula ha sido creada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear matrícula",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  actualizarMatricula: async (matricula, toast) => {
    try {
      await MatriculaRepository.updateMatricula(matricula);
      toast({
        title: "Matrícula actualizada",
        description: `La matrícula ha sido actualizada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar matrícula",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarMatricula: async (id, toast) => { // Note: no 'nombre' for matricula
    try {
      await MatriculaRepository.deleteMatricula(id);
      toast({
        title: "Matrícula eliminada",
        description: `La matrícula ha sido eliminada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar matrícula",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  }
};