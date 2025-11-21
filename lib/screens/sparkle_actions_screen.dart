import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../utils/gradient_background.dart';

class SparkleActionsScreen extends StatelessWidget {
  const SparkleActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      _SparkAction(
        title: 'Generate Daily Brief',
        description: 'Summarize your sleep, mood, and top priorities.',
        icon: PhosphorIcons.sunDim(),
        color: const Color(0xFFFFC95F),
      ),
      _SparkAction(
        title: 'Idea Storm',
        description: 'Create three new rituals for mindful focus.',
        icon: PhosphorIcons.shootingStar(),
        color: const Color(0xFF9B7EDE),
      ),
      _SparkAction(
        title: 'Voice Insights',
        description: 'Analyze tone and extract key highlights.',
        icon: PhosphorIcons.microphoneStage(),
        color: const Color(0xFF7DC4FF),
      ),
      _SparkAction(
        title: 'Image Inspiration',
        description: 'Craft visuals to match your current intention.',
        icon: PhosphorIcons.image(),
        color: const Color(0xFFFB7185),
      ),
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _SparkleHeader(onBack: () => Navigator.pop(context)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Instant Spark',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Pick a creative jump-start. I will orchestrate the workflow and surface the results.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    final action = actions[index];
                    return _SparkActionTile(data: action);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: actions.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SparkleHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _SparkleHeader({required this.onBack});

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
              'Sparkle Actions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: Icon(PhosphorIcons.sparkle(), size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _SparkActionTile extends StatelessWidget {
  final _SparkAction data;

  const _SparkActionTile({required this.data});

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
            child: Icon(data.icon, size: 22, color: data.color),
          ),
          const SizedBox(width: 12),
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
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(PhosphorIcons.playCircle(), color: data.color),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _SparkAction {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _SparkAction({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}


