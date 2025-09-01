// src/features/matriculas/datasources/MatriculaDatasource.js
import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { Matricula } from "../models/Matricula";

const collectionRef = collection(db, "matriculas");

export const MatriculaDatasource = {
  getAllMatriculas: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => new Matricula({ id: doc.id, ...doc.data() }));
  },

  getMatriculaById: async (id) => {
    const docRef = doc(db, "matriculas", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return new Matricula({ id: snapshot.id, ...snapshot.data() });
  },

  createMatricula: async (matricula) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, matricula.toFirestore());
    matricula.id = docRef.id;
    return matricula;
  },

  updateMatricula: async (matricula) => {
    const docRef = doc(db, "matriculas", matricula.id);
    await setDoc(docRef, matricula.toFirestore(), { merge: true });
    return matricula;
  },

  deleteMatricula: async (id) => {
    const docRef = doc(db, "matriculas", id);
    await deleteDoc(docRef);
  },
};