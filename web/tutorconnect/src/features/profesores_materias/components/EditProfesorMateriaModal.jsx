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
import { ProfesorMateriaActions } from "../actions/ProfesorMateriaActions";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles"; // 👈 IMPORTAR ROLES

export default function EditProfesorMateriaModal({ profesorMateria, onClose }) {
  const [profesorId, setProfesorId] = useState(profesorMateria.profesorId || "");
  const [materiaId, setMateriaId] = useState(profesorMateria.materiaId || "");
  const [profesores, setProfesores] = useState([]);
  const [materias, setMaterias] = useState([]);
  const toast = useToast();

  useEffect(() => {
    const cargarDatos = async () => {
      const allMaterias = await MateriaRepository.getAllMaterias();
      setMaterias(allMaterias);

      const allUsuarios = await UsuarioRepository.getAllUsuarios();
      // 👇 Solo usuarios con rol Docente
      setProfesores(allUsuarios.filter((u) => u.rol === Roles.Docente));
    };
    cargarDatos();
  }, []);

  const actualizarProfesorMateria = async () => {
    if (!profesorId || !materiaId) {
      toast({
        title: "Complete todos los campos",
        status: "warning",
        duration: 3000,
        isClosable: true,
      });
      return;
    }

    try {
      await ProfesorMateriaActions.actualizarProfesorMateria(
        { id: profesorMateria.id, profesorId, materiaId },
        toast
      );
      onClose();
    } catch (error) {
      toast({
        title: "Error al actualizar",
        description: error.message,
        status: "error",
        duration: 3000,
        isClosable: true,
      });
    }
  };

  const profesorOptions = profesores.map((p) => ({
    value: p.id,
    label: p.nombreCompleto,
  }));

  const materiaOptions = materias.map((m) => ({
    value: m.id,
    label: m.nombre,
  }));

  const selectedProfesor = profesorOptions.find((option) => option.value === profesorId);
  const selectedMateria = materiaOptions.find((option) => option.value === materiaId);

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent bg="surface.DEFAULT">
        <ModalHeader color="brand.500">Editar Asignación de materia</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel color="brand.500">Docente</FormLabel>
            <Select
              options={profesorOptions}
              value={selectedProfesor}
              onChange={(option) => setProfesorId(option ? option.value : "")}
              placeholder="Seleccione o busque un cocente"
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Materia</FormLabel>
            <Select
              options={materiaOptions}
              value={selectedMateria}
              onChange={(option) => setMateriaId(option ? option.value : "")}
              placeholder="Seleccione o busque una materia"
              isClearable
              isSearchable
            />
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button colorScheme="brand" mr={3} onClick={actualizarProfesorMateria}>
            Actualizar
          </Button>
          <Button
            bg="white"
            color="black"
            _hover={{ bg: "gray.100" }}
            onClick={onClose}
          >
            Cancelar
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
