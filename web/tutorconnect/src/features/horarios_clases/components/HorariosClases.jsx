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
import CrearHorarioClaseModal from "./CrearHorarioClaseModal";
import EditHorarioClaseModal from "./EditHorarioClaseModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { HorarioClaseActions } from "../actions/HorarioClaseActions";
import { HorarioClaseRepository } from "../repositories/HorarioClaseRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { AulaRepository } from "../../aulas/repositories/AulaRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";
import ReactSelect from "react-select";

const diasSemana = ["lunes", "martes", "miercoles", "jueves", "viernes"];
const diaOrden = { lunes: 1, martes: 2, miercoles: 3, jueves: 4, viernes: 5};

// Función para normalizar los días (eliminar acentos)
const normalizarDia = (dia) =>
  dia
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "");

const parseHora = (hora) => {
  const [h, m] = hora.split(":").map(Number);
  return h * 60 + m;
};

function HorariosClases() {
  const [horariosClases, setHorariosClases] = useState([]);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingHorarioClase, setEditingHorarioClase] = useState(null);
  const [selectedHorarioClase, setSelectedHorarioClase] = useState(null);
  const [action, setAction] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  const [profesoresMap, setProfesoresMap] = useState({});
  const [materiasMap, setMateriasMap] = useState({});
  const [aulasMap, setAulasMap] = useState({});

  const [filtroProfesor, setFiltroProfesor] = useState("");
  const [filtroMateria, setFiltroMateria] = useState("");
  const [filtroDia, setFiltroDia] = useState("");

  const toast = useToast();

  const cargarHorariosClases = async () => {
    const data = await HorarioClaseRepository.getAllHorariosClases();
    setHorariosClases(data);
  };

  const cargarMapas = async () => {
    const [allProfesores, allMaterias, allAulas] = await Promise.all([
      UsuarioRepository.getAllUsuarios(),
      MateriaRepository.getAllMaterias(),
      AulaRepository.getAllAulas(),
    ]);

    const pMap = {};
    allProfesores.filter(u => u.rol === Roles.DOCENTE).forEach(p => {
      pMap[p.id] = p.nombreCompleto;
    });
    setProfesoresMap(pMap);

    const mMap = {};
    allMaterias.forEach(m => { mMap[m.id] = m.nombre; });
    setMateriasMap(mMap);

    const aMap = {};
    allAulas.forEach(a => { aMap[a.id] = a.nombre; });
    setAulasMap(aMap);
  };

  useEffect(() => {
    cargarHorariosClases();
    cargarMapas();
  }, []);

  const openConfirmModal = (hc, actionType) => {
    setSelectedHorarioClase(hc);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await HorarioClaseActions.eliminarHorarioClase(selectedHorarioClase.id, toast);
      cargarHorariosClases();
    }
  };

  const horariosFiltrados = horariosClases
    .filter(hc => {
      const nombreProfesor = profesoresMap[hc.profesorId] || "";
      const nombreMateria = materiasMap[hc.materiaId] || "";
      return (
        nombreProfesor.toLowerCase().includes(filtroProfesor.toLowerCase()) &&
        nombreMateria.toLowerCase().includes(filtroMateria.toLowerCase()) &&
        hc.diaSemana.toLowerCase().includes(filtroDia.toLowerCase())
      );
    })
    .sort((a, b) => {
      const ordenA = diaOrden[normalizarDia(a.diaSemana)] || 99;
      const ordenB = diaOrden[normalizarDia(b.diaSemana)] || 99;
      if (ordenA !== ordenB) return ordenA - ordenB;

      return parseHora(a.horaInicio) - parseHora(b.horaInicio);
    });

  return (
    <Box>
      <Heading mb={4} color="brand.500">Horarios de Clases</Heading>

      <Box display="flex" mb={4} gap={2} flexWrap="wrap" alignItems="center">
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          w="160px"
          flexShrink={0}
        >
          Crear Horario
        </Button>

        <Input
          placeholder="Filtrar por docente..."
          value={filtroProfesor}
          onChange={(e) => setFiltroProfesor(e.target.value)}
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
          flex="1"
          minW="120px"
        />

        <Input
          placeholder="Filtrar por materia..."
          value={filtroMateria}
          onChange={(e) => setFiltroMateria(e.target.value)}
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
          flex="1"
          minW="120px"
        />

        <Box flex="1" minW="150px">
          <ReactSelect
            placeholder="Filtrar por día..."
            value={filtroDia ? { label: filtroDia, value: filtroDia } : null}
            onChange={(option) => setFiltroDia(option ? option.value : "")}
            options={diasSemana.map(d => ({ label: d, value: d }))}
            isClearable
          />
        </Box>
      </Box>

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Día</Th>
            <Th>Hora Inicio</Th>
            <Th>Hora Fin</Th>
            <Th>Docente</Th>
            <Th>Materia</Th>
            <Th>Aula</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {horariosFiltrados.map(hc => (
            <Tr key={hc.id}>
              <Td>{hc.diaSemana}</Td>
              <Td>{hc.horaInicio}</Td>
              <Td>{hc.horaFin}</Td>
              <Td>{profesoresMap[hc.profesorId] || hc.profesorId}</Td>
              <Td>{materiasMap[hc.materiaId] || hc.materiaId}</Td>
              <Td>{aulasMap[hc.aulaId] || hc.aulaId}</Td>
              <Td>
                <Button
                  size="sm"
                  bg="brand.500"
                  color="white"
                  _hover={{ bg: "brand.600" }}
                  mr={2}
                  onClick={() => setEditingHorarioClase(hc)}
                >
                  Editar
                </Button>
                <Button
                  size="sm"
                  bg="brand.500"
                  color="white"
                  _hover={{ bg: "brand.600" }}
                  onClick={() => openConfirmModal(hc, "delete")}
                >
                  Eliminar
                </Button>
              </Td>
            </Tr>
          ))}
        </Tbody>
      </Table>

      {crearModalOpen && (
        <CrearHorarioClaseModal
          onClose={() => {
            setCrearModalOpen(false);
            cargarHorariosClases();
          }}
        />
      )}

      {editingHorarioClase && (
        <EditHorarioClaseModal
          horarioClase={editingHorarioClase}
          onClose={() => {
            setEditingHorarioClase(null);
            cargarHorariosClases();
          }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Horario"
        message={`¿Estás seguro que deseas eliminar este horario?`}
        onConfirm={handleConfirm}
        colorScheme="brand"
      />
    </Box>
  );
}

export default HorariosClases;
