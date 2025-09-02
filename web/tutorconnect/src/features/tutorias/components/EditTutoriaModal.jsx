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
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { AulaRepository } from "../../aulas/repositories/AulaRepository";
import { ProfesorMateriaRepository } from "../../profesores_materias/repositories/ProfesorMateriaRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";
import { AulaEstado } from "../../aulas/models/Aula"; // Importar enum

export default function EditTutoriaModal({ tutoria, onClose }) {
  const [profesorId, setProfesorId] = useState(tutoria.profesorId || "");
  const [materiaId, setMateriaId] = useState(tutoria.materiaId || "");
  const [aulaId, setAulaId] = useState(tutoria.aulaId || "");
  const [fecha, setFecha] = useState(tutoria.fecha ? new Date(tutoria.fecha).toISOString().split('T')[0] : "");
  const [horaInicio, setHoraInicio] = useState(tutoria.horaInicio || "");
  const [horaFin, setHoraFin] = useState(tutoria.horaFin || "");
  const [estado, setEstado] = useState(tutoria.estado || "pendiente");
  const [tema, setTema] = useState(tutoria.tema || "");
  const [descripcion, setDescripcion] = useState(tutoria.descripcion || "");

  const [profesores, setProfesores] = useState([]);
  const [materias, setMaterias] = useState([]);
  const [aulas, setAulas] = useState([]);
  const [profesorMaterias, setProfesorMaterias] = useState([]);
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

  const actualizarTutoria = async () => {
    if (!profesorId || !materiaId || !aulaId || !fecha || !horaInicio || !horaFin || !estado || !tema || !descripcion) {
      toast({ title: "Complete todos los campos", status: "warning" });
      return;
    }

    try {
      await TutoriaActions.actualizarTutoria(
        {
          id: tutoria.id,
          profesorId,
          materiaId,
          aulaId,
          fecha: new Date(fecha),
          horaInicio,
          horaFin,
          estado,
          tema,
          descripcion,
        },
        toast
      );
      onClose();
    } catch (error) {
      toast({
        title: "Error al actualizar tutoría",
        description: error.message,
        status: "error",
      });
    }
  };

  const profesorOptions = profesores.map((p) => ({ value: p.id, label: p.nombreCompleto }));
  const aulaOptions = aulas
    .filter(a => a.estado === AulaEstado.DISPONIBLE) // solo aulas disponibles
    .map((a) => ({ value: a.id, label: a.nombre }));
  const estadoOptions = [
    { value: "pendiente", label: "Pendiente" },
    { value: "confirmada", label: "Confirmada" },
    { value: "cancelada", label: "Cancelada" },
    { value: "completada", label: "Completada" },
  ];

  // Filtrar materias según el profesor seleccionado
  const materiasDelProfesor = profesorMaterias
    .filter(pm => pm.profesorId === profesorId)
    .map(pm => materias.find(m => m.id === pm.materiaId))
    .filter(Boolean)
    .map(m => ({ value: m.id, label: m.nombre }));

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>Editar Tutoría</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel>Profesor</FormLabel>
            <Select
              value={profesorOptions.find(option => option.value === profesorId)}
              options={profesorOptions}
              onChange={(option) => {
                setProfesorId(option ? option.value : "");
                setMateriaId(""); // Reset materia al cambiar profesor
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
              onChange={(option) => setMateriaId(option ? option.value : "")}
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
              onChange={(option) => setAulaId(option ? option.value : "")}
              placeholder="Seleccione un aula disponible..."
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Fecha</FormLabel>
            <Input type="date" value={fecha} onChange={(e) => setFecha(e.target.value)} />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Hora Inicio</FormLabel>
            <Input type="time" value={horaInicio} onChange={(e) => setHoraInicio(e.target.value)} />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Hora Fin</FormLabel>
            <Input type="time" value={horaFin} onChange={(e) => setHoraFin(e.target.value)} />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Estado</FormLabel>
            <Select
              value={estadoOptions.find(option => option.value === estado)}
              options={estadoOptions}
              onChange={(option) => setEstado(option ? option.value : "")}
              placeholder="Seleccione el estado..."
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Tema</FormLabel>
            <Input value={tema} onChange={(e) => setTema(e.target.value)} placeholder="Ingrese el tema..." />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Descripción</FormLabel>
            <Textarea value={descripcion} onChange={(e) => setDescripcion(e.target.value)} placeholder="Ingrese la descripción..." />
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button bg="brand.500" color="white" _hover={{ bg: "brand.600" }} mr={3} onClick={actualizarTutoria}>
            Actualizar
          </Button>
          <Button onClick={onClose}>Cancelar</Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
