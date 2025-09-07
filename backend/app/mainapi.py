import motor.motor_asyncio
from beanie import init_beanie
from fastapi import FastAPI
from contextlib import asynccontextmanager

# --- Import your new settings object ---
from app.core.config import settings

from app.models.user import User, Organization
from app.routes import auth

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Code to run on startup
    print("Starting up... Connecting to database.")
    
    # --- Use the settings object to get the URI ---
    client = motor.motor_asyncio.AsyncIOMotorClient(settings.MONGO_URI)
    
    await init_beanie(
        database=client.get_database("course_app_db"),
        document_models=[User, Organization]
    )
    print("Startup complete.")

    yield

    print("Shutting down...")

app = FastAPI(lifespan=lifespan)

app.include_router(auth.router, prefix="/auth", tags=["Authentication"])

@app.get("/")
def read_root():
    return {"status": "API is running"}