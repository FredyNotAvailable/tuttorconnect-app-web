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

export default function CrearMallaModal({ onClose }) {
  const [carreraId, setCarreraId] = useState("");
  const [ciclo, setCiclo] = useState("");
  const [anio, setAnio] = useState(null); // ahora es Date
  const [carreras, setCarreras] = useState([]);
  const toast = useToast();

  const cargarCarreras = async () => {
    const data = await CarreraRepository.getAllCarreras();
    setCarreras(data);
  };

  useEffect(() => {
    cargarCarreras();
  }, []);

  const crearMalla = async () => {
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
      await MallaActions.crearMalla(
        { carreraId, ciclo: Number(ciclo), anio: anio.getFullYear() }, // solo año
        toast
      );
      onClose();
    } catch (error) {
      toast({
        title: "Error al crear malla",
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

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent bg="surface.DEFAULT">
        <ModalHeader color="brand.500">Crear Malla Curricular</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel color="brand.500">Carrera</FormLabel>
            <Select
              options={carreraOptions}
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
          <Button colorScheme="brand" mr={3} onClick={crearMalla}>
            Crear
          </Button>
          <Button bg="white" color="black" _hover={{ bg: "gray.100" }} onClick={onClose}>
            Cancelar
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}