import { TutoriaRepository } from "../repositories/TutoriaRepository";

export const TutoriaActions = {
  crearTutoria: async (tutoria, toast) => {
    try {
      await TutoriaRepository.createTutoria(tutoria);
      toast({
        title: "Tutoría creada",
        description: `La tutoría ha sido creada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear tutoría",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  actualizarTutoria: async (tutoria, toast) => {
    try {
      await TutoriaRepository.updateTutoria(tutoria);
      toast({
        title: "Tutoría actualizada",
        description: `La tutoría ha sido actualizada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar tutoría",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarTutoria: async (id, toast) => {
    try {
      await TutoriaRepository.deleteTutoria(id);
      toast({
        title: "Tutoría eliminada",
        description: `La tutoría ha sido eliminada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar tutoría",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },
};