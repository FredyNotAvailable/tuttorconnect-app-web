// src/features/horarios_clases/datasources/HorarioClaseDatasource.js
import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { HorarioClase } from "../models/HorarioClase";

const collectionRef = collection(db, "horarios_clases");

export const HorarioClaseDatasource = {
  getAllHorariosClases: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => new HorarioClase({ id: doc.id, ...doc.data() }));
  },

  getHorarioClaseById: async (id) => {
    const docRef = doc(db, "horarios_clases", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return new HorarioClase({ id: snapshot.id, ...snapshot.data() });
  },

  createHorarioClase: async (horarioClase) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, horarioClase.toFirestore());
    horarioClase.id = docRef.id;
    return horarioClase;
  },

  updateHorarioClase: async (horarioClase) => {
    const docRef = doc(db, "horarios_clases", horarioClase.id);
    await setDoc(docRef, horarioClase.toFirestore(), { merge: true });
    return horarioClase;
  },

  deleteHorarioClase: async (id) => {
    const docRef = doc(db, "horarios_clases", id);
    await deleteDoc(docRef);
  },
};