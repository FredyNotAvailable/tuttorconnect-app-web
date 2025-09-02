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
  useToast,
  Box,
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
import { Aula } from "../../aulas/models/Aula";


// ...


const diasSemana = ["lunes", "martes", "miercoles", "jueves", "viernes"];

export default function CrearHorarioClaseModal({ onClose }) {
  const [profesorId, setProfesorId] = useState("");
  const [materiaId, setMateriaId] = useState("");
  const [aulaId, setAulaId] = useState("");
  const [diaSemana, setDiaSemana] = useState(null);
  const [horaInicio, setHoraInicio] = useState("");
  const [horaFin, setHoraFin] = useState("");

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

  const crearHorario = async () => {
    if (!profesorId || !materiaId || !aulaId || !diaSemana || !horaInicio || !horaFin) {
      toast({ title: "Complete todos los campos", status: "warning" });
      return;
    }
    try {
      await HorarioClaseActions.crearHorarioClase({
        profesorId,
        materiaId,
        aulaId,
        diaSemana: diaSemana.value,
        horaInicio,
        horaFin,
      }, toast);
      onClose();
    } catch (error) {
      toast({ title: "Error al crear horario", description: error.message, status: "error" });
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

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent bg="surface.DEFAULT">
        <ModalHeader color="brand.500">Crear Nuevo Horario</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel color="brand.500">Profesor</FormLabel>
            <Select
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
              options={materiaOptions}
              onChange={option => setMateriaId(option ? option.value : "")}
              value={materiaOptions.find(m => m.value === materiaId) || null}
              placeholder="Buscar materia..."
              isClearable
              isSearchable
              isDisabled={!profesorId} // solo habilitar si se seleccionó profesor
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Aula</FormLabel>
            <Select
              options={aulaOptions}
              onChange={option => setAulaId(option ? option.value : "")}
              placeholder="Buscar aula..."
              isClearable
              isSearchable
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Día de la Semana</FormLabel>
            <Box>
              <Select
                options={diasOptions}
                value={diaSemana}
                onChange={setDiaSemana}
                placeholder="Seleccione un día"
                isClearable
                styles={{
                  control: (provided, state) => ({
                    ...provided,
                    background: "white",
                    borderColor: state.isFocused
                      ? themeChakra.colors.brand[500]
                      : "transparent",
                    minHeight: "40px",
                    boxShadow: state.isFocused
                      ? `0 0 0 1px ${themeChakra.colors.brand[500]}`
                      : "none",
                    "&:hover": {
                      borderColor: state.isFocused
                        ? themeChakra.colors.brand[500]
                        : "#E2E8F0",
                    },
                  }),
                  placeholder: (provided) => ({ ...provided, color: "#A0AEC0" }),
                  singleValue: (provided) => ({ ...provided, color: "black" }),
                  menu: (provided) => ({ ...provided, zIndex: 9999 }),
                }}
              />
            </Box>
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Hora de Inicio</FormLabel>
            <Input
              type="time"
              value={horaInicio}
              onChange={e => setHoraInicio(e.target.value)}
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            />
          </FormControl>

          <FormControl mb={3}>
            <FormLabel color="brand.500">Hora de Fin</FormLabel>
            <Input
              type="time"
              value={horaFin}
              onChange={e => setHoraFin(e.target.value)}
              bg="white"
              borderColor="transparent"
              _hover={{ borderColor: "gray.200" }}
              focusBorderColor="brand.500"
            />
          </FormControl>
        </ModalBody>

        <ModalFooter>
          <Button colorScheme="brand" mr={3} onClick={crearHorario}>
            Crear
          </Button>
          <Button bg="white" color="black" _hover={{ bg: "gray.100" }} onClick={onClose}>
            Cancelar
          </Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
