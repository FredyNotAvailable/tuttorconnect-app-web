import { TutoriaEstudianteRepository } from "../repositories/TutoriaEstudianteRepository";

export const TutoriaEstudianteActions = {
  crearTutoriaEstudiante: async (tutoriaEstudiante, toast) => {
    try {
      await TutoriaEstudianteRepository.createTutoriaEstudiante(tutoriaEstudiante);
      toast({
        title: "Tutoría de estudiante creada",
        description: `La tutoría de estudiante ha sido creada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear tutoría de estudiante",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  actualizarTutoriaEstudiante: async (tutoriaEstudiante, toast) => {
    try {
      await TutoriaEstudianteRepository.updateTutoriaEstudiante(tutoriaEstudiante);
      toast({
        title: "Tutoría de estudiante actualizada",
        description: `La tutoría de estudiante ha sido actualizada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar tutoría de estudiante",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarTutoriaEstudiante: async (id, toast) => {
    try {
      await TutoriaEstudianteRepository.deleteTutoriaEstudiante(id);
      toast({
        title: "Tutoría de estudiante eliminada",
        description: `La tutoría de estudiante ha sido eliminada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar tutoría de estudiante",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },
};