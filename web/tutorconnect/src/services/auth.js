// src/services/auth.js
import { auth } from "./firebase";
import { signInWithEmailAndPassword, signOut, sendPasswordResetEmail } from "firebase/auth";
import { UsuarioRepository } from "../features/usuarios/repositories/UsuarioRepository";
import { Roles } from "../features/usuarios/models/UsuarioRoles"
/**
 * Login con email y password
 */

export const login = async (email, password) => {
  try {
    // 1️⃣ Iniciar sesión
    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    const userAuth = userCredential.user;

    // 2️⃣ Obtener usuario desde Firestore
    const usuario = await UsuarioRepository.getUsuarioById(userAuth.uid);

    if (!usuario) {
      await signOut(auth); // 👈 cerrar sesión si no está en Firestore
      return { error: "Usuario no encontrado en la base de datos." };
    }

    // 3️⃣ Validar rol
    if (usuario.rol !== Roles.ADMIN) {
      await signOut(auth); // 👈 cerrar sesión si no es admin
      return { error: "No tienes permisos. Solo los administradores pueden ingresar." };
    }

    // 4️⃣ Retornar usuario válido
    return { user: usuario };

  } catch (error) {
    return { error: error.message };
  }
};

/**
 * Logout del usuario actual
 */
export const logout = async () => {
  try {
    await signOut(auth);
    return { success: true };
  } catch (error) {
    return { error: error.message };
  }
};

/**
 * Enviar email para restablecer contraseña
 */
export const sendPasswordReset = async (email) => {
  try {
    await sendPasswordResetEmail(auth, email);
    return { success: true };
  } catch (error) {
    return { error: error.message };
  }
};
