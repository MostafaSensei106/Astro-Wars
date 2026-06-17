import 'package:flutter/material.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('English'),
            trailing: const Icon(Icons.check, color: Colors.blue),
            onTap: () {},
          ),
          ListTile(title: const Text('العربية'), onTap: () {}),
        ],
      ),
    );
  }
}
