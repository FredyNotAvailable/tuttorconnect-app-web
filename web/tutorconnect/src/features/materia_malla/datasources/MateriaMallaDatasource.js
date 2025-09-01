// src/features/mallas_curriculares/datasources/MateriaMallaDatasource.js
import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { MateriaMalla } from "../models/MateriaMalla";

const collectionRef = collection(db, "materias_malla");

export const MateriaMallaDatasource = {
  getAllMateriasMalla: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => new MateriaMalla({ id: doc.id, ...doc.data() }));
  },

  getMateriaMallaById: async (id) => {
    const docRef = doc(db, "materias_malla", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return new MateriaMalla({ id: snapshot.id, ...snapshot.data() });
  },

  createMateriaMalla: async (materiaMalla) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, {
      mallaId: materiaMalla.mallaId,
      materiaId: materiaMalla.materiaId,
    });
    materiaMalla.id = docRef.id;
    return materiaMalla;
  },

  updateMateriaMalla: async (materiaMalla) => {
    const docRef = doc(db, "materias_malla", materiaMalla.id);
    await setDoc(docRef, {
      mallaId: materiaMalla.mallaId,
      materiaId: materiaMalla.materiaId,
    }, { merge: true });
    return materiaMalla;
  },

  deleteMateriaMalla: async (id) => {
    const docRef = doc(db, "materias_malla", id);
    await deleteDoc(docRef);
  },
};
