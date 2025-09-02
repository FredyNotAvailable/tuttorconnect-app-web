import 'package:flutter/material.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback toggleObscure;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.toggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: 'Correo',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: theme.colorScheme.primary,
              ),
              onPressed: toggleObscure,
            ),
          ),
        ),
      ],
    );
  }
}
