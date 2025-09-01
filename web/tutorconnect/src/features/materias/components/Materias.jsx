import { useEffect, useState } from "react";
import {
  Box,
  Heading,
  Table,
  Thead,
  Tbody,
  Tr,
  Th,
  Td,
  Button,
  Input,
  useToast
} from "@chakra-ui/react";
import CrearMateriaModal from "./CrearMateriaModal";
import EditMateriaModal from "./EditMateriaModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { MateriaActions } from "../actions/materiaActions";
import { MateriaRepository } from "../repositories/MateriaRepository";

function Materias() {
  const [materias, setMaterias] = useState([]);
  const [filtroNombre, setFiltroNombre] = useState("");
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingMateria, setEditingMateria] = useState(null);
  const [selectedMateria, setSelectedMateria] = useState(null);
  const [action, setAction] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  const toast = useToast();

  const cargarMaterias = async () => {
    const data = await MateriaRepository.getAllMaterias();
    setMaterias(data);
  };

  useEffect(() => { cargarMaterias(); }, []);

  const openConfirmModal = (materia, actionType) => {
    setSelectedMateria(materia);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await MateriaActions.eliminarMateria(selectedMateria.id, selectedMateria.nombre, toast);
      cargarMaterias();
    }
  };

  const materiasFiltradas = materias.filter(m =>
    m.nombre.toLowerCase().includes(filtroNombre.toLowerCase())
  );

  return (
    <Box>
      <Heading mb={4} color="brand.500">Materias</Heading>

      <Box display="flex" mb={4} gap={2}>
        <Button bg="brand.500" color="white" _hover={{ bg: "brand.600" }} onClick={() => setCrearModalOpen(true)}>
          Agregar Materia
        </Button>
        <Input
          placeholder="Buscar por nombre..."
          value={filtroNombre}
          onChange={(e) => setFiltroNombre(e.target.value)}
          bg="white" borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />
      </Box>

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Nombre</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {materiasFiltradas.map((m) => (
            <Tr key={m.id}>
              <Td>{m.nombre}</Td>
              <Td>
                <Button size="sm" bg="brand.500" color="white" _hover={{ bg: "brand.600" }} mr={2} onClick={() => setEditingMateria(m)}>
                  Editar
                </Button>
                <Button size="sm" bg="brand.500" color="white" _hover={{ bg: "brand.600" }} onClick={() => openConfirmModal(m, "delete")}>
                  Eliminar
                </Button>
              </Td>
            </Tr>
          ))}
        </Tbody>
      </Table>

      {crearModalOpen && <CrearMateriaModal onClose={() => { setCrearModalOpen(false); cargarMaterias(); }} />}
      {editingMateria && <EditMateriaModal materia={editingMateria} onClose={() => { setEditingMateria(null); cargarMaterias(); }} />}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Materia"
        message={`¿Estás seguro que deseas eliminar ${selectedMateria?.nombre}?`}
        onConfirm={handleConfirm}
        colorScheme="brand"
      />
    </Box>
  );
}

export default Materias;
