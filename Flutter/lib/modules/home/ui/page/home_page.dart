import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes_names.dart';
import '../../../../core/utils/theme/astro_design.dart';
import '../../../../core/constants/assets_images.dart';

/// Mission-control home: title, best score, big launch button, level grid.
class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final best = useState(0);
    final unlocked = useState(1);
    final ship = useState(AstroDesign.kDefaultShip);

    Future<void> refresh() async {
      best.value = await AstroDesign.bestScore();
      unlocked.value = await AstroDesign.maxLevel();
      ship.value = await AstroDesign.selectedShip();
    }

    useEffect(() {
      refresh();
      return null;
    }, const []);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetsImages.spaceBgPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.55),
                Colors.black.withValues(alpha: 0.85),
              ],
            ),
          ),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  // Top icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _IconBtn(
                        icon: Icons.palette_outlined,
                        onTap: () => context.push(RoutesNames.theme),
                      ),
                      const Gap(8),
                      _IconBtn(
                        icon: Icons.settings_outlined,
                        onTap: () => context.push(RoutesNames.settings),
                      ),
                    ],
                  ),
                  const Gap(8),
                  // Title
                  Text(
                        'ASTRO WARS',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              color: Colors.white,
                              letterSpacing: 5,
                              shadows: [
                                Shadow(color: scheme.primary, blurRadius: 24),
                              ],
                            ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: -0.3, end: 0),
                  const Gap(4),
                  Text(
                    'DEFEND THE GALAXY',
                    style: TextStyle(
                      color: AstroDesign.neonCyan,
                      letterSpacing: 6,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 150.ms, duration: 500.ms),
                  const Gap(20),
                  // Ship + best strip
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'BEST SCORE',
                          value: '${best.value}',
                          icon: Icons.emoji_events_rounded,
                          color: AstroDesign.neonAmber,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _StatCard(
                          label: 'SECTORS OPEN',
                          value: '${unlocked.value}/10',
                          icon: Icons.grid_view_rounded,
                          color: AstroDesign.neonCyan,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
                  const Gap(16),
                  // Active ship preview
                  GestureDetector(
                    onTap: () => context.go(RoutesNames.hangar),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(
                          AstroDesign.radiusLg,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            AssetsImages.path(ship.value),
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.rocket_launch_rounded,
                              size: 56,
                              color: Colors.white70,
                            ),
                          ),
                          const Gap(16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ACTIVE INTERCEPTOR',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    letterSpacing: 2,
                                  ),
                                ),
                                Gap(4),
                                Text(
                                  'Hangar → swap ship',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 320.ms, duration: 400.ms),
                  const Gap(20),
                  // LAUNCH
                  SizedBox(
                        height: 64,
                        child: FilledButton.icon(
                          onPressed: () =>
                              context.push('${RoutesNames.game}?level=1'),
                          icon: const Icon(Icons.play_arrow_rounded, size: 32),
                          label: const Text(
                            'LAUNCH MISSION',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AstroDesign.radiusMd,
                              ),
                            ),
                            shadowColor: scheme.primary,
                            elevation: 8,
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .scaleXY(begin: 0.95, end: 1.0, duration: 300.ms),
                  const Gap(24),
                  const Text(
                    'SELECT SECTOR',
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: 10,
                    itemBuilder: (context, i) {
                      final level = i + 1;
                      final locked = level > unlocked.value;
                      return Material(
                        color: locked
                            ? Colors.white.withValues(alpha: 0.05)
                            : scheme.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: locked
                              ? null
                              : () => context.push(
                                  '${RoutesNames.game}?level=$level',
                                ),
                          child: Center(
                            child: locked
                                ? const Icon(
                                    Icons.lock_rounded,
                                    color: Colors.white24,
                                    size: 20,
                                  )
                                : Text(
                                    '$level',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.08),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AstroDesign.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const Gap(6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const Gap(6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
