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
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    // 🔹 Cargar todos los datos apenas inicia el widget
    Future.microtask(() async {
      try {
        await ref.read(usuarioProvider.notifier).getAllUsuarios();
        await ref.read(matriculaProvider.notifier).getAllMatriculas();
        await ref.read(mallaCurricularProvider.notifier).getAllMallas();
        await ref.read(materiaMallaProvider.notifier).getAllMateriasMalla();
        await ref.read(materiaProvider.notifier).getAllMaterias();
        await ref.read(profesorMateriaProvider.notifier).getAllProfesoresMaterias();
        setState(() => loading = false);
      } catch (e) {
        setState(() {
          error = e.toString();
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text('Error: $error'));

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
