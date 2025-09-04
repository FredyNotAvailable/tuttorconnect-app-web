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
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutoria_actions.dart';

class DetalleTutoriaScreen extends ConsumerWidget {
  final TutoriaModel tutoria;

  const DetalleTutoriaScreen({super.key, required this.tutoria});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;

    // Tutoría actualizada desde el estado
    final tutoriaState = ref.watch(tutoriaProvider);
    TutoriaModel currentTutoria = tutoriaState.tutorias?.firstWhere(
          (t) => t.id == tutoria.id,
          orElse: () => tutoria,
        ) ?? tutoria;

    // 🔹 Combinar fecha + hora de inicio y fin
    final fechaFirestore = currentTutoria.fecha.toDate();

    final inicioParts = currentTutoria.horaInicio.split(':');
    final horaInicio = int.parse(inicioParts[0]);
    final minutoInicio = int.parse(inicioParts[1]);

    final finParts = currentTutoria.horaFin.split(':');
    final horaFin = int.parse(finParts[0]);
    final minutoFin = int.parse(finParts[1]);

    final fechaInicio = DateTime(
      fechaFirestore.year,
      fechaFirestore.month,
      fechaFirestore.day,
      horaInicio,
      minutoInicio,
    );

    final fechaFin = DateTime(
      fechaFirestore.year,
      fechaFirestore.month,
      fechaFirestore.day,
      horaFin,
      minutoFin,
    );

    // 🔹 Hora actual en UTC-5 (Ecuador)
    final ahoraUTC5 = DateTime.now().toUtc().subtract(const Duration(hours: 5));

    // 🔹 Comparar con la hora de inicio y fin
    final isBeforeInicio = ahoraUTC5.isBefore(fechaInicio);

    // 🔹 Actualizar estado a finalizada si ya pasó la hora de fin y no está finalizada ni cancelada
    if (ahoraUTC5.isAfter(fechaFin) &&
        currentTutoria.estado != TutoriaEstado.finalizada &&
        currentTutoria.estado != TutoriaEstado.cancelada) {
      final updatedTutoria = currentTutoria.copyWith(
        estado: TutoriaEstado.finalizada,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(tutoriaProvider.notifier).updateTutoria(updatedTutoria);
      });
    }

    // Mostrar botones solo si corresponde
    final isDocente = currentUser?.rol == UsuarioRol.docente;

    // 🔹 Editar/Eliminar permitido si la tutoría aún no ha iniciado y no está cancelada
    final canEditOrDelete =
        isDocente && isBeforeInicio && currentTutoria.estado != TutoriaEstado.cancelada;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle de la Tutoría',
          style: AppTextStyles.heading2.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // 🔄 Recargar datos de la tutoría desde el provider
          await ref.read(tutoriaProvider.notifier).getAllTutorias();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                tutoria: currentTutoria,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: canEditOrDelete
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🗑️ Botón eliminar
                FloatingActionButton(
                  heroTag: "eliminarTutoria",
                  backgroundColor: AppColors.error,
                  child: const Icon(Icons.delete),
                  onPressed: () async {
                    await TutoriaActions.eliminarTutoria(
                      context,
                      ref,
                      currentTutoria,
                    );
                  },
                ),
                const SizedBox(width: 12),
                // ✏️ Botón editar
                FloatingActionButton(
                  heroTag: "editarTutoria",
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
                ),
              ],
            )
          : null,
    );
  }
}
