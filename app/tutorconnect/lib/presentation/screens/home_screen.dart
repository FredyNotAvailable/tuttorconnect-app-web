import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorconnect/features/auth/application/providers/auth_provider.dart';
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

    // Lista de pantallas que mostrará el bottom nav
    final List<Widget> _screens = [
      const TutoriasWidget(),
      const SolicitudesTutoriasWidget(),
      if (user != null)
        ClasesWidget(usuario: user)
      else
        const Center(child: Text("No hay usuario logueado")),
      if (user != null)
        PerfilUsuarioWidget(usuario: user)
      else
        const Center(child: Text("No hay usuario logueado")),
    ];

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
                  content: const Text(
                    '¿Estás seguro de que quieres cerrar sesión?',
                  ),
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

      // 👇 Pantalla seleccionada
      body: _screens[_selectedIndex],

      // 👇 Bottom Navigation Bar actualizado
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Tutorías",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Solicitudes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: "Clases",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
