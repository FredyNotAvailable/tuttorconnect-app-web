import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { AsistenciaTutoria } from "../models/AsistenciaTutoria";

const collectionRef = collection(db, "asistencia_tutorias");

export const AsistenciaTutoriaDatasource = {
  getAllAsistenciaTutorias: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => AsistenciaTutoria.fromFirestore(doc));
  },

  getAsistenciaTutoriaById: async (id) => {
    const docRef = doc(db, "asistencia_tutorias", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return AsistenciaTutoria.fromFirestore(snapshot);
  },

  createAsistenciaTutoria: async (asistenciaTutoria) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, asistenciaTutoria.toFirestore());
    asistenciaTutoria.id = docRef.id;
    return asistenciaTutoria;
  },

  updateAsistenciaTutoria: async (asistenciaTutoria) => {
    const docRef = doc(db, "asistencia_tutorias", asistenciaTutoria.id);
    await setDoc(docRef, asistenciaTutoria.toFirestore(), { merge: true });
    return asistenciaTutoria;
  },

  deleteAsistenciaTutoria: async (id) => {
    const docRef = doc(db, "asistencia_tutorias", id);
    await deleteDoc(docRef);
  },
};