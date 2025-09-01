// src/pages/Dashboard.jsx
import { useState } from "react";
import { Flex, Box } from "@chakra-ui/react";
import Navbar from "../components/Navbar";
import Sidebar from "../components/Sidebar";
import Usuarios from "../features/usuarios/components/Usuarios";
import Carreras from "../features/carreras/components/Carreras";
import Materias from "../features/materias/components/Materias";
import MallasCurriculares from "../features/mallas_curricualares/components/Mallas";
import MateriaMalla from "../features/materia_malla/components/MateriaMalla";
import ProfesoresMaterias from "../features/profesores_materias/components/ProfesoresMaterias";
import HorariosClases from "../features/horarios_clases/components/HorariosClases";
import Aulas from "../features/aulas/components/Aulas";
import Matriculas from "../features/matriculas/components/Matriculas";
import Tutorias from "../features/tutorias/components/Tutorias";
import TutoriasEstudiantes from "../features/tutorias_estudiantes/components/TutoriasEstudiantes";
import SolicitudesTutorias from "../features/solicitudes_tutorias/components/SolicitudesTutorias";
import AsistenciaTutorias from "../features/asistencia_tutorias/components/AsistenciaTutorias";

function Dashboard() {
  const [activeComponent, setActiveComponent] = useState("usuarios");

  return (
    <Flex direction="column" h="100vh" overflow="hidden" bg="background.DEFAULT">
  <Navbar />
  <Flex flex="1" overflow="hidden">
    <Sidebar onSelect={setActiveComponent} activeComponent={activeComponent} />
    <Box flex="1" p={0} bg="background.DEFAULT" overflow="hidden">
      {activeComponent === "usuarios" && <Usuarios height="100%" />}
      {activeComponent === "carreras" && <Carreras height="100%" />}
      {activeComponent === "materias" && <Materias height="100%" />}
      {activeComponent === "mallasCurriculares" && <MallasCurriculares height="100%" />}
      {activeComponent === "materiaMalla" && <MateriaMalla height="100%" />}
      {activeComponent === "profesoresMaterias" && <ProfesoresMaterias height="100%" />}
      {activeComponent === "horariosClases" && <HorariosClases height="100%" />}
      {activeComponent === "aulas" && <Aulas height="100%" />}
      {activeComponent === "matriculas" && <Matriculas height="100%" />}
      {activeComponent === "tutorias" && <Tutorias height="100%" />}
      {activeComponent === "tutoriasEstudiantes" && <TutoriasEstudiantes height="100%" />}
      {activeComponent === "solicitudesTutorias" && <SolicitudesTutorias height="100%" />}
      {activeComponent === "asistenciaTutorias" && <AsistenciaTutorias height="100%" />}
    </Box>
  </Flex>
</Flex>
  );
}

export default Dashboard;
