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
  useTheme
} from "@chakra-ui/react";
import Select from "react-select";
import { HorarioClaseActions } from "../actions/HorarioClaseActions";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { AulaRepository } from "../../aulas/repositories/AulaRepository";
import { ProfesorMateriaRepository } from "../../profesores_materias/repositories/ProfesorMateriaRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";
import { AulaEstado } from "../../aulas/models/Aula";

const diasSemana = ["lunes", "martes", "miercoles", "jueves", "viernes"];

export default function EditHorarioClaseModal({ horarioClase, onClose }) {
  const [profesorId, setProfesorId] = useState(horarioClase.profesorId || "");
  const [materiaId, setMateriaId] = useState(horarioClase.materiaId || "");
  const [aulaId, setAulaId] = useState(horarioClase.aulaId || "");
  const [diaSemana, setDiaSemana] = useState({ label: horarioClase.diaSemana, value: horarioClase.diaSemana });
  const [horaInicio, setHoraInicio] = useState(horarioClase.horaInicio || "");
  const [horaFin, setHoraFin] = useState(horarioClase.horaFin || "");

  const [profesores, setProfesores] = useState([]);
  const [materias, setMaterias] = useState([]);
  const [aulas, setAulas] = useState([]);
  const [profesorMateriasMap, setProfesorMateriasMap] = useState({}); // mapa profesor → materias

  const toast = useToast();
  const themeChakra = useTheme();

  useEffect(() => {
    const cargarDatos = async () => {
      const [allUsuarios, allMaterias, allAulas, allProfesorMaterias] = await Promise.all([
        UsuarioRepository.getAllUsuarios(),
        MateriaRepository.getAllMaterias(),
        AulaRepository.getAllAulas(),
        ProfesorMateriaRepository.getAllProfesoresMaterias(),
      ]);

      setProfesores(allUsuarios.filter(u => u.rol === Roles.DOCENTE));
      setMaterias(allMaterias);

      // Filtrar solo aulas disponibles
      const aulasDisponibles = allAulas.filter(a => a.estado === AulaEstado.DISPONIBLE);
      setAulas(aulasDisponibles);

      // Crear mapa profesorId → [materiaId]
      const map = {};
      allProfesorMaterias.forEach(pm => {
        if (!map[pm.profesorId]) map[pm.profesorId] = [];
        map[pm.profesorId].push(pm.materiaId);
      });
      setProfesorMateriasMap(map);
    };
    cargarDatos();
  }, []);


  const actualizarHorario = async () => {
    if (!profesorId || !materiaId || !aulaId || !diaSemana || !horaInicio || !horaFin) {
      toast({ title: "Complete todos los campos", status: "warning" });
      return;
    }
    try {
      await HorarioClaseActions.actualizarHorarioClase({
        id: horarioClase.id,
        profesorId,
        materiaId,
        aulaId,
        diaSemana: diaSemana.value,
        horaInicio,
        horaFin,
      }, toast);
      onClose();
    } catch (error) {
      toast({ title: "Error al actualizar horario", description: error.message, status: "error" });
    }
  };

  const profesorOptions = profesores.map(p => ({ value: p.id, label: p.nombreCompleto }));

  // Filtrar materias según el profesor seleccionado
  const materiasFiltradas = profesorId ? materias.filter(m =>
    profesorMateriasMap[profesorId]?.includes(m.id)
  ) : materias;

  const materiaOptions = materiasFiltradas.map(m => ({ value: m.id, label: m.nombre }));
  const aulaOptions = aulas.map(a => ({ value: a.id, label: a.nombre }));
  const diasOptions = diasSemana.map(d => ({ label: d, value: d }));

  const selectedProfesor = profesorOptions.find(option => option.value === profesorId) || null;
  const selectedMateria = materiaOptions.find(option => option.value === materiaId) || null;
  const selectedAula = aulaOptions.find(option => option.value === aulaId) || null;

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent bg="surface.DEFAULT">
        <ModalHeader color="brand.500">Editar Horario</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel color="brand.500">Profesor</FormLabel>
            <Select
              value={selectedProfesor}
              options={profesorOptions}
              onChange={option => {
                setProfesorId(option ? option.value : "");
                setMateriaId(""); // resetear materia al cambiar profesor
              }}
              placeholder="Buscar profesor..."
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Materia</FormLabel>
            <Select
              value={selectedMateria}
              options={materiaOptions}
              onChange={option => setMateriaId(option ? option.value : "")}
              placeholder="Buscar materia..."
              isClearable
              isSearchable
              isDisabled={!profesorId} // solo habilitar si hay profesor
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Aula</FormLabel>
            <Select
              value={selectedAula}
              options={aulaOptions}
              onChange={option => setAulaId(option ? option.value : "")}
              placeholder="Buscar aula..."
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Día de la Semana</FormLabel>
            <Select
              options={diasOptions}
              value={diaSemana}
              onChange={setDiaSemana}
              placeholder="Seleccione un día"
              isClearable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Hora de Inicio</FormLabel>
            <Input
              type="time"
              value={horaInicio}
              onChange={e => setHoraInicio(e.target.value)}
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Hora de Fin</FormLabel>
            <Input
              type="time"
              value={horaFin}
              onChange={e => setHoraFin(e.target.value)}
            />
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button colorScheme="brand" mr={3} onClick={actualizarHorario}>
            Actualizar
          </Button>
          <Button bg="white" color="black" _hover={{ bg: "gray.100" }} onClick={onClose}>
            Cancelar
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
