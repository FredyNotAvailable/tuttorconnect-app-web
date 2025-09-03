import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/aulas/data/models/aula_model.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/presentation/screens/tutoria_detail_info.widget.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/aulas/application/providers/aula_provider.dart';
import 'package:tutorconnect/features/materias/application/providers/materia_provider.dart';
import 'package:tutorconnect/features/usuarios/application/providers/usuario_provider.dart';
import 'package:tutorconnect/features/asistencia_tutoria/data/models/asistencia_tutoria_model.dart';
import 'package:tutorconnect/features/asistencia_tutoria/application/providers/asistencia_tutoria_provider.dart';
import 'package:tutorconnect/features/tutoria_estudiante/application/providers/tutorias_estudiantes_provider.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';

class DetalleTutoriaWidget extends ConsumerStatefulWidget {
  final TutoriaModel tutoria;
  const DetalleTutoriaWidget({super.key, required this.tutoria});

  @override
  ConsumerState<DetalleTutoriaWidget> createState() => _DetalleTutoriaWidgetState();
}

class _DetalleTutoriaWidgetState extends ConsumerState<DetalleTutoriaWidget> {
  bool _datosCargados = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_datosCargados) {
      _datosCargados = true;

      // ⚡ Ejecutar después del build
      Future.microtask(() async {
        await ref.read(aulaProvider.notifier).getAllAulas();
        await ref.read(materiaProvider.notifier).getAllMaterias();
        await ref.read(usuarioProvider.notifier).getAllUsuarios();
        await ref.read(tutoriasEstudiantesProvider.notifier).getAllTutoriasEstudiantes();
        await ref.read(asistenciaTutoriaProvider.notifier).getAllAsistencias();
      });
    }
  }

@override
Widget build(BuildContext context) {
  final authState = ref.watch(authProvider);
  final currentUser = authState.user;
  final isDocente = currentUser?.rol == UsuarioRol.docente;

  // Providers
  final aulaState = ref.watch(aulaProvider);
  final materiaState = ref.watch(materiaProvider);
  final usuarioState = ref.watch(usuarioProvider);
  final tutoriasEstudiantesState = ref.watch(tutoriasEstudiantesProvider);
  final asistenciasState = ref.watch(asistenciaTutoriaProvider);

  if (currentUser == null) {
    return const Center(child: Text("No hay usuario logueado"));
  }

  final loading = aulaState.loading ||
      materiaState.loading ||
      usuarioState.loading ||
      tutoriasEstudiantesState.loading ||
      asistenciasState.loading;

  if (loading) {
    return const Center(child: CircularProgressIndicator());
  }

  // 🔹 Construir listas solo si hay datos
  final aula = aulaState.aulas?.firstWhere(
    (a) => a.id == widget.tutoria.aulaId,
    orElse: () => AulaModel(
      id: '',
      nombre: 'Desconocida',
      tipo: '',
      estado: AulaEstado.disponible,
    ),
  );

  final materia = materiaState.materias?.firstWhere(
    (m) => m.id == widget.tutoria.materiaId,
    orElse: () => MateriaModel(id: '', nombre: 'Desconocida'),
  );

  final profesor = usuarioState.usuarios?.firstWhere(
    (u) => u.id == widget.tutoria.profesorId,
    orElse: () => UsuarioModel(
      id: '',
      nombreCompleto: 'Docente desconocido',
      correo: '',
      rol: UsuarioRol.docente,
      fcmToken: '',
    ),
  );

  // 🔹 Estudiantes inscritos
  final estudiantes = (tutoriasEstudiantesState.tutoriasEstudiantes ?? [])
      .where((te) => te.tutoriaId == widget.tutoria.id)
      .map((te) => usuarioState.usuarios?.firstWhere(
            (u) => u.id == te.estudianteId,
            orElse: () => UsuarioModel(
              id: '',
              nombreCompleto: 'Estudiante desconocido',
              correo: '',
              rol: UsuarioRol.estudiante,
              fcmToken: '',
            ),
          ))
      .whereType<UsuarioModel>()
      .toList();


  // 🔹 Asistencias
  final Map<String, AsistenciaTutoriaModel> asistencias = {
    for (var a in asistenciasState.asistencias ?? [])
      if (a.tutoriaId == widget.tutoria.id) a.estudianteId: a
  };

  final ahora = DateTime.now();
  final horaFinParts = widget.tutoria.horaFin.split(':');
  final horaFin = DateTime(
    widget.tutoria.fecha.toDate().year,
    widget.tutoria.fecha.toDate().month,
    widget.tutoria.fecha.toDate().day,
    int.parse(horaFinParts[0]),
    int.parse(horaFinParts[1]),
  );
  final tutoriaTerminada = ahora.isAfter(horaFin) &&
      widget.tutoria.estado != TutoriaEstado.cancelada;

  return TutoriaDetailInfoWidget(
    tutoria: widget.tutoria,
    estudiantes: estudiantes,
    asistencias: asistencias,
    isDocente: isDocente,
    tutoriaTerminada: tutoriaTerminada,
    aulaNombre: aula?.nombre ?? 'Desconocida',
    aulaTipo: aula?.tipo ?? '',
    materiaNombre: materia?.nombre ?? 'Desconocida',
    profesorNombre: profesor?.nombreCompleto ?? 'Docente desconocido',
  );
}

  
}
