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
  useToast,
} from "@chakra-ui/react";
import ReactSelect from "react-select";
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
  const [action, setAction] = useState(""); 
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

  // Filtrado con ReactSelect
  const carrerasFiltradas = filtroNombre
    ? carreras.filter(c => c.nombre === filtroNombre)
    : carreras;

  const nombreOptions = carreras.map(c => ({ value: c.nombre, label: c.nombre }));

  return (
    <Box>
      <Heading mb={4} color="brand.500">Carreras</Heading>

      <Box display="flex" mb={4} gap={2} flexWrap="wrap">
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          minW="160px"
        >
          Agregar Carrera
        </Button>

        <Box flex="1" minW="200px">
          <ReactSelect
            placeholder="Buscar por nombre..."
            options={nombreOptions}
            value={filtroNombre ? { value: filtroNombre, label: filtroNombre } : null}
            onChange={(option) => setFiltroNombre(option ? option.value : "")}
            isClearable
          />
        </Box>
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
