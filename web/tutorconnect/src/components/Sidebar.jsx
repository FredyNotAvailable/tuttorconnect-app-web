// src/components/Sidebar.jsx
import { Box, VStack, Button } from "@chakra-ui/react";

function Sidebar({ onSelect, activeComponent }) {
  const menuItems = [
    { key: "usuarios", label: "Usuarios" },
    { key: "carreras", label: "Carreras" },
    { key: "materias", label: "Materias" },
    { key: "aulas", label: "Aulas" },
    { key: "tutorias", label: "Tutorías" },
    { key: "tutoriasEstudiantes", label: "Tutorías Estudiantes" },
    { key: "solicitudesTutorias", label: "Solicitudes Tutorías" },
    { key: "asistenciaTutorias", label: "Asistencia Tutorías" },
    { key: "profesoresMaterias", label: "Profesores Materias" },
    { key: "horariosClases", label: "Horarios de clase" },
    { key: "matriculas", label: "Matrículas Estudiantes" },
    { key: "materiaMalla", label: "Materias con malla" },
    { key: "mallasCurriculares", label: "Mallas curriculares" },
  ];

  return (
    <Box w="220px" bg="brand.50" p={5} minH="100vh" borderRight="1px solid" borderColor="surface.DEFAULT">
      <VStack align="start" spacing={2}>
        {menuItems.map((item) => (
          <Button
            key={item.key}
            variant={activeComponent === item.key ? "solid" : "ghost"}
            colorScheme={activeComponent === item.key ? "brand" : "gray"}
            width="100%"
            justifyContent="flex-start"
            onClick={() => onSelect(item.key)}
          >
            {item.label}
          </Button>
        ))}
      </VStack>
    </Box>
  );
}

export default Sidebar;
