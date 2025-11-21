"""
FastAPI application package for the Lira agentic backend.

This package exposes the FastAPI `app` instance so that uvicorn can run:

    uvicorn app:app --reload
"""

from .main import app

__all__ = ["app"]

