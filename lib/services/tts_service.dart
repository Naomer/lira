import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../config/api_config.dart';

class TTSService {
  final String baseUrl;

  TTSService({String? baseUrl}) 
      : baseUrl = baseUrl ?? ApiConfig.backendBaseUrl;

  Future<String> synthesizeSpeech(String text, {String voice = "grandma", double speed = 1.0}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tts/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': text,
          'voice': voice,
          'speed': speed,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final audioBase64 = data['audio_base64'] as String;
        
        // Decode and save to temporary file
        final audioBytes = base64Decode(audioBase64);
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final audioPath = '${directory.path}/tts_$timestamp.wav';
        
        final audioFile = File(audioPath);
        await audioFile.writeAsBytes(audioBytes);
        
        return audioPath;
      } else {
        throw Exception('TTS failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in TTS: $e');
      rethrow;
    }
  }
}

