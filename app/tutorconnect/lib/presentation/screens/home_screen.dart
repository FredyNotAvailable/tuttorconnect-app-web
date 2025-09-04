import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/core/routes/app_routes.dart';
import 'package:tutorconnect/core/themes/app_constants.dart';
import 'package:tutorconnect/core/themes/app_colors.dart';
import 'package:tutorconnect/core/themes/app_text_styles.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/presentation/clases/clases_widget.dart';
import 'package:tutorconnect/features/usuarios/presentation/widgets/perfil_usuario_widget.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cerrar Sesión', style: AppTextStyles.heading2),
        content: const Text(
          '¿Estás seguro de que quieres cerrar sesión?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text("Cerrar Sesión"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  List<Widget> _buildScreens(UsuarioModel? user) => [
    const TutoriasWidget(),
    if (user?.rol == UsuarioRol.estudiante) const SolicitudesTutoriasWidget(),
    user != null
        ? ClasesWidget(usuario: user)
        : const Center(child: Text("No hay usuario logueado")),
    user != null
        ? PerfilUsuarioWidget(usuario: user)
        : const Center(child: Text("No hay usuario logueado")),
  ];

  List<BottomNavigationBarItem> _buildNavItems(UsuarioModel? user) => [
    const BottomNavigationBarItem(
      icon: Icon(Icons.menu_book),
      label: "Tutorías",
    ),
    if (user?.rol == UsuarioRol.estudiante)
      const BottomNavigationBarItem(
        icon: Icon(Icons.assignment),
        label: "Solicitudes",
      ),
    const BottomNavigationBarItem(icon: Icon(Icons.class_), label: "Clases"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final screens = _buildScreens(user);
    final navItems = _buildNavItems(user);

    if (_selectedIndex >= screens.length) _selectedIndex = 0;

    final List<String> titles = [
      "Tutorías",
      if (user?.rol == UsuarioRol.estudiante) "Solicitudes",
      "Clases",
      "Perfil",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_selectedIndex],
          style: AppTextStyles.heading2.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Cerrar sesión",
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Padding(
          key: ValueKey(_selectedIndex),
          padding: const EdgeInsets.all(AppPaddingConstants.global),
          child: screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: navItems,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: AppTextStyles.body,
        unselectedLabelStyle: AppTextStyles.caption,
      ),
    );
  }
}
