import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/features/auth/presentation/screens/boton_restablecer_password.dart';
import 'package:tutorconnect/features/usuarios/presentation/widgets/info_academica_card.dart';
import 'package:tutorconnect/features/usuarios/presentation/widgets/perfil_card.dart';
import 'package:tutorconnect/features/matriculas/helpers/matricula_helper.dart';
import 'package:tutorconnect/features/matriculas/application/providers/matricula_provider.dart';
import 'package:tutorconnect/features/carreras/application/providers/carrera_provider.dart';
import 'package:tutorconnect/features/mallas_curriculares/application/providers/malla_curricular_provider.dart';
import 'package:tutorconnect/features/materias_malla/application/providers/materia_malla_provider.dart';

class PerfilUsuarioWidget extends ConsumerStatefulWidget {
  final UsuarioModel usuario;

  const PerfilUsuarioWidget({super.key, required this.usuario});

  @override
  ConsumerState<PerfilUsuarioWidget> createState() => _PerfilUsuarioWidgetState();
}

class _PerfilUsuarioWidgetState extends ConsumerState<PerfilUsuarioWidget> {
  List matriculas = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    // 🔹 Cargar toda la info académica aquí
    Future.microtask(() async {
      try {
        await ref.read(matriculaProvider.notifier).getAllMatriculas();
        await ref.read(carreraProvider.notifier).getAllCarreras();
        await ref.read(mallaCurricularProvider.notifier).getAllMallas();
        await ref.read(materiaMallaProvider.notifier).getAllMateriasMalla();

        final m = getAllMatriculasByEstudiante(ref, widget.usuario.id);
        setState(() {
          matriculas = m;
          loading = false;
        });
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PerfilCard(usuario: widget.usuario),

          if (widget.usuario.rol == UsuarioRol.estudiante)
            InfoAcademicaCard(
              matriculas: matriculas,
              loading: loading,
              error: error,
              ref: ref,
            ),

          const SizedBox(height: 16),
          BotonRestablecerContrasena(correo: widget.usuario.correo),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
