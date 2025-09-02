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
  Textarea,
  useToast,
} from "@chakra-ui/react";
import Select from "react-select";
import { TutoriaActions } from "../actions/TutoriaActions";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { AulaRepository } from "../../aulas/repositories/AulaRepository";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { ProfesorMateriaRepository } from "../../profesores_materias/repositories/ProfesorMateriaRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";
import { AulaEstado } from "../../aulas/models/Aula"; // Importar enum

export default function CrearTutoriaModal({ onClose }) {
  const [profesorId, setProfesorId] = useState("");
  const [materiaId, setMateriaId] = useState("");
  const [aulaId, setAulaId] = useState("");
  const [fecha, setFecha] = useState("");
  const [horaInicio, setHoraInicio] = useState("");
  const [horaFin, setHoraFin] = useState("");
  const [estado, setEstado] = useState("pendiente");
  const [tema, setTema] = useState("");
  const [descripcion, setDescripcion] = useState("");

  const [profesores, setProfesores] = useState([]);
  const [materias, setMaterias] = useState([]);
  const [profesorMaterias, setProfesorMaterias] = useState([]);
  const [aulas, setAulas] = useState([]);
  const toast = useToast();

  useEffect(() => {
    const cargarDatos = async () => {
      const [allUsuarios, allMaterias, allAulas, allProfesorMaterias] = await Promise.all([
        UsuarioRepository.getAllUsuarios(),
        MateriaRepository.getAllMaterias(),
        AulaRepository.getAllAulas(),
        ProfesorMateriaRepository.getAllProfesoresMaterias(),
      ]);

      setProfesores(allUsuarios.filter(u => u.rol === Roles.DOCENTE || u.rol === "Docente"));
      setMaterias(allMaterias);
      setAulas(allAulas);
      setProfesorMaterias(allProfesorMaterias);
    };
    cargarDatos();
  }, []);

  // Filtra materias según el profesor seleccionado
  const materiasDelProfesor = profesorMaterias
    .filter(pm => pm.profesorId === profesorId)
    .map(pm => materias.find(m => m.id === pm.materiaId))
    .filter(Boolean)
    .map(m => ({ value: m.id, label: m.nombre }));

  // Opciones para select
  const profesorOptions = profesores.map(p => ({ value: p.id, label: p.nombreCompleto }));
  const aulaOptions = aulas
    .filter(a => a.estado === AulaEstado.DISPONIBLE) // solo aulas disponibles
    .map(a => ({ value: a.id, label: a.nombre }));
  const estadoOptions = [
    { value: "pendiente", label: "Pendiente" },
    { value: "confirmada", label: "Confirmada" },
    { value: "cancelada", label: "Cancelada" },
    { value: "completada", label: "Completada" },
  ];

  const crearTutoria = async () => {
    if (!profesorId || !materiaId || !aulaId || !fecha || !horaInicio || !horaFin || !estado || !tema || !descripcion) {
      toast({ title: "Complete todos los campos", status: "warning" });
      return;
    }

    try {
      await TutoriaActions.crearTutoria(
        { profesorId, materiaId, aulaId, fecha: new Date(fecha), horaInicio, horaFin, estado, tema, descripcion },
        toast
      );
      onClose();
    } catch (error) {
      toast({ title: "Error al crear tutoría", description: error.message, status: "error" });
    }
  };

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>Crear Nueva Tutoría</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel>Profesor</FormLabel>
            <Select
              value={profesorOptions.find(option => option.value === profesorId)}
              options={profesorOptions}
              onChange={option => {
                setProfesorId(option ? option.value : "");
                setMateriaId(""); // reset materia al cambiar profesor
              }}
              placeholder="Seleccione un profesor..."
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Materia</FormLabel>
            <Select
              value={materiasDelProfesor.find(option => option.value === materiaId)}
              options={materiasDelProfesor}
              onChange={option => setMateriaId(option ? option.value : "")}
              placeholder="Seleccione una materia..."
              isClearable
              isSearchable
              isDisabled={!profesorId}
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Aula</FormLabel>
            <Select
              value={aulaOptions.find(option => option.value === aulaId)}
              options={aulaOptions}
              onChange={option => setAulaId(option ? option.value : "")}
              placeholder="Seleccione un aula disponible..."
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Fecha</FormLabel>
            <Input type="date" value={fecha} onChange={e => setFecha(e.target.value)} />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Hora Inicio</FormLabel>
            <Input type="time" value={horaInicio} onChange={e => setHoraInicio(e.target.value)} />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Hora Fin</FormLabel>
            <Input type="time" value={horaFin} onChange={e => setHoraFin(e.target.value)} />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Estado</FormLabel>
            <Select
              value={estadoOptions.find(option => option.value === estado)}
              options={estadoOptions}
              onChange={option => setEstado(option ? option.value : "")}
              placeholder="Seleccione el estado..."
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Tema</FormLabel>
            <Input value={tema} onChange={e => setTema(e.target.value)} placeholder="Ingrese el tema..." />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Descripción</FormLabel>
            <Textarea value={descripcion} onChange={e => setDescripcion(e.target.value)} placeholder="Ingrese la descripción..." />
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button bg="brand.500" color="white" _hover={{ bg: "brand.600" }} mr={3} onClick={crearTutoria}>
            Crear
          </Button>
          <Button onClick={onClose}>Cancelar</Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
