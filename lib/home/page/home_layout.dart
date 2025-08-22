import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page = selectedIndex == 0 ? GeneratorPage() : FavoritesPage();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mainArea = ColoredBox(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: page,
            ),
          );

          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    currentIndex: selectedIndex,
                    onTap: (value) => setState(() => selectedIndex = value),
                    items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) => setState(() => selectedIndex = value),
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
                      NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
                    ],
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
