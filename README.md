# Lira
**Lira** is a sleek Flutter mobile app (iOS/Android) that acts as your always-on voice buddy—like ChatGPT’s voice mode but cozier.  
It uses a cloned "grandma" voice to provide empathetic advice on daily life, emotional check-ins, quick planning (e.g., "Remind me about that meeting in Amharic?"), or just venting sessions.  

- Hands-free, real-time chat: Speak naturally (even with Ethiopian accents), it listens live, thinks via AI, and responds in a warm, storytelling tone.  
- Privacy-first (mostly on-device), with optional integration with Neuroviate vibes for multicultural empathy.  
- Monetization can be added later via premium voices or third-party integrations.  
- Target audience: Busy individuals craving low-key wisdom, starting in Ethiopia/global diaspora.  

---

## 🔥 Tech Stack & Free LLM Options

### Frontend
![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)

### Backend
![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=white)

### AI & LLMs (Free)
![Mistral](https://img.shields.io/badge/Mistral-Free?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAK...) 
![LLaMA](https://img.shields.io/badge/LLaMA-Free?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAK...) 
![OpenRouter](https://img.shields.io/badge/OpenRouter-Free?logo=openai&logoColor=white)
![HuggingFace](https://img.shields.io/badge/HuggingFace-Free?logo=huggingface&logoColor=white)

### Speech Processing (Free)
![Whisper](https://img.shields.io/badge/Whisper-Free?logo=ai&logoColor=white)
![Vosk](https://img.shields.io/badge/Vosk-Free?logo=ai&logoColor=white)
![CoquiTTS](https://img.shields.io/badge/CoquiTTS-Free?logo=ai&logoColor=white)
![FlutterTTS](https://img.shields.io/badge/FlutterTTS-Free?logo=flutter&logoColor=white)

---

## 📸 Screenshots
<p align="center">
  <img src="https://raw.githubusercontent.com/Naomer/lira/567e552045b40a20d08d8f4bb99a7eb09be0e8e7/IMG_6680.PNG" alt="Lira Home Screen" width="300" />
  <img src="https://raw.githubusercontent.com/Naomer/lira/3903e290a9d1f6220b24ad5193fe99a60056beb9/IMG_6681.PNG" alt="Lira Voice Screen" width="300" />
</p>

</p>

---

## 🏗️ UI Components

### 1. Home / Dashboard Screen (`lib/screens/home_screen.dart`)
- User greeting with profile picture  
- "Good Morning" prompt  
- Main "Talk to AI assistant" card with **Start Talking** button  
- Voice and Image feature cards  
- Topics section with pill-shaped buttons  
- Information cards (Blood pressure, Sleep)  
- Bottom navigation bar with AI sparkle button  

### 2. Voice Analysis Screen (`lib/screens/voice_analysis_screen.dart`)
- "Listening..." indicator  
- Animated 3D orb visualizer with gradient colors  
- Live transcript display  
- Bottom control bar with timer, microphone button, and cancel button  

### 3. Smart Chat Screen (`lib/screens/smart_chat_screen.dart`)
- Chat interface with AI and user message bubbles  
- Sparkle icons for AI messages  
- Audio message bubbles with waveform visualization  
- Text input field with mic and add buttons  
- Pre-populated sample conversation  

### 4. Shared Components
- **Gradient Background** (`lib/utils/gradient_background.dart`) — Purple/pink gradient  
- **Status Bar** (`lib/widgets/status_bar.dart`) — Time, signal, WiFi, battery  
- **Orb Visualizer** (`lib/widgets/orb_visualizer.dart`) — Animated 3D sphere with swirling patterns  

---

## 🎨 Design Features
- Purple/pink gradient backgrounds matching app visuals  
- Rounded corners on all UI elements  
- Modern, clean aesthetic  
- Smooth animations on the orb visualizer  
- Consistent color scheme using `#9B7EDE` purple  

---

## 🧠 Lira MVP Workflow

```mermaid
flowchart TD
    A[User speaks into Flutter app] --> B[Flutter captures audio]
    B --> C[Speech-to-Text (Whisper / Vosk / Coqui STT)]
    C --> D[Text sent to Python FastAPI backend]
    D --> E[Backend queries Free LLM (Mistral / LLaMA / OpenRouter)]
    E --> F[AI generates agentic response (grandma voice style)]
    F --> G[Text returned to Flutter app]
    G --> H[Text-to-Speech (Coqui TTS / flutter_tts)]
    H --> I[Flutter plays AI voice response]
    I --> A[User continues conversation]
```

**Workflow explanation:**  
1. User speaks → Flutter captures audio  
2. Audio → text via STT  
3. Python backend receives text → queries free LLM  
4. LLM generates empathetic, agentic response  
5. Text-to-speech converts AI text → voice  
6. Flutter plays voice back to user  
7. Conversation continues naturally  

---

## 🛠️ Free Backend Setup (Python + LLM)
- **Python** with **FastAPI** for REST API endpoints  
- Free LLM options: OpenRouter, HuggingFace Inference (Mistral, LLaMA, Grok, Qwen)  
- Speech-to-Text: Whisper (local) or Vosk  
- Text-to-Speech: Coqui TTS or flutter_tts  
- Conversation memory: store last 3–5 messages in RAM (privacy-first)  

> Fully free, no subscription required, and privacy-friendly MVP  

---

## 📂 Project Structure
```
Lira/
│── lib/
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── voice_analysis_screen.dart
│   │   └── smart_chat_screen.dart
│   ├── widgets/
│   │   ├── status_bar.dart
│   │   └── orb_visualizer.dart
│   └── utils/
│       └── gradient_background.dart
│── assets/
│── backend/
│   └── main.py (FastAPI + LLM endpoint)
│── README.md
```

---

## ▶️ Getting Started

### 1. Clone the repository
```
git clone https://github.com/your-username/lira.git
cd lira
```

### 2. Install Flutter dependencies
```
flutter pub get
```

### 3. Run the app
```
flutter run
```

### 4. Backend setup
```
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```

---

## 📌 Roadmap for MVP → Full App
- Multi-language support (Amharic, English)  
- Premium voices & AI personality options  
- Push notifications & reminders  
- Advanced conversation memory & reasoning  
- Integrations with Neuroviate for multicultural empathy  
- Polished UI animations and orb visualizer  

---

## 🤝 Contributing
Pull requests welcome! Please open an issue for major changes.

---

## 📄 License
MIT License
