import { useState, useEffect } from "react";
import { Navigate } from "react-router-dom";
import { useAuthState } from "react-firebase-hooks/auth";
import { auth } from "../services/firebase";
import { UsuarioRepository } from "../features/usuarios/repositories/UsuarioRepository";
import { Roles } from "../features/usuarios/models/UsuarioRoles";

function PublicRoute({ children }) {
  const [userAuth, loadingAuth] = useAuthState(auth);
  const [loading, setLoading] = useState(true);
  const [esAdmin, setEsAdmin] = useState(false);

  useEffect(() => {
    const verificarUsuario = async () => {
      if (!userAuth) {
        setEsAdmin(false);
        setLoading(false);
        return;
      }

      try {
        const usuario = await UsuarioRepository.getUsuarioById(userAuth.uid);
        if (usuario && usuario.rol === Roles.ADMIN) {
          setEsAdmin(true); // Es admin, redirigir al dashboard
        } else {
          setEsAdmin(false); // No es admin, puede ver la ruta pública
        }
      } catch {
        await auth.signOut(); // Desconectar en caso de error
        setEsAdmin(false);
      } finally {
        setLoading(false);
      }
    };

    verificarUsuario();
  }, [userAuth]);

  if (loadingAuth || loading) return <p>Cargando...</p>;

  return esAdmin ? <Navigate to="/dashboard" replace /> : children;
}

export default PublicRoute;
