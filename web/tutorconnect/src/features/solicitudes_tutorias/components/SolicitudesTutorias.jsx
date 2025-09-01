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
import CrearSolicitudTutoriaModal from "./CrearSolicitudTutoriaModal";
import EditSolicitudTutoriaModal from "./EditSolicitudTutoriaModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { SolicitudTutoriaActions } from "../actions/SolicitudTutoriaActions";
import { SolicitudTutoriaRepository } from "../repositories/SolicitudTutoriaRepository";
import { TutoriaRepository } from "../../tutorias/repositories/TutoriaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";
import { SolicitudTutoriaEstado } from "../models/SolicitudTutoria";



function SolicitudesTutorias() {
  const [solicitudesTutorias, setSolicitudesTutorias] = useState([]);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingSolicitudTutoria, setEditingSolicitudTutoria] = useState(null);
  const [selectedSolicitudTutoria, setSelectedSolicitudTutoria] = useState(null);
  const [action, setAction] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  const [tutoriasMap, setTutoriasMap] = useState({});
  const [estudiantesMap, setEstudiantesMap] = useState({});
  const [profesoresMap, setProfesoresMap] = useState({});

  const [filtroProfesor, setFiltroProfesor] = useState(null);
  const [filtroEstudiante, setFiltroEstudiante] = useState(null);
  const [filtroEstado, setFiltroEstado] = useState(null);
  const [filtroFechaEnvio, setFiltroFechaEnvio] = useState("");
  const [filtroFechaRespuesta, setFiltroFechaRespuesta] = useState("");

  const toast = useToast();

  const cargarSolicitudesTutorias = async () => {
    const data = await SolicitudTutoriaRepository.getAllSolicitudesTutorias();
    setSolicitudesTutorias(data);
  };

  const cargarMapas = async () => {
    const [allTutorias, allUsuarios] = await Promise.all([
      TutoriaRepository.getAllTutorias(),
      UsuarioRepository.getAllUsuarios(),
    ]);

    const tMap = {};
    allTutorias.forEach((t) => (tMap[t.id] = t));
    setTutoriasMap(tMap);

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
    cargarSolicitudesTutorias();
    cargarMapas();
  }, []);

  const openConfirmModal = (st, actionType) => {
    setSelectedSolicitudTutoria(st);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await SolicitudTutoriaActions.eliminarSolicitudTutoria(selectedSolicitudTutoria.id, toast);
      cargarSolicitudesTutorias();
    }
  };

  // Filtros
  const solicitudesTutoriasFiltradas = solicitudesTutorias
    .filter((st) => {
      const tutoria = tutoriasMap[st.tutoriaId];
      const estudiante = estudiantesMap[st.estudianteId];
      const profesor = tutoria ? profesoresMap[tutoria.profesorId] : "";

      const estadoSolicitud = st.estado || "";

      // Convertir a string YYYY-MM-DD si existe
      const fechaEnvioVal = st.fechaEnvio ? new Date(st.fechaEnvio).toISOString().split("T")[0] : "";
      const fechaRespuestaVal = st.fechaRespuesta ? new Date(st.fechaRespuesta).toISOString().split("T")[0] : "";

      return (
        (!filtroProfesor || (profesor && profesor === filtroProfesor.value)) &&
        (!filtroEstudiante || (estudiante && estudiante === filtroEstudiante.value)) &&
        (!filtroEstado || estadoSolicitud === filtroEstado.value) &&
        (!filtroFechaEnvio || fechaEnvioVal === filtroFechaEnvio) &&
        (!filtroFechaRespuesta || fechaRespuestaVal === filtroFechaRespuesta)
      );
    })
    .sort((a, b) => {
      const dateA = a.fechaEnvio ? new Date(a.fechaEnvio).getTime() : 0;
      const dateB = b.fechaEnvio ? new Date(b.fechaEnvio).getTime() : 0;
      return dateA - dateB;
    });


  // Opciones para React Select
  const profesorOptions = Object.entries(profesoresMap).map(([id, nombre]) => ({ value: nombre, label: nombre }));
  const estudianteOptions = Object.entries(estudiantesMap).map(([id, nombre]) => ({ value: nombre, label: nombre }));
  const estadoOptions = Object.values(SolicitudTutoriaEstado).map((estado) => ({
    value: estado,
    label: estado,
  }));


  return (
    <Box h="100%" overflow="hidden">
      <Heading mb={4} color="brand.500">Solicitudes de Tutorías</Heading>

      <Box display="flex" mb={4} gap={2} flexWrap="wrap" alignItems="center">
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          minW="160px"
        >
          Crear Solicitud de Tutoría
        </Button>

        <ReactSelect
          placeholder="Filtrar por profesor..."
          value={filtroProfesor}
          onChange={setFiltroProfesor}
          options={profesorOptions}
          isClearable
          styles={{ container: (base) => ({ ...base, minWidth: 200, flex: 1 }) }}
        />

        <ReactSelect
          placeholder="Filtrar por estudiante..."
          value={filtroEstudiante}
          onChange={setFiltroEstudiante}
          options={estudianteOptions}
          isClearable
          styles={{ container: (base) => ({ ...base, minWidth: 200, flex: 1 }) }}
        />

        <Input
          type="date"
          placeholder="Filtrar por fecha envío..."
          value={filtroFechaEnvio}
          onChange={(e) => setFiltroFechaEnvio(e.target.value)}
          flex="1"
          minW="150px"
        />

        <Input
          type="date"
          placeholder="Filtrar por fecha respuesta..."
          value={filtroFechaRespuesta}
          onChange={(e) => setFiltroFechaRespuesta(e.target.value)}
          flex="1"
          minW="150px"
        />

        <ReactSelect
          placeholder="Filtrar por estado..."
          value={filtroEstado}
          onChange={setFiltroEstado}
          options={estadoOptions}
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
            <Th>Fecha Envío</Th>
            <Th>Fecha Respuesta</Th>
            <Th>Estado</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {solicitudesTutoriasFiltradas.map((st) => {
            const tutoria = tutoriasMap[st.tutoriaId];
            const estudiante = estudiantesMap[st.estudianteId];
            const profesor = tutoria ? profesoresMap[tutoria.profesorId] : "";
            const fechaEnvioFormateada = st.fechaEnvio ? new Date(st.fechaEnvio).toLocaleDateString() : '';
            const fechaRespuestaFormateada = st.fechaRespuesta ? new Date(st.fechaRespuesta).toLocaleDateString() : '';

            return (
              <Tr key={st.id}>
                <Td>{tutoria ? tutoria.tema : st.tutoriaId}</Td>
                <Td>{profesor || ""}</Td>
                <Td>{estudiante || st.estudianteId}</Td>
                <Td>{fechaEnvioFormateada}</Td>
                <Td>{fechaRespuestaFormateada}</Td>
                <Td>{st.estado}</Td>
                <Td>
                  <Button
                    size="sm"
                    mr={2}
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    onClick={() => setEditingSolicitudTutoria(st)}
                  >
                    Editar
                  </Button>
                  <Button
                    size="sm"
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    onClick={() => openConfirmModal(st, "delete")}
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
        <CrearSolicitudTutoriaModal
          onClose={() => {
            setCrearModalOpen(false);
            cargarSolicitudesTutorias();
          }}
        />
      )}

      {editingSolicitudTutoria && (
        <EditSolicitudTutoriaModal
          solicitudTutoria={editingSolicitudTutoria}
          onClose={() => {
            setEditingSolicitudTutoria(null);
            cargarSolicitudesTutorias();
          }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Solicitud de Tutoría"
        message="¿Estás seguro que deseas eliminar esta solicitud de tutoría?"
        onConfirm={handleConfirm}
      />
    </Box>
  );
}

export default SolicitudesTutorias;
