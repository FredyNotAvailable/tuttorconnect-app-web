import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:tutorconnect/features/auth/presentation/modals/custom_status_modal.dart';

class BotonRestablecerContrasena extends ConsumerWidget {
  final String correo;

  const BotonRestablecerContrasena({super.key, required this.correo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);
    final authRepository = authNotifier.repository;

    return ElevatedButton.icon(
      icon: const Icon(Icons.lock_reset),
      label: const Text('Restablecer contraseña'),
      onPressed: () async {
        final confirmar = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar acción'),
            content: Text('¿Deseas enviar un correo de restablecimiento a $correo?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );

        if (confirmar != true) return;

        try {
          // 🔹 Mostrar modal de carga
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const CustomStatusModal(
              status: StatusModal.loading,
              message: 'Enviando correo...',
            ),
          );

          // 🔹 Intentar enviar correo
          await authRepository.sendPasswordResetEmail(correo);

          // 🔹 Cerrar modal de carga
          if (Navigator.canPop(context)) Navigator.pop(context);

          // 🔹 Modal de éxito
          showDialog(
            context: context,
            builder: (_) => const CustomStatusModal(
              status: StatusModal.success,
              message: 'Correo de restablecimiento enviado correctamente.',
            ),
          );
        } on RepositoryException catch (e) {
          // 🔹 Cerrar modal de carga si hubo error
          if (Navigator.canPop(context)) Navigator.pop(context);

          String mensaje = e.message;
          if (mensaje.contains('requires-recent-login')) {
            mensaje = 'Para restablecer la contraseña, debes iniciar sesión nuevamente.';
          }

          // 🔹 Modal de error
          showDialog(
            context: context,
            builder: (_) => CustomStatusModal(
              status: StatusModal.error,
              message: mensaje,
            ),
          );
        } catch (e) {
          // 🔹 Cerrar modal de carga si hubo error
          if (Navigator.canPop(context)) Navigator.pop(context);

          showDialog(
            context: context,
            builder: (_) => CustomStatusModal(
              status: StatusModal.error,
              message: 'Error inesperado: $e',
            ),
          );
        }
      },
    );
  }
}
