# Lira Backend

FastAPI project that powers the agentic behavior, live voice pipeline, and
LLM integrations for Lira.

## Features

- `/chat`: orchestrates persona prompts + conversation memory and forwards
  requests to free LLM providers (OpenRouter, HuggingFace, local models).
- `/stt`: placeholder Speech-to-Text route; upgrade to Whisper/Vosk streaming.
- `/tts`: placeholder Text-to-Speech route; upgrade to Coqui TTS or gTTS.
- `/health`: uptime check for mobile clients.

## Getting Started

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate  # or source .venv/bin/activate on macOS/Linux
pip install -r requirements.txt
uvicorn app:app --reload
```

## Environment Variables

| Variable      | Description                                      | Default                               |
|---------------|--------------------------------------------------|---------------------------------------|
| `LLM_BASE_URL`| Provider endpoint                                | `https://openrouter.ai/api`           |
| `LLM_API_KEY` | Secret for OpenRouter/HF/etc.                    | _(required for remote providers)_     |
| `LLM_MODEL`   | Model slug (e.g., `openrouter/mistral-7b-instruct`) | `openrouter/mistral-7b-instruct` |

Store them in a `.env` and load with `python-dotenv` or your process manager.

## Roadmap

1. **STT streaming**: swap `/stt` stub with Whisper (via `faster-whisper`) or
   Vosk server. Return partial transcripts for low-latency UX.
2. **TTS synthesis**: integrate Coqui TTS for the “grandma” voice and cache
   snippets locally to reduce regeneration time.
3. **Tooling**: add LangChain or custom planner for reminders, journaling, and
   calendar hooks. Use the `tool_calls` schema to signal the Flutter client.
4. **Persistence**: when ready, persist memory snippets in SQLite (or Supabase)
   to survive reconnects while staying privacy-first.

This backend is intentionally lightweight so you can prototype freely and only
pay for infrastructure once you outgrow the free tiers.

