import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/core/themes/app_constants.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/presentation/widgets/clases_widget.dart';
import 'package:tutorconnect/presentation/widgets/perfil_usuario_widget.dart';
import 'package:tutorconnect/features/solicitud_estudiante/presentation/widgets/solicitud_tutoria_widget.dart';
import 'package:tutorconnect/features/tutorias/presentation/widgets/tutorias_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  void _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Cerrar Sesión')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
    }
  }

  List<Widget> _buildScreens(UsuarioModel? user) => [
        const TutoriasWidget(),
        if (user?.rol == UsuarioRol.estudiante) const SolicitudesTutoriasWidget(),
        user != null ? ClasesWidget(usuario: user) : const Center(child: Text("No hay usuario logueado")),
        user != null ? PerfilUsuarioWidget(usuario: user) : const Center(child: Text("No hay usuario logueado")),
      ];

  List<BottomNavigationBarItem> _buildNavItems(UsuarioModel? user) => [
        const BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Tutorías"),
        if (user?.rol == UsuarioRol.estudiante) const BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Solicitudes"),
        const BottomNavigationBarItem(icon: Icon(Icons.class_), label: "Clases"),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
      ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final screens = _buildScreens(user);
    final navItems = _buildNavItems(user);

    // Asegurarse de que el índice seleccionado sea válido
    if (_selectedIndex >= screens.length) _selectedIndex = 0;

    // Definir títulos por índice
    final List<String> titles = [
      "Tutorías",
      if (user?.rol == UsuarioRol.estudiante) "Solicitudes",
      "Clases",
      "Perfil",
    ];

return Scaffold(
  appBar: PreferredSize(
    preferredSize: const Size.fromHeight(64), // altura total del AppBar
    child: AppBar(
      backgroundColor: AppColors.primary, // <-- cambio de color
      elevation: 0,
      flexibleSpace: Padding(
        padding: const EdgeInsets.all( AppPaddingConstants.global ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            titles[_selectedIndex],
            style: TextStyle(
              color: Colors.white, // Para que contraste con el fondo primario
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      ],
    ),
  ),
  body: Padding(
    padding: const EdgeInsets.all(AppPaddingConstants.global),
    child: screens[_selectedIndex],
  ),
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: _selectedIndex,
    onTap: (index) => setState(() => _selectedIndex = index),
    items: navItems,
    type: BottomNavigationBarType.fixed,
  ),
);


  }
}
