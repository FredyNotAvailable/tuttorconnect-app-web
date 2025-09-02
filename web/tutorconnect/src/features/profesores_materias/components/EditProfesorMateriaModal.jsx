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
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";
import { MallaCurricularRepository } from "../../mallas_curricualares/repositories/MallaCurricularRepository";
import { MateriaMallaRepository } from "../../materia_malla/repositories/MateriaMallaRepository";
import { MateriaRepository } from "../../materias/repositories/MateriaRepository";
import { CarreraRepository } from "../../carreras/repositories/CarreraRepository";

export default function EditProfesorMateriaModal({ profesorMateria, onClose }) {
  const [profesorId, setProfesorId] = useState(profesorMateria.profesorId || "");
  const [ciclo, setCiclo] = useState(""); // 🔹 ciclo seleccionado
  const [mallaId, setMallaId] = useState("");
  const [materiaId, setMateriaId] = useState("");

  const [profesores, setProfesores] = useState([]);
  const [mallas, setMallas] = useState([]);
  const [materiasMalla, setMateriasMalla] = useState([]);
  const [materias, setMaterias] = useState([]);
  const [carreras, setCarreras] = useState([]);

  const toast = useToast();

  useEffect(() => {
    const cargarDatos = async () => {
      const allUsuarios = await UsuarioRepository.getAllUsuarios();
      const docentes = allUsuarios.filter((u) => u.rol === Roles.DOCENTE);
      setProfesores(docentes);

      const allMallas = await MallaCurricularRepository.getAllMallas();
      setMallas(allMallas);

      const allMaterias = await MateriaRepository.getAllMaterias();
      setMaterias(allMaterias);

      const allMateriasMalla = await MateriaMallaRepository.getAllMateriasMalla();
      setMateriasMalla(allMateriasMalla);

      const allCarreras = await CarreraRepository.getAllCarreras();
      setCarreras(allCarreras);

      // Pre-cargar los datos existentes
      const mallaAsignada = allMallas.find((m) =>
        allMateriasMalla.some(
          (mm) => mm.mallaId === m.id && mm.materiaId === profesorMateria.materiaId
        )
      );
      if (mallaAsignada) {
        setMallaId(mallaAsignada.id);
        setCiclo(mallaAsignada.ciclo);
      }
      setMateriaId(profesorMateria.materiaId);
      setProfesorId(profesorMateria.profesorId);
    };
    cargarDatos();
  }, [profesorMateria]);

  const actualizarProfesorMateria = async () => {
    if (!profesorId || !ciclo || !mallaId || !materiaId) {
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
        { id: profesorMateria.id, profesorId, materiaId, mallaId },
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

  // Opciones
  const profesorOptions = profesores.map((p) => ({
    value: p.id,
    label: p.nombreCompleto,
  }));

  const ciclosOptions = Array.from({ length: 10 }, (_, i) => ({
    value: i + 1,
    label: `Ciclo ${i + 1}`,
  }));

  const mallaOptions = mallas
    .filter((m) => (ciclo ? m.ciclo === ciclo : true))
    .map((m) => {
      const carrera = carreras.find((c) => c.id === m.carreraId);
      const carreraNombre = carrera ? carrera.nombre : "Carrera desconocida";
      return {
        value: m.id,
        label: `${carreraNombre} - Ciclo ${m.ciclo} - Año ${m.anio}`,
      };
    });

  const materiasDeMalla = materiasMalla
    .filter((mm) => mm.mallaId === mallaId)
    .map((mm) => {
      const materia = materias.find((m) => m.id === mm.materiaId);
      return materia ? { value: materia.id, label: materia.nombre } : null;
    })
    .filter(Boolean);

  const selectedProfesor = profesorOptions.find((option) => option.value === profesorId);
  const selectedCiclo = ciclosOptions.find((option) => option.value === ciclo);
  const selectedMalla = mallaOptions.find((option) => option.value === mallaId);
  const selectedMateria = materiasDeMalla.find((option) => option.value === materiaId);

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
              placeholder="Seleccione un docente"
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Ciclo</FormLabel>
            <Select
              options={ciclosOptions}
              value={selectedCiclo}
              onChange={(option) => {
                setCiclo(option ? option.value : "");
                setMallaId(""); // limpiar malla si se cambia ciclo
              }}
              placeholder="Seleccione un ciclo"
              isClearable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Malla Curricular</FormLabel>
            <Select
              options={mallaOptions}
              value={selectedMalla}
              onChange={(option) => setMallaId(option ? option.value : "")}
              placeholder={ciclo ? "Seleccione una malla del ciclo" : "Seleccione primero un ciclo"}
              isClearable
              isSearchable
              isDisabled={!ciclo}
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Materia</FormLabel>
            <Select
              options={materiasDeMalla}
              value={selectedMateria}
              onChange={(option) => setMateriaId(option ? option.value : "")}
              placeholder={mallaId ? "Seleccione una materia de la malla" : "Seleccione primero una malla"}
              isClearable
              isSearchable
              isDisabled={!mallaId}
            />
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button colorScheme="brand" mr={3} onClick={actualizarProfesorMateria}>
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
