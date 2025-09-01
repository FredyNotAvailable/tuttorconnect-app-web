// src/features/profesores_materias/datasources/ProfesorMateriaDatasource.js
import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { ProfesorMateria } from "../models/ProfesorMateria";

const collectionRef = collection(db, "profesores_materias");

export const ProfesorMateriaDatasource = {
  getAllProfesoresMaterias: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => new ProfesorMateria({ id: doc.id, ...doc.data() }));
  },

  getProfesorMateriaById: async (id) => {
    const docRef = doc(db, "profesores_materias", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return new ProfesorMateria({ id: snapshot.id, ...snapshot.data() });
  },

  createProfesorMateria: async (profesorMateria) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, {
      profesorId: profesorMateria.profesorId,
      materiaId: profesorMateria.materiaId,
    });
    profesorMateria.id = docRef.id;
    return profesorMateria;
  },

  updateProfesorMateria: async (profesorMateria) => {
    const docRef = doc(db, "profesores_materias", profesorMateria.id);
    await setDoc(docRef, {
      profesorId: profesorMateria.profesorId,
      materiaId: profesorMateria.materiaId,
    }, { merge: true });
    return profesorMateria;
  },

  deleteProfesorMateria: async (id) => {
    const docRef = doc(db, "profesores_materias", id);
    await deleteDoc(docRef);
  },
};