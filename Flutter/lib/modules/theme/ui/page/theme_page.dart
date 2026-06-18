import 'package:flutter/material.dart';
import '../../../../core/widgets/neu_widgets.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  int _selectedThemeIndex = 0;

  final List<Map<String, dynamic>> _themes = [
    {
      'name': 'Deep Space',
      'color': Colors.purpleAccent,
    },
    {
      'name': 'Neon Red',
      'color': Colors.redAccent,
    },
    {
      'name': 'Cyber Blue',
      'color': Colors.blueAccent,
    },
    {
      'name': 'Toxic Green',
      'color': Colors.greenAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuTheme.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NeuIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: const Text(
          'THEME',
          style: TextStyle(
            color: NeuTheme.textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SELECT ACCENT COLOR',
                style: TextStyle(
                  color: NeuTheme.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _themes.length,
                  itemBuilder: (context, index) {
                    final theme = _themes[index];
                    final isSelected = _selectedThemeIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedThemeIndex = index;
                        });
                      },
                      child: NeuContainer(
                        padding: const EdgeInsets.all(16.0),
                        isInner: isSelected, // Makes it look pressed/selected
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: theme['color'],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme['color'].withOpacity(0.5),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              theme['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? theme['color'] : NeuTheme.textColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              NeuButton(
                onPressed: () {
                  // Apply theme logic
                  Navigator.of(context).pop();
                },
                width: double.infinity,
                child: const Text(
                  'APPLY THEME',
                  style: TextStyle(
                    color: NeuTheme.accentColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
