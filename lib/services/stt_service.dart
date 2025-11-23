import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class STTService {
  final String baseUrl;

  STTService({String? baseUrl}) 
      : baseUrl = baseUrl ?? ApiConfig.backendBaseUrl;

  Future<String> transcribeAudio(String audioFilePath, {String modelSize = "tiny"}) async {
    try {
      print('📁 Reading audio file: $audioFilePath');
      // Read audio file
      final audioFile = File(audioFilePath);
      if (!await audioFile.exists()) {
        throw Exception('Audio file not found: $audioFilePath');
      }

      final audioBytes = await audioFile.readAsBytes();
      print('📦 Audio size: ${audioBytes.length} bytes');
      final audioBase64 = base64Encode(audioBytes);
      print('📤 Sending to backend: $baseUrl/stt/');

      // Send to backend
      final response = await http.post(
        Uri.parse('$baseUrl/stt/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'audio_base64': audioBase64,
          'settings': {
            'model_size': modelSize,
            'language': null,
          },
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('STT request timed out - is backend running?');
        },
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['text'] as String? ?? '';
        print('✅ Transcription: $text');
        return text;
      } else {
        throw Exception('STT failed: ${response.statusCode} - ${response.body}');
      }
    } on SocketException catch (e) {
      print('❌ Network error: $e');
      throw Exception('Cannot connect to backend at $baseUrl. Is it running? Error: $e');
    } on HttpException catch (e) {
      print('❌ HTTP error: $e');
      rethrow;
    } catch (e) {
      print('❌ Error in STT: $e');
      rethrow;
    }
  }
}

