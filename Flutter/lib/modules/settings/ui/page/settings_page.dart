import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/theme/astro_design.dart';

/// Settings with real persistence: SFX/BGM gates + danger-zone reset.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _sfx = true;
  bool _bgm = true;

  @override
  void initState() {
    super.initState();
    Sfx.loadFromPrefs().then((_) {
      if (!mounted) return;
      setState(() {
        _sfx = Sfx.enabled;
        _bgm = Sfx.bgmEnabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Tile(
            icon: Icons.volume_up_rounded,
            title: 'Sound effects',
            subtitle: 'Lasers, explosions, pickups',
            trailing: Switch(
              value: _sfx,
              onChanged: (v) async {
                await Sfx.setEnabled(v);
                setState(() => _sfx = v);
              },
            ),
          ),
          const Gap(12),
          _Tile(
            icon: Icons.music_note_rounded,
            title: 'Background music',
            subtitle: 'Synthwave loop during missions',
            trailing: Switch(
              value: _bgm,
              onChanged: (v) async {
                await Sfx.setBgmEnabled(v);
                setState(() => _bgm = v);
              },
            ),
          ),
          const Gap(12),
          _Tile(
            icon: Icons.palette_outlined,
            title: 'Theme & accent',
            subtitle: 'Dark / light, neon accent',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/theme'),
          ),
          const Gap(32),
          const Text('DANGER ZONE',
              style: TextStyle(
                  color: AstroDesign.danger,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold)),
          const Gap(12),
          OutlinedButton.icon(
            onPressed: () => _confirmReset(context),
            icon: const Icon(Icons.delete_forever_rounded),
            label: const Text('RESET PROGRESS'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AstroDesign.danger,
              side: const BorderSide(color: AstroDesign.danger),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset all progress?'),
        content: const Text(
            'Best score, unlocked sectors and mission count will be erased.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
                backgroundColor: AstroDesign.danger),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    if (!context.mounted) return;
    await AstroDesign.resetProgress();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress erased. Fresh start, Commander.')),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  const _Tile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.trailing,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius:
          BorderRadius.circular(AstroDesign.radiusMd),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(AstroDesign.radiusMd),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: scheme.primary, size: 28),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text(subtitle,
                        style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 13)),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
