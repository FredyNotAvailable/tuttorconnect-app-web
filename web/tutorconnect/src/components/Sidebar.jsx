// src/components/Sidebar.jsx
import { Box, VStack, Button } from "@chakra-ui/react";

function Sidebar({ onSelect }) {
  return (
    <Box w="220px" bg="brand.50" p={5} minH="100vh">
      <VStack align="start" spacing={4}>
        <Button variant="ghost" onClick={() => onSelect("dashboard")}>Dashboard</Button>
        <Button variant="ghost" onClick={() => onSelect("usuarios")}>Usuarios</Button>
        <Button variant="ghost" onClick={() => onSelect("carreras")}>Carreras</Button> {/* <-- Agregado */}
        <Button variant="ghost" onClick={() => onSelect("materias")}>Materias</Button> {/* <-- Agregado */}
        <Button variant="ghost" onClick={() => onSelect("aulas")}>Aulas</Button>
        <Button variant="ghost" onClick={() => onSelect("horariosClases")}>Horarios de clase</Button>
        <Button variant="ghost" onClick={() => onSelect("profesoresMaterias")}>Profesores materias</Button>
        <Button variant="ghost" onClick={() => onSelect("mallasCurriculares")}>Mallas curriculares</Button> {/* <-- Agregado */}
        <Button variant="ghost" onClick={() => onSelect("materiaMalla")}>Materias con malla</Button> {/* <-- Agregado */}
        <Button variant="ghost" onClick={() => onSelect("matriculas")}>Matrículas estudiantes</Button>
      </VStack>
    </Box>
  );
}

export default Sidebar;
