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
import { MatriculaActions } from "../actions/MatriculaActions";
import { UsuarioRepository } from "../../usuarios/repositories/UsuarioRepository";
import { MallaCurricularRepository } from "../../mallas_curricualares/repositories/MallaCurricularRepository";
import { CarreraRepository } from "../../carreras/repositories/CarreraRepository";
import { Roles } from "../../usuarios/models/UsuarioRoles";

export default function EditMatriculaModal({ matricula, onClose }) {
  const [estudianteId, setEstudianteId] = useState(matricula.estudianteId || "");
  const [mallaId, setMallaId] = useState(matricula.mallaId || "");

  const [estudiantes, setEstudiantes] = useState([]);
  const [mallas, setMallas] = useState([]);
  const [carrerasMap, setCarrerasMap] = useState({});
  const toast = useToast();

  useEffect(() => {
    const cargarDatos = async () => {
      const [allUsuarios, allMallas, allCarreras] = await Promise.all([
        UsuarioRepository.getAllUsuarios(),
        MallaCurricularRepository.getAllMallas(),
        CarreraRepository.getAllCarreras(),
      ]);

      setEstudiantes(allUsuarios.filter(u => u.rol === Roles.ESTUDIANTE));

      // Map de carreras por ID
      const cMap = {};
      allCarreras.forEach(c => (cMap[c.id] = c.nombre));
      setCarrerasMap(cMap);

      // Agregar nombre de carrera a cada malla
      const mallasConNombre = allMallas.map(m => ({
        ...m,
        nombreCompleto: `${cMap[m.carreraId] || "Sin carrera"} - Ciclo ${m.ciclo} - Año ${m.anio}`,
      }));
      setMallas(mallasConNombre);
    };
    cargarDatos();
  }, []);

  const actualizarMatricula = async () => {
    if (!estudianteId || !mallaId) {
      toast({ title: "Complete todos los campos", status: "warning" });
      return;
    }
    try {
      await MatriculaActions.actualizarMatricula({
        id: matricula.id,
        estudianteId,
        mallaId,
      }, toast);
      onClose();
    } catch (error) {
      toast({ title: "Error al actualizar matrícula", description: error.message, status: "error" });
    }
  };

  const estudianteOptions = estudiantes.map(e => ({ value: e.id, label: e.nombreCompleto }));
  const mallaOptions = mallas.map(m => ({ value: m.id, label: m.nombreCompleto }));

  const selectedEstudiante = estudianteOptions.find(option => option.value === estudianteId);
  const selectedMalla = mallaOptions.find(option => option.value === mallaId);

  return (
    <Modal isOpen={true} onClose={onClose} isCentered>
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>Editar Matrícula</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <FormControl mb={3}>
            <FormLabel>Estudiante</FormLabel>
            <Select
              value={selectedEstudiante}
              options={estudianteOptions}
              onChange={option => setEstudianteId(option ? option.value : "")}
              placeholder="Buscar estudiante..."
              isClearable
              isSearchable
            />
          </FormControl>
          <FormControl mb={3}>
            <FormLabel>Malla Curricular</FormLabel>
            <Select
              value={selectedMalla}
              options={mallaOptions}
              onChange={option => setMallaId(option ? option.value : "")}
              placeholder="Buscar malla..."
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
            onClick={actualizarMatricula}
          >
            Actualizar
          </Button>
          <Button onClick={onClose}>Cancelar</Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  );
}
