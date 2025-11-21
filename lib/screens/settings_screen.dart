import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../utils/gradient_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _haptics = true;
  bool _dataInsights = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _SettingsHeader(onBack: () => Navigator.pop(context)),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  children: [
                    const _SectionLabel('General'),
                    _SettingsTile(
                      icon: PhosphorIcons.bellSimple(),
                      title: 'Notifications',
                      subtitle: 'Get nudges for check-ins and reminders',
                      trailing: Switch(
                        value: _notifications,
                        onChanged: (value) => setState(() => _notifications = value),
                      ),
                    ),
                    _SettingsTile(
                      icon: PhosphorIcons.waveSawtooth(),
                      title: 'Haptic Feedback',
                      subtitle: 'Subtle confirmation when actions complete',
                      trailing: Switch(
                        value: _haptics,
                        onChanged: (value) => setState(() => _haptics = value),
                      ),
                    ),
                    _SettingsTile(
                      icon: PhosphorIcons.chartLineUp(),
                      title: 'Data Insights',
                      subtitle: 'Allow AI to aggregate trends over time',
                      trailing: Switch(
                        value: _dataInsights,
                        onChanged: (value) => setState(() => _dataInsights = value),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _SectionLabel('Account'),
                    _SettingsTile(
                      icon: PhosphorIcons.userCircle(),
                      title: 'Profile',
                      subtitle: 'Personal information and preferences',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: PhosphorIcons.shieldCheck(),
                      title: 'Privacy & Security',
                      subtitle: 'Manage data permissions and sessions',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: PhosphorIcons.question(),
                      title: 'Help Center',
                      subtitle: 'FAQs, tutorials, and feedback',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _SettingsHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(PhosphorIcons.arrowLeft(), size: 20),
            onPressed: onBack,
          ),
          const Expanded(
            child: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF9B7EDE).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF9B7EDE), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else
            IconButton(
              icon: Icon(PhosphorIcons.caretRight(), color: Colors.grey[500]),
              onPressed: onTap,
            ),
        ],
      ),
    );
  }
}


