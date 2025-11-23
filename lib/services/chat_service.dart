import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/chat_message.dart';

class ChatService {
  final String baseUrl;

  ChatService({String? baseUrl}) 
      : baseUrl = baseUrl ?? ApiConfig.backendBaseUrl;

  Future<ChatResponse> sendMessage({
    required String userMessage,
    required List<ChatMessage> conversationHistory,
    String personality = "grandma",
    String? model,
  }) async {
    try {
      // Convert conversation history to API format
      final messages = [
        ...conversationHistory.map((msg) => {
          'role': msg.isAI ? 'assistant' : 'user',
          'content': msg.text,
        }),
        {
          'role': 'user',
          'content': userMessage,
        },
      ];

      final response = await http.post(
        Uri.parse('$baseUrl/chat/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'conversation': messages,
          'personality': personality,
          'model': model,
          'locale': 'en-US',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ChatResponse(
          reply: data['reply'] as String,
          reasoning: data['reasoning'] as String?,
        );
      } else {
        throw Exception('Chat failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in chat: $e');
      rethrow;
    }
  }
}

class ChatResponse {
  final String reply;
  final String? reasoning;

  ChatResponse({required this.reply, this.reasoning});
}

