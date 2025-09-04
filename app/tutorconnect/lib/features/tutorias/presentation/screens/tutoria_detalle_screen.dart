import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/features/tutorias/application/providers/tutoria_provider.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/features/tutorias/presentation/screens/detalle_tutoria_widget.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/core/themes/app_text_styles.dart';

class DetalleTutoriaScreen extends ConsumerWidget {
  final TutoriaModel tutoria;

  const DetalleTutoriaScreen({super.key, required this.tutoria});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    // Tutoría actual
    final tutoriaState = ref.watch(tutoriaProvider);
    TutoriaModel currentTutoria =
        tutoriaState.tutorias?.firstWhere(
          (t) => t.id == tutoria.id,
          orElse: () => tutoria,
        ) ??
        tutoria;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle de la Tutoría',
          style: AppTextStyles.heading2.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AppColors.surface,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: DetalleTutoriaWidget(
              tutoria: currentTutoria, // Le pasamos directamente el model
            ),
          ),
        ),
      ),
      floatingActionButton:
          (currentUser?.rol == UsuarioRol.docente &&
              !DateTime.now().isAfter(
                DateTime(
                  currentTutoria.fecha.toDate().year,
                  currentTutoria.fecha.toDate().month,
                  currentTutoria.fecha.toDate().day,
                  int.parse(currentTutoria.horaFin.split(':')[0]),
                  int.parse(currentTutoria.horaFin.split(':')[1]),
                ),
              ) &&
              currentTutoria.estado != TutoriaEstado.cancelada)
          ? FloatingActionButton(
              backgroundColor: AppColors.secondary,
              child: const Icon(Icons.edit, color: AppColors.onSecondary),
              onPressed: () async {
                final updatedTutoria =
                    await Navigator.pushNamed(
                          context,
                          AppRoutes.editarTutoria,
                          arguments: currentTutoria,
                        )
                        as TutoriaModel?;

                if (updatedTutoria != null) {
                  ref
                      .read(tutoriaProvider.notifier)
                      .updateTutoria(updatedTutoria);
                }
              },
            )
          : null,
    );
  }
}
