// Feature/usuarios/datasources/UsuarioDatasource.js
import { collection, getDocs, doc, setDoc, deleteDoc, getDoc } from "firebase/firestore";
import { db } from "../../../services/firebase";
import { Usuario } from "../models/Usuario";

const usuariosRef = collection(db, "usuarios");

export const UsuarioDatasource = {
  // Obtener todos los usuarios
  getAllUsuarios: async () => {
    const snapshot = await getDocs(usuariosRef);
    return snapshot.docs.map(doc => Usuario.fromFirestore(doc));
  },

  // Obtener un usuario por UID
  getUsuarioById: async (uid) => {
    const docRef = doc(db, "usuarios", uid);
    const snapshot = await getDoc(docRef);
    if (!snapshot.exists()) return null;
    return Usuario.fromFirestore(snapshot);
  },

  // Crear un usuario (UID ya definido desde Firebase Auth)
  createUsuario: async (usuario) => {
    if (!usuario.id) throw new Error("El usuario debe tener un UID definido");
    const docRef = doc(db, "usuarios", usuario.id);
    await setDoc(docRef, usuario.toFirestore());
  },

  // Actualizar un usuario existente
  updateUsuario: async (usuario) => {
    if (!usuario.id) throw new Error("El usuario debe tener un UID definido");
    const docRef = doc(db, "usuarios", usuario.id);
    await setDoc(docRef, usuario.toFirestore(), { merge: true });
  },

  // Eliminar usuario por UID
  deleteUsuario: async (uid) => {
    const docRef = doc(db, "usuarios", uid);
    await deleteDoc(docRef);
  },
};
