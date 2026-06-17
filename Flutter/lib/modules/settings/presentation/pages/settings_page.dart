import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes_names.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => context.push(RoutesNames.profile),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            onTap: () => context.push(RoutesNames.theme),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            onTap: () => context.push(RoutesNames.language),
          ),
        ],
      ),
    );
  }
}
