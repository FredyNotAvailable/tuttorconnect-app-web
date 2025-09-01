import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { Tutoria } from "../models/Tutoria";

const collectionRef = collection(db, "tutorias");

export const TutoriaDatasource = {
  getAllTutorias: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => Tutoria.fromFirestore(doc));
  },

  getTutoriaById: async (id) => {
    const docRef = doc(db, "tutorias", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return Tutoria.fromFirestore(snapshot);
  },

  createTutoria: async (tutoria) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, tutoria.toFirestore());
    tutoria.id = docRef.id;
    return tutoria;
  },

  updateTutoria: async (tutoria) => {
    const docRef = doc(db, "tutorias", tutoria.id);
    await setDoc(docRef, tutoria.toFirestore(), { merge: true });
    return tutoria;
  },

  deleteTutoria: async (id) => {
    const docRef = doc(db, "tutorias", id);
    await deleteDoc(docRef);
  },
};