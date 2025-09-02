import { useState } from "react";
import {
  Box,
  Heading,
  Input,
  InputGroup,
  InputRightElement,
  Button,
  FormControl,
  FormLabel,
  IconButton
} from "@chakra-ui/react";
import { ViewIcon, ViewOffIcon } from "@chakra-ui/icons";
import { login } from "../services/auth";
import { useNavigate } from "react-router-dom";
import { Roles } from "../features/usuarios/models/UsuarioRoles"

function Login() {
  const navigate = useNavigate();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleLogin = async () => {
    setLoading(true);
    const res = await login(email, password);
    setLoading(false);

    if (res.user && res.user.rol === Roles.ADMIN) {
      navigate("/dashboard");
    } else {
      alert(res.error || "No tienes permisos");
    }
  };


  return (
    <Box display="flex" alignItems="center" justifyContent="center" minH="100vh" bg="background.DEFAULT">
      <Box maxW="md" w="full" p={8} borderWidth={1} borderRadius="lg" boxShadow="md" bg="surface.DEFAULT">
        <Heading mb={6} textAlign="center" color="brand.500">
          Login
        </Heading>

        <FormControl mb={4}>
          <FormLabel>Correo</FormLabel>
          <Input
            type="email"
            placeholder="Ingrese su correo"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </FormControl>

        <FormControl mb={6}>
          <FormLabel>Password</FormLabel>
          <InputGroup>
            <Input
              type={showPassword ? "text" : "password"}
              placeholder="Ingrese su contraseña"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            <InputRightElement>
              <IconButton
                h="1.75rem"
                size="sm"
                onClick={() => setShowPassword(!showPassword)}
                icon={showPassword ? <ViewOffIcon /> : <ViewIcon />}
                aria-label={showPassword ? "Ocultar password" : "Mostrar password"}
              />
            </InputRightElement>
          </InputGroup>
        </FormControl>

        <Button
          colorScheme="brand"
          width="full"
          onClick={handleLogin}
          isLoading={loading}
        >
          Iniciar Sesión
        </Button>
      </Box>
    </Box>
  );
}

export default Login;
