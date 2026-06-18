import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/widgets/neu_widgets.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedShip = useState('hd_ship_sleek_1781686447510.jpg');

    useEffect(() {
      SharedPreferences.getInstance().then((prefs) {
        final ship = prefs.getString('selected_ship');
        if (ship != null) {
          selectedShip.value = ship;
        }
      });
      return null;
    }, []);

    return Scaffold(
      backgroundColor: NeuTheme.bgColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 20),
            _buildTitle(context),
            const SizedBox(height: 30),
            _buildShipSelection(context, selectedShip),
            const SizedBox(height: 30),
            _buildStoryModeButton(context),
            const SizedBox(height: 20),
            Expanded(child: _buildLevelsGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildShipSelection(
    BuildContext context,
    ValueNotifier<String> selectedShip,
  ) {
    final ships = [
      {"asset": "hd_ship_sleek_1781686447510.jpg", "name": "SLEEK FIGHTER"},
      {"asset": "hd_ship_heavy_1781686457671.jpg", "name": "HEAVY CRUISER"},
      {"asset": "hd_ship_pixel_1781686721018.jpg", "name": "PIXEL GLIDER"},
      {"asset": "hd_ship_cipher_1781686731026.jpg", "name": "CIPHER STEALTH"},
    ];

    return Column(
      children: [
        NeuContainer(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          borderRadius: 20,
          child: Text(
            "HANGAR",
            style: TextStyle(
              color: NeuTheme.accentColor(context),
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ships.map((shipData) {
              final ship = shipData["asset"]!;
              final name = shipData["name"]!;
              final isSelected = selectedShip.value == ship;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GestureDetector(
                  onTap: () async {
                    selectedShip.value = ship;
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('selected_ship', ship);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    transform: Matrix4.identity()
                      ..scale(isSelected ? 1.1 : 1.0),
                    child: Column(
                      children: [
                        NeuContainer(
                          width: isSelected ? 100 : 80,
                          height: isSelected ? 100 : 80,
                          isInner: isSelected, // Recessed if selected
                          padding: const EdgeInsets.all(12),
                          borderRadius: 24,
                          child: Container(
                            decoration: isSelected
                                ? BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: NeuTheme.accentColor(
                                          context,
                                        ).withValues(alpha: 0.5),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  )
                                : null,
                            child: Image.asset(
                              "assets/images/$ship",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.5,
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            name,
                            style: TextStyle(
                              color: isSelected
                                  ? NeuTheme.accentColor(context)
                                  : NeuTheme.textColor(context),
                              fontSize: isSelected ? 14 : 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
                  context.push('/profile');
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
                  context.push('/theme');
                },
              ),
              const SizedBox(width: 16),
              NeuIconButton(
                icon: Icons.settings_rounded,
                onPressed: () {
                  context.push('/settings');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      children: [
        NeuContainer(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          borderRadius: 20.0,
          child: Text(
            'ASTRO WARS',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: NeuTheme.textColor(context),
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
            color: NeuTheme.textColor(context).withValues(alpha: 0.7),
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
          context.push('/game');
        },
        padding: const EdgeInsets.symmetric(vertical: 20),
        borderRadius: 20.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_fill_rounded,
              color: NeuTheme.accentColor(context),
              size: 32,
            ),
            SizedBox(width: 12),
            Text(
              'STORY MODE & CUTSCENES',
              style: TextStyle(
                color: NeuTheme.accentColor(context),
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
          Builder(
            builder: (context) {
              return Text(
                'SELECT LEVEL',
                style: TextStyle(
                  color: NeuTheme.textColor(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              );
            },
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

                    return _buildLevelButton(context, level, isLocked);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelButton(BuildContext context, int level, bool isLocked) {
    return NeuButton(
      onPressed: isLocked
          ? null
          : () {
              context.push('/game');
            },
      borderRadius: 16.0,
      padding: EdgeInsets.zero,
      child: isLocked
          ? Icon(
              Icons.lock_rounded,
              color: NeuTheme.textColor(context).withValues(alpha: 0.3),
            )
          : Text(
              '$level',
              style: TextStyle(
                color: NeuTheme.textColor(context),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
