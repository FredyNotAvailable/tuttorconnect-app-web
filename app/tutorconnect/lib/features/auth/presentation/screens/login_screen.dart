import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/constants/app_assets.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'login_form_fields.dart';
import 'login_actions.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.5,
              width: double.infinity,
              child: Image.asset(AppAssets.loginImage, fit: BoxFit.cover),
            ),
            SizedBox(
              height: screenHeight * 0.5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '¡Bienvenido/a! Por favor ingresa tus datos para iniciar sesión.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    LoginFormFields(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      toggleObscure: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => handleLogin(
                        context,
                        ref,
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      ),
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => handlePasswordReset(
                        context,
                        ref,
                        _emailController.text.trim(),
                      ),
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
