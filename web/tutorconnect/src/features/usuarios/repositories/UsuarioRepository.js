import { UsuarioDatasource } from "../datasources/UsuarioDatasource";
import { Usuario } from "../models/Usuario";
import { auth, firebaseConfig } from "../../../services/firebase";
import { createUserWithEmailAndPassword, getAuth } from "firebase/auth";
import { getApp, getApps, initializeApp } from "firebase/app";

export const UsuarioRepository = {
  getAllUsuarios: async () => {
    return await UsuarioDatasource.getAllUsuarios();
  },

  getUsuarioById: async (uid) => {
    return await UsuarioDatasource.getUsuarioById(uid);
  },

  createUsuario: async ({ nombreCompleto, correo, password, rol, fcmToken }) => {
    // 1️⃣ Crear usuario en Firebase Auth
    password = "password";
    
    const appName = "secondary";
    let secondaryApp;
    if (getApps().filter(app => app.name === appName).length === 0) {
      secondaryApp = initializeApp(firebaseConfig, appName);
    } else {
      secondaryApp = getApp(appName);
    }
    const secondaryAuth = getAuth(secondaryApp);

    const cred = await createUserWithEmailAndPassword(secondaryAuth, correo, password);
    const uid = cred.user.uid;

    // 2️⃣ Crear el objeto Usuario con UID generado
    const nuevoUsuario = new Usuario({
      id: uid,
      nombreCompleto,
      correo,
      rol,
      fcmToken: fcmToken || "",
    });

    // 3️⃣ Guardar en Firestore
    await UsuarioDatasource.createUsuario(nuevoUsuario);

    return nuevoUsuario;
  },

  updateUsuario: async ({ id, nombreCompleto, correo, rol, fcmToken }) => {
    const usuario = new Usuario({ id, nombreCompleto, correo, rol, fcmToken });
    await UsuarioDatasource.updateUsuario(usuario);
    return usuario;
  },

  deleteUsuario: async (uid) => {
    await UsuarioDatasource.deleteUsuario(uid);
  },
};
