import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/materias/application/providers/materia_provider.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
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

class _TutoriasWidgetState extends ConsumerState<TutoriasWidget> {

  @override
  Widget build(BuildContext context) {
    final tutoriaState = ref.watch(tutoriaProvider);
    final materiaState = ref.watch(materiaProvider);
    final usuarioState = ref.watch(usuarioProvider);
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    // Logs para depuración
    // ignore: avoid_print
    print('DEBUG: Tutorías cargadas: ${tutoriaState.tutorias?.length ?? 0}');
    // ignore: avoid_print
    print('DEBUG: Materias cargadas: ${materiaState.materias?.length ?? 0}');
    // ignore: avoid_print
    print('DEBUG: Usuarios cargados: ${usuarioState.usuarios?.length ?? 0}');


    // Obtengo todas las tutorias registradas en Firebase
    final allTutorias = tutoriaState.tutorias ?? [];

    // Filtrar por tutoria de docentes


    // Filtrar por tutoria de estudiante


    // Agrupar tutotorias pro materia ( Debo pasarle todas las tutorias filtradas por docente o estudiante )
    final tutoriasPorMateria = agruparTutoriasPorMateria<TutoriaModel, String>(
      items: allTutorias,
      agruparPor: (t) => t.materiaId,
    );

    // ignore: avoid_print
    print('DEBUG: Tutorías agrupadas por materia: ${tutoriasPorMateria.keys.length}');


    tutoriasPorMateria.forEach((materiaId, lista) {
      // Buscar el nombre de la materia correspondiente
      final materia = materiaState.materias!.firstWhere(
      (m) => m.id == materiaId,
      orElse: () => MateriaModel(id: materiaId, nombre: 'Desconocida'), // placeholder
    );

      final nombreMateria = materia.nombre;
      // ignore: avoid_print
      print('DEBUG: Materia: $nombreMateria, Tutorías: ${lista.length}');
    });

    return Scaffold(
      body: TutoriasStatus(
        loading: tutoriaState.loading || materiaState.loading || usuarioState.loading,
        error: tutoriaState.error ?? materiaState.error ?? usuarioState.error,
        child: tutoriasPorMateria.isEmpty
            ? const Center(child: Text('No hay tutorías disponibles'))
            : TutoriasLista(
                tutoriasPorMateria: tutoriasPorMateria,
                materias: materiaState.materias ?? [],
                usuarios: usuarioState.usuarios ?? [],
                onTap: (tutoria) => TutoriaActions.abrirDetalleTutoria(context, ref, tutoria),
              ),
      ),
      floatingActionButton: currentUser?.rol == UsuarioRol.docente
        ? FloatingActionButton(
            onPressed: () => TutoriaActions.crearNuevaTutoria(context),
            tooltip: 'Crear nueva tutoría',
            child: const Icon(Icons.add),
          ) : null,
    );
  }
}
