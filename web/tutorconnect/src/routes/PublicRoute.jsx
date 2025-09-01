// src/routes/PublicRoute.jsx
import { Navigate } from "react-router-dom";
import { useAuthState } from "react-firebase-hooks/auth";
import { auth } from "../services/firebase";

function PublicRoute({ children }) {
  const [user, loading] = useAuthState(auth);

  if (loading) return <p>Cargando...</p>;

  return !user ? children : <Navigate to="/dashboard" />;
}

export default PublicRoute;
