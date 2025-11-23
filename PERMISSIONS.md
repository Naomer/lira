# Permissions Guide for Lira

Lira requires certain permissions to function properly. This guide explains what permissions are needed and why.

## Required Permissions

### 1. Microphone Permission
**Platforms:** Android & iOS  
**Purpose:** Record user's voice for speech-to-text conversion

#### Android
- **Permission:** `RECORD_AUDIO`
- **Location:** `android/app/src/main/AndroidManifest.xml`
- **Runtime Permission:** Requested via `permission_handler` package
- **When requested:** On first use when user taps the microphone button

#### iOS
- **Permission:** `NSMicrophoneUsageDescription`
- **Location:** `ios/Runner/Info.plist`
- **Runtime Permission:** Requested automatically by iOS when accessing microphone
- **When requested:** On first use when user taps the microphone button

### 2. Internet Permission
**Platforms:** Android & iOS  
**Purpose:** Communicate with the backend API for STT, LLM, and TTS

#### Android
- **Permission:** `INTERNET`
- **Location:** `android/app/src/main/AndroidManifest.xml`
- **Note:** Internet permission is granted by default on Android

#### iOS
- **Permission:** Automatically granted (no explicit permission needed)
- **Note:** iOS allows network access by default for apps

### 3. Storage Permissions (Android only)
**Platforms:** Android  
**Purpose:** Save temporary audio files for processing

#### Android
- **Permissions:** `WRITE_EXTERNAL_STORAGE`, `READ_EXTERNAL_STORAGE`
- **Location:** `android/app/src/main/AndroidManifest.xml`
- **Note:** For Android 10+ (API 29+), scoped storage is used automatically, so these may not be strictly required, but included for compatibility

## Permission Request Flow

1. **User opens voice analysis screen**
   - App calls `VoiceAssistantService.initialize()`
   - This calls `AudioService.initialize()`
   - `AudioService` requests microphone permission via `Permission.microphone.request()`

2. **Permission dialog appears**
   - **Android:** System permission dialog
   - **iOS:** System permission dialog with custom message from `NSMicrophoneUsageDescription`

3. **User grants/denies permission**
   - **Granted:** Recording can proceed
   - **Denied:** User sees error message and must enable in settings

## Handling Permission Denials

If the user denies microphone permission:

1. **First denial:** App shows a SnackBar message explaining the need for permission
2. **Subsequent denials:** User must manually enable in device settings
3. **Code location:** `lib/screens/voice_analysis_screen.dart` → `_initializeService()`

## Testing Permissions

### Android
```bash
# Check current permissions
adb shell dumpsys package com.example.lira | grep permission

# Grant permission manually (for testing)
adb shell pm grant com.example.lira android.permission.RECORD_AUDIO

# Revoke permission (for testing)
adb shell pm revoke com.example.lira android.permission.RECORD_AUDIO
```

### iOS
- Permissions are managed through Settings app
- For testing, you can reset permissions by deleting and reinstalling the app

## Troubleshooting

### Permission not requested
- **Check:** Ensure `permission_handler` is in `pubspec.yaml`
- **Check:** Verify Android manifest has `RECORD_AUDIO` permission
- **Check:** Verify iOS Info.plist has `NSMicrophoneUsageDescription`

### Permission denied but app doesn't show error
- **Check:** Error handling in `_initializeService()` method
- **Check:** SnackBar is properly displayed in the widget tree

### Permission works in debug but not release
- **Android:** Check if ProGuard is stripping permission-related code
- **iOS:** Verify Info.plist is included in release build

## Best Practices

1. **Request permission when needed:** Don't request on app launch, only when user tries to use voice feature
2. **Explain why:** The iOS description explains why microphone is needed
3. **Handle gracefully:** Show clear error messages if permission is denied
4. **Provide fallback:** Allow text input as alternative to voice

## Future Enhancements

- Add permission status indicator in UI
- Add "Open Settings" button when permission is denied
- Request permission with better context (e.g., "We need microphone to hear your voice")

