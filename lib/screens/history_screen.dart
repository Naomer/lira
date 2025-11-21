import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../utils/gradient_background.dart';

class ActivityHistoryScreen extends StatelessWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = [
      _HistoryEntry(
        title: 'Voice Analysis Session',
        description: 'Identified calm tone and clear articulation.',
        icon: PhosphorIcons.waveform(),
        timestamp: 'Today • 09:24 AM',
      ),
      _HistoryEntry(
        title: 'Smart Chat: Nutrition Plan',
        description: 'Generated a custom macro split for your goal.',
        icon: PhosphorIcons.chatCircleText(),
        timestamp: 'Yesterday • 7:18 PM',
      ),
      _HistoryEntry(
        title: 'Image Generator',
        description: 'Created 3 calming focus wallpapers.',
        icon: PhosphorIcons.imageSquare(),
        timestamp: 'Mon • 6:02 PM',
      ),
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _HistoryHeader(onBack: () => Navigator.pop(context)),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return _HistoryTile(data: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _HistoryHeader({required this.onBack});

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
              'Activity History',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: Icon(PhosphorIcons.funnel(), size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final _HistoryEntry data;

  const _HistoryTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              color: const Color(0xFF9B7EDE).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 22, color: const Color(0xFF9B7EDE)),
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
                const SizedBox(height: 6),
                Text(
                  data.description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.clock(),
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      data.timestamp,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryEntry {
  final String title;
  final String description;
  final IconData icon;
  final String timestamp;

  _HistoryEntry({
    required this.title,
    required this.description,
    required this.icon,
    required this.timestamp,
  });
}


