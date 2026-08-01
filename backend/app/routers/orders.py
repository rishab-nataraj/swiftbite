"""Order placement, history and status-tracking routes."""
from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.security import get_current_user
from app.database import get_db
from app.models import MenuItem, Order, OrderItem, Restaurant, User
from app.schemas import OrderCreate, OrderOut, OrderStatusUpdate

router = APIRouter(prefix="/orders", tags=["Orders"])

VALID_STATUSES = [
    "PLACED",
    "CONFIRMED",
    "PREPARING",
    "OUT_FOR_DELIVERY",
    "DELIVERED",
    "CANCELLED",
]


@router.post("", response_model=OrderOut, status_code=status.HTTP_201_CREATED)
def place_order(
    payload: OrderCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Place an order. Prices are recomputed server-side, never trusted from client."""
    restaurant = db.query(Restaurant).filter(Restaurant.id == payload.restaurant_id).first()
    if not restaurant:
        raise HTTPException(status_code=404, detail="Restaurant not found")
    if not restaurant.is_open:
        raise HTTPException(status_code=400, detail="Restaurant is currently closed")
    if not payload.items:
        raise HTTPException(status_code=400, detail="Cart is empty")

    order = Order(
        user_id=current_user.id,
        restaurant_id=restaurant.id,
        status="PLACED",
        payment_method=payload.payment_method,
        delivery_address=payload.delivery_address or current_user.address,
        delivery_fee=restaurant.delivery_fee,
    )

    subtotal = 0.0
    for line in payload.items:
        item = (
            db.query(MenuItem)
            .filter(
                MenuItem.id == line.menu_item_id,
                MenuItem.restaurant_id == restaurant.id,
            )
            .first()
        )
        if not item:
            raise HTTPException(
                status_code=400,
                detail=f"Menu item {line.menu_item_id} not on this restaurant's menu",
            )
        if not item.is_available:
            raise HTTPException(status_code=400, detail=f"'{item.name}' is unavailable")

        subtotal += item.price * line.quantity
        order.items.append(
            OrderItem(
                menu_item_id=item.id,
                name_snapshot=item.name,
                unit_price=item.price,
                quantity=line.quantity,
            )
        )

    order.subtotal = round(subtotal, 2)
    order.total = round(subtotal + restaurant.delivery_fee, 2)

    db.add(order)
    db.commit()
    db.refresh(order)
    return order


@router.get("", response_model=List[OrderOut])
def my_orders(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Order history for the authenticated user, newest first."""
    return (
        db.query(Order)
        .filter(Order.user_id == current_user.id)
        .order_by(Order.placed_at.desc())
        .all()
    )


@router.get("/{order_id}", response_model=OrderOut)
def get_order(
    order_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Fetch a single order — used by the live tracking screen."""
    order = (
        db.query(Order)
        .filter(Order.id == order_id, Order.user_id == current_user.id)
        .first()
    )
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return order


@router.patch("/{order_id}/status", response_model=OrderOut)
def update_status(
    order_id: int,
    payload: OrderStatusUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Advance the order lifecycle (restaurant/rider action, simulated in the demo)."""
    new_status = payload.status.upper()
    if new_status not in VALID_STATUSES:
        raise HTTPException(
            status_code=400, detail=f"Status must be one of {VALID_STATUSES}"
        )
    order = db.query(Order).filter(Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    order.status = new_status
    db.commit()
    db.refresh(order)
    return order


@router.post("/{order_id}/cancel", response_model=OrderOut)
def cancel_order(
    order_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Customer cancellation — only allowed before the food is being prepared."""
    order = (
        db.query(Order)
        .filter(Order.id == order_id, Order.user_id == current_user.id)
        .first()
    )
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    if order.status not in ("PLACED", "CONFIRMED"):
        raise HTTPException(
            status_code=400, detail="Order can no longer be cancelled"
        )
    order.status = "CANCELLED"
    db.commit()
    db.refresh(order)
    return order
