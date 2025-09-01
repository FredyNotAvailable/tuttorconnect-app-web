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
import ReactSelect from "react-select"
import CrearTutoriaEstudianteModal from "./CrearTutoriaEstudianteModal";
import EditTutoriaEstudianteModal from "./EditTutoriaEstudianteModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { TutoriaEstudianteActions } from "../actions/TutoriaEstudianteActions";
import { TutoriaEstudianteRepository } from "../repositories/TutoriaEstudianteRepository";
import { TutoriaRepository } from "../../tutorias/repositories/TutoriaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";

const limpiarTexto = (texto) =>
  texto
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-zA-Z0-9 ]/g, "");

function TutoriasEstudiantes() {
  const [tutoriasEstudiantes, setTutoriasEstudiantes] = useState([]);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingTutoriaEstudiante, setEditingTutoriaEstudiante] = useState(null);
  const [selectedTutoriaEstudiante, setSelectedTutoriaEstudiante] = useState(null);
  const [action, setAction] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  const [tutoriasMap, setTutoriasMap] = useState({});
  const [usuariosMap, setUsuariosMap] = useState({});
  const [materiasMap, setMateriasMap] = useState({});

  const [filtroTutoria, setFiltroTutoria] = useState("");
  const [filtroEstudiante, setFiltroEstudiante] = useState("");
  const [filtroProfesor, setFiltroProfesor] = useState("");
  const [filtroMateria, setFiltroMateria] = useState("");


  const toast = useToast();

  const cargarTutoriasEstudiantes = async () => {
    const data = await TutoriaEstudianteRepository.getAllTutoriasEstudiantes();
    setTutoriasEstudiantes(data);
  };

  const cargarMapas = async () => {
    const [allTutorias, allUsuarios, allMaterias] = await Promise.all([
      TutoriaRepository.getAllTutorias(),
      UsuarioRepository.getAllUsuarios(),
      MateriaRepository.getAllMaterias(),
    ]);

    // Map de tutorías
    const tMap = {};
    allTutorias.forEach((t) => (tMap[t.id] = t));
    setTutoriasMap(tMap);

    // Map de usuarios (profesores y estudiantes)
    const uMap = {};
    allUsuarios.forEach((u) => (uMap[u.id] = u.nombreCompleto));
    setUsuariosMap(uMap);

    // Map de materias
    const mMap = {};
    allMaterias.forEach((m) => (mMap[m.id] = m.nombre));
    setMateriasMap(mMap);
  };

  useEffect(() => {
    cargarTutoriasEstudiantes();
    cargarMapas();
  }, []);

  const openConfirmModal = (te, actionType) => {
    setSelectedTutoriaEstudiante(te);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await TutoriaEstudianteActions.eliminarTutoriaEstudiante(selectedTutoriaEstudiante.id, toast);
      cargarTutoriasEstudiantes();
    }
  };

  const tutoriasEstudiantesFiltradas = tutoriasEstudiantes
    .filter((te) => {
      const tutoria = tutoriasMap[te.tutoriaId];
      const estudiante = usuariosMap[te.estudianteId];
      const profesor = tutoria ? usuariosMap[tutoria.profesorId] : "";
      const materia = tutoria ? materiasMap[tutoria.materiaId] : "";

      const tutoriaInfo = tutoria ? limpiarTexto(`${tutoria.tema} ${profesor} ${materiasMap[tutoria.materiaId] || ""}`) : "";
      const estudianteNombre = estudiante ? limpiarTexto(estudiante) : "";

      return (
        (tutoria ? tutoria.tema.toLowerCase().includes(filtroTutoria.toLowerCase()) : true) &&
        (profesor ? profesor.toLowerCase().includes(filtroProfesor.toLowerCase()) : true) &&
        (materia ? materia.toLowerCase().includes(filtroMateria.toLowerCase()) : true) &&
        (estudiante ? estudiante.toLowerCase().includes(filtroEstudiante.toLowerCase()) : true)
      );
    })
    .sort((a, b) => {
      const tutoriaA = tutoriasMap[a.tutoriaId];
      const tutoriaB = tutoriasMap[b.tutoriaId];

      if (tutoriaA && tutoriaB) {
        const dateA = new Date(tutoriaA.fecha);
        const dateB = new Date(tutoriaB.fecha);
        if (dateA.getTime() !== dateB.getTime()) {
          return dateA.getTime() - dateB.getTime();
        }
        return tutoriaA.horaInicio.localeCompare(tutoriaB.horaInicio);
      }
      return 0;
    });

  return (
    <Box h="100%" overflow="hidden">
      <Heading mb={4} color="brand.500">Tutorías de Estudiantes</Heading>


      <Box display="flex" mb={4} gap={2} flexWrap="wrap" alignItems="center">
        {/* Botón para asignar tutoría */}
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          minW="160px"
        >
          Asignar Tutoría a Estudiante
        </Button>

        {/* Filtro por tema de la tutoría */}
        <Input
          placeholder="Filtrar por tema de la tutoría..."
          value={filtroTutoria}
          onChange={(e) => setFiltroTutoria(e.target.value)}
          flex="1"
          minW="200px"
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />

        {/* Filtro por profesor */}
        <ReactSelect
          options={Object.entries(usuariosMap).map(([id, nombre]) => ({ value: id, label: nombre }))}
          placeholder="Filtrar por profesor..."
          isClearable
          onChange={(option) => setFiltroProfesor(option ? option.value : "")}
          value={filtroProfesor ? { value: filtroProfesor, label: usuariosMap[filtroProfesor] } : null}
          styles={{ container: (base) => ({ ...base, flex: 1, minWidth: 200 }) }}
        />

        {/* Filtro por materia */}
        <ReactSelect
          options={Object.entries(materiasMap).map(([id, nombre]) => ({ value: id, label: nombre }))}
          placeholder="Filtrar por materia..."
          isClearable
          onChange={(option) => setFiltroMateria(option ? option.value : "")}
          value={filtroMateria ? { value: filtroMateria, label: materiasMap[filtroMateria] } : null}
          styles={{ container: (base) => ({ ...base, flex: 1, minWidth: 200 }) }}
        />

        {/* Filtro por estudiante */}
        <ReactSelect
          options={Object.entries(usuariosMap).map(([id, nombre]) => ({ value: id, label: nombre }))}
          placeholder="Filtrar por estudiante..."
          isClearable
          onChange={(option) => setFiltroEstudiante(option ? option.value : "")}
          value={filtroEstudiante ? { value: filtroEstudiante, label: usuariosMap[filtroEstudiante] } : null}
          styles={{ container: (base) => ({ ...base, flex: 1, minWidth: 200 }) }}
        />



      </Box>

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Tutoría (Tema)</Th>
            <Th>Profesor</Th>
            <Th>Materia</Th>
            <Th>Fecha</Th>
            <Th>Estudiante</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {tutoriasEstudiantesFiltradas.map((te) => {
            const tutoria = tutoriasMap[te.tutoriaId];
            const estudiante = usuariosMap[te.estudianteId];
            const profesor = tutoria ? usuariosMap[tutoria.profesorId] : "";
            const fechaFormateada = tutoria && tutoria.fecha ? new Date(tutoria.fecha).toLocaleDateString() : '';

            return (
              <Tr key={te.id}>
                <Td>{tutoria ? tutoria.tema : te.tutoriaId}</Td>
                <Td>{profesor || (tutoria ? tutoria.profesorId : "")}</Td>
                <Td>{tutoria ? (materiasMap[tutoria.materiaId] || tutoria.materiaId) : ""}</Td>
                <Td>{fechaFormateada}</Td>
                <Td>{estudiante || te.estudianteId}</Td>
                <Td>
                  <Button
                    size="sm"
                    mr={2}
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    onClick={() => setEditingTutoriaEstudiante(te)}
                  >
                    Editar
                  </Button>
                  <Button
                    size="sm"
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    onClick={() => openConfirmModal(te, "delete")}
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
        <CrearTutoriaEstudianteModal
          onClose={() => {
            setCrearModalOpen(false);
            cargarTutoriasEstudiantes();
          }}
        />
      )}

      {editingTutoriaEstudiante && (
        <EditTutoriaEstudianteModal
          tutoriaEstudiante={editingTutoriaEstudiante}
          onClose={() => {
            setEditingTutoriaEstudiante(null);
            cargarTutoriasEstudiantes();
          }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Asignación de Tutoría a Estudiante"
        message="¿Estás seguro que deseas eliminar esta asignación?"
        onConfirm={handleConfirm}
      />
    </Box>
  );
}

export default TutoriasEstudiantes;
