import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { SolicitudTutoria } from "../models/SolicitudTutoria";

const collectionRef = collection(db, "solicitudes_tutorias");

export const SolicitudTutoriaDatasource = {
  getAllSolicitudesTutorias: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => SolicitudTutoria.fromFirestore(doc));
  },

  getSolicitudTutoriaById: async (id) => {
    const docRef = doc(db, "solicitudes_tutorias", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return SolicitudTutoria.fromFirestore(snapshot);
  },

  createSolicitudTutoria: async (solicitudTutoria) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, solicitudTutoria.toFirestore());
    solicitudTutoria.id = docRef.id;
    return solicitudTutoria;
  },

  updateSolicitudTutoria: async (solicitudTutoria) => {
    const docRef = doc(db, "solicitudes_tutorias", solicitudTutoria.id);
    await setDoc(docRef, solicitudTutoria.toFirestore(), { merge: true });
    return solicitudTutoria;
  },

  deleteSolicitudTutoria: async (id) => {
    const docRef = doc(db, "solicitudes_tutorias", id);
    await deleteDoc(docRef);
  },
};