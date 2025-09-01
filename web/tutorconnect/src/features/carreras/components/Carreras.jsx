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
import CrearCarreraModal from "./CrearCarreraModal";
import EditCarreraModal from "./EditCarreraModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { CarreraActions } from "../actions/carreraActions";
import { CarreraRepository } from "../repositories/CarreraRepository";

function Carreras() {
  const [carreras, setCarreras] = useState([]);
  const [filtroNombre, setFiltroNombre] = useState("");
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingCarrera, setEditingCarrera] = useState(null);
  const [selectedCarrera, setSelectedCarrera] = useState(null);
  const [action, setAction] = useState(""); // "delete"
  const [isModalOpen, setIsModalOpen] = useState(false);

  const toast = useToast();

  const cargarCarreras = async () => {
    const data = await CarreraRepository.getAllCarreras();
    setCarreras(data);
  };

  useEffect(() => {
    cargarCarreras();
  }, []);

  const openConfirmModal = (carrera, actionType) => {
    setSelectedCarrera(carrera);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await CarreraActions.eliminarCarrera(selectedCarrera.id, selectedCarrera.nombre, toast);
      cargarCarreras();
    }
  };

  const carrerasFiltradas = carreras.filter(c =>
    c.nombre.toLowerCase().includes(filtroNombre.toLowerCase())
  );

  return (
    <Box>
      <Heading mb={4} color="brand.500">Carreras</Heading>

      <Box display="flex" mb={4} gap={2}>
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
        >
          Agregar Carrera
        </Button>

        <Input
          placeholder="Buscar por nombre..."
          value={filtroNombre}
          onChange={(e) => setFiltroNombre(e.target.value)}
          bg="white"
          borderColor="transparent"
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
          {carrerasFiltradas.map((c) => (
            <Tr key={c.id}>
              <Td>{c.nombre}</Td>
              <Td>
                <Button
                  size="sm"
                  bg="brand.500"
                  color="white"
                  _hover={{ bg: "brand.600" }}
                  mr={2}
                  onClick={() => setEditingCarrera(c)}
                >
                  Editar
                </Button>
                <Button
                  size="sm"
                  bg="brand.500"
                  color="white"
                  _hover={{ bg: "brand.600" }}
                  onClick={() => openConfirmModal(c, "delete")}
                >
                  Eliminar
                </Button>
              </Td>
            </Tr>
          ))}
        </Tbody>
      </Table>

      {crearModalOpen && (
        <CrearCarreraModal
          onClose={() => { setCrearModalOpen(false); cargarCarreras(); }}
        />
      )}

      {editingCarrera && (
        <EditCarreraModal
          carrera={editingCarrera}
          onClose={() => { setEditingCarrera(null); cargarCarreras(); }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Carrera"
        message={`¿Estás seguro que deseas eliminar ${selectedCarrera?.nombre}?`}
        onConfirm={handleConfirm}
        colorScheme="brand"
      />
    </Box>
  );
}

export default Carreras;
