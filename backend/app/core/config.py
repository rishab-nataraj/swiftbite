"""Application configuration loaded from environment variables."""
import os


class Settings:
    PROJECT_NAME: str = "SwiftBite API"
    VERSION: str = "1.0.0"
    API_PREFIX: str = "/api"

    DATABASE_URL: str = os.getenv(
        "DATABASE_URL",
        "postgresql://swiftbite:swiftbite@db:5432/swiftbite",
    )
    SECRET_KEY: str = os.getenv("SECRET_KEY", "dev-secret-change-me")
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24

    CORS_ORIGINS: list[str] = ["*"]


settings = Settings()
