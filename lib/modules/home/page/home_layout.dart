import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/controller/auth_controller.dart';
import '../../../data/veterinaria/page/cita_page.dart';
import '../../../data/veterinaria/page/mascotacontroller_form_page.dart';
import 'home_page.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    late final Widget page;

    // Selección de página según el índice
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage(); // Página principal
        break;
      case 1:
        page = CitaPage(); // Página de citas
        break;
      case 2:
        page = MascotaScreenUnica(); // Página de mascotas
        break;
      default:
        page = GeneratorPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              // Confirmación antes de cerrar sesión
              final confirm = await Get.dialog<bool>(
                AlertDialog(
                  title: Text('Cerrar sesión'),
                  content: Text('¿Estás seguro de que deseas cerrar sesión?'),
                  actions: [
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () => Get.back(result: false),
                    ),
                    TextButton(
                      child: Text('Cerrar sesión'),
                      onPressed: () => Get.back(result: true),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await AuthController.instance.logout();
                Get.offAllNamed('/login');
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mainArea = ColoredBox(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: page,
            ),
          );

          // Pantallas pequeñas: BottomNavigationBar
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    currentIndex: selectedIndex,
                    onTap: (value) => setState(() => selectedIndex = value),
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.favorite), label: 'Citas'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.pets), label: 'Mascotas'),
                    ],
                  ),
                ),
              ],
            );
          }

          // Pantallas grandes: NavigationRail
          return Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) =>
                      setState(() => selectedIndex = value),
                  extended: constraints.maxWidth >= 600,
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(
                        icon: Icon(Icons.favorite), label: Text('Citas')),
                    NavigationRailDestination(
                        icon: Icon(Icons.pets), label: Text('Mascotas')),
                  ],
                ),
              ),
              Expanded(child: mainArea),
            ],
          );
        },
      ),
    );
  }
}
