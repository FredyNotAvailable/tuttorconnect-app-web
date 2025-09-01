import { useEffect, useState } from "react";
import { HStack, Text, Box, Avatar, Button, useToast, Modal, ModalOverlay, ModalContent, ModalHeader, ModalBody, ModalFooter, ModalCloseButton, useDisclosure } from "@chakra-ui/react";
import { logout } from "../services/auth";
import { auth } from "../services/firebase";
import { UsuarioRepository } from "../features/usuarios/repositories/UsuarioRepository";

function Navbar() {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const toast = useToast();
  const [isLoading, setIsLoading] = useState(false);
  const [usuario, setUsuario] = useState(null);

  // Obtener usuario actual usando el UID
  useEffect(() => {
    const fetchUsuario = async () => {
      const currentUser = auth.currentUser;
      if (!currentUser) return;
      const usuarioData = await UsuarioRepository.getUsuarioById(currentUser.uid);
      setUsuario(usuarioData);
    };
    fetchUsuario();
  }, []);

  const handleLogout = async () => {
    setIsLoading(true);
    try {
      await logout();
      toast({
        title: "Sesión cerrada",
        description: "Has cerrado sesión correctamente.",
        status: "success",
        duration: 3000,
        isClosable: true,
        position: "top-right",
      });
      window.location.href = "/login";
    } catch (error) {
      toast({
        title: "Error",
        description: "No se pudo cerrar sesión.",
        status: "error",
        duration: 3000,
        isClosable: true,
        position: "top-right",
      });
    } finally {
      setIsLoading(false);
      onClose();
    }
  };

  return (
    <Box bg="surface.DEFAULT" borderBottomWidth={1} borderColor="brand.100" w="full" p={4}>
      <HStack justifyContent="space-between">
        <Text fontSize="xl" fontWeight="bold" color="brand.500">Mi Dashboard</Text>

        <HStack spacing={4}>
          <HStack spacing={2}>
            <Avatar size="sm" name={usuario?.nombreCompleto || "Usuario"} />
            <Text>{usuario?.nombreCompleto || "Usuario Ejemplo"}</Text>
          </HStack>

          <Button colorScheme="brand" size="sm" onClick={onOpen}>
            Cerrar Sesión
          </Button>
        </HStack>
      </HStack>

      <Modal isOpen={isOpen} onClose={onClose} isCentered>
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Confirmar cierre de sesión</ModalHeader>
          <ModalCloseButton />
          <ModalBody>¿Estás seguro de que deseas cerrar sesión?</ModalBody>
          <ModalFooter>
            <Button variant="ghost" mr={3} onClick={onClose}>Cancelar</Button>
            <Button colorScheme="brand" onClick={handleLogout} isLoading={isLoading}>Cerrar Sesión</Button>
          </ModalFooter>
        </ModalContent>
      </Modal>
    </Box>
  );
}

export default Navbar;
