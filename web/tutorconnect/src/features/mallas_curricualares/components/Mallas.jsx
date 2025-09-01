// src/features/mallas_curriculares/components/Mallas.jsx
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
  useToast,
} from "@chakra-ui/react";
import CrearMallaModal from "./CrearMallaModal";
import EditMallaModal from "./EditMallaModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { MallaActions } from "../actions/MallaActions";
import { MallaCurricularRepository } from "../repositories/MallaCurricularRepository";
import { CarreraRepository } from "../../carreras/repositories/CarreraRepository";

function Mallas() {
  const [mallas, setMallas] = useState([]);
  const [filtroCiclo, setFiltroCiclo] = useState("");
  const [filtroAnio, setFiltroAnio] = useState(""); // 🔹 Nuevo filtro
  const [filtroCarrera, setFiltroCarrera] = useState("");
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingMalla, setEditingMalla] = useState(null);
  const [selectedMalla, setSelectedMalla] = useState(null);
  const [action, setAction] = useState(""); // "delete"
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [carrerasMap, setCarrerasMap] = useState({});

  const toast = useToast();

  const cargarMallas = async () => {
    const data = await MallaCurricularRepository.getAllMallas();
    setMallas(data);
  };

  const cargarCarreras = async () => {
    const allCarreras = await CarreraRepository.getAllCarreras();
    const map = {};
    allCarreras.forEach((c) => {
      map[c.id] = c.nombre;
    });
    setCarrerasMap(map);
  };

  useEffect(() => {
    cargarMallas();
    cargarCarreras();
  }, []);

  const openConfirmModal = (malla, actionType) => {
    setSelectedMalla(malla);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await MallaActions.eliminarMalla(
        selectedMalla.id,
        selectedMalla.ciclo,
        selectedMalla.anio,
        toast
      );
      cargarMallas();
    }
  };

  // 🔹 Aplicar filtros
  const mallasFiltradas = mallas.filter((m) => {
    const nombreCarrera = carrerasMap[m.carreraId] || "";
    return (
      m.ciclo.toString().includes(filtroCiclo) &&
      m.anio.toString().includes(filtroAnio) && // 🔹 Filtro por año
      nombreCarrera.toLowerCase().includes(filtroCarrera.toLowerCase())
    );
  });

  return (
    <Box h="100%" overflow="hidden">
      <Heading mb={4} color="brand.500">
        Mallas Curriculares
      </Heading>

      <Box display="flex" mb={4} gap={2}>
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          minW="140px" // ancho mínimo para el botón
        >
          Agregar Malla
        </Button>

        <Input
          flex="1"
          placeholder="Filtrar por carrera..."
          value={filtroCarrera}
          onChange={(e) => setFiltroCarrera(e.target.value)}
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />

        <Input
          flex="1"
          placeholder="Filtrar por ciclo..."
          value={filtroCiclo}
          onChange={(e) => setFiltroCiclo(e.target.value)}
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />

        <Input
          flex="1"
          placeholder="Filtrar por año..."
          value={filtroAnio}
          onChange={(e) => setFiltroAnio(e.target.value)}
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />
      </Box>

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Carrera</Th>
            <Th>Ciclo</Th>
            <Th>Año</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {mallasFiltradas.map((m) => (
            <Tr key={m.id}>
              <Td>{carrerasMap[m.carreraId] || m.carreraId}</Td>
              <Td>{m.ciclo}</Td>
              <Td>{m.anio}</Td>
              <Td>
                <Button
                  size="sm"
                  bg="brand.500"
                  color="white"
                  _hover={{ bg: "brand.600" }}
                  mr={2}
                  onClick={() => setEditingMalla(m)}
                >
                  Editar
                </Button>
                <Button
                  size="sm"
                  bg="brand.500"
                  color="white"
                  _hover={{ bg: "brand.600" }}
                  onClick={() => openConfirmModal(m, "delete")}
                >
                  Eliminar
                </Button>
              </Td>
            </Tr>
          ))}
        </Tbody>
      </Table>

      {crearModalOpen && (
        <CrearMallaModal
          onClose={() => {
            setCrearModalOpen(false);
            cargarMallas();
          }}
        />
      )}

      {editingMalla && (
        <EditMallaModal
          malla={editingMalla}
          onClose={() => {
            setEditingMalla(null);
            cargarMallas();
          }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Malla Curricular"
        message={`¿Estás seguro que deseas eliminar la malla ciclo ${selectedMalla?.ciclo}, año ${selectedMalla?.anio}?`}
        onConfirm={handleConfirm}
        colorScheme="brand"
      />
    </Box>
  );
}

export default Mallas;
