import { SolicitudTutoriaRepository } from "../repositories/SolicitudTutoriaRepository";

export const SolicitudTutoriaActions = {
  crearSolicitudTutoria: async (solicitudTutoria, toast) => {
    try {
      await SolicitudTutoriaRepository.createSolicitudTutoria(solicitudTutoria);
      toast({
        title: "Solicitud de tutoría creada",
        description: `La solicitud de tutoría ha sido creada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear solicitud de tutoría",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  actualizarSolicitudTutoria: async (solicitudTutoria, toast) => {
    try {
      await SolicitudTutoriaRepository.updateSolicitudTutoria(solicitudTutoria);
      toast({
        title: "Solicitud de tutoría actualizada",
        description: `La solicitud de tutoría ha sido actualizada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar solicitud de tutoría",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarSolicitudTutoria: async (id, toast) => {
    try {
      await SolicitudTutoriaRepository.deleteSolicitudTutoria(id);
      toast({
        title: "Solicitud de tutoría eliminada",
        description: `La solicitud de tutoría ha sido eliminada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar solicitud de tutoría",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },
};