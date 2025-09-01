import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { Carrera } from "../models/Carrera";

const collectionRef = collection(db, "carreras");

export const CarreraDatasource = {
  getAllCarreras: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => new Carrera({ id: doc.id, ...doc.data() }));
  },

  getCarreraById: async (id) => {
    const docRef = doc(db, "carreras", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return new Carrera({ id: snapshot.id, ...snapshot.data() });
  },

  createCarrera: async (carrera) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, { nombre: carrera.nombre });
    carrera.id = docRef.id;
    return carrera;
  },

  updateCarrera: async (carrera) => {
    const docRef = doc(db, "carreras", carrera.id);
    await setDoc(docRef, { nombre: carrera.nombre }, { merge: true });
    return carrera;
  },

  deleteCarrera: async (id) => {
    const docRef = doc(db, "carreras", id);
    await deleteDoc(docRef);
  }
};
