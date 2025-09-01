import { useState } from "react";
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
  Input,
  Select as ChakraSelect,
  useToast,
} from "@chakra-ui/react";
import { AulaActions } from "../actions/AulaActions";
import { AulaTipo, AulaEstado } from "../models/Aula"; // Importa los enums

export default function CrearAulaModal({ onClose }) {
  const [nombre, setNombre] = useState("");
  const [tipo, setTipo] = useState("");
  const [estado, setEstado] = useState("");
  const toast = useToast();

  const crearAula = async () => {
    if (!nombre || !tipo || !estado) {
      toast({
        title: "Complete todos los campos",
        status: "warning",
        duration: 3000,
        isClosable: true,
      });
      return;
    }

    try {
      await AulaActions.crearAula({ nombre, tipo, estado }, toast);
      onClose();
    } catch (error) {
      toast({
        title: "Error al crear aula",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  };

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent bg="surface.DEFAULT">
        <ModalHeader color="brand.500">Crear Nueva Aula</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel color="brand.500">Nombre</FormLabel>
            <Input
              placeholder="Ej: Aula 101"
              value={nombre}
              onChange={(e) => setNombre(e.target.value)}
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Tipo</FormLabel>
            <ChakraSelect
              placeholder="Seleccione un tipo"
              value={tipo}
              onChange={(e) => setTipo(e.target.value)}
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            >
              {Object.values(AulaTipo).map((t) => (
                <option key={t} value={t}>
                  {t}
                </option>
              ))}
            </ChakraSelect>
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Estado</FormLabel>
            <ChakraSelect
              placeholder="Seleccione un estado"
              value={estado}
              onChange={(e) => setEstado(e.target.value)}
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            >
              {Object.values(AulaEstado).map((valor) => {
                // Crear etiqueta amigable
                const label =
                  valor === AulaEstado.NO_DISPONIBLE ? "No disponible" : valor.charAt(0).toUpperCase() + valor.slice(1);
                return (
                  <option key={valor} value={valor}>
                    {label}
                  </option>
                );
              })}
            </ChakraSelect>
          </FormControl>

        </ModalBody>

        <ModalFooter>
          <Button colorScheme="brand" mr={3} onClick={crearAula}>
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
