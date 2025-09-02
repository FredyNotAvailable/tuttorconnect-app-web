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
          labelStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
          filled: true,
          fillColor: theme.colorScheme.surface.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: passwordController,
        obscureText: obscurePassword,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
          filled: true,
          fillColor: theme.colorScheme.surface.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
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
