import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/features/aulas/helpers/aula_helper.dart';
import 'package:tutorconnect/features/horarios_clases/data/models/horario_clase_model.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutoria_card.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutoria_fecha_filtro_ui_widget.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/usuarios/helpers/usuario_helper.dart';

class ClaseDetalleInfoWidget extends ConsumerStatefulWidget {
  final MateriaModel materia;
  final List<HorarioClaseModel> horarios;
  final List<TutoriaModel> tutorias;
  final List<UsuarioModel> estudiantes;
  final bool isDocente;
  final bool isEstudiante;

  const ClaseDetalleInfoWidget({
    super.key,
    required this.materia,
    required this.horarios,
    required this.tutorias,
    required this.estudiantes,
    required this.isDocente,
    required this.isEstudiante,
  });

  @override
  ConsumerState<ClaseDetalleInfoWidget> createState() => _ClaseDetalleInfoWidgetState();
}

class _ClaseDetalleInfoWidgetState extends ConsumerState<ClaseDetalleInfoWidget> {
  DateTimeRange? rangoSeleccionado;

  @override
  Widget build(BuildContext context) {
    // 🔹 Aplicar filtro de fechas si se selecciona rango
    final tutoriasFiltradas = widget.tutorias.where((t) {
      final fecha = t.fecha.toDate();
      if (rangoSeleccionado != null) {
        return fecha.isAfter(rangoSeleccionado!.start.subtract(const Duration(seconds: 1))) &&
               fecha.isBefore(rangoSeleccionado!.end.add(const Duration(days: 1)));
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Materia
          Text(
            widget.materia.nombre,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Horarios
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: widget.horarios.isEmpty
                  ? Text(
                      'No hay horarios asignados.',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Horarios',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        ...widget.horarios.map((horario) {
                          final aula = getAulaById(ref, horario.aulaId);
                          final profesor = getUsuarioById(ref, horario.profesorId);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '📅 ${horario.diaSemana.name.toUpperCase()}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('🕒 ${horario.horaInicio} - ${horario.horaFin}'),
                                Text('🏫 Aula: ${aula.nombre} - ${aula.tipo}'),
                                if (widget.isEstudiante)
                                  Text('👨‍🏫 Profesor: ${profesor.nombreCompleto}'),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Estudiantes
          if (widget.isDocente)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: widget.estudiantes.isEmpty
                    ? Text('No hay estudiantes inscritos.',
                        style: TextStyle(color: Theme.of(context).hintColor))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estudiantes inscritos',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          ...widget.estudiantes.map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.person, size: 18),
                                  const SizedBox(width: 8),
                                  Text(e.nombreCompleto),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          if (widget.isDocente) const SizedBox(height: 20),

          // 🔹 Tutorías
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: tutoriasFiltradas.isEmpty
                  ? Text(
                      'No hay tutorías asignadas.',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Filtro de fechas
                        TutoriaFechaFiltroUiWidget(
                          rangoSeleccionado: rangoSeleccionado,
                          onChanged: (rango) {
                            setState(() {
                              rangoSeleccionado = rango;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Tutorías',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        ...tutoriasFiltradas.map((tutoria) {
                          final docente = getUsuarioById(ref, tutoria.profesorId);
                          final materia = getMateriaById(ref, tutoria.materiaId);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TutoriaCard(
                              tutoria: tutoria,
                              docente: docente,
                              materia: materia,
                              formatDate: (timestamp) => timestamp != null
                                  ? DateFormat('dd/MM/yyyy').format(timestamp.toDate())
                                  : '',
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.detalleTutoria,
                                arguments: tutoria,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
