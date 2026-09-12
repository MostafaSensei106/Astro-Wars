import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes_names.dart';
import '../../../../core/utils/theme/astro_design.dart';

/// Ship hangar: swipe carousel with real stats + persistent selection.
class HangarPage extends StatefulWidget {
  const HangarPage({super.key});

  @override
  State<HangarPage> createState() => _HangarPageState();
}

class _HangarPageState extends State<HangarPage> {
  final _controller = PageController(viewportFraction: 0.82);
  String _selected = AstroDesign.kDefaultShip;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    AstroDesign.selectedShip().then((ship) {
      if (!mounted) return;
      final idx = AstroDesign.ships
          .indexWhere((s) => s.asset == ship)
          .clamp(0, AstroDesign.ships.length - 1);
      setState(() {
        _selected = AstroDesign.ships[idx].asset;
        _page = idx;
      });
      _controller.jumpToPage(idx);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ships = AstroDesign.ships;
    return Scaffold(
      appBar: AppBar(title: const Text('HANGAR')),
      body: Column(
        children: [
          const Gap(8),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: ships.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                final ship = ships[i];
                final active = i == _page;
                final isSelected = ship.asset == _selected;
                return AnimatedScale(
                  scale: active ? 1.0 : 0.92,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 12),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(
                          AstroDesign.radiusLg),
                      border: Border.all(
                        color: isSelected
                            ? scheme.primary
                            : Colors.white.withValues(alpha: 0.12),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: scheme.primary
                                      .withValues(alpha: 0.35),
                                  blurRadius: 32)
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: scheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('ACTIVE',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2)),
                          ),
                        const Gap(12),
                        Expanded(
                          child: Image.asset(
                            'assets/images/${ship.asset}',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                                Icons.rocket_launch_rounded,
                                size: 120,
                                color: scheme.primary),
                          ),
                        ),
                        const Gap(12),
                        Text(ship.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900)),
                        Text(ship.role,
                            style: TextStyle(
                                color: scheme.onSurfaceVariant)),
                        const Gap(16),
                        _StatBar(
                            label: 'FIREPOWER',
                            value: ship.firepower,
                            color: AstroDesign.danger),
                        const Gap(8),
                        _StatBar(
                            label: 'SPEED',
                            value: ship.speed,
                            color: AstroDesign.neonCyan),
                        const Gap(8),
                        _StatBar(
                            label: 'ARMOR',
                            value: ship.armor,
                            color: AstroDesign.neonGreen),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                ships.length,
                (i) => Container(
                      margin: const EdgeInsets.all(4),
                      width: i == _page ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? scheme.primary
                            : Colors.grey.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
          ),
          const Gap(12),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ships[_page].asset == _selected
                  ? FilledButton.tonalIcon(
                      onPressed: () => context.go(
                          '${RoutesNames.game}?level=1'),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('FLY THIS SHIP',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5)),
                    )
                  : FilledButton.icon(
                      onPressed: () async {
                        await AstroDesign.selectShip(
                            ships[_page].asset);
                        setState(
                            () => _selected = ships[_page].asset);
                      },
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('SELECT SHIP',
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5)),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value; // 1..5
  final Color color;
  const _StatBar(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Row(
            children: List.generate(
                5,
                (i) => Expanded(
                      child: Container(
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i < value
                              ? color
                              : Colors.grey.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: i < value
                              ? [
                                  BoxShadow(
                                      color: color.withValues(
                                          alpha: 0.6),
                                      blurRadius: 6)
                                ]
                              : null,
                        ),
                      ),
                    )),
          ),
        ),
      ],
    );
  }
}
