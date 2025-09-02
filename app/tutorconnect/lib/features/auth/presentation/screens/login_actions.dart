import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features_test/customModal.dart';

Future<void> handleLogin(
  BuildContext context,
  WidgetRef ref,
  String email,
  String password,
) async {
  final authNotifier = ref.read(authProvider.notifier);

  if (email.isEmpty || password.isEmpty) {
    showDialog(
      context: context,
      builder: (_) => CustomModal(
        type: ModalType.message,
        message: 'Por favor, ingresa tu email y contraseña.',
        acceptText: 'Aceptar',
      ),
    );
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const CustomModal(
      type: ModalType.loading,
      message: 'Iniciando sesión...',
    ),
  );

  await authNotifier.login(email, password);
  final updatedState = ref.read(authProvider);
  Navigator.of(context).pop();

  if (updatedState.error == null && updatedState.user != null) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const CustomModal(
        type: ModalType.success,
        message: '¡Has iniciado sesión correctamente!',
        acceptText: 'Aceptar',
      ),
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomModal(
        type: ModalType.error,
        message: updatedState.error ?? 'Ocurrió un error inesperado.',
        acceptText: 'Aceptar',
      ),
    );
  }
}

Future<void> handlePasswordReset(
  BuildContext context,
  WidgetRef ref,
  String email,
) async {
  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ingresa tu email primero')),
    );
    return;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Restablecer Contraseña'),
      content: const Text(
          '¿Estás seguro de que quieres enviar un correo para restablecer tu contraseña?'),
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

  final authNotifier = ref.read(authProvider.notifier);
  final success = await authNotifier.sendPasswordResetEmail(email);
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Correo de recuperación enviado')),
    );
  }
}

