import 'package:flutter/material.dart';
import '../../../../core/widgets/neu_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
          'PROFILE',
          style: TextStyle(
            color: NeuTheme.textColor(context),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Avatar
              NeuContainer(
                width: 120,
                height: 120,
                borderRadius: 60,
                padding: const EdgeInsets.all(8.0),
                child: NeuContainer(
                  borderRadius: 55,
                  isInner: true,
                  child: Icon(
                    Icons.person_rounded,
                    size: 60,
                    color: NeuTheme.accentColor(context),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'COMMANDER',
                style: TextStyle(
                  color: NeuTheme.textColor(context),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Space Fleet Admiral',
                style: TextStyle(
                  color: NeuTheme.textColor(context).withValues(alpha: 0.5),
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 40),
              // Stats
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, 'HIGH SCORE', '24,500')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, 'LEVEL', '7')),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, 'BOSSES', '3')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(context, 'HOURS PLAYED', '12.5')),
                ],
              ),
              const SizedBox(height: 40),
              NeuButton(
                onPressed: () {
                  // Edit profile
                },
                width: double.infinity,
                child: Text(
                  'EDIT PROFILE',
                  style: TextStyle(
                    color: NeuTheme.textColor(context),
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

  Widget _buildStatCard(BuildContext context, String title, String value) {
    return NeuContainer(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: NeuTheme.textColor(context).withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: NeuTheme.accentColor(context),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
