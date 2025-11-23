# Troubleshooting Voice Recording Issues

## Problem: "Listening..." but no transcription appears

### Step 1: Check Backend Connection

**The app will show a warning if backend is not reachable.** Check the console/logs for:
- `✅ Backend is connected!` = Good
- `❌ Backend connection test failed` = Problem

**Solution:**
1. Make sure backend is running:
   ```bash
   cd backend
   uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
   ```

2. Test backend manually:
   ```bash
   curl http://localhost:8000/health
   ```
   Should return: `{"status":"ok"}`

### Step 2: Check Backend URL Configuration

**If using a physical device, `localhost` won't work!**

Edit `lib/config/api_config.dart`:

- **Android Emulator:** `http://10.0.2.2:8000`
- **iOS Simulator:** `http://localhost:8000`
- **Physical Device:** `http://YOUR_COMPUTER_IP:8000`

**To find your computer's IP:**
- **Windows:** Run `ipconfig` in CMD, look for "IPv4 Address"
- **Mac/Linux:** Run `ifconfig` or `ip addr`, look for your network interface IP

**Example:**
```dart
static const String backendBaseUrl = 'http://192.168.1.100:8000';
```

### Step 3: Check Console Logs

The app now has detailed logging. Look for these messages:

**Good flow:**
```
🔍 Testing backend connection...
✅ Backend is connected!
🎤 Starting recording to: /path/to/recording.wav
✅ Recording started
🛑 Stopping recording...
✅ Recording stopped. Path: /path/to/recording.wav
🔄 Starting voice processing...
🎤 Step 1: Stopping recording...
✅ Audio saved to: /path/to/recording.wav
📊 Audio file size: 12345 bytes
🎙️ Step 2: Transcribing audio...
📁 Reading audio file: /path/to/recording.wav
📦 Audio size: 12345 bytes
📤 Sending to backend: http://...
📥 Response status: 200
✅ Transcription: Hello world
```

**Error indicators:**
- `❌ Cannot connect to backend` = Backend URL wrong or backend not running
- `❌ Audio file is empty` = Recording failed
- `❌ STT request timed out` = Backend not responding
- `❌ Network error` = Cannot reach backend

### Step 4: Common Issues

#### Issue: "Cannot connect to backend"
**Causes:**
- Backend not running
- Wrong URL in `api_config.dart`
- Firewall blocking connection
- Device and computer not on same network

**Solutions:**
1. Verify backend is running: `curl http://localhost:8000/health`
2. Check URL in `lib/config/api_config.dart`
3. Disable firewall temporarily for testing
4. Ensure device and computer are on same WiFi network

#### Issue: "Audio file is empty"
**Causes:**
- Microphone permission denied
- Microphone not working
- Recording stopped too quickly

**Solutions:**
1. Check microphone permission in device settings
2. Test microphone with another app
3. Record for at least 2-3 seconds

#### Issue: "STT request timed out"
**Causes:**
- Backend is slow (first Whisper model load)
- Network is slow
- Backend crashed

**Solutions:**
1. Wait longer on first run (Whisper downloads model)
2. Check backend logs for errors
3. Try smaller Whisper model (`tiny` instead of `small`)

#### Issue: "Transcription returned empty"
**Causes:**
- Audio too quiet
- Background noise
- Wrong language

**Solutions:**
1. Speak louder and clearer
2. Reduce background noise
3. Check if Whisper supports your language

### Step 5: Test Each Component

#### Test 1: Backend Health
```bash
curl http://localhost:8000/health
```

#### Test 2: Backend STT Endpoint
```bash
# Create a test audio file first, then:
curl -X POST http://localhost:8000/stt/ \
  -H "Content-Type: application/json" \
  -d '{"audio_base64": "BASE64_AUDIO_HERE", "settings": {"model_size": "tiny"}}'
```

#### Test 3: Flutter Backend Connection
- Open app → Voice Analysis screen
- Check console for backend connection message

#### Test 4: Audio Recording
- Tap microphone
- Speak for 3-5 seconds
- Tap again to stop
- Check console for "Audio file size: X bytes"
- If size is 0, microphone isn't working

### Step 6: Enable Debug Mode

The app now prints detailed logs. To see them:

**Android:**
```bash
flutter run
# Or
adb logcat | grep -i "flutter\|lira\|🎤\|✅\|❌"
```

**iOS:**
```bash
flutter run
# Logs appear in Xcode console
```

### Quick Checklist

- [ ] Backend is running (`uvicorn app.main:app --reload`)
- [ ] Backend URL is correct in `lib/config/api_config.dart`
- [ ] Device and computer are on same network (for physical devices)
- [ ] Microphone permission is granted
- [ ] Backend health endpoint works (`/health`)
- [ ] Console shows "✅ Backend is connected!"
- [ ] Audio file size > 0 bytes
- [ ] No firewall blocking port 8000

### Still Not Working?

1. **Check backend logs** for errors
2. **Check Flutter console** for detailed error messages
3. **Try text chat first** to verify LLM connection works
4. **Test with a simple audio file** manually via curl
5. **Check Whisper model download** - first run takes time

### Getting Help

When asking for help, include:
1. Console logs (especially lines with 🎤, ✅, ❌)
2. Backend URL you're using
3. Device type (emulator/simulator/physical)
4. Backend logs
5. Error messages shown in app

