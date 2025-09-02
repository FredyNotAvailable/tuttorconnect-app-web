import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/auth/presentation/actions/domain_validator.dart';
import 'package:tutorconnect/features/auth/presentation/modals/custom_status_modal.dart';

Future<void> iniciarSesion( BuildContext context, WidgetRef ref, String email, String password ) async {
  
  final authNotifier = ref.read(authProvider.notifier);

  // Validación de campos vacíos
  if (email.isEmpty || password.isEmpty) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CustomStatusModal(
        status: StatusModal.warning,
        message: 'Por favor ingresa tu correo y contraseña.',
      ),
    );
    return;
  }

  // Verificar que el correo termine en @uide.edu.ec
  if (!EmailDomainValidator.validate(email, EmailDomainType.uide)) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomStatusModal(
        status: StatusModal.warning,
        message: 'El correo debe ser institucional (${EmailDomainValidator.getDomain(EmailDomainType.uide)}).',
      ),
    );
    return;
  }


  // Verificar si el correo existe en la base de datos
  final emailExists = await authNotifier.checkEmailExists(email);
  if (!emailExists) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const CustomStatusModal(
        status: StatusModal.error,
        message: 'El correo electrónico no está registrado.',
      ),
    );
    return;
  }

  // Mostrar modal de carga
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const CustomStatusModal(
      status: StatusModal.loading,
      message: 'Iniciando sesión...',
    ),
  );

  // Intentar iniciar sesión
  await authNotifier.login(email, password);

  // Leer estado actualizado
  final updatedState = ref.read(authProvider);
  Navigator.of(context).pop(); // Cerrar modal de carga

  // Mostrar modal de éxito o error
  if (updatedState.error == null && updatedState.user != null) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const CustomStatusModal(
        status: StatusModal.success,
        message: '¡Has iniciado sesión correctamente!',
      ),
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomStatusModal(
        status: StatusModal.error,
        message: updatedState.error ?? 'Ocurrió un error inesperado.',
      ),
    );
  }
}

