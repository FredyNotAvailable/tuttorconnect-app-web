import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/mallas_curriculares/application/providers/malla_curricular_provider.dart';
import 'package:tutorconnect/features/materias/application/providers/materia_provider.dart';
import 'package:tutorconnect/features/materias/helpers/materia_helper.dart';
import 'package:tutorconnect/features/materias_malla/application/providers/materia_malla_provider.dart';
import 'package:tutorconnect/features/matriculas/application/providers/matricula_provider.dart';
import 'package:tutorconnect/features/matriculas/helpers/matricula_helper.dart';
import 'package:tutorconnect/features/profesores_materias/application/providers/profesor_materia_provider.dart';
import 'package:tutorconnect/features/usuarios/application/providers/usuario_provider.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/profesores_materias/helpers/profesor_materia_helper.dart';
import 'package:tutorconnect/features/profesores_materias/data/models/profesor_materia_model.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/presentation/clases/clase_card.dart';

class ClasesWidget extends ConsumerStatefulWidget {
  final UsuarioModel usuario;

  const ClasesWidget({super.key, required this.usuario});

  @override
  ConsumerState<ClasesWidget> createState() => _ClasesWidgetState();
}

class _ClasesWidgetState extends ConsumerState<ClasesWidget> {
  @override
  void initState() {
    super.initState();
    // ⚡ Cargar datos después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatos();
    });
  }

  void _cargarDatos() {
    // Llamadas directas a los providers
    ref.read(usuarioProvider.notifier).getAllUsuarios();
    ref.read(matriculaProvider.notifier).getAllMatriculas();
    ref.read(mallaCurricularProvider.notifier).getAllMallas();
    ref.read(materiaMallaProvider.notifier).getAllMateriasMalla();
    ref.read(materiaProvider.notifier).getAllMaterias();
    ref.read(profesorMateriaProvider.notifier).getAllProfesoresMaterias();
  }

  @override
  Widget build(BuildContext context) {
    List<MateriaModel> materias = [];

    if (widget.usuario.rol == UsuarioRol.estudiante) {
      materias = getMateriasByEstudianteId(ref, widget.usuario.id);
    } else if (widget.usuario.rol == UsuarioRol.docente) {
      final List<ProfesorMateriaModel> relaciones =
          getMateriasByProfesorId(ref, widget.usuario.id);
      materias = relaciones.map((r) => getMateriaById(ref, r.materiaId)).toList();
    } else {
      return const Center(child: Text('Rol no reconocido'));
    }

    if (materias.isEmpty) {
      return Center(
        child: Text(
          widget.usuario.rol == UsuarioRol.estudiante
              ? 'No tienes clases asignadas'
              : 'No dictas materias asignadas',
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: materias.length,
      itemBuilder: (context, index) {
        final materia = materias[index];
        return ClaseCard(materia: materia);
      },
    );
  }
}
