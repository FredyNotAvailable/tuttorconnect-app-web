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
import CrearProfesorMateriaModal from "./CrearProfesorMateriaModal";
import EditProfesorMateriaModal from "./EditProfesorMateriaModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { ProfesorMateriaActions } from "../actions/ProfesorMateriaActions";
import { ProfesorMateriaRepository } from "../repositories/ProfesorMateriaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";

function ProfesoresMaterias() {
  const [profesoresMaterias, setProfesoresMaterias] = useState([]);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingProfesorMateria, setEditingProfesorMateria] = useState(null);
  const [selectedProfesorMateria, setSelectedProfesorMateria] = useState(null);
  const [action, setAction] = useState(""); // "delete"
  const [isModalOpen, setIsModalOpen] = useState(false);

  const [profesoresMap, setProfesoresMap] = useState({});
  const [materiasMap, setMateriasMap] = useState({});

  // filtros
  const [filtroProfesor, setFiltroProfesor] = useState("");
  const [filtroMateria, setFiltroMateria] = useState("");

  const toast = useToast();

  /** Cargar asignaciones */
  const cargarProfesoresMaterias = async () => {
    const data = await ProfesorMateriaRepository.getAllProfesoresMaterias();
    setProfesoresMaterias(data);
  };

  /** Cargar docentes */
  const cargarProfesores = async () => {
    const allUsuarios = await UsuarioRepository.getAllUsuarios();
    const map = {};
    allUsuarios
      .filter((u) => u.rol === Roles.Docente || u.rol === "Docente")
      .forEach((p) => {
        map[p.id] = p.nombreCompleto;
      });
    setProfesoresMap(map);
  };

  /** Cargar materias */
  const cargarMaterias = async () => {
    const allMaterias = await MateriaRepository.getAllMaterias();
    const map = {};
    allMaterias.forEach((m) => {
      map[m.id] = m.nombre;
    });
    setMateriasMap(map);
  };

  useEffect(() => {
    cargarProfesoresMaterias();
    cargarProfesores();
    cargarMaterias();
  }, []);

  /** Modal de confirmación */
  const openConfirmModal = (pm, actionType) => {
    setSelectedProfesorMateria(pm);
    setAction(actionType);
    setIsModalOpen(true);
  };

  /** Confirmar acción */
  const handleConfirm = async () => {
    if (action === "delete") {
      await ProfesorMateriaActions.eliminarProfesorMateria(
        selectedProfesorMateria.id,
        toast
      );
      cargarProfesoresMaterias();
    }
  };

  /** Filtrar asignaciones */
  const profesoresMateriasFiltradas = profesoresMaterias
    .filter((pm) => {
      const nombreProfesor = profesoresMap[pm.profesorId] || "";
      const nombreMateria = materiasMap[pm.materiaId] || "";

      return (
        nombreProfesor.toLowerCase().includes(filtroProfesor.toLowerCase()) &&
        nombreMateria.toLowerCase().includes(filtroMateria.toLowerCase())
      );
    })
    .sort((a, b) => {
      const nombreA = (profesoresMap[a.profesorId] || "").toLowerCase();
      const nombreB = (profesoresMap[b.profesorId] || "").toLowerCase();
      if (nombreA < nombreB) return -1;
      if (nombreA > nombreB) return 1;
      return 0;
    });

  return (
    <Box h="100%" overflow="hidden">
      <Heading mb={4} color="brand.500">
        Asignación de materias a Docentes
      </Heading>

      {/* Barra de acciones y filtros */}
      <Box display="flex" mb={4} gap={2} flexWrap="wrap">
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          minW="160px"
          flexShrink={0}
        >
          Asignar Docente
        </Button>

        <Input
          flex="1"
          minW="180px"
          placeholder="Filtrar por docente..."
          value={filtroProfesor}
          onChange={(e) => setFiltroProfesor(e.target.value)}
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />

        <Input
          flex="1"
          minW="200px"
          placeholder="Filtrar por materia..."
          value={filtroMateria}
          onChange={(e) => setFiltroMateria(e.target.value)}
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />
      </Box>

      {/* Tabla */}
      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Docente</Th>
            <Th>Materia</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {profesoresMateriasFiltradas.map((pm) => {
            const nombreProfesor =
              profesoresMap[pm.profesorId] || "Docente no encontrado";
            const nombreMateria =
              materiasMap[pm.materiaId] || "Materia no encontrada";

            return (
              <Tr key={pm.id}>
                <Td>{nombreProfesor}</Td>
                <Td>{nombreMateria}</Td>
                <Td>
                  <Button
                    size="sm"
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    mr={2}
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
            );
          })}
        </Tbody>
      </Table>

      {/* Modales */}
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
        message="¿Estás seguro que deseas eliminar esta asignación?"
        onConfirm={handleConfirm}
        colorScheme="brand"
      />
    </Box>
  );
}

export default ProfesoresMaterias;
