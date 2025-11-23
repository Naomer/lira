import 'dart:io';

class ApiConfig {
  // ⚠️ IMPORTANT: For REAL DEVICES, you MUST set your computer's IP address below!
  //
  // Android Emulator: http://10.0.2.2:8000
  // iOS Simulator: http://localhost:8000
  // REAL Android/iOS Device: http://YOUR_COMPUTER_IP:8000
  //
  // To find your computer's IP:
  //   Windows: Run "ipconfig" in CMD, look for "IPv4 Address" under your WiFi/Ethernet adapter
  //   Mac/Linux: Run "ifconfig" or "ip addr", look for your network interface IP
  //
  // Example: If your computer IP is 192.168.1.100, set it to: 'http://192.168.1.100:8000'
  //
  // ⚠️ Make sure your phone and computer are on the SAME WiFi network!

  // SET THIS TO YOUR COMPUTER'S IP ADDRESS FOR REAL DEVICES:
  static const String? manualBackendUrl =
      'http://192.168.43.113:8000'; // Your computer's IP

  static String get backendBaseUrl {
    // Use manual override if set (REQUIRED for real devices!)
    if (manualBackendUrl != null) {
      print('🔧 Using manual backend URL: $manualBackendUrl');
      return manualBackendUrl!;
    }

    // Auto-detect (only works for emulators/simulators)
    if (Platform.isAndroid) {
      // This only works for Android EMULATOR, not real devices!
      final url = 'http://10.0.2.2:8000';
      print('🤖 Android detected - using emulator URL: $url');
      print(
        '⚠️ If you\'re on a REAL device, set manualBackendUrl to your computer IP!',
      );
      return url;
    } else if (Platform.isIOS) {
      // iOS simulator can use localhost
      final url = 'http://localhost:8000';
      print('🍎 iOS detected, using: $url');
      return url;
    } else {
      // Desktop or other platforms
      final url = 'http://localhost:8000';
      print('💻 Desktop detected, using: $url');
      return url;
    }
  }
}
