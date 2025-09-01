export class TutoriaEstudiante {
  constructor({ id = '', tutoriaId, estudianteId }) {
    this.id = id;
    this.tutoriaId = tutoriaId;
    this.estudianteId = estudianteId;
  }

  static fromFirestore(doc) {
    const data = doc.data();
    return new TutoriaEstudiante({
      id: doc.id,
      tutoriaId: data.tutoriaId,
      estudianteId: data.estudianteId,
    });
  }

  toFirestore() {
    return {
      tutoriaId: this.tutoriaId,
      estudianteId: this.estudianteId,
    };
  }
}