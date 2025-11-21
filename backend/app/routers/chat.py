from fastapi import APIRouter, Depends

from ..schemas import ChatRequest, ChatResponse
from ..services.llm import LLMService, get_llm_service

router = APIRouter()


@router.post("/", response_model=ChatResponse)
async def chat(
    payload: ChatRequest,
    llm_service: LLMService = Depends(get_llm_service),
) -> ChatResponse:
    """
    Agentic chat endpoint.

    Accepts a transcript snippet + conversation history,
    then produces the assistant's next response.
    """
    reply = await llm_service.generate_reply(payload)

    return ChatResponse(
        reply=reply.reply,
        reasoning=reply.reasoning,
        tool_calls=reply.tool_calls,
    )

