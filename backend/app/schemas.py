from __future__ import annotations

from enum import Enum
from typing import Literal

from pydantic import BaseModel, Field


class Role(str, Enum):
    USER = "user"
    ASSISTANT = "assistant"
    SYSTEM = "system"


class Message(BaseModel):
    role: Role
    content: str


class ToolCall(BaseModel):
    name: str
    arguments: dict[str, str] | None = None


class ChatRequest(BaseModel):
    conversation: list[Message] = Field(
        ...,
        description="Ordered history, newest last.",
    )
    locale: str = Field(
        default="en-US",
        description="Used for STT/TTS hints and persona tweaks.",
    )
    model: str | None = Field(
        default=None,
        description="Optional override for provider/model.",
    )
    personality: Literal["grandma", "default"] = Field(
        default="grandma",
        description="Grandma persona aligns with Lira's brand.",
    )


class ChatReply(BaseModel):
    reply: str
    reasoning: str | None = None
    tool_calls: list[ToolCall] | None = None


class ChatResponse(ChatReply):
    pass


class TranscriptionChunk(BaseModel):
    text: str
    confidence: float | None = None
    is_final: bool = False


class STTSettings(BaseModel):
    model_size: Literal["tiny", "base", "small"] = Field(default="small")
    language: str | None = None


class STTRequest(BaseModel):
    audio_base64: str
    settings: STTSettings = Field(default_factory=STTSettings)


class TTSRequest(BaseModel):
    text: str
    voice: str = "grandma"
    speed: float = Field(default=1.0, ge=0.5, le=1.5)


class TTSResponse(BaseModel):
    audio_base64: str

