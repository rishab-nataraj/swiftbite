"""Pydantic request/response schemas."""
from datetime import datetime
from typing import List, Optional

from pydantic import BaseModel, EmailStr, Field


# ---------- Auth ----------
class UserCreate(BaseModel):
    name: str = Field(..., min_length=2, max_length=120)
    email: EmailStr
    password: str = Field(..., min_length=6)
    phone: Optional[str] = None
    address: Optional[str] = None


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserOut(BaseModel):
    id: int
    name: str
    email: EmailStr
    phone: Optional[str] = None
    address: Optional[str] = None
    role: str

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserOut


# ---------- Catalogue ----------
class MenuItemOut(BaseModel):
    id: int
    restaurant_id: int
    name: str
    description: Optional[str] = None
    price: float
    category: str
    is_veg: bool
    is_available: bool

    class Config:
        from_attributes = True


class RestaurantOut(BaseModel):
    id: int
    name: str
    cuisine: str
    description: Optional[str] = None
    image_url: Optional[str] = None
    rating: float
    delivery_fee: float
    eta_minutes: int
    is_open: bool

    class Config:
        from_attributes = True


class RestaurantDetail(RestaurantOut):
    menu_items: List[MenuItemOut] = []


# ---------- Orders ----------
class OrderItemCreate(BaseModel):
    menu_item_id: int
    quantity: int = Field(1, ge=1, le=50)


class OrderCreate(BaseModel):
    restaurant_id: int
    items: List[OrderItemCreate]
    delivery_address: str
    payment_method: str = "COD"


class OrderItemOut(BaseModel):
    id: int
    menu_item_id: int
    name_snapshot: str
    unit_price: float
    quantity: int

    class Config:
        from_attributes = True


class OrderOut(BaseModel):
    id: int
    restaurant_id: int
    status: str
    subtotal: float
    delivery_fee: float
    total: float
    payment_method: str
    delivery_address: Optional[str] = None
    placed_at: datetime
    items: List[OrderItemOut] = []

    class Config:
        from_attributes = True


class OrderStatusUpdate(BaseModel):
    status: str
