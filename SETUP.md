# Lira Setup Guide

This guide will help you set up Lira's agentic AI voice assistant from scratch.

## Prerequisites

- Python 3.9+ installed
- Flutter SDK installed
- A computer with at least 8GB RAM (for running Whisper locally)
- Microphone access on your device

## Step 1: Backend Setup (Python FastAPI)

### 1.1 Install Python Dependencies

```bash
cd backend
pip install -r requirements.txt
```

**Note:** Installing Whisper and TTS may take a few minutes as they download models.

### 1.2 Configure Environment Variables

```bash
# Copy the example env file
cp .env.example .env

# Edit .env and add your API keys
# For free tier, you can use:
# - OpenRouter (sign up at https://openrouter.ai)
# - HuggingFace Inference API (sign up at https://huggingface.co)
```

### 1.3 Start the Backend Server

```bash
# From the backend directory
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The backend will be available at `http://localhost:8000`

**First run note:** Whisper will download the model on first use (tiny model is ~75MB).

## Step 2: Flutter Setup

### 2.1 Install Flutter Dependencies

```bash
# From the project root
flutter pub get
```

### 2.2 Configure Backend URL

Edit `lib/config/api_config.dart` and set the correct backend URL:

- **Local development (same machine):** `http://localhost:8000`
- **Android Emulator:** `http://10.0.2.2:8000`
- **iOS Simulator:** `http://localhost:8000`
- **Physical device:** `http://YOUR_COMPUTER_IP:8000` (find your IP with `ipconfig` on Windows or `ifconfig` on Mac/Linux)

### 2.3 Run the Flutter App

```bash
flutter run
```

## Step 3: Testing the Voice Flow

1. **Open the app** and navigate to the voice analysis screen
2. **Tap the microphone** button to start recording
3. **Speak your question** (e.g., "What's the weather like?")
4. **Tap the microphone again** to stop recording
5. The app will:
   - Transcribe your speech using Whisper
   - Send it to the LLM for a response
   - Convert the response to speech using Coqui TTS
   - Play the audio response

## Troubleshooting

### Backend Issues

**Problem:** `ModuleNotFoundError: No module named 'whisper'`
- **Solution:** Make sure you're in a virtual environment and ran `pip install -r requirements.txt`

**Problem:** Whisper model download fails
- **Solution:** Check your internet connection. Models are downloaded on first use.

**Problem:** TTS model fails to load
- **Solution:** Coqui TTS downloads models automatically. Ensure you have internet on first run.

### Flutter Issues

**Problem:** `Target of URI doesn't exist` errors
- **Solution:** Run `flutter pub get` to install dependencies

**Problem:** Can't connect to backend
- **Solution:** 
  - Check that backend is running (`http://localhost:8000/health`)
  - Verify the URL in `lib/config/api_config.dart`
  - For physical devices, ensure your phone and computer are on the same network

**Problem:** Microphone permission denied
- **Solution:** 
  - **Android:** Go to Settings → Apps → Lira → Permissions → Microphone → Allow
  - **iOS:** Go to Settings → Lira → Microphone → Enable
  - The app will request permission on first use, but if denied, you'll need to enable it manually

### Performance Issues

**Problem:** STT is slow
- **Solution:** Use a smaller Whisper model (change `model_size` to "tiny" in `stt_service.dart`)

**Problem:** TTS is slow
- **Solution:** Coqui TTS may be slow on first run. Subsequent runs are faster.

## Free LLM Options

### OpenRouter (Recommended)
1. Sign up at https://openrouter.ai
2. Get your API key from the dashboard
3. Add to `.env`: `LLM_API_KEY=your_key_here`
4. Models available: Mistral, LLaMA, Qwen, etc.

### HuggingFace Inference API
1. Sign up at https://huggingface.co
2. Create an access token
3. Add to `.env`: `LLM_API_KEY=your_token_here`
4. Models available: Mistral, LLaMA, etc.

## Next Steps

- Customize the "grandma" personality prompt in `backend/app/services/llm.py`
- Add conversation memory persistence (currently in RAM)
- Implement streaming responses for faster feedback
- Add support for multiple languages (Amharic, etc.)
- Fine-tune TTS voice to sound more like a grandma

## Architecture Overview

```
Flutter App (Voice Input)
    ↓
Audio Recording (flutter_sound)
    ↓
STT Service → FastAPI /stt → Whisper
    ↓
Chat Service → FastAPI /chat → LLM (Mistral/LLaMA/etc.)
    ↓
TTS Service → FastAPI /tts → Coqui TTS
    ↓
Audio Playback (audioplayers)
```

Enjoy building with Lira! 🎙️✨

