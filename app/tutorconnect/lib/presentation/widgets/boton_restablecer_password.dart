import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/auth/data/repositories_impl/auth_repository_impl.dart';

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
          await authRepository.sendPasswordResetEmail(correo);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Correo de restablecimiento enviado.')),
          );
        } on RepositoryException catch (e) {
          String mensaje = e.message;
          if (mensaje.contains('requires-recent-login')) {
            mensaje = 'Para restablecer la contraseña, debes iniciar sesión nuevamente.';
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      },
    );
  }
}
