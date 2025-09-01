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
import CrearMateriaMallaModal from "./CrearMateriaMallaModal";
import EditMateriaMallaModal from "./EditMateriaMallaModal";
import ConfirmModal from "../../common/components/ConfirmModal";
import { MateriaMallaActions } from "../actions/MateriaMallaActions";
import { MateriaMallaRepository } from "../repositories/MateriaMallaRepository";
import { MallaCurricularRepository } from "../../mallas_curricualares/repositories/MallaCurricularRepository";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { CarreraRepository } from "../../carreras/repositories/CarreraRepository";

function MateriasMalla() {
  const [materiasMalla, setMateriasMalla] = useState([]);
  const [crearModalOpen, setCrearModalOpen] = useState(false);
  const [editingMateriaMalla, setEditingMateriaMalla] = useState(null);
  const [selectedMateriaMalla, setSelectedMateriaMalla] = useState(null);
  const [action, setAction] = useState(""); // "delete"
  const [isModalOpen, setIsModalOpen] = useState(false);

  const [mallasMap, setMallasMap] = useState({});
  const [materiasMap, setMateriasMap] = useState({});

  // filtros
  const [filtroCarrera, setFiltroCarrera] = useState("");
  const [filtroCiclo, setFiltroCiclo] = useState("");
  const [filtroAnio, setFiltroAnio] = useState("");
  const [filtroMateria, setFiltroMateria] = useState("");

  const toast = useToast();

  const cargarMateriasMalla = async () => {
    const data = await MateriaMallaRepository.getAllMateriasMalla();
    setMateriasMalla(data);
  };

  const cargarMallas = async () => {
    const allMallas = await MallaCurricularRepository.getAllMallas();
    const allCarreras = await CarreraRepository.getAllCarreras();

    const carrerasMap = {};
    allCarreras.forEach((c) => {
      carrerasMap[c.id] = c.nombre;
    });

    const map = {};
    allMallas.forEach((m) => {
      map[m.id] = {
        carrera: carrerasMap[m.carreraId] || m.carreraId,
        ciclo: m.ciclo.toString(),
        anio: m.anio.toString(),
      };
    });
    setMallasMap(map);
  };

  const cargarMaterias = async () => {
    const allMaterias = await MateriaRepository.getAllMaterias();
    const map = {};
    allMaterias.forEach((m) => {
      map[m.id] = m.nombre;
    });
    setMateriasMap(map);
  };

  useEffect(() => {
    cargarMateriasMalla();
    cargarMallas();
    cargarMaterias();
  }, []);

  const openConfirmModal = (mm, actionType) => {
    setSelectedMateriaMalla(mm);
    setAction(actionType);
    setIsModalOpen(true);
  };

  const handleConfirm = async () => {
    if (action === "delete") {
      await MateriaMallaActions.eliminarMateriaMalla(selectedMateriaMalla.id, toast);
      cargarMateriasMalla();
    }
  };

  const materiasMallaFiltradas = materiasMalla
    .filter((mm) => {
      const malla = mallasMap[mm.mallaId] || {};
      const nombreMateria = materiasMap[mm.materiaId] || "";

      return (
        (malla.carrera || "").toLowerCase().includes(filtroCarrera.toLowerCase()) &&
        (malla.ciclo || "").toLowerCase().includes(filtroCiclo.toLowerCase()) &&
        (malla.anio || "").toLowerCase().includes(filtroAnio.toLowerCase()) &&
        nombreMateria.toLowerCase().includes(filtroMateria.toLowerCase())
      );
    })
    .sort((a, b) => {
      const carreraA = (mallasMap[a.mallaId]?.carrera || "").toLowerCase();
      const carreraB = (mallasMap[b.mallaId]?.carrera || "").toLowerCase();
      if (carreraA < carreraB) return -1;
      if (carreraA > carreraB) return 1;
      return 0;
    });

  return (
    <Box h="100%" overflow="hidden">
      <Heading mb={4} color="brand.500">
        Agregar materias a la malla
      </Heading>

      <Box display="flex" mb={4} gap={2} flexWrap="wrap">
        <Button
          bg="brand.500"
          color="white"
          _hover={{ bg: "brand.600" }}
          onClick={() => setCrearModalOpen(true)}
          minW="160px"
          flexShrink={0}
        >
          Agregar Materia
        </Button>

        <Input
          flex="1"
          minW="180px"
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
          minW="140px"
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
          minW="140px"
          placeholder="Filtrar por año..."
          value={filtroAnio}
          onChange={(e) => setFiltroAnio(e.target.value)}
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

      <Table variant="simple">
        <Thead>
          <Tr>
            <Th>Carrera</Th>
            <Th>Ciclo</Th>
            <Th>Año</Th>
            <Th>Materia</Th>
            <Th>Acciones</Th>
          </Tr>
        </Thead>
        <Tbody>
          {materiasMallaFiltradas.map((mm) => {
            const malla = mallasMap[mm.mallaId] || {};
            return (
              <Tr key={mm.id}>
                <Td>{malla.carrera || mm.mallaId}</Td>
                <Td>{malla.ciclo || ""}</Td>
                <Td>{malla.anio || ""}</Td>
                <Td>{materiasMap[mm.materiaId] || mm.materiaId}</Td>
                <Td>
                  <Button
                    size="sm"
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    mr={2}
                    onClick={() => setEditingMateriaMalla(mm)}
                  >
                    Editar
                  </Button>
                  <Button
                    size="sm"
                    bg="brand.500"
                    color="white"
                    _hover={{ bg: "brand.600" }}
                    onClick={() => openConfirmModal(mm, "delete")}
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
        <CrearMateriaMallaModal
          onClose={() => {
            setCrearModalOpen(false);
            cargarMateriasMalla();
          }}
        />
      )}

      {editingMateriaMalla && (
        <EditMateriaMallaModal
          materiaMalla={editingMateriaMalla}
          onClose={() => {
            setEditingMateriaMalla(null);
            cargarMateriasMalla();
          }}
        />
      )}

      <ConfirmModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title="Eliminar Materia de Malla"
        message={`¿Estás seguro que deseas eliminar esta materia de la malla?`}
        onConfirm={handleConfirm}
        colorScheme="brand"
      />
    </Box>
  );
}

export default MateriasMalla;
