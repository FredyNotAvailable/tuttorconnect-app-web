import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';

enum ResetStatus { idle, loading, success, error }

class RestablecerPasswordModal extends ConsumerStatefulWidget {
  const RestablecerPasswordModal({super.key});

  @override
  ConsumerState<RestablecerPasswordModal> createState() => _PasswordResetModalState();
}

class _PasswordResetModalState extends ConsumerState<RestablecerPasswordModal> {
  final TextEditingController _emailController = TextEditingController();
  ResetStatus _status = ResetStatus.idle;
  String _message = "";

  Future<void> _handleSend() async {
    setState(() {
      _status = ResetStatus.loading;
      _message = "";
    });

    final email = _emailController.text.trim();

    try {
      // 👉 Verifica si existe en tu colección de usuarios
      final success = await ref.read(authProvider.notifier).sendPasswordResetEmail(email);

      if (!success) {
        setState(() {
          _status = ResetStatus.error;
          _message = "El correo no está registrado en la plataforma";
        });
        return;
      }

      setState(() {
        _status = ResetStatus.success;
        _message = "Correo de recuperación enviado";
      });
    } catch (e) {
      setState(() {
        _status = ResetStatus.error;
        _message = "Hubo un error al enviar el correo";
      });
    }
  }

  Widget _buildIcon() {
    switch (_status) {
      case ResetStatus.loading:
        return const CircularProgressIndicator(color: AppColors.primary);
      case ResetStatus.success:
        return const Icon(Icons.check_circle, color: Colors.green, size: 48);
      case ResetStatus.error:
        return const Icon(Icons.error, color: AppColors.error, size: 48);
      case ResetStatus.idle:
        return const SizedBox.shrink(); // Nada
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Restablecer contraseña",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          const SizedBox(height: 16),
          if (_status == ResetStatus.idle || _status == ResetStatus.error)
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Correo electrónico",
                border: OutlineInputBorder(),
              ),
            ),
          if (_message.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _status == ResetStatus.error ? AppColors.error : Colors.green,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
          child: const Text("Cancelar"),
        ),
        if (_status == ResetStatus.idle || _status == ResetStatus.error)
          ElevatedButton(
            onPressed: _handleSend,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text("Enviar"),
          ),
        if (_status == ResetStatus.success)
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text("Cerrar"),
          ),
      ],
    );
  }
}
