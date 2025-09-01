import { AsistenciaTutoriaRepository } from "../repositories/AsistenciaTutoriaRepository";

export const AsistenciaTutoriaActions = {
  crearAsistenciaTutoria: async (asistenciaTutoria, toast) => {
    try {
      await AsistenciaTutoriaRepository.createAsistenciaTutoria(asistenciaTutoria);
      toast({
        title: "Asistencia de tutoría creada",
        description: `La asistencia de tutoría ha sido creada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear asistencia de tutoría",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  actualizarAsistenciaTutoria: async (asistenciaTutoria, toast) => {
    try {
      await AsistenciaTutoriaRepository.updateAsistenciaTutoria(asistenciaTutoria);
      toast({
        title: "Asistencia de tutoría actualizada",
        description: `La asistencia de tutoría ha sido actualizada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar asistencia de tutoría",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarAsistenciaTutoria: async (id, toast) => {
    try {
      await AsistenciaTutoriaRepository.deleteAsistenciaTutoria(id);
      toast({
        title: "Asistencia de tutoría eliminada",
        description: `La asistencia de tutoría ha sido eliminada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar asistencia de tutoría",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },
};