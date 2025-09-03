import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/core/themes/app_theme.dart';
import 'package:tutorconnect/features/auth/presentation/screens/auth_wrapper.dart';
import 'core/firebase/firebase_initializer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await FirebaseInitializer.initialize();
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      onGenerateRoute: AppRoutes.generateRoute,

      // 🔹 Soporte de localización
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés (fallback)
      ],

      // 🔹 Idioma por defecto en español
      locale: const Locale('es', 'ES'),
    );
  }
}