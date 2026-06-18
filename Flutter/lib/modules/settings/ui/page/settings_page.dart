import 'package:flutter/material.dart';
import '../../../../core/widgets/neu_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuTheme.bgColor(context),
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
        title: Text(
          'SETTINGS',
          style: TextStyle(
            color: NeuTheme.textColor(context),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildSettingItem(
              icon: Icons.volume_up_rounded,
              title: 'Sound Effects',
              value: _soundEnabled,
              onChanged: (val) => setState(() => _soundEnabled = val),
            ),
            const SizedBox(height: 24),
            _buildSettingItem(
              icon: Icons.music_note_rounded,
              title: 'Background Music',
              value: _musicEnabled,
              onChanged: (val) => setState(() => _musicEnabled = val),
            ),
            const SizedBox(height: 24),
            _buildSettingItem(
              icon: Icons.notifications_rounded,
              title: 'Notifications',
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
            const SizedBox(height: 48),
            NeuButton(
              onPressed: () {
                // Logout or reset progress
              },
              child: Text(
                'RESET PROGRESS',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return NeuContainer(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Icon(icon, color: NeuTheme.accentColor(context), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: NeuTheme.textColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          NeuButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onPressed: () => onChanged(!value),
            child: Text(
              value ? 'ON' : 'OFF',
              style: TextStyle(
                color: value
                    ? NeuTheme.accentColor(context)
                    : NeuTheme.textColor(context).withValues(alpha: 0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
