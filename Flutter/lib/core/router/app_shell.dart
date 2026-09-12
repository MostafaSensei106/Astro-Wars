import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes_names.dart';

/// Bottom-navigation shell: Base / Hangar / Profile.
class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _indexFor(String path) {
    if (path.startsWith(RoutesNames.hangar)) return 1;
    if (path.startsWith(RoutesNames.profile)) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final index = _indexFor(path);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go(RoutesNames.base);
            case 1:
              context.go(RoutesNames.hangar);
            case 2:
              context.go(RoutesNames.profile);
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Base'),
          NavigationDestination(
            icon: Icon(Icons.rocket_launch_rounded),
            label: 'Hangar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Pilot',
          ),
        ],
      ),
    );
  }
}
