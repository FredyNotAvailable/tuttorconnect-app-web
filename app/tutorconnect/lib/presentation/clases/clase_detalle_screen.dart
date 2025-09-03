import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/aulas/application/providers/aula_provider.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/horarios_clases/data/models/horario_clase_model.dart';
import 'package:tutorconnect/features/horarios_clases/helper/horario_helper.dart';
import 'package:tutorconnect/features/horarios_clases/application/providers/horarios_clases_provider.dart';
import 'package:tutorconnect/features/materias/application/providers/materia_provider.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/features/tutoria_estudiante/application/providers/tutorias_estudiantes_provider.dart';
import 'package:tutorconnect/features/tutoria_estudiante/data/models/tutoria_estudiante_model.dart';
import 'package:tutorconnect/features/tutoria_estudiante/helper/tutoria_estudiante_helper.dart';
import 'package:tutorconnect/features/tutorias/application/providers/tutoria_provider.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/helper/tutoria_helper.dart';
import 'package:tutorconnect/features/usuarios/application/providers/usuario_provider.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/presentation/clases/clase_detalle_info_widget.dart';

class ClaseDetalleScreen extends ConsumerStatefulWidget {
  final MateriaModel materia;

  const ClaseDetalleScreen({super.key, required this.materia});

  @override
  ConsumerState<ClaseDetalleScreen> createState() => _ClaseDetailScreenState();
}

class _ClaseDetailScreenState extends ConsumerState<ClaseDetalleScreen> {
  bool loading = true;
  String? error;

  List<TutoriaModel> tutoriasFiltradas = [];
  List<HorarioClaseModel> horarios = [];
  List<UsuarioModel> estudiantes = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_cargarDatos);
  }

  /// Filtra todas las tutorías estudiante por materia
  List<TutoriaEstudianteModel> _getAllTutoriasEstudiantesByMateria(String materiaId) {
    final allTutoriasEstudiantes =
        ref.read(tutoriasEstudiantesProvider).tutoriasEstudiantes ?? [];
    final allTutorias = ref.read(tutoriaProvider).tutorias ?? [];

    final tutoriaIdsMateria =
        allTutorias.where((t) => t.materiaId == materiaId).map((t) => t.id).toSet();

    return allTutoriasEstudiantes
        .where((te) => tutoriaIdsMateria.contains(te.tutoriaId))
        .toList();
  }

  Future<void> _cargarDatos() async {
    try {
      await ref.read(aulaProvider.notifier).getAllAulas();
      await ref.read(horariosClasesProvider.notifier).getAllHorarios();
      await ref.read(materiaProvider.notifier).getAllMaterias();
      await ref.read(tutoriasEstudiantesProvider.notifier).getAllTutoriasEstudiantes();
      await ref.read(usuarioProvider.notifier).getAllUsuarios();
      await ref.read(tutoriaProvider.notifier).getAllTutorias();

      final authState = ref.read(authProvider);
      final currentUser = authState.user;

      final allTutorias = getAllTutoriasByMateriaId(ref, widget.materia.id);
      final allTutoriasEstudiantes = _getAllTutoriasEstudiantesByMateria(widget.materia.id);

      if (currentUser?.rol == UsuarioRol.docente) {
        tutoriasFiltradas = allTutorias.where((t) => t.profesorId == currentUser!.id).toList();
      } else if (currentUser?.rol == UsuarioRol.estudiante) {
        final tutoriaIds = allTutoriasEstudiantes
            .where((te) => te.estudianteId == currentUser!.id)
            .map((te) => te.tutoriaId)
            .toSet();
        tutoriasFiltradas = allTutorias.where((t) => tutoriaIds.contains(t.id)).toList();
      }

      horarios = getHorariosByMateria(ref, widget.materia.id);
      estudiantes = getAllEstudiantesByMateria(ref, widget.materia.id);

      setState(() => loading = false);
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    final isDocente = currentUser?.rol == UsuarioRol.docente;
    final isEstudiante = currentUser?.rol == UsuarioRol.estudiante;

    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null) return Scaffold(body: Center(child: Text('Error: $error')));

    return Scaffold(
      appBar: AppBar(title: Text(widget.materia.nombre)),
      body: ClaseDetalleInfoWidget(
        materia: widget.materia,
        horarios: horarios,
        tutorias: tutoriasFiltradas,
        estudiantes: estudiantes,
        isDocente: isDocente,
        isEstudiante: isEstudiante,
      ),
    );
  }
}

