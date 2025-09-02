import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/auth/presentation/modals/custom_status_modal.dart';

Future<void> resetPassword(
  BuildContext context,
  WidgetRef ref,
  String email,
) async {
  if (email.isEmpty) {
    // Mostrar advertencia si no se ingresó correo
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const CustomStatusModal(
        status: StatusModal.warning,
        message: 'Ingresa tu correo primero.',
      ),
    );
    return;
  }

  // Confirmación antes de enviar el correo
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Restablecer Contraseña'),
      content: const Text(
        '¿Estás seguro de que quieres enviar un correo para restablecer tu contraseña?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Enviar'),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  // Mostrar modal de carga
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const CustomStatusModal(
      status: StatusModal.loading,
      message: 'Enviando correo...',
    ),
  );

  final authNotifier = ref.read(authProvider.notifier);
  final success = await authNotifier.sendPasswordResetEmail(email);

  Navigator.of(context).pop(); // Cerrar modal de carga

  // Mostrar resultado
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => CustomStatusModal(
      status: success ? StatusModal.success : StatusModal.error,
      message: success
          ? 'Correo de recuperación enviado.'
          : 'Error al enviar el correo. Verifica el correo ingresado.',
    ),
  );
}
