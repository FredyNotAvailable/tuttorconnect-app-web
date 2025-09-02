import { useState, useEffect } from "react";
import { Navigate } from "react-router-dom";
import { useAuthState } from "react-firebase-hooks/auth";
import { auth } from "../services/firebase";
import { UsuarioRepository } from "../features/usuarios/repositories/UsuarioRepository";
import { Roles } from "../features/usuarios/models/UsuarioRoles";

function PrivateRoute({ children, rolRequerido = Roles.ADMIN }) {
  const [userAuth, loadingAuth] = useAuthState(auth);
  const [loading, setLoading] = useState(true);
  const [tieneAcceso, setTieneAcceso] = useState(false);

  useEffect(() => {
    const verificarUsuario = async () => {
      if (!userAuth) {
        setTieneAcceso(false);
        setLoading(false);
        return;
      }

      try {
        const usuario = await UsuarioRepository.getUsuarioById(userAuth.uid);
        if (!usuario || usuario.rol !== rolRequerido) {
          await auth.signOut(); // 👈 desconecta si no es admin
          setTieneAcceso(false);
        } else {
          setTieneAcceso(true);
        }
      } catch {
        await auth.signOut();
        setTieneAcceso(false);
      } finally {
        setLoading(false);
      }
    };

    verificarUsuario();
  }, [userAuth, rolRequerido]);

  if (loadingAuth || loading) return <p>Cargando...</p>;

  return tieneAcceso ? children : <Navigate to="/login" replace />;
}

export default PrivateRoute;
