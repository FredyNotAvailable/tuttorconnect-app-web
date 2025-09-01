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
import CrearMatriculaModal from "./CrearMatriculaModal";
import EditMatriculaModal from "./EditMatriculaModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { MatriculaActions } from "../actions/MatriculaActions";
import { MatriculaRepository } from "../repositories/MatriculaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { MallaCurricularRepository } from "../../mallas_curricualares/repositories/MallaCurricularRepository";
import { CarreraRepository } from "../../carreras/repositories/CarreraRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";

const ciclos = Array.from({ length: 10 }, (_, i) => i + 1);

const limpiarTexto = (texto) =>
  texto
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-zA-Z0-9 ]/g, "");

function Matriculas() {
  const [matriculas, setMatriculas] = useState([]);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingMatricula, setEditingMatricula] = useState(null);
  const [selectedMatricula, setSelectedMatricula] = useState(null);
  const [action, setAction] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);

  const [estudiantesMap, setEstudiantesMap] = useState({});
  const [mallasMap, setMallasMap] = useState({});
  const [carrerasMap, setCarrerasMap] = useState({});

  const [filtroEstudiante, setFiltroEstudiante] = useState("");
  const [filtroMalla, setFiltroMalla] = useState("");
  const [filtroCiclo, setFiltroCiclo] = useState("");

  const toast = useToast();

  const cargarMatriculas = async () => {
    const data = await MatriculaRepository.getAllMatriculas();
    setMatriculas(data);
  };

  const cargarMapas = async () => {
    const [allUsuarios, allMallas, allCarreras] = await Promise.all([
      UsuarioRepository.getAllUsuarios(),
      MallaCurricularRepository.getAllMallas(),
      CarreraRepository.getAllCarreras(),
    ]);

    const eMap = {};
    allUsuarios
      .filter((u) => u.rol === Roles.ESTUDIANTE)
      .forEach((e) => (eMap[e.id] = e.nombreCompleto));
    setEstudiantesMap(eMap);

    const cMap = {};
    allCarreras.forEach((c) => (cMap[c.id] = c.nombre));
    setCarrerasMap(cMap);

    const mMap = {};
    allMallas.forEach((m) => {
      const nombreCarrera = cMap[m.carreraId] || m.carreraId;
      mMap[m.id] = {
        nombre: `${nombreCarrera} - Ciclo ${m.ciclo}`,
        ciclo: m.ciclo,
        carreraId: m.carreraId,
        anio: m.anio,
      };
    });
    setMallasMap(mMap);
  };

  useEffect(() => {
    cargarMatriculas();
    cargarMapas();
  }, []);

  const openConfirmModal = (m, actionType) => {
    setSelectedMatricula(m);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await MatriculaActions.eliminarMatricula(selectedMatricula.id, toast);
      cargarMatriculas();
    }
  };

  const matriculasFiltradas = matriculas
    .filter((m) => {
      const nombreEstudiante = limpiarTexto(estudiantesMap[m.estudianteId] || "");
      const malla = mallasMap[m.mallaId];
      const nombreMalla = malla ? limpiarTexto(malla.nombre) : "";
      const cicloMalla = malla ? malla.ciclo : "";

      return (
        nombreEstudiante.toLowerCase().includes(limpiarTexto(filtroEstudiante).toLowerCase()) &&
        nombreMalla.toLowerCase().includes(limpiarTexto(filtroMalla).toLowerCase()) &&
        (filtroCiclo === "" || cicloMalla.toString() === filtroCiclo)
      );
    })
    .sort((a, b) => {
      const nombreEstudianteA = limpiarTexto(estudiantesMap[a.estudianteId] || "").toLowerCase();
      const nombreEstudianteB = limpiarTexto(estudiantesMap[b.estudianteId] || "").toLowerCase();
      if (nombreEstudianteA !== nombreEstudianteB) {
        return nombreEstudianteA.localeCompare(nombreEstudianteB);
      }
      const mallaA = mallasMap[a.mallaId]?.nombre || "";
      const mallaB = mallasMap[b.mallaId]?.nombre || "";
      return limpiarTexto(mallaA).localeCompare(limpiarTexto(mallaB));
    });

  return (
    <Box h="100%" overflow="hidden">
      <Heading mb={4} color="brand.500">Matrículas</Heading>

      <Box display="flex" mb={4} gap={2} flexWrap="wrap" alignItems="center">
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          minW="160px"
        >
          Crear Matrícula
        </Button>

        <Input
          placeholder="Filtrar por estudiante..."
          value={filtroEstudiante}
          onChange={(e) => setFiltroEstudiante(e.target.value)}
          flex="1"
          minW="200px"
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />

        <Input
          placeholder="Filtrar por malla..."
          value={filtroMalla}
          onChange={(e) => setFiltroMalla(e.target.value)}
          flex="1"
          minW="200px"
          bg="white"
          borderColor="transparent"
          _hover={{ borderColor: "gray.200" }}
          focusBorderColor="brand.500"
        />

        <Box flex="1" minW="150px">
          <ReactSelect
            placeholder="Filtrar por ciclo..."
            value={filtroCiclo ? { label: filtroCiclo, value: filtroCiclo } : null}
            onChange={(option) => setFiltroCiclo(option ? option.value : "")}
            options={ciclos.map((c) => ({ label: c, value: c }))}
            isClearable
          />
        </Box>
      </Box>

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Estudiante</Th>
            <Th>Carrera</Th>
            <Th>Ciclo</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {matriculasFiltradas.map((m) => {
            const malla = mallasMap[m.mallaId];
            const carreraNombre = malla ? mallasMap[m.mallaId].nombre.split(" - ")[0] : "-";
            const ciclo = malla ? malla.ciclo : "-";
            return (
              <Tr key={m.id}>
                <Td>{estudiantesMap[m.estudianteId] || m.estudianteId}</Td>
                <Td>{carreraNombre}</Td>
                <Td>{ciclo}</Td>
                <Td>
                  <Button
                    size="sm"
                    mr={2}
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    onClick={() => setEditingMatricula(m)}
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
            );
          })}
        </Tbody>
      </Table>

      {crearModalOpen && (
        <CrearMatriculaModal
          onClose={() => {
            setCrearModalOpen(false);
            cargarMatriculas();
          }}
        />
      )}

      {editingMatricula && (
        <EditMatriculaModal
          matricula={editingMatricula}
          onClose={() => {
            setEditingMatricula(null);
            cargarMatriculas();
          }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Matrícula"
        message="¿Estás seguro que deseas eliminar esta matrícula?"
        onConfirm={handleConfirm}
      />
    </Box>
  );
}

export default Matriculas;
