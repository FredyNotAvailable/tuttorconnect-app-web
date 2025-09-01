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
import CrearAsistenciaTutoriaModal from "./CrearAsistenciaTutoriaModal";
import EditAsistenciaTutoriaModal from "./EditAsistenciaTutoriaModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { AsistenciaTutoriaActions } from "../actions/AsistenciaTutoriaActions";
import { AsistenciaTutoriaRepository } from "../repositories/AsistenciaTutoriaRepository";
import { TutoriaRepository } from "../../tutorias/repositories/TutoriaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";

const limpiarTexto = (texto) =>
  texto
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-zA-Z0-9 ]/g, "");

function AsistenciaTutorias() {
  const [asistenciaTutorias, setAsistenciaTutorias] = useState([]);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingAsistenciaTutoria, setEditingAsistenciaTutoria] = useState(null);
  const [selectedAsistenciaTutoria, setSelectedAsistenciaTutoria] = useState(null);
  const [action, setAction] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  const [tutoriasMap, setTutoriasMap] = useState({});
  const [profesoresMap, setProfesoresMap] = useState({});
  const [estudiantesMap, setEstudiantesMap] = useState({});

  const [filtroProfesor, setFiltroProfesor] = useState(null);
  const [filtroEstudiante, setFiltroEstudiante] = useState(null);
  const [filtroEstado, setFiltroEstado] = useState(null);
  const [filtroFecha, setFiltroFecha] = useState("");

  const toast = useToast();

  const cargarAsistenciaTutorias = async () => {
    const data = await AsistenciaTutoriaRepository.getAllAsistenciaTutorias();
    setAsistenciaTutorias(data);
  };

  const cargarMapas = async () => {
    const [allTutorias, allUsuarios] = await Promise.all([
      TutoriaRepository.getAllTutorias(),
      UsuarioRepository.getAllUsuarios(),
    ]);

    // Map de tutorias
    const tMap = {};
    allTutorias.forEach((t) => (tMap[t.id] = t));
    setTutoriasMap(tMap);

    // Map de estudiantes y profesores
    const eMap = {};
    const pMap = {};
    allUsuarios.forEach((u) => {
      if (u.rol === Roles.ESTUDIANTE) eMap[u.id] = u.nombreCompleto;
      if (u.rol === Roles.DOCENTE) pMap[u.id] = u.nombreCompleto;
    });
    setEstudiantesMap(eMap);
    setProfesoresMap(pMap);
  };

  useEffect(() => {
    cargarAsistenciaTutorias();
    cargarMapas();
  }, []);

  const openConfirmModal = (at, actionType) => {
    setSelectedAsistenciaTutoria(at);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await AsistenciaTutoriaActions.eliminarAsistenciaTutoria(selectedAsistenciaTutoria.id, toast);
      cargarAsistenciaTutorias();
    }
  };

  const asistenciaTutoriasFiltradas = asistenciaTutorias
    .filter((at) => {
      const tutoria = tutoriasMap[at.tutoriaId];
      const profesorNombre = tutoria ? profesoresMap[tutoria.profesorId] : "";
      const estudianteNombre = estudiantesMap[at.estudianteId] || "";
      const estado = at.estado?.toLowerCase() || "";

      const cumpleProfesor = !filtroProfesor || (profesorNombre && profesorNombre === filtroProfesor.label);
      const cumpleEstudiante = !filtroEstudiante || (estudianteNombre && estudianteNombre === filtroEstudiante.label);
      const cumpleEstado = !filtroEstado || estado === filtroEstado.value.toLowerCase();
      const cumpleFecha = !filtroFecha || (at.fecha?.split("T")[0] === filtroFecha);

      return cumpleProfesor && cumpleEstudiante && cumpleEstado && cumpleFecha;
    })
    .sort((a, b) => new Date(a.fecha).getTime() - new Date(b.fecha).getTime());

  // Opciones para ReactSelect
  const opcionesProfesores = Object.entries(profesoresMap).map(([id, nombre]) => ({ value: id, label: nombre }));
  const opcionesEstudiantes = Object.entries(estudiantesMap).map(([id, nombre]) => ({ value: id, label: nombre }));
  const opcionesEstado = [
    { value: "presente", label: "Presente" },
    { value: "ausente", label: "Ausente" },
  ];

  return (
    <Box h="100%" overflow="hidden">
      <Heading mb={4} color="brand.500">Asistencia a Tutorías</Heading>

      <Box display="flex" mb={4} gap={2} flexWrap="wrap" alignItems="center">
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          minW="160px"
        >
          Registrar Asistencia
        </Button>

        <ReactSelect
          options={opcionesProfesores}
          placeholder="Filtrar por profesor..."
          value={filtroProfesor}
          onChange={setFiltroProfesor}
          isClearable
          styles={{ container: (base) => ({ ...base, minWidth: 200, flex: 1 }) }}
        />

        <ReactSelect
          options={opcionesEstudiantes}
          placeholder="Filtrar por estudiante..."
          value={filtroEstudiante}
          onChange={setFiltroEstudiante}
          isClearable
          styles={{ container: (base) => ({ ...base, minWidth: 200, flex: 1 }) }}
        />

        <Input
          type="date"
          placeholder="Filtrar por fecha..."
          value={filtroFecha}
          onChange={(e) => setFiltroFecha(e.target.value)}
          flex="1"
          minW="150px"
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />

        <ReactSelect
          options={opcionesEstado}
          placeholder="Filtrar por estado..."
          value={filtroEstado}
          onChange={setFiltroEstado}
          isClearable
          styles={{ container: (base) => ({ ...base, minWidth: 150, flex: 1 }) }}
        />
      </Box>

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Tutoría (Tema)</Th>
            <Th>Profesor</Th>
            <Th>Estudiante</Th>
            <Th>Fecha</Th>
            <Th>Estado</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {asistenciaTutoriasFiltradas.map((at) => {
            const tutoria = tutoriasMap[at.tutoriaId];
            const profesorNombre = tutoria ? profesoresMap[tutoria.profesorId] : "";
            const estudianteNombre = estudiantesMap[at.estudianteId] || "";
            const fechaFormateada = at.fecha ? new Date(at.fecha).toLocaleDateString() : "";

            return (
              <Tr key={at.id}>
                <Td>{tutoria ? tutoria.tema : at.tutoriaId}</Td>
                <Td>{profesorNombre}</Td>
                <Td>{estudianteNombre}</Td>
                <Td>{fechaFormateada}</Td>
                <Td>{at.estado}</Td>
                <Td>
                  <Button
                    size="sm"
                    mr={2}
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    onClick={() => setEditingAsistenciaTutoria(at)}
                  >
                    Editar
                  </Button>
                  <Button
                    size="sm"
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    onClick={() => openConfirmModal(at, "delete")}
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
        <CrearAsistenciaTutoriaModal
          onClose={() => {
            setCrearModalOpen(false);
            cargarAsistenciaTutorias();
          }}
        />
      )}

      {editingAsistenciaTutoria && (
        <EditAsistenciaTutoriaModal
          asistenciaTutoria={editingAsistenciaTutoria}
          onClose={() => {
            setEditingAsistenciaTutoria(null);
            cargarAsistenciaTutorias();
          }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Registro de Asistencia"
        message="¿Estás seguro que deseas eliminar este registro de asistencia?"
        onConfirm={handleConfirm}
      />
    </Box>
  );
}

export default AsistenciaTutorias;
