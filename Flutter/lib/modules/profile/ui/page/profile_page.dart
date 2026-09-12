import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/theme/astro_design.dart';

/// Pilot profile with real stats from local persistence.
class ProfilePage extends HookWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final best = useState(0);
    final levels = useState(1);
    final runs = useState(0);

    Future<void> load() async {
      best.value = await AstroDesign.bestScore();
      levels.value = await AstroDesign.maxLevel();
      runs.value = await AstroDesign.runsPlayed();
    }

    useEffect(() {
      load();
      return null;
    }, const []);

    String rank() {
      if (best.value >= 10000) return 'Space Fleet Admiral';
      if (best.value >= 5000) return 'Wing Commander';
      if (best.value >= 2000) return 'Squadron Leader';
      if (best.value >= 500) return 'Cadet Pilot';
      return 'Rookie';
    }

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('PILOT')),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [scheme.primary, AstroDesign.neonCyan],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.5),
                      blurRadius: 28,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),
            const Gap(16),
            Text(
              'COMMANDER',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),
            Gap(4),
            Text(
              rank(),
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
            const Gap(24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _StatTile(
                  label: 'HIGH SCORE',
                  value: '${best.value}',
                  color: AstroDesign.neonAmber,
                ),
                _StatTile(
                  label: 'SECTORS OPEN',
                  value: '${levels.value}',
                  color: AstroDesign.neonCyan,
                ),
                _StatTile(
                  label: 'MISSIONS FLOWN',
                  value: '${runs.value}',
                  color: AstroDesign.neonMagenta,
                ),
                _StatTile(
                  label: 'RANK',
                  value: rank().split(' ').first,
                  color: AstroDesign.neonGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AstroDesign.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
