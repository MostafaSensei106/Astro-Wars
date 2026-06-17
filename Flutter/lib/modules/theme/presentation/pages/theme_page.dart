import 'package:flutter/material.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('System Default'),
            trailing: const Icon(Icons.check, color: Colors.blue),
            onTap: () {},
          ),
          ListTile(title: const Text('Light Theme'), onTap: () {}),
          ListTile(title: const Text('Dark Theme'), onTap: () {}),
        ],
      ),
    );
  }
}
