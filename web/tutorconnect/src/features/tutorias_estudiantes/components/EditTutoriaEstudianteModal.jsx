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
  useToast,
} from "@chakra-ui/react";
import Select from "react-select";
import { TutoriaEstudianteActions } from "../actions/TutoriaEstudianteActions";
import { TutoriaRepository } from "../../tutorias/repositories/TutoriaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";

export default function EditTutoriaEstudianteModal({ tutoriaEstudiante, onClose }) {
  const [tutoriaId, setTutoriaId] = useState(tutoriaEstudiante.tutoriaId || "");
  const [estudianteId, setEstudianteId] = useState(tutoriaEstudiante.estudianteId || "");
  const [tutorias, setTutorias] = useState([]);
  const [estudiantes, setEstudiantes] = useState([]);
  const [profesoresMap, setProfesoresMap] = useState({});
  const toast = useToast();

  useEffect(() => {
    const cargarDatos = async () => {
      try {
        const [allTutorias, allUsuarios] = await Promise.all([
          TutoriaRepository.getAllTutorias(),
          UsuarioRepository.getAllUsuarios(),
        ]);

        setTutorias(allTutorias);
        setEstudiantes(allUsuarios.filter(u => u.rol === Roles.ESTUDIANTE));

        // Crear un mapa de profesores por ID (asegurando que los IDs sean strings)
        const profesores = allUsuarios.filter(u => u.rol === Roles.DOCENTE);
        const map = {};
        profesores.forEach(p => {
          map[String(p.id)] = p.nombreCompleto;
        });
        setProfesoresMap(map);
      } catch (error) {
        toast({
          title: "Error cargando datos",
          description: error.message,
          status: "error",
        });
      }
    };

    cargarDatos();
  }, []);

  const actualizarTutoriaEstudiante = async () => {
    if (!tutoriaId || !estudianteId) {
      toast({ title: "Complete todos los campos", status: "warning" });
      return;
    }
    try {
      await TutoriaEstudianteActions.actualizarTutoriaEstudiante(
        {
          id: tutoriaEstudiante.id,
          tutoriaId,
          estudianteId,
        },
        toast
      );
      onClose();
    } catch (error) {
      toast({
        title: "Error al actualizar asignación de tutoría a estudiante",
        description: error.message,
        status: "error",
      });
    }
  };

  const tutoriaOptions = tutorias.map(t => {
    const profesorIdStr = String(t.profesorId);
    const nombreProfesor = profesoresMap[profesorIdStr];
    if (!nombreProfesor) {
      console.warn(`Profesor no encontrado para tutoría "${t.tema}", id: ${t.profesorId}`);
    }
    return {
      value: t.id,
      label: `${t.tema} (${t.fecha ? new Date(t.fecha).toLocaleDateString() : ''}) - ${nombreProfesor || 'Profesor desconocido'}`,
    };
  });

  const estudianteOptions = estudiantes.map(e => ({
    value: e.id,
    label: e.nombreCompleto,
  }));

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>Editar Asignación de Tutoría a Estudiante</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel>Tutoría</FormLabel>
            <Select
              value={tutoriaOptions.find(option => option.value === tutoriaId)}
              options={tutoriaOptions}
              onChange={option => setTutoriaId(option ? option.value : "")}
              placeholder="Seleccione una tutoría..."
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel>Estudiante</FormLabel>
            <Select
              value={estudianteOptions.find(option => option.value === estudianteId)}
              options={estudianteOptions}
              onChange={option => setEstudianteId(option ? option.value : "")}
              placeholder="Seleccione un estudiante..."
              isClearable
              isSearchable
            />
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button
            bg="brand.500"
            color="white"
            _hover={{ bg: "brand.600" }}
            mr={3}
            onClick={actualizarTutoriaEstudiante}
          >
            Actualizar
          </Button>
          <Button onClick={onClose}>Cancelar</Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
