// features/tutorias/presentation/widgets/tutorias_lista.dart
import 'package:flutter/material.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutoria_card.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutoria_fecha_filtro_ui_widget.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';

class TutoriasLista extends StatefulWidget {
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
  State<TutoriasLista> createState() => _TutoriasListaState();
}

class _TutoriasListaState extends State<TutoriasLista> {
  DateTimeRange? _rangoSeleccionado;


@override
Widget build(BuildContext context) {
  // Filtrar las tutorías según el rango seleccionado
  Map<String, List<TutoriaModel>> tutoriasFiltradas = {};

  widget.tutoriasPorMateria.forEach((materiaId, tutorias) {
    final filtradas = _rangoSeleccionado == null
        ? tutorias
        : tutorias.where((t) {
            final fecha = t.fecha.toDate();
            return !fecha.isBefore(_rangoSeleccionado!.start) &&
                   !fecha.isAfter(_rangoSeleccionado!.end);
          }).toList();

    if (filtradas.isNotEmpty) {
      tutoriasFiltradas[materiaId] = filtradas;
    }
  });

  return Column(
    children: [
      // 🔹 Filtro siempre visible
      Padding(
        padding: const EdgeInsets.all(16),
        child: TutoriaFechaFiltroUiWidget(
          rangoSeleccionado: _rangoSeleccionado,
          onChanged: (nuevoRango) {
            setState(() {
              _rangoSeleccionado = nuevoRango;
            });
          },
        ),
      ),

      // 🔹 Lista de tutorías o mensaje si no hay
      Expanded(
        child: tutoriasFiltradas.isEmpty
            ? const Center(child: Text('No hay tutorías en el rango seleccionado'))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: tutoriasFiltradas.entries.map((entry) {
                  final materia = widget.materias.firstWhere(
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
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...tutorias.map((tutoria) {
                          final docente = widget.usuarios.firstWhere(
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
                            formatDate: (t) => t == null
                                ? '-'
                                : '${t.toDate().year}-${t.toDate().month}-${t.toDate().day}',
                            onTap: () => widget.onTap(tutoria),
                          );
                        }),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
    ],
  );
}



}
