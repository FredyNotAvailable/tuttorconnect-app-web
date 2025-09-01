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
import Select from "react-select";
import CrearAulaModal from "./CrearAulaModal";
import EditAulaModal from "./EditAulaModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { AulaActions } from "../actions/AulaActions";
import { AulaRepository } from "../repositories/AulaRepository";
import { AulaTipo, AulaEstado } from "../models/Aula";

function Aulas() {
  const [aulas, setAulas] = useState([]);
  const [filtroNombre, setFiltroNombre] = useState("");
  const [filtroTipo, setFiltroTipo] = useState(null);
  const [filtroEstado, setFiltroEstado] = useState(null);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingAula, setEditingAula] = useState(null);
  const [selectedAula, setSelectedAula] = useState(null);
  const [action, setAction] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  const toast = useToast();

  const cargarAulas = async () => {
    const data = await AulaRepository.getAllAulas();
    setAulas(data);
  };

  useEffect(() => {
    cargarAulas();
  }, []);

  const openConfirmModal = (aula, actionType) => {
    setSelectedAula(aula);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await AulaActions.eliminarAula(selectedAula.id, selectedAula.nombre, toast);
      cargarAulas();
    }
  };

  const formatEstado = (estado) => {
    if (estado === AulaEstado.NO_DISPONIBLE) return "No disponible";
    return estado.charAt(0).toUpperCase() + estado.slice(1);
  };

  // Crear opciones para react-select usando los enums
  const opcionesTipo = Object.values(AulaTipo).map(t => ({ value: t, label: t }));
  const opcionesEstado = Object.entries(AulaEstado).map(([key, value]) => ({
    value,
    label: value === AulaEstado.NO_DISPONIBLE ? "No disponible" : "Disponible"
  }));

  // Filtrado y ordenamiento
  const aulasFiltradas = aulas
    .filter(a =>
      a.nombre.toLowerCase().includes(filtroNombre.toLowerCase()) &&
      (!filtroTipo || a.tipo === filtroTipo.value) &&
      (!filtroEstado || a.estado === filtroEstado.value)
    )
    .sort((a, b) => a.nombre.localeCompare(b.nombre, undefined, { numeric: true, sensitivity: 'base' }));

  return (
    <Box>
      <Heading mb={4} color="brand.500">Aulas</Heading>

      <Box display="flex" mb={4} gap={2} flexWrap="wrap">
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          flexShrink={0}
          minW="150px"
        >
          Agregar Aula
        </Button>

        <Input
          placeholder="Buscar por nombre..."
          value={filtroNombre}
          onChange={(e) => setFiltroNombre(e.target.value)}
          flex="1"
          minW="150px"
        />

        <Box flex="1" minW="150px">
          <Select
            placeholder="Buscar por tipo..."
            options={opcionesTipo}
            value={filtroTipo}
            onChange={setFiltroTipo}
            isClearable
          />
        </Box>

        <Box flex="1" minW="150px">
          <Select
            placeholder="Buscar por estado..."
            options={opcionesEstado}
            value={filtroEstado}
            onChange={setFiltroEstado}
            isClearable
          />
        </Box>
      </Box>

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Nombre</Th>
            <Th>Tipo</Th>
            <Th>Estado</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {aulasFiltradas.map(a => (
            <Tr key={a.id}>
              <Td>{a.nombre}</Td>
              <Td>{a.tipo}</Td>
              <Td>{formatEstado(a.estado)}</Td>
              <Td>
                <Button
                  size="sm"
                  bg="brand.500"
                  color="white"
                  _hover={{ bg: "brand.600" }}
                  mr={2}
                  onClick={() => setEditingAula(a)}
                >
                  Editar
                </Button>
                <Button
                  size="sm"
                  bg="brand.500"
                  color="white"
                  _hover={{ bg: "brand.600" }}
                  onClick={() => openConfirmModal(a, "delete")}
                >
                  Eliminar
                </Button>
              </Td>
            </Tr>
          ))}
        </Tbody>
      </Table>

      {crearModalOpen && <CrearAulaModal onClose={() => { setCrearModalOpen(false); cargarAulas(); }} />}
      {editingAula && <EditAulaModal aula={editingAula} onClose={() => { setEditingAula(null); cargarAulas(); }} />}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Aula"
        message={`¿Estás seguro que deseas eliminar ${selectedAula?.nombre}?`}
        onConfirm={handleConfirm}
        colorScheme="brand"
      />
    </Box>
  );
}

export default Aulas;
