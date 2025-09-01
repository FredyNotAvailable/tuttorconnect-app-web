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
  Input,
  Select as ChakraSelect,
  useToast,
} from "@chakra-ui/react";
import { AulaActions } from "../actions/AulaActions";
import { AulaTipo, AulaEstado } from "../models/Aula";

export default function EditAulaModal({ aula, onClose }) {
  const [nombre, setNombre] = useState("");
  const [tipo, setTipo] = useState("");
  const [estado, setEstado] = useState("");
  const toast = useToast();

  // Precargar datos cada vez que cambie "aula"
  useEffect(() => {
    if (aula) {
      setNombre(aula.nombre || "");
      setTipo(aula.tipo || "");
      setEstado(aula.estado || "");
    }
  }, [aula]);

  const guardarCambios = async () => {
    if (!nombre.trim() || !tipo || !estado) {
      toast({
        title: "Complete todos los campos",
        status: "warning",
        duration: 3000,
        isClosable: true,
      });
      return;
    }
    await AulaActions.editarAula({ id: aula.id, nombre, tipo, estado }, toast);
    onClose();
  };

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent bg="surface.DEFAULT">
        <ModalHeader color="brand.500">Editar Aula</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel color="brand.500">Nombre</FormLabel>
            <Input
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
              value={estado}
              onChange={(e) => setEstado(e.target.value)}
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            >
              {Object.values(AulaEstado).map((valor) => {
                const label =
                  valor === AulaEstado.NO_DISPONIBLE
                    ? "No disponible"
                    : valor.charAt(0).toUpperCase() + valor.slice(1);
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
