import { useState } from "react";
import {
  Modal, ModalOverlay, ModalContent, ModalHeader, ModalCloseButton,
  ModalBody, ModalFooter, Button, Input, Select, FormControl, FormLabel, chakra
} from "@chakra-ui/react";
import { UsuarioRepository } from "../repositories/UsuarioRepository";
import { Roles } from "../models/UsuarioRoles";

export default function EditUsuarioModal({ usuario, onClose }) {
  const [nombre, setNombre] = useState(usuario.nombreCompleto);
  const [rol, setRol] = useState(usuario.rol);

  const guardarCambios = async () => {
    await UsuarioRepository.updateUsuario({
      id: usuario.id,
      nombreCompleto: nombre,
      correo: usuario.correo,
      rol
    });
    onClose();
  };

  return (
    <Modal isOpen={true} onClose={onClose}>
      <ModalOverlay />
      <ModalContent>
        <ModalHeader color="brand.500">Editar Usuario</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel>Nombre</FormLabel>
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
            <FormLabel>Rol</FormLabel>
            <Select
              value={rol}
              onChange={(e) => setRol(e.target.value)}
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            >
              {Object.values(Roles).map((r) => (
                <chakra.option
                  key={r}
                  value={r}
                  _hover={{ bg: "brand.500", color: "white" }}
                >
                  {r}
                </chakra.option>
              ))}
            </Select>
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
