"""SwiftBite API entrypoint."""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.database import Base, SessionLocal, engine, wait_for_db
from app.routers import auth, orders, restaurants
from app.seed import seed

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description=(
        "REST API for SwiftBite, a food ordering and delivery platform. "
        "Built for Software Engineering Digital Assignment 1."
    ),
    docs_url="/docs",
    redoc_url="/redoc",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def on_startup() -> None:
    """Wait for Postgres, create tables, then seed demo data."""
    wait_for_db()
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        seed(db)
    finally:
        db.close()


@app.get("/health", tags=["System"])
def health():
    """Liveness probe used by Docker Compose healthcheck."""
    return {"status": "ok", "service": settings.PROJECT_NAME, "version": settings.VERSION}


app.include_router(auth.router, prefix=settings.API_PREFIX)
app.include_router(restaurants.router, prefix=settings.API_PREFIX)
app.include_router(orders.router, prefix=settings.API_PREFIX)
