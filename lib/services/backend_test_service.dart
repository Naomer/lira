import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class BackendTestService {
  static Future<bool> testConnection() async {
    try {
      final url = '${ApiConfig.backendBaseUrl}/health';
      print('🔍 Testing backend at: $url');
      
      final response = await http.get(
        Uri.parse(url),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      final success = response.statusCode == 200;
      if (success) {
        print('✅ Backend is connected!');
      } else {
        print('❌ Backend returned status: ${response.statusCode}');
      }
      return success;
    } catch (e) {
      print('❌ Backend connection test failed: $e');
      print('💡 Troubleshooting steps:');
      print('   1. Make sure backend is running: py -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000');
      print('   2. Test backend manually: curl http://localhost:8000/health');
      print('   3. If on Android emulator, backend should be at: http://10.0.2.2:8000');
      print('   4. If on physical device, use your computer IP instead of localhost');
      return false;
    }
  }

  static String getBackendUrl() {
    return ApiConfig.backendBaseUrl;
  }
}

