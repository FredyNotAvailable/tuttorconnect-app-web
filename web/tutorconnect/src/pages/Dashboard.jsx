// src/pages/Dashboard.jsx
import { useState } from "react";
import { Flex, Box } from "@chakra-ui/react";
import Navbar from "../components/Navbar";
import Sidebar from "../components/Sidebar";
import Usuarios from "../features/usuarios/components/Usuarios";
import Carreras from "../features/carreras/components/Carreras";
import Materias from "../features/materias/components/Materias";
import MallasCurriculares from "../features/mallas_curricualares/components/Mallas";
import MateriaMalla from "../features/materia_malla/components/MateriaMalla"; // <- componente React
import ProfesoresMaterias from "../features/profesores_materias/components/ProfesoresMaterias";
import HorariosClases from "../features/horarios_clases/components/HorariosClases";
import Aulas from "../features/aulas/components/Aulas";
import Matriculas from "../features/matriculas/components/Matriculas";

function Dashboard() {
  const [activeComponent, setActiveComponent] = useState("dashboard");

  return (
    <Flex direction="column" minH="100vh" overflow="hidden">
      <Navbar />
      <Flex flex="1" overflow="hidden">
        <Sidebar onSelect={setActiveComponent} />
        <Box flex="1" p={5} bg="background.DEFAULT" overflow="hidden">
          {activeComponent === "dashboard" && <Box>Bienvenido al Dashboard</Box>}
          {activeComponent === "usuarios" && <Usuarios />}
          {activeComponent === "carreras" && <Carreras />}
          {activeComponent === "materias" && <Materias />}
          {activeComponent === "mallasCurriculares" && <MallasCurriculares />}
          {activeComponent === "materiaMalla" && <MateriaMalla />} {/* <- usar componente */}
          {activeComponent === "profesoresMaterias" && <ProfesoresMaterias />} {/* <- usar componente */}
          {activeComponent === "horariosClases" && <HorariosClases />}
          {activeComponent === "aulas" && <Aulas />}
          {activeComponent === "matriculas" && <Matriculas />}
        </Box>
      </Flex>
    </Flex>
  );
}

export default Dashboard;
