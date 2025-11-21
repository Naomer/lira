import base64

from fastapi import APIRouter

from ..schemas import STTRequest, TranscriptionChunk

router = APIRouter()


@router.post("/", response_model=TranscriptionChunk)
async def transcribe(payload: STTRequest) -> TranscriptionChunk:
    """
    Placeholder STT endpoint.

    In production, stream audio chunks to Whisper/Vosk and emit partial
    transcripts via WebSocket. For now we just echo a dummy response.
    """
    _audio = base64.b64decode(payload.audio_base64)

    return TranscriptionChunk(
        text="[stub] implement Whisper/Vosk backend",
        confidence=None,
        is_final=True,
    )

