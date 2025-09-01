// src/features/mallas_curriculares/components/EditMallaModal.jsx
import { useState, useEffect } from "react";
import {
  Input,
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
  Select as ChakraSelect,
  useToast,
} from "@chakra-ui/react";
import Select from "react-select";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";
import { MallaActions } from "../actions/MallaActions";
import { CarreraRepository } from "../../carreras/repositories/CarreraRepository";

export default function EditMallaModal({ malla, onClose }) {
  const [carreraId, setCarreraId] = useState(malla.carreraId);
  const [ciclo, setCiclo] = useState(malla.ciclo);
  const [anio, setAnio] = useState(new Date(malla.anio, 0, 1)); // convertir año a Date
  const [carreras, setCarreras] = useState([]);
  const toast = useToast();

  const cargarCarreras = async () => {
    const data = await CarreraRepository.getAllCarreras();
    setCarreras(data);
  };

  useEffect(() => {
    cargarCarreras();
  }, []);

  const guardarCambios = async () => {
    if (!carreraId || !ciclo || !anio) {
      toast({
        title: "Complete todos los campos",
        status: "warning",
        duration: 3000,
        isClosable: true,
      });
      return;
    }

    try {
      await MallaActions.editarMalla(
        { id: malla.id, carreraId, ciclo: Number(ciclo), anio: anio.getFullYear() },
        toast
      );
      onClose();
    } catch (error) {
      toast({
        title: "Error al actualizar malla",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  };

  const ciclos = Array.from({ length: 10 }, (_, i) => i + 1);

  const carreraOptions = carreras.map((c) => ({
    value: c.id,
    label: c.nombre,
  }));

  const selectedCarrera = carreraOptions.find(option => option.value === carreraId);

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent bg="surface.DEFAULT">
        <ModalHeader color="brand.500">Editar Malla Curricular</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel color="brand.500">Carrera</FormLabel>
            <Select
              options={carreraOptions}
              value={selectedCarrera}
              onChange={(option) => setCarreraId(option ? option.value : "")}
              placeholder="Seleccione o busque una carrera"
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Ciclo</FormLabel>
            <ChakraSelect
              placeholder="Seleccione un ciclo"
              value={ciclo}
              onChange={(e) => setCiclo(e.target.value)}
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            >
              {ciclos.map((c) => (
                <option key={c} value={c}>
                  {c}
                </option>
              ))}
            </ChakraSelect>
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Año</FormLabel>
            <DatePicker
              selected={anio}
              onChange={(date) => setAnio(date)}
              showYearPicker
              dateFormat="yyyy"
              placeholderText="Seleccione un año"
              customInput={
                <Input
                  width="100%"
                  focusBorderColor="brand.500" // borde al enfocar
                  borderColor="gray.200"        // borde por defecto
                  _hover={{ borderColor: "gray.300" }} // hover
                />
              }
            />
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button colorScheme="brand" mr={3} onClick={guardarCambios}>
            Guardar
          </Button>
          <Button bg="white" color="black" _hover={{ bg: "gray.100" }} onClick={onClose}>
            Cancelar
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}