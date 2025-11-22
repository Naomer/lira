import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/gradient_background.dart';
import '../widgets/orb_visualizer.dart';

class VoiceAnalysisScreen extends StatefulWidget {
  const VoiceAnalysisScreen({super.key});

  @override
  State<VoiceAnalysisScreen> createState() => _VoiceAnalysisScreenState();
}

class _VoiceAnalysisScreenState extends State<VoiceAnalysisScreen> {
  bool _isListening = false;
  final String _transcript =
      'What movies are playing near me, and which ones are trending right now?';
  final String _timer = '00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(PhosphorIcons.arrowLeft(), size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Voice Analysis',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(PhosphorIcons.list(), size: 24),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Listening indicator
                        Text(
                          'Listening...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.05),
                        // 3D Orb Visualizer
                        const OrbVisualizer(isActive: true, size: 220),
                        SizedBox(height: constraints.maxHeight * 0.06),
                        // Transcript display with highlighted second part
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _transcript.split(', ')[0] + ', ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87.withOpacity(0.4),
                                      height: 1.4,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _transcript.split(', ').length > 1
                                        ? _transcript
                                              .split(', ')
                                              .sublist(1)
                                              .join(', ')
                                        : '',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87.withOpacity(0.9),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Bottom control bar
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Timer
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _timer,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              // Microphone button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isListening = !_isListening;
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: _isListening
                                        ? const Color(0xFF9B7EDE)
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            (_isListening
                                                    ? const Color(0xFF9B7EDE)
                                                    : Colors.grey)
                                                .withOpacity(0.3),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    PhosphorIcons.microphone(),
                                    size: 40,
                                    color: _isListening
                                        ? Colors.white
                                        : const Color(0xFF9B7EDE),
                                  ),
                                ),
                              ),
                              // Cancel button
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    PhosphorIcons.x(),
                                    size: 24,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
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
