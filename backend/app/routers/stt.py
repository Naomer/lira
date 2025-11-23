import base64
import io
import tempfile
from pathlib import Path

import whisper
from fastapi import APIRouter, HTTPException

from ..schemas import STTRequest, TranscriptionChunk

router = APIRouter()

# Global Whisper model cache
_whisper_model_cache = {}


def get_whisper_model(model_size: str = "tiny"):
    """Load Whisper model (cached)."""
    if model_size not in _whisper_model_cache:
        try:
            _whisper_model_cache[model_size] = whisper.load_model(model_size)
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"Failed to load Whisper model '{model_size}': {str(e)}",
            )
    return _whisper_model_cache[model_size]


@router.post("/", response_model=TranscriptionChunk)
async def transcribe(payload: STTRequest) -> TranscriptionChunk:
    """
    Transcribe audio using Whisper.

    Accepts base64-encoded audio (WAV, MP3, etc.) and returns transcription.
    """
    try:
        # Decode audio
        audio_bytes = base64.b64decode(payload.audio_base64)
        
        # Load Whisper model
        model = get_whisper_model(payload.settings.model_size)
        
        # Save to temporary file for Whisper
        with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as tmp_file:
            tmp_file.write(audio_bytes)
            tmp_path = tmp_file.name
        
        try:
            # Transcribe
            result = model.transcribe(
                tmp_path,
                language=payload.settings.language,
                task="transcribe",
            )
            
            text = result["text"].strip()
            # Whisper doesn't provide confidence per segment easily, 
            # but we can use average logprob as a proxy
            confidence = None
            if "segments" in result and len(result["segments"]) > 0:
                avg_logprob = sum(s.get("avg_logprob", -1.0) for s in result["segments"]) / len(result["segments"])
                # Convert logprob to rough confidence (0-1 scale)
                confidence = min(1.0, max(0.0, (avg_logprob + 1.0) / 2.0))
            
            return TranscriptionChunk(
                text=text,
                confidence=confidence,
                is_final=True,
            )
        finally:
            # Clean up temp file
            Path(tmp_path).unlink(missing_ok=True)
            
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Transcription failed: {str(e)}",
        )

