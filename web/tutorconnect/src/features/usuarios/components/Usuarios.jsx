import { useEffect, useState } from "react";
import { 
  Box, Heading, Table, Thead, Tbody, Tr, Th, Td, Button, Input, useToast, HStack 
} from "@chakra-ui/react";
import ReactSelect from "react-select";
import EditUsuarioModal from "./EditUsuarioModal";
import CrearUsuarioModal from "./CrearUsuarioModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { UsuarioActions } from "../actions/usuarioActions";
import { UsuarioRepository } from "../repositories/UsuarioRepository";
import { Roles } from "../models/UsuarioRoles"; // tu enum de roles

function Usuarios() {
  const [usuarios, setUsuarios] = useState([]);
  const [usuariosFiltrados, setUsuariosFiltrados] = useState([]);
  const [editingUsuario, setEditingUsuario] = useState(null);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [action, setAction] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  // filtros
  const [filtroNombre, setFiltroNombre] = useState("");
  const [filtroCorreo, setFiltroCorreo] = useState("");
  const [filtroRol, setFiltroRol] = useState("");

  const toast = useToast();

  const cargarUsuarios = async () => {
    const data = await UsuarioRepository.getAllUsuarios();
    setUsuarios(data);
    setUsuariosFiltrados(data);
  };

  useEffect(() => {
    cargarUsuarios();
  }, []);

  // Filtrar usuarios
  useEffect(() => {
    const filtrados = usuarios.filter((u) =>
      u.nombreCompleto.toLowerCase().includes(filtroNombre.toLowerCase()) &&
      u.correo.toLowerCase().includes(filtroCorreo.toLowerCase()) &&
      u.rol.toLowerCase().includes(filtroRol.toLowerCase())
    );
    setUsuariosFiltrados(filtrados);
  }, [filtroNombre, filtroCorreo, filtroRol, usuarios]);

  const openConfirmModal = (user, actionType) => {
    setSelectedUser(user);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await UsuarioActions.eliminarUsuario(selectedUser.id, selectedUser.nombreCompleto, toast);
      cargarUsuarios();
    } else if (action === "reset") {
      await UsuarioActions.restablecerPassword(selectedUser.correo, toast);
    }
  };

  // opciones para ReactSelect
  const rolOptions = Object.values(Roles).map(r => ({ label: r, value: r }));

  return (
    <Box>
      <Heading mb={4} color="brand.500">Usuarios</Heading>

      <HStack mb={4} spacing={4} flexWrap="wrap">
        <Button 
          bg="brand.500" 
          color="white" 
          _hover={{ bg: "brand.600" }} 
          onClick={() => setCrearModalOpen(true)}
          flexShrink={0}      
          minW="160px"        
        >
          Agregar Usuario
        </Button>

        <Input
          placeholder="Buscar por nombre..."
          value={filtroNombre}
          onChange={(e) => setFiltroNombre(e.target.value)}
          bg="white"
          flex="1"            
          minW="200px"        
          _hover={{ borderColor: "gray.200" }}
          _focus={{ borderColor: "brand.500", boxShadow: "0 0 0 1px var(--chakra-colors-brand-500)" }}
        />

        <Input
          placeholder="Buscar por correo..."
          value={filtroCorreo}
          onChange={(e) => setFiltroCorreo(e.target.value)}
          bg="white"
          flex="1"
          minW="200px"
          _hover={{ borderColor: "gray.200" }}
          _focus={{ borderColor: "brand.500", boxShadow: "0 0 0 1px var(--chakra-colors-brand-500)" }}
        />

        <Box flex="1" minW="200px">
          <ReactSelect
            placeholder="Filtrar por rol..."
            value={filtroRol ? { label: filtroRol, value: filtroRol } : null}
            onChange={(option) => setFiltroRol(option ? option.value : "")}
            options={rolOptions}
            isClearable
          />
        </Box>
      </HStack>

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Nombre</Th>
            <Th>Correo</Th>
            <Th>Rol</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {usuariosFiltrados.map((u) => (
            <Tr key={u.id}>
              <Td>{u.nombreCompleto}</Td>
              <Td>{u.correo}</Td>
              <Td>{u.rol}</Td>
              <Td>
                <Button size="sm" bg="brand.500" color="white" _hover={{ bg: "brand.600" }} mr={2} onClick={() => setEditingUsuario(u)}>
                  Editar
                </Button>
                <Button size="sm" bg="brand.500" color="white" _hover={{ bg: "brand.600" }} mr={2} onClick={() => openConfirmModal(u, "delete")}>
                  Eliminar
                </Button>
                <Button size="sm" bg="brand.500" color="white" _hover={{ bg: "brand.600" }} onClick={() => openConfirmModal(u, "reset")}>
                  Restablecer contraseña
                </Button>
              </Td>
            </Tr>
          ))}
        </Tbody>
      </Table>

      {editingUsuario && (
        <EditUsuarioModal
          usuario={editingUsuario}
          onClose={() => { setEditingUsuario(null); cargarUsuarios(); }}
        />
      )}

      {crearModalOpen && (
        <CrearUsuarioModal
          onClose={() => { setCrearModalOpen(false); cargarUsuarios(); }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title={action === "delete" ? "Eliminar Usuario" : "Restablecer Contraseña"}
        message={
          action === "delete"
            ? `¿Estás seguro que deseas eliminar a ${selectedUser?.nombreCompleto}?`
            : `¿Deseas enviar un correo de restablecimiento a ${selectedUser?.correo}?`
        }
        onConfirm={handleConfirm}
        colorScheme="brand"
      />
    </Box>
  );
}

export default Usuarios;
