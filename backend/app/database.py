"""SQLAlchemy engine, session factory and declarative base."""
import time

from sqlalchemy import create_engine
from sqlalchemy.exc import OperationalError
from sqlalchemy.orm import declarative_base, sessionmaker

from app.core.config import settings

engine = create_engine(settings.DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


def get_db():
    """FastAPI dependency that yields a database session."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def wait_for_db(retries: int = 30, delay: int = 2) -> None:
    """Block until Postgres accepts connections (compose start-order safety)."""
    for attempt in range(1, retries + 1):
        try:
            with engine.connect():
                print(f"[db] connected on attempt {attempt}")
                return
        except OperationalError:
            print(f"[db] not ready (attempt {attempt}/{retries}) - retrying...")
            time.sleep(delay)
    raise RuntimeError("Database never became available")
