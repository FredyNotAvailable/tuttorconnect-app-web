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
import ReactSelect from "react-select";
import CrearProfesorMateriaModal from "./CrearProfesorMateriaModal";
import EditProfesorMateriaModal from "./EditProfesorMateriaModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { ProfesorMateriaActions } from "../actions/ProfesorMateriaActions";
import { ProfesorMateriaRepository } from "../repositories/ProfesorMateriaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";

const limpiarTexto = (texto) =>
  texto
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-zA-Z0-9 ]/g, "");

function ProfesoresMaterias() {
  const [profesoresMaterias, setProfesoresMaterias] = useState([]);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingProfesorMateria, setEditingProfesorMateria] = useState(null);
  const [selectedProfesorMateria, setSelectedProfesorMateria] = useState(null);
  const [action, setAction] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  const [profesoresMap, setProfesoresMap] = useState({});
  const [materiasMap, setMateriasMap] = useState({});

  const [filtroProfesor, setFiltroProfesor] = useState("");
  const [filtroMateria, setFiltroMateria] = useState("");

  const toast = useToast();

  const cargarProfesoresMaterias = async () => {
    const data = await ProfesorMateriaRepository.getAllProfesoresMaterias();
    setProfesoresMaterias(data);
  };

  const cargarMapas = async () => {
    const [allUsuarios, allMaterias] = await Promise.all([
      UsuarioRepository.getAllUsuarios(),
      MateriaRepository.getAllMaterias(),
    ]);

    const pMap = {};
    allUsuarios
      .filter((u) => u.rol === Roles.DOCENTE)
      .forEach((p) => (pMap[p.id] = p.nombreCompleto));
    setProfesoresMap(pMap);

    const mMap = {};
    allMaterias.forEach((m) => (mMap[m.id] = m.nombre));
    setMateriasMap(mMap);
  };

  useEffect(() => {
    cargarProfesoresMaterias();
    cargarMapas();
  }, []);

  const openConfirmModal = (pm, actionType) => {
    setSelectedProfesorMateria(pm);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await ProfesorMateriaActions.eliminarProfesorMateria(selectedProfesorMateria.id, toast);
      cargarProfesoresMaterias();
    }
  };

  const profesoresMateriasFiltradas = profesoresMaterias
    .filter((pm) => {
      const nombreProfesor = limpiarTexto(profesoresMap[pm.profesorId] || "");
      const nombreMateria = limpiarTexto(materiasMap[pm.materiaId] || "");

      return (
        nombreProfesor.toLowerCase().includes(limpiarTexto(filtroProfesor).toLowerCase()) &&
        nombreMateria.toLowerCase().includes(limpiarTexto(filtroMateria).toLowerCase())
      );
    })
    .sort((a, b) => {
      const nombreProfesorA = limpiarTexto(profesoresMap[a.profesorId] || "").toLowerCase();
      const nombreProfesorB = limpiarTexto(profesoresMap[b.profesorId] || "").toLowerCase();
      if (nombreProfesorA !== nombreProfesorB) {
        return nombreProfesorA.localeCompare(nombreProfesorB);
      }
      const nombreMateriaA = limpiarTexto(materiasMap[a.materiaId] || "").toLowerCase();
      const nombreMateriaB = limpiarTexto(materiasMap[b.materiaId] || "").toLowerCase();
      return nombreMateriaA.localeCompare(nombreMateriaB);
    });

  return (
    <Box h="100%" overflow="hidden">
      <Heading mb={4} color="brand.500">Asignación de Profesores a Materias</Heading>

      <Box display="flex" mb={4} gap={2} flexWrap="wrap" alignItems="center">
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          minW="160px"
        >
          Asignar Profesor a Materia
        </Button>

        <Input
          placeholder="Filtrar por profesor..."
          value={filtroProfesor}
          onChange={(e) => setFiltroProfesor(e.target.value)}
          flex="1"
          minW="200px"
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />

        <Input
          placeholder="Filtrar por materia..."
          value={filtroMateria}
          onChange={(e) => setFiltroMateria(e.target.value)}
          flex="1"
          minW="200px"
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />
      </Box>

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Profesor</Th>
            <Th>Materia</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {profesoresMateriasFiltradas.map((pm) => (
            <Tr key={pm.id}>
              <Td>{profesoresMap[pm.profesorId] || pm.profesorId}</Td>
              <Td>{materiasMap[pm.materiaId] || pm.materiaId}</Td>
              <Td>
                <Button
                  size="sm"
                  mr={2}
                  bg="brand.500"
                  color="white"
                  _hover={{ bg: "brand.600" }}
                  onClick={() => setEditingProfesorMateria(pm)}
                >
                  Editar
                </Button>
                <Button
                  size="sm"
                  bg="brand.500"
                  color="white"
                  _hover={{ bg: "brand.600" }}
                  onClick={() => openConfirmModal(pm, "delete")}
                >
                  Eliminar
                </Button>
              </Td>
            </Tr>
          ))}
        </Tbody>
      </Table>

      {crearModalOpen && (
        <CrearProfesorMateriaModal
          onClose={() => {
            setCrearModalOpen(false);
            cargarProfesoresMaterias();
          }}
        />
      )}

      {editingProfesorMateria && (
        <EditProfesorMateriaModal
          profesorMateria={editingProfesorMateria}
          onClose={() => {
            setEditingProfesorMateria(null);
            cargarProfesoresMaterias();
          }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Asignación"
        message="¿Estás seguro que deseas eliminar esta asignación de profesor a materia?"
        onConfirm={handleConfirm}
      />
    </Box>
  );
}

export default ProfesoresMaterias;