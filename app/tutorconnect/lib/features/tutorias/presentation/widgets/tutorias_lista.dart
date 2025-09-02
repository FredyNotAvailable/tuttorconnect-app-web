// features/tutorias/presentation/widgets/tutorias_lista.dart
import 'package:flutter/material.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutoria_card.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class TutoriasLista extends StatelessWidget {
  final Map<String, List<TutoriaModel>> tutoriasPorMateria;
  final List<MateriaModel> materias;
  final List<UsuarioModel> usuarios;
  final void Function(TutoriaModel) onTap;

  const TutoriasLista({
    super.key,
    required this.tutoriasPorMateria,
    required this.materias,
    required this.usuarios,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tutoriasPorMateria.isEmpty) {
      return const Center(child: Text('No hay tutorías en el rango seleccionado'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: tutoriasPorMateria.entries.map((entry) {
        final materia = materias.firstWhere(
          (m) => m.id == entry.key,
          orElse: () => MateriaModel(id: '', nombre: 'Materia desconocida'),
        );
        final tutorias = entry.value;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                materia.nombre,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...tutorias.map((tutoria) {
                final docente = usuarios.firstWhere(
                  (u) => u.id == tutoria.profesorId,
                  orElse: () => UsuarioModel(
                    id: '',
                    nombreCompleto: 'Docente desconocido',
                    correo: '',
                    rol: UsuarioRol.docente,
                    fcmToken: '',
                  ),
                );

                return TutoriaCard(
                  tutoria: tutoria,
                  materia: materia,
                  docente: docente,
                  formatDate: (t) => t == null ? '-' : '${t.toDate().year}-${t.toDate().month}-${t.toDate().day}',
                  onTap: () => onTap(tutoria),
                );
              }).toList(),
            ],
          ),
        );
      }).toList(),
    );
  }
}
