import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
import 'package:tutorconnect/features/usuarios/data/models/usuario.dart';
import 'package:tutorconnect/presentation/widgets/clases_widget.dart';
import 'package:tutorconnect/presentation/widgets/perfil_usuario_widget.dart';
import 'package:tutorconnect/presentation/widgets/solicitud_tutoria_widget.dart';
import 'package:tutorconnect/presentation/widgets/tutorias_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    // Definir pantallas y tabs según rol
    final List<Widget> screens = [
      const TutoriasWidget(),
      if (user?.rol == UsuarioRol.estudiante) const SolicitudesTutoriasWidget(),
      if (user != null)
        ClasesWidget(usuario: user)
      else
        const Center(child: Text("No hay usuario logueado")),
      if (user != null)
        PerfilUsuarioWidget(usuario: user)
      else
        const Center(child: Text("No hay usuario logueado")),
    ];

    final List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.menu_book),
        label: "Tutorías",
      ),
      if (user?.rol == UsuarioRol.estudiante)
        const BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: "Solicitudes",
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.class_),
        label: "Clases",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: "Perfil",
      ),
    ];

    // Asegurarse de que el índice seleccionado sea válido si el rol cambia
    if (_selectedIndex >= screens.length) _selectedIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TutorConnect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar Sesión'),
                  content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Cerrar Sesión'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref.read(authProvider.notifier).logout();
              }
            },
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: navItems,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
