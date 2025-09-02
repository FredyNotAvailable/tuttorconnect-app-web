import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/core/constants/app_assets.dart';
import 'package:tutorconnect/features_test/customModal.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    if (authState.lastAttemptedEmail != null) {
      _emailController.text = authState.lastAttemptedEmail!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final theme = Theme.of(context);

    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false, // Bloquea retroceso físico
      child: Scaffold(
        body: Column(
          children: [
            // Imagen superior con altura proporcional
            SizedBox(
              height: screenHeight * 0.5, // 40% de la pantalla
              width: double.infinity,
              child: Image.asset(
                AppAssets.loginImage,
                fit: BoxFit.cover,
              ),
            ),

            // Formulario
            SizedBox(
              height: screenHeight * 0.5, // 60% restante
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Mensaje de bienvenida
                    Text(
                      '¡Bienvenido/a! Por favor ingresa tus datos para iniciar sesión.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        labelStyle: theme.textTheme.bodyLarge,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: theme.textTheme.bodyLarge,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Botón Login


ElevatedButton(
  onPressed: () async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => CustomModal(
          type: ModalType.message,
          message: 'Por favor, ingresa tu email y contraseña.',
          acceptText: 'Aceptar',
        ),
      );
      return;
    }

    // Mostrar modal de loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CustomModal(
        type: ModalType.loading,
        message: 'Iniciando sesión...',
      ),
    );

    // Intentar login
    await authNotifier.login(email, password);

    // Obtener el estado actualizado después del login
    final updatedState = ref.read(authProvider);

    // Cerrar modal de loading
    Navigator.of(context).pop();

    // Mostrar resultado según estado actualizado
    if (updatedState.error == null && updatedState.user != null) {
      // Login exitoso
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
      // Error de login
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
  },
  child: const Text('Login'),
),


                    const SizedBox(height: 8),

                    // Recuperar contraseña
                    TextButton(
                      onPressed: () async {
                        if (_emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Ingresa tu email primero')),
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
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Enviar'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          final success = await authNotifier
                              .sendPasswordResetEmail(_emailController.text.trim());
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Correo de recuperación enviado')),
                            );
                          }
                        }
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
