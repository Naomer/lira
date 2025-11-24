import base64
import tempfile
from pathlib import Path

from fastapi import APIRouter, HTTPException

from ..schemas import TTSRequest, TTSResponse

router = APIRouter()

# Try to import TTS, but handle if it's not installed
try:
    from TTS.api import TTS
    TTS_AVAILABLE = True
except ImportError:
    TTS_AVAILABLE = False
    TTS = None

# Global TTS model cache
_tts_model_cache = {}


def get_tts_model(voice: str = "grandma"):
    """
    Load Coqui TTS model (cached).
    
    For 'grandma' voice, we use a warm, empathetic model.
    Falls back to default English model if specific voice not available.
    """
    if not TTS_AVAILABLE:
        raise HTTPException(
            status_code=503,
            detail="TTS is not installed. Install with: py -m pip install TTS",
        )
    
    cache_key = voice
    
    if cache_key not in _tts_model_cache:
        try:
            # Use a warm, natural-sounding model for grandma voice
            # You can customize this model name based on your preference
            # Options: "tts_models/en/ljspeech/tacotron2-DDC", 
            #          "tts_models/en/vctk/vits", etc.
            model_name = "tts_models/en/ljspeech/tacotron2-DDC"
            _tts_model_cache[cache_key] = TTS(model_name=model_name)
        except Exception as e:
            raise HTTPException(
                status_code=500,
                detail=f"Failed to load TTS model: {str(e)}",
            )
    return _tts_model_cache[cache_key]


@router.post("/", response_model=TTSResponse)
async def synthesize(request: TTSRequest) -> TTSResponse:
    """
    Synthesize speech using Coqui TTS.

    Returns base64-encoded WAV audio.
    """
    try:
        if not request.text.strip():
            raise HTTPException(status_code=400, detail="Text cannot be empty")
        
        # Load TTS model
        tts = get_tts_model(request.voice)
        
        # Generate speech to temporary file
        with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as tmp_file:
            tmp_path = tmp_file.name
        
        try:
            # Synthesize
            tts.tts_to_file(
                text=request.text,
                file_path=tmp_path,
                speed=request.speed,
            )
            
            # Read audio file and encode as base64
            with open(tmp_path, "rb") as f:
                audio_bytes = f.read()
            
            audio_base64 = base64.b64encode(audio_bytes).decode("utf-8")
            
            return TTSResponse(audio_base64=audio_base64)
        finally:
            # Clean up temp file
            Path(tmp_path).unlink(missing_ok=True)
            
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"TTS synthesis failed: {str(e)}",
        )

