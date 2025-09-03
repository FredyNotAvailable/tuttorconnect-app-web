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
import 'package:tutorconnect/features/tutoria_estudiante/helper/tutoria_estudiante_helper.dart';
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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatos();
    });
  }

  void _cargarDatos() {
    ref.read(aulaProvider.notifier).getAllAulas();
    ref.read(horariosClasesProvider.notifier).getAllHorarios();
    ref.read(materiaProvider.notifier).getAllMaterias();
    ref.read(tutoriasEstudiantesProvider.notifier).getAllTutoriasEstudiantes();
    ref.read(usuarioProvider.notifier).getAllUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    final List<HorarioClaseModel> horarios = getHorariosByMateria(ref, widget.materia.id);
    final List<TutoriaModel> tutorias = getAllTutoriasByMateriaId(ref, widget.materia.id);
    final List<UsuarioModel> estudiantes = getAllEstudiantesByMateria(ref, widget.materia.id);

    final bool isDocente = currentUser?.rol == UsuarioRol.docente;
    final bool isEstudiante = currentUser?.rol == UsuarioRol.estudiante;

    return Scaffold(
      appBar: AppBar(title: Text(widget.materia.nombre)),
      body: ClaseDetalleInfoWidget(
        materia: widget.materia,
        horarios: horarios,
        tutorias: tutorias,
        estudiantes: estudiantes,
        isDocente: isDocente,
        isEstudiante: isEstudiante,
      ),
    );
  }
}
