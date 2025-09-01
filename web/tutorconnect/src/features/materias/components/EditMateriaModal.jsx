import { useState } from "react";
import { Modal, ModalOverlay, ModalContent, ModalHeader, ModalCloseButton, ModalBody, ModalFooter, Button, Input, FormControl, FormLabel, useToast } from "@chakra-ui/react";
import { MateriaActions } from "../actions/materiaActions";

export default function EditMateriaModal({ materia, onClose }) {
  const [nombre, setNombre] = useState(materia.nombre);
  const toast = useToast();

  const guardarCambios = async () => {
    if (!nombre.trim()) {
      toast({ title: "Ingrese un nombre", status: "warning", duration: 3000, isClosable: true });
      return;
    }
    await MateriaActions.editarMateria({ id: materia.id, nombre }, toast);
    onClose();
  };

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent bg="surface.DEFAULT">
        <ModalHeader color="brand.500">Editar Materia</ModalHeader>
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
        </ModalBody>
        <ModalFooter>
          <Button colorScheme="brand" mr={3} onClick={guardarCambios}>Guardar</Button>
          <Button bg="white" color="black" _hover={{ bg: "gray.100" }} onClick={onClose}>Cancelar</Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
