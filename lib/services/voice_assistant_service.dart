import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import '../models/chat_message.dart';
import 'audio_service.dart';
import 'stt_service.dart';
import 'chat_service.dart';
import 'tts_service.dart';

class VoiceAssistantService {
  final AudioService _audioService = AudioService();
  final STTService _sttService = STTService();
  final ChatService _chatService = ChatService();
  final TTSService _ttsService = TTSService();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<ChatMessage> _conversationHistory = [];
  bool _isInitialized = false;

  List<ChatMessage> get conversationHistory => List.unmodifiable(_conversationHistory);

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    final success = await _audioService.initialize();
    if (success) {
      _isInitialized = true;
    }
    return success;
  }

  Future<void> startRecording() async {
    await _audioService.startRecording();
  }

  Future<String?> stopRecording() async {
    return await _audioService.stopRecording();
  }

  bool get isRecording => _audioService.isRecording;

  /// Complete voice assistant flow:
  /// 1. Stop recording
  /// 2. Transcribe audio to text
  /// 3. Send to LLM for response
  /// 4. Convert response to speech
  /// 5. Play audio response
  Future<String> processVoiceInput() async {
    try {
      print('🎤 Step 1: Stopping recording...');
      // 1. Stop recording and get audio file path
      final audioPath = await stopRecording();
      if (audioPath == null) {
        throw Exception('No audio recorded - check microphone permission');
      }
      print('✅ Audio saved to: $audioPath');

      // Check if file exists and has content
      final audioFile = File(audioPath);
      if (!await audioFile.exists()) {
        throw Exception('Audio file was not created');
      }
      final fileSize = await audioFile.length();
      print('📊 Audio file size: $fileSize bytes');
      if (fileSize == 0) {
        throw Exception('Audio file is empty - recording may have failed');
      }

      print('🎙️ Step 2: Transcribing audio...');
      // 2. Transcribe audio to text
      final transcript = await _sttService.transcribeAudio(audioPath);
      print('✅ YOU SAID: $transcript');
      
      if (transcript.isEmpty || transcript.trim().isEmpty) {
        throw Exception('Transcription returned empty - try speaking louder or check microphone');
      }

      print('🤖 Step 3: Sending to LLM...');
      // 3. Send to LLM for response
      final chatResponse = await _chatService.sendMessage(
        userMessage: transcript,
        conversationHistory: _conversationHistory,
        personality: 'grandma',
      );
      print('✅ LLM Response: ${chatResponse.reply}');

      // Update conversation history
      _conversationHistory.add(
        ChatMessage(text: transcript, isAI: false),
      );
      _conversationHistory.add(
        ChatMessage(text: chatResponse.reply, isAI: true, hasSparkle: true),
      );

      print('🔊 Step 4: Converting to speech...');
      // 4. Convert response to speech
      final ttsAudioPath = await _ttsService.synthesizeSpeech(
        chatResponse.reply,
        voice: 'grandma',
      );
      print('✅ TTS audio saved to: $ttsAudioPath');

      print('▶️ Step 5: Playing audio...');
      // 5. Play audio response
      await _audioPlayer.play(DeviceFileSource(ttsAudioPath));

      return chatResponse.reply;
    } catch (e, stackTrace) {
      print('❌ Error in voice assistant flow: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Send text message and get voice response
  Future<String> sendTextMessage(String text) async {
    try {
      // Send to LLM
      final chatResponse = await _chatService.sendMessage(
        userMessage: text,
        conversationHistory: _conversationHistory,
        personality: 'grandma',
      );

      // Update conversation history
      _conversationHistory.add(
        ChatMessage(text: text, isAI: false),
      );
      _conversationHistory.add(
        ChatMessage(text: chatResponse.reply, isAI: true, hasSparkle: true),
      );

      // Convert to speech and play
      final ttsAudioPath = await _ttsService.synthesizeSpeech(
        chatResponse.reply,
        voice: 'grandma',
      );

      await _audioPlayer.play(DeviceFileSource(ttsAudioPath));

      return chatResponse.reply;
    } catch (e) {
      print('Error in text message flow: $e');
      rethrow;
    }
  }

  void clearHistory() {
    _conversationHistory.clear();
  }

  Future<void> dispose() async {
    await _audioService.dispose();
    await _audioPlayer.dispose();
  }
}

