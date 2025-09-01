// src/features/mallas_curriculares/datasources/MallaCurricularDatasource.js
import { db } from "../../../services/firebase";
import { collection, doc, getDocs, setDoc, deleteDoc } from "firebase/firestore";
import { MallaCurricular } from "../models/MallaCurricular";

const collectionRef = collection(db, "mallas_curriculares");

export const MallaCurricularDatasource = {
  getAllMallas: async () => {
    const snapshot = await getDocs(collectionRef);
    return snapshot.docs.map(doc => new MallaCurricular({ id: doc.id, ...doc.data() }));
  },

  getMallaById: async (id) => {
    const docRef = doc(db, "mallas_curriculares", id);
    const snapshot = await docRef.get();
    if (!snapshot.exists()) return null;
    return new MallaCurricular({ id: snapshot.id, ...snapshot.data() });
  },

  createMalla: async (malla) => {
    const docRef = doc(collectionRef); // genera ID automáticamente
    await setDoc(docRef, {
      carreraId: malla.carreraId,
      ciclo: malla.ciclo,
      anio: malla.anio,
    });
    malla.id = docRef.id;
    return malla;
  },

  updateMalla: async (malla) => {
    const docRef = doc(db, "mallas_curriculares", malla.id);
    await setDoc(docRef, {
      carreraId: malla.carreraId,
      ciclo: malla.ciclo,
      anio: malla.anio,
    }, { merge: true });
    return malla;
  },

  deleteMalla: async (id) => {
    const docRef = doc(db, "mallas_curriculares", id);
    await deleteDoc(docRef);
  },
};
