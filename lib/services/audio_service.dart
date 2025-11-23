import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _currentRecordingPath;

  bool get isRecording => _isRecording;

  Future<bool> initialize() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        return false;
      }

      _recorder = FlutterSoundRecorder();
      await _recorder!.openRecorder();
      return true;
    } catch (e) {
      print('Error initializing audio recorder: $e');
      return false;
    }
  }

  Future<String?> startRecording() async {
    if (_isRecording) {
      print('⚠️ Already recording!');
      return null;
    }

    // Make sure recorder is initialized
    if (_recorder == null) {
      print('⚠️ Recorder not initialized, initializing now...');
      final initialized = await initialize();
      if (!initialized) {
        print('❌ Failed to initialize recorder');
        return null;
      }
    }

    try {
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${directory.path}/recording_$timestamp.wav';
      print('🎤 Starting recording to: $_currentRecordingPath');

      if (_recorder == null) {
        throw Exception('Recorder is still null after initialization');
      }

      await _recorder!.startRecorder(
        toFile: _currentRecordingPath,
        codec: Codec.pcm16WAV,
      );

      _isRecording = true;
      print('✅ Recording started');
      return _currentRecordingPath;
    } catch (e) {
      print('❌ Error starting recording: $e');
      return null;
    }
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) {
      print('⚠️ Not recording!');
      return null;
    }

    try {
      print('🛑 Stopping recording...');
      final path = await _recorder!.stopRecorder();
      _isRecording = false;
      print('✅ Recording stopped. Path: $path');
      return path;
    } catch (e) {
      print('❌ Error stopping recording: $e');
      _isRecording = false;
      return null;
    }
  }

  Future<void> dispose() async {
    if (_recorder != null) {
      await _recorder!.closeRecorder();
      _recorder = null;
    }
  }
}

