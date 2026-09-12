import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/theme/astro_design.dart';

/// Pilot profile with real stats from local persistence.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _best = 0;
  int _levels = 1;
  int _runs = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final best = await AstroDesign.bestScore();
    final levels = await AstroDesign.maxLevel();
    final runs = await AstroDesign.runsPlayed();
    if (!mounted) return;
    setState(() {
      _best = best;
      _levels = levels;
      _runs = runs;
    });
  }

  String _rank() {
    if (_best >= 10000) return 'Space Fleet Admiral';
    if (_best >= 5000) return 'Wing Commander';
    if (_best >= 2000) return 'Squadron Leader';
    if (_best >= 500) return 'Cadet Pilot';
    return 'Rookie';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('PILOT')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    scheme.primary,
                    AstroDesign.neonCyan,
                  ]),
                  boxShadow: [
                    BoxShadow(
                        color:
                            scheme.primary.withValues(alpha: 0.5),
                        blurRadius: 28)
                  ],
                ),
                child: const Icon(Icons.person_rounded,
                    size: 56, color: Colors.white),
              ),
            ),
            const Gap(16),
            Text('COMMANDER',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3)),
            Gap(4),
            Text(_rank(),
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant)),
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
                    value: '$_best',
                    color: AstroDesign.neonAmber),
                _StatTile(
                    label: 'SECTORS OPEN',
                    value: '$_levels',
                    color: AstroDesign.neonCyan),
                _StatTile(
                    label: 'MISSIONS FLOWN',
                    value: '$_runs',
                    color: AstroDesign.neonMagenta),
                _StatTile(
                    label: 'RANK',
                    value: _rank().split(' ').first,
                    color: AstroDesign.neonGreen),
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
  const _StatTile(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius:
            BorderRadius.circular(AstroDesign.radiusMd),
        border:
            Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold)),
          const Gap(8),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 26,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
