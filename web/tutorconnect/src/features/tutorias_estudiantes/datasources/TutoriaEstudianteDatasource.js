import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { TutoriaEstudiante } from "../models/TutoriaEstudiante";

const collectionRef = collection(db, "tutorias_estudiantes");

export const TutoriaEstudianteDatasource = {
  getAllTutoriasEstudiantes: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => TutoriaEstudiante.fromFirestore(doc));
  },

  getTutoriaEstudianteById: async (id) => {
    const docRef = doc(db, "tutorias_estudiantes", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return TutoriaEstudiante.fromFirestore(snapshot);
  },

  createTutoriaEstudiante: async (tutoriaEstudiante) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, tutoriaEstudiante.toFirestore());
    tutoriaEstudiante.id = docRef.id;
    return tutoriaEstudiante;
  },

  updateTutoriaEstudiante: async (tutoriaEstudiante) => {
    const docRef = doc(db, "tutorias_estudiantes", tutoriaEstudiante.id);
    await setDoc(docRef, tutoriaEstudiante.toFirestore(), { merge: true });
    return tutoriaEstudiante;
  },

  deleteTutoriaEstudiante: async (id) => {
    const docRef = doc(db, "tutorias_estudiantes", id);
    await deleteDoc(docRef);
  },
};