import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/voice_analysis_screen.dart';
import 'screens/smart_chat_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'screens/sparkle_actions_screen.dart';
import 'screens/voice_to_text_screen.dart';
import 'screens/image_generator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const LiraApp());
}

class LiraApp extends StatelessWidget {
  const LiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lira',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/voice-analysis': (context) => const VoiceAnalysisScreen(),
        '/smart-chat': (context) => const SmartChatScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/history': (context) => const ActivityHistoryScreen(),
        '/sparkle-actions': (context) => const SparkleActionsScreen(),
        '/voice-to-text': (context) => const VoiceToTextScreen(),
        '/image-generator': (context) => const ImageGeneratorScreen(),
      },
    );
  }
}
