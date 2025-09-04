import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/materias/application/providers/materia_provider.dart';
import 'package:tutorconnect/features/tutoria_estudiante/application/providers/tutorias_estudiantes_provider.dart';
import 'package:tutorconnect/features/tutorias/application/providers/tutoria_provider.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutoria_actions.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutorias_filtro.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutorias_lista.dart';
import 'package:tutorconnect/features/usuarios/application/providers/usuario_provider.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutorias_status.dart';

class TutoriasWidget extends ConsumerStatefulWidget {
  const TutoriasWidget({super.key});

  @override
  ConsumerState<TutoriasWidget> createState() => _TutoriasWidgetState();
}

class _TutoriasWidgetState extends ConsumerState<TutoriasWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _datosCargados = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentUser = ref.read(authProvider).user;

    if (currentUser != null && !_datosCargados) {
      _datosCargados = true;
      Future.microtask(() async {
        await ref.read(tutoriaProvider.notifier).getAllTutorias();
        await ref.read(materiaProvider.notifier).getAllMaterias();
        await ref.read(usuarioProvider.notifier).getAllUsuarios();
        if (currentUser.rol == UsuarioRol.estudiante) {
          await ref.read(tutoriasEstudiantesProvider.notifier).getAllTutoriasEstudiantes();
        }
      });
    }
  }

  @override
Widget build(BuildContext context) {
  super.build(context);

  final tutoriaState = ref.watch(tutoriaProvider);
  final materiaState = ref.watch(materiaProvider);
  final usuarioState = ref.watch(usuarioProvider);
  final tutoriaEstudianteState = ref.watch(tutoriasEstudiantesProvider);
  final authState = ref.watch(authProvider);
  final currentUser = authState.user;

  if (currentUser == null) {
    return const Center(child: Text("No hay usuario logueado"));
  }

  final allTutorias = tutoriaState.tutorias ?? [];

  // 🔹 Filtrado según rol
  List<TutoriaModel> tutoriasFiltradas = [];
  if (currentUser.rol == UsuarioRol.docente) {
    tutoriasFiltradas =
        allTutorias.where((t) => t.profesorId == currentUser.id).toList();
  } else if (currentUser.rol == UsuarioRol.estudiante) {
    final tutoriasEstudiantes = tutoriaEstudianteState.tutoriasEstudiantes ?? [];
    final idsInscrito = tutoriasEstudiantes
        .where((te) => te.estudianteId == currentUser.id)
        .map((te) => te.tutoriaId)
        .toSet();
    tutoriasFiltradas =
        allTutorias.where((t) => idsInscrito.contains(t.id)).toList();
  }

  final tutoriasPorMateria = agruparTutoriasPorMateria<TutoriaModel, String>(
    items: tutoriasFiltradas,
    agruparPor: (t) => t.materiaId,
  );

  return Scaffold(
    body: RefreshIndicator(
      onRefresh: () async {
        // Recargar todos los datos necesarios
        try {
          await ref.read(tutoriaProvider.notifier).getAllTutorias();
          await ref.read(materiaProvider.notifier).getAllMaterias();
          await ref.read(usuarioProvider.notifier).getAllUsuarios();
          if (currentUser.rol == UsuarioRol.estudiante) {
            await ref.read(tutoriasEstudiantesProvider.notifier).getAllTutoriasEstudiantes();
          }
        } catch (e) {
          // Opcional: mostrar un SnackBar o manejar el error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al refrescar: $e')),
          );
        }
      },
      child: TutoriasStatus(
        loading: tutoriaState.loading ||
            materiaState.loading ||
            usuarioState.loading ||
            (currentUser.rol == UsuarioRol.estudiante
                ? tutoriaEstudianteState.loading
                : false),
        error: tutoriaState.error ??
            materiaState.error ??
            usuarioState.error ??
            tutoriaEstudianteState.error,
        child: tutoriasPorMateria.isEmpty
            ? const Center(child: Text('No hay tutorías disponibles'))
            : TutoriasLista(
                tutoriasPorMateria: tutoriasPorMateria,
                materias: materiaState.materias ?? [],
                usuarios: usuarioState.usuarios ?? [],
                onTap: (tutoria) =>
                    TutoriaActions.abrirDetalleTutoria(context, ref, tutoria),
              ),
      ),
    ),
    floatingActionButton: currentUser.rol == UsuarioRol.docente
        ? FloatingActionButton(
            onPressed: () => TutoriaActions.crearNuevaTutoria(context),
            tooltip: 'Crear nueva tutoría',
            child: const Icon(Icons.add),
          )
        : null,
  );
}

}
