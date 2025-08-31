// lib/app/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:tutorconnect/features/auth/presentation/screens/login_screen.dart';
import 'package:tutorconnect/presentation/screens/home_screen.dart';
import 'package:tutorconnect/presentation/screens/clase_detalle_screen.dart';
import 'package:tutorconnect/features/materias/data/models/materia_model.dart';
import 'package:tutorconnect/presentation/screens/crear_tutoria_screen.dart';
import 'package:tutorconnect/features/tutorias/data/models/tutoria_model.dart';
import 'package:tutorconnect/presentation/screens/tutoria_detalle_screen.dart';
import 'package:tutorconnect/presentation/screens/tutoria_editar_screen.dart'; // 🔹 Importa la pantalla de edición

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String perfilUsuario = '/perfilUsuario';
  static const String claseDetalle = '/claseDetalle';
  static const String crearTutoria = '/crearTutoria';
  static const String detalleTutoria = '/detalleTutoria';
  static const String editarTutoria = '/editarTutoria'; // 🔹 Nueva ruta

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case claseDetalle:
        final materia = settings.arguments as MateriaModel;
        return MaterialPageRoute(
          builder: (_) => ClaseDetalleScreen(materia: materia),
        );

      case crearTutoria:
        return MaterialPageRoute(
          builder: (_) => const CrearTutoriaScreen(),
        );

      case detalleTutoria:
        final tutoria = settings.arguments as TutoriaModel;
        return MaterialPageRoute(
          builder: (_) => DetalleTutoriaScreen(tutoria: tutoria),
        );

      case editarTutoria: // 🔹 Nueva ruta de edición
        final tutoria = settings.arguments as TutoriaModel;
        return MaterialPageRoute(
          builder: (_) => EditarTutoriaScreen(tutoria: tutoria),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Ruta no encontrada')),
      ),
    );
  }
}
