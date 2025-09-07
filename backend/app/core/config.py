from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', env_file_encoding='utf-8')
    
    MONGO_URI: str
    SECRET_KEY: str # Add this
    ALGORITHM: str # Add this
    ACCESS_TOKEN_EXPIRE_MINUTES: int # Add this

settings = Settings()