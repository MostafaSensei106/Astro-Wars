import 'package:flutter/material.dart';
import '../../../../core/widgets/neu_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuTheme.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 20),
            _buildTitle(),
            const SizedBox(height: 40),
            _buildStoryModeButton(context),
            const SizedBox(height: 40),
            Expanded(
              child: _buildLevelsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              NeuIconButton(
                icon: Icons.person_rounded,
                onPressed: () {
                  // Navigate to profile
                },
              ),
              const SizedBox(width: 16),
              NeuIconButton(
                icon: Icons.leaderboard_rounded,
                onPressed: () {
                  // Navigate to leaderboard
                },
              ),
            ],
          ),
          Row(
            children: [
              NeuIconButton(
                icon: Icons.palette_rounded,
                onPressed: () {
                  // Navigate to theme settings
                },
              ),
              const SizedBox(width: 16),
              NeuIconButton(
                icon: Icons.settings_rounded,
                onPressed: () {
                  // Navigate to settings
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        NeuContainer(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          borderRadius: 20.0,
          child: const Text(
            'ASTRO WARS',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: NeuTheme.textColor,
              letterSpacing: 4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'DEFEND THE GALAXY',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: NeuTheme.textColor.withOpacity(0.7),
            letterSpacing: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildStoryModeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: NeuButton(
        onPressed: () {
          // Play cutscenes / Boss fight logic
        },
        padding: const EdgeInsets.symmetric(vertical: 20),
        borderRadius: 20.0,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_circle_fill_rounded, color: NeuTheme.accentColor, size: 32),
            SizedBox(width: 12),
            Text(
              'STORY MODE & CUTSCENES',
              style: TextStyle(
                color: NeuTheme.accentColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelsGrid() {
    return NeuContainer(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      padding: const EdgeInsets.all(24.0),
      borderRadius: 40.0,
      isInner: true, // Recessed container for levels
      child: Column(
        children: [
          const Text(
            'SELECT LEVEL',
            style: TextStyle(
              color: NeuTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth > 600 ? 10 : 5;
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final level = index + 1;
                    final isLocked = level > 3;

                    return _buildLevelButton(level, isLocked);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(int level, bool isLocked) {
    return NeuButton(
      onPressed: isLocked ? null : () {
        // Navigate to level
      },
      borderRadius: 16.0,
      padding: EdgeInsets.zero,
      child: isLocked
          ? Icon(Icons.lock_rounded, color: NeuTheme.textColor.withOpacity(0.3))
          : Text(
              '$level',
              style: const TextStyle(
                color: NeuTheme.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
