import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/theme/astro_design.dart';
import '../../../../core/utils/theme/logic/cubit/theme_cubit.dart';

/// Theme studio: mode (system/dark/light) + neon accent, all persisted
/// through the hydrated [ThemeCubit] (was local throwaway state before).
class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('THEME')),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final cubit = context.read<ThemeCubit>();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'APPEARANCE',
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              const Gap(12),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(Icons.settings_suggest_rounded),
                    label: Text('Auto'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode_rounded),
                    label: Text('Dark'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode_rounded),
                    label: Text('Light'),
                  ),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (s) => cubit.changeTheme(s.first),
              ),
              const Gap(28),
              const Text(
                'NEON ACCENT',
                style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              const Gap(12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemCount: AstroDesign.accents.length,
                itemBuilder: (context, i) {
                  final color = AstroDesign.accents[i];
                  final selected = state.accentValue == color.toARGB32();
                  return Material(
                    color: color.withValues(alpha: selected ? 0.25 : 0.08),
                    borderRadius: BorderRadius.circular(AstroDesign.radiusMd),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AstroDesign.radiusMd),
                      onTap: () => cubit.changeAccent(color.toARGB32()),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AstroDesign.radiusMd,
                          ),
                          border: Border.all(
                            color: selected
                                ? color
                                : Colors.grey.withValues(alpha: 0.3),
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.6),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: selected
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const Gap(8),
                            Text(
                              AstroDesign.accentNames[i],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
