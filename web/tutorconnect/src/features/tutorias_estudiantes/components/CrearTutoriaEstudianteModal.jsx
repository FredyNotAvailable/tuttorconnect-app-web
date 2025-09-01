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

export default function CrearTutoriaEstudianteModal({ onClose }) {
  const [tutoriaId, setTutoriaId] = useState("");
  const [estudianteId, setEstudianteId] = useState("");

  const [tutorias, setTutorias] = useState([]);
  const [estudiantes, setEstudiantes] = useState([]);
  const toast = useToast();

  useEffect(() => {
    const cargarDatos = async () => {
      const [allTutorias, allUsuarios] = await Promise.all([
        TutoriaRepository.getAllTutorias(),
        UsuarioRepository.getAllUsuarios(),
      ]);

      setTutorias(allTutorias);
      setEstudiantes(allUsuarios.filter(u => u.rol === Roles.ESTUDIANTE));
    };
    cargarDatos();
  }, []);

  const crearTutoriaEstudiante = async () => {
    if (!tutoriaId || !estudianteId) {
      toast({ title: "Complete todos los campos", status: "warning" });
      return;
    }
    try {
      await TutoriaEstudianteActions.crearTutoriaEstudiante(
        {
          tutoriaId,
          estudianteId,
        },
        toast
      );
      onClose();
    } catch (error) {
      toast({
        title: "Error al asignar tutoría a estudiante",
        description: error.message,
        status: "error",
      });
    }
  };

  const tutoriaOptions = tutorias.map(t => ({
    value: t.id,
    label: `${t.tema} (${t.fecha ? new Date(t.fecha).toLocaleDateString() : ''}) - ${t.profesorId}`,
  }));

  const estudianteOptions = estudiantes.map(e => ({
    value: e.id,
    label: e.nombreCompleto,
  }));

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>Asignar Tutoría a Estudiante</ModalHeader>
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
            onClick={crearTutoriaEstudiante}
          >
            Asignar
          </Button>
          <Button onClick={onClose}>Cancelar</Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
