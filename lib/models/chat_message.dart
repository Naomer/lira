class ChatMessage {
  final String text;
  final bool isAI;
  final bool hasSparkle;
  final bool isAudio;
  final String audioDuration;

  ChatMessage({
    required this.text,
    required this.isAI,
    this.hasSparkle = false,
    this.isAudio = false,
    this.audioDuration = '',
  });
}

