from fastapi import FastAPI

from .routers import chat, stt, tts

app = FastAPI(
    title="Lira Agentic Backend",
    version="0.1.0",
    description=(
        "Backend services that power Lira's live voice interactions, "
        "LLM reasoning, and agentic behaviors."
    ),
)

app.include_router(chat.router, prefix="/chat", tags=["chat"])
app.include_router(stt.router, prefix="/stt", tags=["speech-to-text"])
app.include_router(tts.router, prefix="/tts", tags=["text-to-speech"])


@app.get("/health", tags=["health"])
async def health_check() -> dict[str, str]:
    """Simple liveness endpoint for uptime checks."""
    return {"status": "ok"}

