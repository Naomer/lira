import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/gradient_background.dart';
import '../widgets/orb_visualizer.dart';
import '../services/voice_assistant_service.dart';
import '../services/backend_test_service.dart';

class VoiceAnalysisScreen extends StatefulWidget {
  const VoiceAnalysisScreen({super.key});

  @override
  State<VoiceAnalysisScreen> createState() => _VoiceAnalysisScreenState();
}

class _VoiceAnalysisScreenState extends State<VoiceAnalysisScreen> {
  final VoiceAssistantService _voiceService = VoiceAssistantService();
  bool _isListening = false;
  String _transcript = '';
  String _timer = '00';
  Timer? _timerController;
  int _secondsElapsed = 0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    // Test backend connection first
    print('🔍 Testing backend connection...');
    final backendConnected = await BackendTestService.testConnection();
    if (!backendConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚠️ Cannot connect to backend!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('URL: ${BackendTestService.getBackendUrl()}'),
                SizedBox(height: 4),
                Text('Steps to fix:'),
                Text('1. Start backend: py -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000'),
                Text('2. Test: curl http://localhost:8000/health'),
                Text('3. Restart this app after backend is running'),
              ],
            ),
            duration: const Duration(seconds: 10),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print('✅ Backend is connected!');
    }

    final success = await _voiceService.initialize();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Microphone permission is required for voice recording. Please enable it in settings.',
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void _startTimer() {
    _secondsElapsed = 0;
    _timerController = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
        _timer = _secondsElapsed.toString().padLeft(2, '0');
      });
    });
  }

  void _stopTimer() {
    _timerController?.cancel();
    _timerController = null;
  }

  Future<void> _startRecording() async {
    setState(() {
      _isListening = true;
      _transcript = '';
    });
    _startTimer();
    await _voiceService.startRecording();
  }

  Future<void> _stopRecording() async {
    _stopTimer();
    setState(() {
      _isListening = false;
      _isProcessing = true;
      _transcript = 'Processing audio...';
    });

    try {
      print('🔄 Starting voice processing...');
      final response = await _voiceService.processVoiceInput();
      print('✅ Got response: $response');

      setState(() {
        _transcript = response;
        _isProcessing = false;
      });

      // Navigate back to chat screen after processing
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e, stackTrace) {
      print('❌ Error in voice processing: $e');
      print('Stack trace: $stackTrace');

      setState(() {
        _isProcessing = false;
        _transcript =
            'Error: ${e.toString()}\n\nCheck:\n1. Is backend running?\n2. Check console for details';
      });

      // Show error dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _stopTimer();
    _voiceService.dispose();
    super.dispose();
  }

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
                          _isProcessing
                              ? 'Processing...'
                              : _isListening
                              ? 'Listening...'
                              : 'Tap to start',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.05),
                        // 3D Orb Visualizer
                        OrbVisualizer(
                          isActive: _isListening || _isProcessing,
                          size: 220,
                        ),
                        SizedBox(height: constraints.maxHeight * 0.06),
                        // Transcript display
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _transcript.isNotEmpty
                                ? Text(
                                    _transcript,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87.withOpacity(0.9),
                                      height: 1.4,
                                    ),
                                  )
                                : Text(
                                    _isProcessing
                                        ? 'Transcribing and thinking...'
                                        : 'Your words will appear here',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87.withOpacity(0.4),
                                      height: 1.4,
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
                                  if (_isProcessing) return;
                                  if (_isListening) {
                                    _stopRecording();
                                  } else {
                                    _startRecording();
                                  }
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
                                  child: _isProcessing
                                      ? const SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : Icon(
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
