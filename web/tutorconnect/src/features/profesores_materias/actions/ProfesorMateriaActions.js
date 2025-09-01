import { ProfesorMateriaRepository } from "../repositories/ProfesorMateriaRepository";

export const ProfesorMateriaActions = {
  crearProfesorMateria: async (profesorMateria, toast) => {
    try {
      await ProfesorMateriaRepository.createProfesorMateria(profesorMateria);
      toast({
        title: "Profesor asignado",
        description: `El profesor ha sido asignado a la materia correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al asignar profesor",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  actualizarProfesorMateria: async (profesorMateria, toast) => {
    try {
      await ProfesorMateriaRepository.updateProfesorMateria(profesorMateria);
      toast({
        title: "Asignación actualizada",
        description: `La asignación ha sido actualizada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar asignación",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarProfesorMateria: async (id, toast) => {
    try {
      await ProfesorMateriaRepository.deleteProfesorMateria(id);
      toast({
        title: "Asignación eliminada",
        description: `La asignación ha sido eliminada correctamente.`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar asignación",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },
};