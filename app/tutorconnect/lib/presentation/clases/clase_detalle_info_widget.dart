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
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/usuarios/helpers/usuario_helper.dart';

class ClaseDetalleInfoWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(materia.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),

          // 🔹 Horarios
          if (horarios.isEmpty)
            const Text('No hay horarios asignados.')
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: horarios.map((horario) {
                final aula = getAulaById(ref, horario.aulaId);
                final profesor = getUsuarioById(ref, horario.profesorId);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Día: ${horario.diaSemana.name.toUpperCase()}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('Hora: ${horario.horaInicio} - ${horario.horaFin}',
                          style: const TextStyle(fontSize: 14)),
                      Text('Aula: ${aula.nombre} - ${aula.tipo}', style: const TextStyle(fontSize: 14)),
                      if (isEstudiante)
                        Text('Profesor: ${profesor.nombreCompleto}', style: const TextStyle(fontSize: 14)),
                      const Divider(),
                    ],
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 16),

          // 🔹 Estudiantes (solo si es docente)
          if (isDocente) ...[
            const Text('Estudiantes inscritos:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (estudiantes.isEmpty)
              const Text('No hay estudiantes inscritos.')
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: estudiantes
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(e.nombreCompleto, style: const TextStyle(fontSize: 14)),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 16),
          ],

        if (tutorias.isEmpty)
          const Text('No hay tutorías asignadas.')
        else
          Column(
            children: tutorias.map((tutoria) {
              final docente = getUsuarioById(ref, tutoria.profesorId);
              final materia = getMateriaById(ref, tutoria.materiaId); // si quieres mostrar info de la materia
              return TutoriaCard(
                tutoria: tutoria,
                docente: docente,
                materia: materia,
                formatDate: (timestamp) => timestamp != null ? DateFormat('dd/MM/yyyy').format(timestamp.toDate()) : '',
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.detalleTutoria,
                  arguments: tutoria,
                ),
              );
            }).toList(),
          ),

        ],
      ),
    );
  }
}
