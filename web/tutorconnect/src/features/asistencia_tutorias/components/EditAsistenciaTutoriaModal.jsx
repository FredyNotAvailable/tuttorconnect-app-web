import { useState, useEffect } from "react";
import {
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalCloseButton,
  ModalBody,
  ModalFooter,
  Button,
  FormControl,
  FormLabel,
  Input,
  Box,
  useToast,
} from "@chakra-ui/react";
import Select from "react-select";
import { AsistenciaTutoriaActions } from "../actions/AsistenciaTutoriaActions";
import { TutoriaRepository } from "../../tutorias/repositories/TutoriaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { ProfesorMateriaRepository } from "../../profesores_materias/repositories/ProfesorMateriaRepository";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { AulaRepository } from "../../aulas/repositories/AulaRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";

export default function EditAsistenciaTutoriaModal({ asistenciaTutoria, onClose }) {
  const [tutoriaId, setTutoriaId] = useState(asistenciaTutoria.tutoriaId || "");
  const [estudianteId, setEstudianteId] = useState(asistenciaTutoria.estudianteId || "");
  const [fecha, setFecha] = useState(asistenciaTutoria.fecha ? new Date(asistenciaTutoria.fecha).toISOString().split('T')[0] : "");
  const [estado, setEstado] = useState(asistenciaTutoria.estado || "Presente");

  const [tutorias, setTutorias] = useState([]);
  const [profesoresMap, setProfesoresMap] = useState({});
  const [materiasMap, setMateriasMap] = useState({});
  const [aulasMap, setAulasMap] = useState({});
  const [profesorMaterias, setProfesorMaterias] = useState([]);
  const [estudiantes, setEstudiantes] = useState([]);
  const [allAulas, setAllAulas] = useState([]);

  const [filtroProfesor, setFiltroProfesor] = useState(null);
  const [filtroMateria, setFiltroMateria] = useState(null);
  const [filtroAula, setFiltroAula] = useState(null);
  const [filtroFecha, setFiltroFecha] = useState("");

  const toast = useToast();

  useEffect(() => {
    const cargarDatos = async () => {
      const [allTutorias, allUsuarios, allProfesorMaterias, allMaterias, allAulasData] = await Promise.all([
        TutoriaRepository.getAllTutorias(),
        UsuarioRepository.getAllUsuarios(),
        ProfesorMateriaRepository.getAllProfesoresMaterias(),
        MateriaRepository.getAllMaterias(),
        AulaRepository.getAllAulas(),
      ]);

      const pMap = {};
      const mMap = {};
      const aMap = {};
      const eList = [];

      allUsuarios.forEach((u) => {
        if (u.rol === Roles.DOCENTE) pMap[u.id] = u.nombreCompleto;
        if (u.rol === Roles.ESTUDIANTE) eList.push(u);
      });

      allMaterias.forEach((m) => {
        mMap[m.id] = m.nombre;
      });

      allAulasData.forEach((a) => {
        aMap[a.id] = a.nombre;
      });

      setTutorias(allTutorias);
      setProfesoresMap(pMap);
      setMateriasMap(mMap);
      setAulasMap(aMap);
      setProfesorMaterias(allProfesorMaterias);
      setEstudiantes(eList);
      setAllAulas(allAulasData);

      // Pre-populate filter values based on the current asistenciaTutoria's associated tutoria
      const currentTutoria = allTutorias.find(t => t.id === asistenciaTutoria.tutoriaId);
      if (currentTutoria) {
        setFiltroProfesor({ value: currentTutoria.profesorId, label: pMap[currentTutoria.profesorId] });
        setFiltroMateria({ value: currentTutoria.materiaId, label: mMap[currentTutoria.materiaId] });
        setFiltroAula({ value: currentTutoria.aulaId, label: aMap[currentTutoria.aulaId] });
        setFiltroFecha(currentTutoria.fecha ? new Date(currentTutoria.fecha).toISOString().split('T')[0] : '');
      }

    };
    cargarDatos();
  }, [asistenciaTutoria]);

  // Filtrar materias
  const materiasFiltradas = filtroProfesor
    ? profesorMaterias
        .filter((pm) => pm.profesorId === filtroProfesor.value)
        .map((pm) => ({
          value: pm.materiaId,
          label: materiasMap[pm.materiaId] || pm.materiaId,
        }))
    : Object.entries(materiasMap).map(([id, nombre]) => ({ value: id, label: nombre }));

  // Filtrar tutorías según profesor, materia, aula y fecha
  const tutoriasFiltradas = tutorias
    .filter((t) => {
      const fechaTutoria = t.fecha ? new Date(t.fecha).toISOString().substring(0, 10) : "";
      return (
        (!filtroProfesor || t.profesorId === filtroProfesor.value) &&
        (!filtroMateria || t.materiaId === filtroMateria?.value) &&
        (!filtroAula || t.aulaId === filtroAula?.value) &&
        (!filtroFecha || fechaTutoria === filtroFecha)
      );
    })
    .map((t) => ({
      value: t.id,
      label: `${t.tema} - ${profesoresMap[t.profesorId]} - ${materiasMap[t.materiaId]} - ${aulasMap[t.aulaId]} (${t.fecha ? new Date(t.fecha).toLocaleDateString() : ""})`,
    }));

  const profesorOptions = Object.entries(profesoresMap).map(([id, nombre]) => ({
    value: id,
    label: nombre,
  }));

  const aulaOptions = allAulas
    .filter((a) => a.estado === "disponible")
    .map((a) => ({
      value: a.id,
      label: a.nombre,
    }));

  const estudianteOptions = estudiantes.map((e) => ({ value: e.id, label: e.nombreCompleto }));

  const estadoOptions = [
    { value: "presente", label: "Presente" },
    { value: "ausente", label: "Ausente" },
  ];

  const actualizarAsistenciaTutoria = async () => {
    if (!tutoriaId || !estudianteId || !fecha || !estado) {
      toast({ title: "Complete todos los campos", status: "warning" });
      return;
    }

    try {
      await AsistenciaTutoriaActions.actualizarAsistenciaTutoria(
        {
          id: asistenciaTutoria.id,
          tutoriaId,
          estudianteId,
          fecha: new Date(fecha),
          estado,
        },
        toast
      );
      onClose();
    } catch (error) {
      toast({
        title: "Error al actualizar asistencia",
        description: error.message,
        status: "error",
      });
    }
  };

  return (
    <Modal isOpen={true} onClose={onClose} isCentered size="lg">
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>Editar Asistencia a Tutoría</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <Box display="flex" gap={2} mb={3} flexWrap="wrap">
            <Select
              placeholder="Filtrar por profesor..."
              value={filtroProfesor}
              onChange={(option) => {
                setFiltroProfesor(option);
                setFiltroMateria(null);
                setFiltroAula(null);
              }}
              options={profesorOptions}
              isClearable
              styles={{ container: (base) => ({ ...base, flex: 1, minWidth: 150 }) }}
            />

            <Select
              placeholder="Filtrar por materia..."
              value={filtroMateria}
              onChange={setFiltroMateria}
              options={materiasFiltradas}
              isClearable
              isDisabled={materiasFiltradas.length === 0} // deshabilitar si no hay materias
              styles={{ container: (base) => ({ ...base, flex: 1, minWidth: 150 }) }}
            />

            <Select
              placeholder="Filtrar por aula..."
              value={filtroAula}
              onChange={setFiltroAula}
              options={aulaOptions}
              isClearable
              styles={{ container: (base) => ({ ...base, flex: 1, minWidth: 150 }) }}
            />

            <Input
              type="date"
              placeholder="Filtrar por fecha..."
              value={filtroFecha}
              onChange={(e) => setFiltroFecha(e.target.value)}
              flex="1"
              minWidth="150px"
            />
          </Box>

          <FormControl mb={3}>
            <FormLabel>Tutoría</FormLabel>
            <Select
              value={tutoriasFiltradas.find((option) => option.value === tutoriaId)}
              options={tutoriasFiltradas}
              onChange={(option) => setTutoriaId(option ? option.value : "")}
              placeholder="Seleccione una tutoría..."
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Estudiante</FormLabel>
            <Select
              value={estudianteOptions.find((option) => option.value === estudianteId)}
              options={estudianteOptions}
              onChange={(option) => setEstudianteId(option ? option.value : "")}
              placeholder="Seleccione un estudiante..."
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Fecha</FormLabel>
            <Input
              type="date"
              value={fecha}
              onChange={(e) => setFecha(e.target.value)}
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Estado</FormLabel>
            <Select
              value={estadoOptions.find((option) => option.value === estado)}
              options={estadoOptions}
              onChange={(option) => setEstado(option ? option.value : "")}
              placeholder="Seleccione el estado..."
            />
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button
            bg="brand.500"
            color="white"
            _hover={{ bg: "brand.600" }}
            mr={3}
            onClick={actualizarAsistenciaTutoria}
          >
            Guardar Cambios
          </Button>
          <Button onClick={onClose}>Cancelar</Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
