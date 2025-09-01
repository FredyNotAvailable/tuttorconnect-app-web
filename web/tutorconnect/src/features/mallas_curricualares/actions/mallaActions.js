// src/features/mallas_curriculares/actions/MallaActions.js
import { MallaCurricularRepository } from "../repositories/MallaCurricularRepository";

export const MallaActions = {
  crearMalla: async (malla, toast) => {
    try {
      await MallaCurricularRepository.createMalla(malla);
      toast({
        title: "Malla curricular creada",
        description: `Ciclo ${malla.ciclo}, Año ${malla.anio} ha sido creada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al crear malla curricular",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  editarMalla: async (malla, toast) => {
    try {
      await MallaCurricularRepository.updateMalla(malla);
      toast({
        title: "Malla curricular actualizada",
        description: `Ciclo ${malla.ciclo}, Año ${malla.anio} ha sido actualizada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al actualizar malla curricular",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },

  eliminarMalla: async (id, ciclo, anio, toast) => {
    try {
      await MallaCurricularRepository.deleteMalla(id);
      toast({
        title: "Malla curricular eliminada",
        description: `Ciclo ${ciclo}, Año ${anio} ha sido eliminada`,
        status: "success",
        duration: 3000,
        isClosable: true,
      });
    } catch (error) {
      toast({
        title: "Error al eliminar malla curricular",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  },
};
