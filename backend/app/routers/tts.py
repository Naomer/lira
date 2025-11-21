import base64

from fastapi import APIRouter

from ..schemas import TTSRequest, TTSResponse

router = APIRouter()


@router.post("/", response_model=TTSResponse)
async def synthesize(request: TTSRequest) -> TTSResponse:
    """
    Placeholder TTS endpoint.

    Replace with Coqui TTS or gTTS output encoded as base64.
    """
    dummy_audio = b"\x00\x00"
    audio_base64 = base64.b64encode(dummy_audio).decode("utf-8")

    return TTSResponse(audio_base64=audio_base64)

