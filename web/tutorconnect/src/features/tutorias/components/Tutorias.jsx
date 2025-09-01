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
import CrearTutoriaModal from "./CrearTutoriaModal";
import EditTutoriaModal from "./EditTutoriaModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { TutoriaActions } from "../actions/TutoriaActions";
import { TutoriaRepository } from "../repositories/TutoriaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { AulaRepository } from "../../aulas/repositories/AulaRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";

function Tutorias() {
  const [tutorias, setTutorias] = useState([]);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingTutoria, setEditingTutoria] = useState(null);
  const [selectedTutoria, setSelectedTutoria] = useState(null);
  const [action, setAction] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  const [profesoresMap, setProfesoresMap] = useState({});
  const [materiasMap, setMateriasMap] = useState({});
  const [aulasMap, setAulasMap] = useState({});
  const [aulasOptions, setAulasOptions] = useState([]);
  const [materiaOptions, setMateriaOptions] = useState([]);

  const [filtroProfesor, setFiltroProfesor] = useState(null);
  const [filtroMateria, setFiltroMateria] = useState(null);
  const [filtroAula, setFiltroAula] = useState(null);
  const [filtroEstado, setFiltroEstado] = useState(null);
  const [filtroFecha, setFiltroFecha] = useState("");

  const toast = useToast();

  const cargarMapas = async () => {
    const [allUsuarios, allMaterias, allAulas] = await Promise.all([
      UsuarioRepository.getAllUsuarios(),
      MateriaRepository.getAllMaterias(),
      AulaRepository.getAllAulas(),
    ]);

    const pMap = {};
    allUsuarios
      .filter((u) => u.rol === Roles.Docente || u.rol === Roles.DOCENTE)
      .forEach((p) => (pMap[String(p.id)] = p.nombreCompleto));
    setProfesoresMap(pMap);

    const mMap = {};
    allMaterias.forEach((m) => (mMap[String(m.id)] = m.nombre));
    setMateriasMap(mMap);
    setMateriaOptions(allMaterias.map((m) => ({ value: String(m.id), label: m.nombre })));

    const aMap = {};
    allAulas.forEach((a) => (aMap[String(a.id)] = a.nombre));
    setAulasMap(aMap);
    setAulasOptions(allAulas.map((a) => ({ value: String(a.id), label: a.nombre })));
  };

  const cargarTutorias = async () => {
    const data = await TutoriaRepository.getAllTutorias();
    setTutorias(data);
  };

  useEffect(() => {
    const cargarDatos = async () => {
      await cargarMapas();
      await cargarTutorias();
    };
    cargarDatos();
  }, []);

  const openConfirmModal = (t, actionType) => {
    setSelectedTutoria(t);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await TutoriaActions.eliminarTutoria(selectedTutoria.id, toast);
      cargarTutorias();
    }
  };

  const estadoOptions = [
    { value: "pendiente", label: "Pendiente" },
    { value: "confirmada", label: "Confirmada" },
    { value: "cancelada", label: "Cancelada" },
    { value: "completada", label: "Completada" },
  ];

  const profesorOptions = Object.entries(profesoresMap).map(([id, nombre]) => ({
    value: id,
    label: nombre,
  }));

  const tutoriasFiltradas = tutorias
    .filter((t) => {
      const profesorIdStr = String(t.profesorId);
      const fechaTutoria = t.fecha ? new Date(t.fecha).toISOString().split("T")[0] : "";

      return (
        (!filtroProfesor || profesorIdStr === filtroProfesor.value) &&
        (!filtroMateria || String(t.materiaId) === filtroMateria.value) &&
        (!filtroAula || String(t.aulaId) === filtroAula.value) &&
        (!filtroEstado || t.estado === filtroEstado.value) &&
        (!filtroFecha || fechaTutoria === filtroFecha)
      );
    })
    .sort((a, b) => {
      const dateA = new Date(a.fecha);
      const dateB = new Date(b.fecha);
      if (dateA.getTime() !== dateB.getTime()) return dateA.getTime() - dateB.getTime();
      return a.horaInicio.localeCompare(b.horaInicio);
    });

  return (
    <Box h="100%" overflow="hidden">
      <Heading mb={4} color="brand.500">Tutorías</Heading>

      <Box display="flex" mb={4} gap={2} flexWrap="wrap" alignItems="center">
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          minW="160px"
        >
          Crear Tutoría
        </Button>

        <Box flex="1" minW="200px">
          <ReactSelect
            placeholder="Filtrar por profesor..."
            value={filtroProfesor}
            onChange={(option) => setFiltroProfesor(option)}
            options={profesorOptions}
            isClearable
          />
        </Box>

        <Box flex="1" minW="150px">
          <ReactSelect
            placeholder="Filtrar por materia..."
            value={filtroMateria}
            onChange={(option) => setFiltroMateria(option)}
            options={materiaOptions}
            isClearable
          />
        </Box>

        <Box flex="1" minW="150px">
          <ReactSelect
            placeholder="Filtrar por aula..."
            value={filtroAula}
            onChange={(option) => setFiltroAula(option)}
            options={aulasOptions}
            isClearable
          />
        </Box>

        <Box flex="1" minW="150px">
          <ReactSelect
            placeholder="Filtrar por estado..."
            value={filtroEstado}
            onChange={(option) => setFiltroEstado(option)}
            options={estadoOptions}
            isClearable
          />
        </Box>

        <Box flex="1" minW="200px">
          <Input
            type="date"
            placeholder="Filtrar por fecha..."
            value={filtroFecha}
            onChange={(e) => setFiltroFecha(e.target.value)}
          />
        </Box>
      </Box>

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Profesor</Th>
            <Th>Materia</Th>
            <Th>Aula</Th>
            <Th>Fecha</Th>
            <Th>Estado</Th>
            <Th>Tema</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {tutoriasFiltradas.map((t) => {
            const fechaFormateada = t.fecha ? new Date(t.fecha).toLocaleDateString() : '';
                console.log("Tutoría:", t.id, "profesorId:", t.profesorId);
                console.log("profesoresMap:", profesoresMap);
            return (
              <Tr key={t.id}>
                <Td>{profesoresMap[String(t.profesorId)] || "Sin profesor"}</Td>
                <Td>{materiasMap[String(t.materiaId)] || "Sin materia"}</Td>
                <Td>{aulasMap[String(t.aulaId)] || "Sin aula"}</Td>
                <Td>{fechaFormateada} | {t.horaInicio} - {t.horaFin}</Td>
                <Td>{t.estado}</Td>
                <Td>{t.tema}</Td>
                <Td>
                  <Button
                    size="sm"
                    mr={2}
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    onClick={() => setEditingTutoria(t)}
                  >
                    Editar
                  </Button>
                  <Button
                    size="sm"
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    onClick={() => openConfirmModal(t, "delete")}
                  >
                    Eliminar
                  </Button>
                </Td>
              </Tr>
            );
          })}
        </Tbody>
      </Table>

      {crearModalOpen && (
        <CrearTutoriaModal
          onClose={() => {
            setCrearModalOpen(false);
            cargarTutorias();
          }}
        />
      )}

      {editingTutoria && (
        <EditTutoriaModal
          tutoria={editingTutoria}
          onClose={() => {
            setEditingTutoria(null);
            cargarTutorias();
          }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Tutoría"
        message="¿Estás seguro que deseas eliminar esta tutoría?"
        onConfirm={handleConfirm}
      />
    </Box>
  );
}

export default Tutorias;
