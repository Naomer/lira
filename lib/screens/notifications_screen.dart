import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../utils/gradient_background.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotificationData(
        title: 'Weekly Report Ready',
        description: 'Your personalized wellness summary is ready to review.',
        icon: PhosphorIcons.trendUp(),
        time: '2m ago',
        color: const Color(0xFF9B7EDE),
      ),
      _NotificationData(
        title: 'New Smart Chat Reply',
        description: 'Lira responded to your sleep optimization question.',
        icon: PhosphorIcons.chatCircleDots(),
        time: '1h ago',
        color: const Color(0xFF7DC4FF),
      ),
      _NotificationData(
        title: 'Hydration Reminder',
        description: 'You have logged 2 of 6 glasses for today.',
        icon: PhosphorIcons.drop(),
        time: '3h ago',
        color: const Color(0xFF4ADE80),
      ),
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _NotificationsHeader(onBack: () => Navigator.pop(context)),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return _NotificationTile(data: item);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: notifications.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _NotificationsHeader({required this.onBack});

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
              'Notifications',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: Icon(PhosphorIcons.dotsThreeVertical(), size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final _NotificationData data;

  const _NotificationTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  data.time,
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationData {
  final String title;
  final String description;
  final IconData icon;
  final String time;
  final Color color;

  _NotificationData({
    required this.title,
    required this.description,
    required this.icon,
    required this.time,
    required this.color,
  });
}


