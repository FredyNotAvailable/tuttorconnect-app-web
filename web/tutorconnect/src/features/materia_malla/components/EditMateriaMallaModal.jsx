import { useState, useEffect } from "react";
import {
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalCloseButton,
  ModalBody,
  ModalFooter,
  Button,
  FormControl,
  FormLabel,
  useToast,
} from "@chakra-ui/react";
import Select from "react-select";
import { MateriaMallaActions } from "../actions/MateriaMallaActions";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { MallaCurricularRepository } from "../../mallas_curricualares/repositories/MallaCurricularRepository";
import { CarreraRepository } from "../../carreras/repositories/CarreraRepository";

export default function EditMateriaMallaModal({ materiaMalla, onClose }) {
  const [materiaId, setMateriaId] = useState(materiaMalla.materiaId || "");
  const [mallaId, setMallaId] = useState(materiaMalla.mallaId || "");
  const [materias, setMaterias] = useState([]);
  const [mallas, setMallas] = useState([]);
  const [carrerasMap, setCarrerasMap] = useState({});
  const toast = useToast();

  useEffect(() => {
    const cargarDatos = async () => {
      const allMaterias = await MateriaRepository.getAllMaterias();
      setMaterias(allMaterias);

      const allMallas = await MallaCurricularRepository.getAllMallas();
      setMallas(allMallas);

      const allCarreras = await CarreraRepository.getAllCarreras();
      const map = {};
      allCarreras.forEach((c) => {
        map[c.id] = c.nombre;
      });
      setCarrerasMap(map);
    };
    cargarDatos();
  }, []);

  const actualizarMateriaMalla = async () => {
    if (!materiaId || !mallaId) {
      toast({
        title: "Complete todos los campos",
        status: "warning",
        duration: 3000,
        isClosable: true,
      });
      return;
    }

    try {
      await MateriaMallaActions.actualizarMateriaMalla(
        { id: materiaMalla.id, materiaId, mallaId },
        toast
      );
      onClose();
    } catch (error) {
      toast({
        title: "Error al actualizar",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  };

  const materiaOptions = materias.map((m) => ({
    value: m.id,
    label: m.nombre,
  }));

  const mallaOptions = mallas.map((m) => ({
    value: m.id,
    label: `${carrerasMap[m.carreraId] || m.carreraId} - Ciclo ${m.ciclo} - Año ${m.anio}`,
  }));

  const selectedMateria = materiaOptions.find(option => option.value === materiaId);
  const selectedMalla = mallaOptions.find(option => option.value === mallaId);

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent bg="surface.DEFAULT">
        <ModalHeader color="brand.500">Editar Materia de Malla</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel color="brand.500">Materia</FormLabel>
            <Select
              options={materiaOptions}
              value={selectedMateria}
              onChange={(option) => setMateriaId(option ? option.value : "")}
              placeholder="Seleccione o busque una materia"
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Malla Curricular</FormLabel>
            <Select
              options={mallaOptions}
              value={selectedMalla}
              onChange={(option) => setMallaId(option ? option.value : "")}
              placeholder="Seleccione o busque una malla"
              isClearable
              isSearchable
            />
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button colorScheme="brand" mr={3} onClick={actualizarMateriaMalla}>
            Actualizar
          </Button>
          <Button bg="white" color="black" _hover={{ bg: "gray.100" }} onClick={onClose}>
            Cancelar
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}