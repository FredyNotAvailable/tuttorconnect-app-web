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
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/core/themes/app_text_styles.dart';

class PerfilUsuarioWidget extends ConsumerStatefulWidget {
  final UsuarioModel usuario;

  const PerfilUsuarioWidget({super.key, required this.usuario});

  @override
  ConsumerState<PerfilUsuarioWidget> createState() =>
      _PerfilUsuarioWidgetState();
}

class _PerfilUsuarioWidgetState extends ConsumerState<PerfilUsuarioWidget> {
  List matriculas = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
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

  void _mostrarModalRestablecer() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BotonRestablecerContrasena(correo: widget.usuario.correo),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Perfil del usuario con estilo moderno
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: PerfilCard(usuario: widget.usuario),
          ),

          const SizedBox(height: 16),

          // 🔹 Información académica (solo estudiantes)
          if (widget.usuario.rol == UsuarioRol.estudiante)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InfoAcademicaCard(
                matriculas: matriculas,
                loading: loading,
                error: error,
                ref: ref,
              ),
            ),

          const SizedBox(height: 24),

          // 🔹 Botón de restablecer contraseña con modal centrado
          ElevatedButton(
            onPressed: _mostrarModalRestablecer,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(172, 189, 2, 95),
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: AppTextStyles.button.copyWith(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Text("Restablecer Contraseña"),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
