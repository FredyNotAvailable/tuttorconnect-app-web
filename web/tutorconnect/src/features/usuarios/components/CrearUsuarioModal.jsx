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
  Input,
  Select,
  FormControl,
  FormLabel,
  useToast
} from "@chakra-ui/react";
import { UsuarioRepository } from "../repositories/UsuarioRepository";
import { Roles } from "../models/UsuarioRoles";

export default function CrearUsuarioModal({ onClose }) {
  const [nombre, setNombre] = useState("");
  const [rol, setRol] = useState(Roles.ESTUDIANTE);
  const toast = useToast();

  // Función para limpiar texto: quita tildes y caracteres especiales
  const limpiarTexto = (texto) =>
    texto
      .normalize("NFD")               // descompone caracteres acentuados
      .replace(/[\u0300-\u036f]/g, "") // elimina los acentos
      .replace(/[^a-zA-Z]/g, "");      // elimina todo lo que no sea letra

  // Función para generar email automáticamente
  const generarEmail = (nombreCompleto) => {
    const partes = nombreCompleto.trim().split(" ");
    if (partes.length < 3) return "";

    const primerNombre = limpiarTexto(partes[0]);
    const primerApellido = limpiarTexto(partes[partes.length - 2]);
    const segundoApellido = limpiarTexto(partes[partes.length - 1]);

    return (
      primerNombre.slice(0, 2).toLowerCase() +
      primerApellido.toLowerCase() +
      segundoApellido.slice(0, 2).toLowerCase() +
      "@uide.edu.ec"
    );
  };

  const crearUsuario = async () => {
    if (!nombre) {
      toast({ title: "Ingrese un nombre completo", status: "warning", duration: 3000, isClosable: true });
      return;
    }

    const correo = generarEmail(nombre);
    if (!correo) {
      toast({ title: "Nombre incompleto", status: "error", duration: 3000, isClosable: true });
      return;
    }

    try {
      await UsuarioRepository.createUsuario({ nombreCompleto: nombre, correo, password: "password", rol });
      toast({ title: "Usuario creado", description: `${nombre} ha sido creado`, status: "success", duration: 3000, isClosable: true });
      onClose();
    } catch (error) {
      toast({ title: "Error al crear usuario", description: error.message, status: "error", duration: 3000, isClosable: true });
    }
  };

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent bg="surface.DEFAULT">
        <ModalHeader color="brand.500">Crear Nuevo Usuario</ModalHeader>
        <ModalCloseButton color="brand.500" />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel color="brand.500">Nombre</FormLabel>
            <Input
              value={nombre}
              onChange={(e) => setNombre(e.target.value)}
              placeholder="Ej: Freddy Emanuel Guaman Gonzalez"
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Correo generado automáticamente</FormLabel>
            <Input
              value={generarEmail(nombre)}
              isReadOnly
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Rol</FormLabel>
            <Select
              value={rol}
              onChange={(e) => setRol(e.target.value)}
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            >
              <option value={Roles.ESTUDIANTE}>Estudiante</option>
              <option value={Roles.Docente}>Docente</option>
              <option value={Roles.ADMIN}>Admin</option>
            </Select>
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button colorScheme="brand" mr={3} onClick={crearUsuario}>
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
