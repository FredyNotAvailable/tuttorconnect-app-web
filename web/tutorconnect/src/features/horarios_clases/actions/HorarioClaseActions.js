import { HorarioClaseRepository } from "../repositories/HorarioClaseRepository";

export const HorarioClaseActions = {
  crearHorarioClase: async (horarioClase, toast) => {
    try {
      await HorarioClaseRepository.createHorarioClase(horarioClase);
      toast({
        title: "Horario creado",
        description: `El horario de clase ha sido creado correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear horario",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  actualizarHorarioClase: async (horarioClase, toast) => {
    try {
      await HorarioClaseRepository.updateHorarioClase(horarioClase);
      toast({
        title: "Horario actualizado",
        description: `El horario de clase ha sido actualizado correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar horario",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarHorarioClase: async (id, toast) => {
    try {
      await HorarioClaseRepository.deleteHorarioClase(id);
      toast({
        title: "Horario eliminado",
        description: `El horario de clase ha sido eliminado correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar horario",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },
};