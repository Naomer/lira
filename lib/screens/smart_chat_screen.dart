import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../utils/gradient_background.dart';
import '../models/chat_message.dart';
import '../services/voice_assistant_service.dart';

class SmartChatScreen extends StatefulWidget {
  const SmartChatScreen({super.key});

  @override
  State<SmartChatScreen> createState() => _SmartChatScreenState();
}

class _SmartChatScreenState extends State<SmartChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final VoiceAssistantService _voiceService = VoiceAssistantService();

  List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hi! How can I assist you today? 👋",
      isAI: true,
      hasSparkle: true,
    ),
  ];
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _voiceService.initialize();
    // Load conversation history from service
    setState(() {
      _messages = [
        ChatMessage(
          text: "Hi! How can I assist you today? 👋",
          isAI: true,
          hasSparkle: true,
        ),
        ..._voiceService.conversationHistory,
      ];
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _voiceService.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isProcessing) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(text: userMessage, isAI: false));
      _isProcessing = true;
    });

    _scrollToBottom();

    try {
      final response = await _voiceService.sendTextMessage(userMessage);

      setState(() {
        _messages.add(
          ChatMessage(text: response, isAI: true, hasSparkle: true),
        );
        _isProcessing = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Sorry, I encountered an error: $e",
            isAI: true,
            hasSparkle: false,
          ),
        );
        _isProcessing = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          PhosphorIcons.arrowLeft(),
                          size: 20,
                          color: Colors.black87,
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Smart Chat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          PhosphorIcons.list(),
                          size: 20,
                          color: Colors.black87,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              // Chat messages with floating input bar
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 16,
                        bottom: 80, // Space for floating input bar
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _ChatBubble(message: _messages[index]);
                      },
                    ),
                    // Floating input bar
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: SafeArea(
                          child: Row(
                            children: [
                              // Text input field (curved, small) with plus button inside
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextField(
                                    controller: _messageController,
                                    decoration: InputDecoration(
                                      prefixIcon: Container(
                                        margin: EdgeInsets.all(4),
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            PhosphorIcons.plus(),
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {},
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                        ),
                                      ),
                                      hintText: 'Type a message...',
                                      hintStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                    onSubmitted: (_) => _sendMessage(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Microphone button with gradient purple background
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/voice-analysis',
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF9B7EDE),
                                        Color(0xFF7B5FCF),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    PhosphorIcons.microphone(),
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isAudio) {
      return _AudioBubble(duration: message.audioDuration);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isAI
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isAI) ...[
            if (message.hasSparkle)
              Container(
                margin: const EdgeInsets.only(right: 8, top: 4),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF9B7EDE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.sparkle(),
                  size: 16,
                  color: Colors.white,
                ),
              ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ] else ...[
            Container(
              margin: const EdgeInsets.only(right: 8, top: 4),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF9B7EDE),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                PhosphorIcons.pencilSimple(),
                size: 14,
                color: Colors.white,
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  message.text,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AudioBubble extends StatelessWidget {
  final String duration;

  const _AudioBubble({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D2D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Waveform visualization
                Row(
                  children: List.generate(5, (index) {
                    final heights = [16, 20, 12, 18, 14];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 3,
                      height: heights[index].toDouble(),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 12),
                Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(PhosphorIcons.play(), color: Colors.white, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
