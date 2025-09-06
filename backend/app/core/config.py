from pydantic_settings import BaseSettings, SettingsConfigDict # type: ignore

class Settings(BaseSettings):
    # This tells Pydantic to load variables from a .env file
    model_config = SettingsConfigDict(env_file='.env', env_file_encoding='utf-8')

    # Define your settings here. Pydantic will automatically find the
    # matching variable in the .env file (case-insensitive).
    MONGO_URI: str

# Create a single, global instance of the settings
settings = Settings()