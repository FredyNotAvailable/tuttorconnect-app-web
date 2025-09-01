// src/features/aulas/datasources/AulaDatasource.js
import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { Aula } from "../models/Aula";

const collectionRef = collection(db, "aulas");

export const AulaDatasource = {
  getAllAulas: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => new Aula({ id: doc.id, ...doc.data() }));
  },

  getAulaById: async (id) => {
    const docRef = doc(db, "aulas", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return new Aula({ id: snapshot.id, ...snapshot.data() });
  },

  createAula: async (aula) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, aula.toFirestore());
    aula.id = docRef.id;
    return aula;
  },

  updateAula: async (aula) => {
    const docRef = doc(db, "aulas", aula.id);
    await setDoc(docRef, aula.toFirestore(), { merge: true });
    return aula;
  },

  deleteAula: async (id) => {
    const docRef = doc(db, "aulas", id);
    await deleteDoc(docRef);
  },
};