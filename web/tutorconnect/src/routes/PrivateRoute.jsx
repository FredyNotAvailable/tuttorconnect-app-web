import { Navigate } from "react-router-dom";
import { useAuthState } from "react-firebase-hooks/auth";
import { auth } from "../services/firebase";

// Este componente protege rutas privadas
function PrivateRoute({ children }) {
  const [user, loading] = useAuthState(auth);

  if (loading) {
    return <p>Cargando...</p>; // 👈 mientras se revisa la sesión
  }

  return user ? children : <Navigate to="/login" />;
}

export default PrivateRoute;
