import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { Materia } from "../models/Materia";

const collectionRef = collection(db, "materias");

export const MateriaDatasource = {
  getAllMaterias: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => new Materia({ id: doc.id, ...doc.data() }));
  },

  getMateriaById: async (id) => {
    const docRef = doc(db, "materias", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return new Materia({ id: snapshot.id, ...snapshot.data() });
  },

  createMateria: async (materia) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, { nombre: materia.nombre });
    materia.id = docRef.id;
    return materia;
  },

  updateMateria: async (materia) => {
    const docRef = doc(db, "materias", materia.id);
    await setDoc(docRef, { nombre: materia.nombre }, { merge: true });
    return materia;
  },

  deleteMateria: async (id) => {
    const docRef = doc(db, "materias", id);
    await deleteDoc(docRef);
  }
};
