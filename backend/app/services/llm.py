from __future__ import annotations

import asyncio
import os
from functools import lru_cache

import httpx

from ..schemas import ChatReply, ChatRequest, Message

DEFAULT_MODEL = "openrouter/mistral-7b-instruct"
SYSTEM_PROMPT = """You are Lira, an empathetic Ethiopian grandmother.

Core behaviors:
- speak with warmth, sprinkle cultural sayings
- offer actionable suggestions, not just platitudes
- reflect the user's feelings and ask clarifying questions when needed
- stay concise (<= 120 words) unless user asks for a story
- if asked medical or crisis questions, respond gently and suggest professional help
"""


class LLMService:
    def __init__(self, client: httpx.AsyncClient) -> None:
        self._client = client

    async def generate_reply(self, request: ChatRequest) -> ChatReply:
        payload = self._build_payload(request)
        response = await self._client.post("/v1/chat/completions", json=payload)
        response.raise_for_status()
        data = response.json()

        message = data["choices"][0]["message"]
        reasoning = message.get("reasoning_content") or data["usage"].get(
            "prompt_tokens"
        )

        tool_calls = message.get("tool_calls")
        return ChatReply(
            reply=message["content"],
            reasoning=str(reasoning) if reasoning else None,
            tool_calls=tool_calls,
        )

    def _build_payload(self, request: ChatRequest) -> dict:
        messages: list[dict[str, str]] = [{"role": "system", "content": SYSTEM_PROMPT}]

        for message in request.conversation[-10:]:
            messages.append({"role": message.role.value, "content": message.content})

        return {
            "model": request.model or os.getenv("LLM_MODEL", DEFAULT_MODEL),
            "messages": messages,
            "temperature": 0.7,
        }


@lru_cache
def _llm_http_client() -> httpx.AsyncClient:
    base_url = os.getenv("LLM_BASE_URL", "https://openrouter.ai/api")
    api_key = os.getenv("LLM_API_KEY")
    headers = {"Authorization": f"Bearer {api_key}"} if api_key else {}

    return httpx.AsyncClient(base_url=base_url, headers=headers, timeout=60)


def get_llm_service() -> LLMService:
    return LLMService(_llm_http_client())

