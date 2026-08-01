"""Restaurant discovery and menu browsing routes."""
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import MenuItem, Restaurant
from app.schemas import MenuItemOut, RestaurantDetail, RestaurantOut

router = APIRouter(prefix="/restaurants", tags=["Restaurants"])


@router.get("", response_model=List[RestaurantOut])
def list_restaurants(
    search: Optional[str] = Query(None, description="Search by restaurant name"),
    cuisine: Optional[str] = Query(None, description="Filter by cuisine"),
    db: Session = Depends(get_db),
):
    """List restaurants with optional search and cuisine filters."""
    q = db.query(Restaurant)
    if search:
        q = q.filter(Restaurant.name.ilike(f"%{search}%"))
    if cuisine:
        q = q.filter(Restaurant.cuisine.ilike(cuisine))
    return q.order_by(Restaurant.rating.desc()).all()


@router.get("/cuisines", response_model=List[str])
def list_cuisines(db: Session = Depends(get_db)):
    """Distinct cuisine list, used to build the filter chips in the UI."""
    rows = db.query(Restaurant.cuisine).distinct().all()
    return sorted({r[0] for r in rows})


@router.get("/{restaurant_id}", response_model=RestaurantDetail)
def get_restaurant(restaurant_id: int, db: Session = Depends(get_db)):
    """Return a single restaurant along with its full menu."""
    restaurant = db.query(Restaurant).filter(Restaurant.id == restaurant_id).first()
    if not restaurant:
        raise HTTPException(status_code=404, detail="Restaurant not found")
    return restaurant


@router.get("/{restaurant_id}/menu", response_model=List[MenuItemOut])
def get_menu(restaurant_id: int, db: Session = Depends(get_db)):
    """Return only the menu items for a restaurant."""
    if not db.query(Restaurant).filter(Restaurant.id == restaurant_id).first():
        raise HTTPException(status_code=404, detail="Restaurant not found")
    return (
        db.query(MenuItem)
        .filter(MenuItem.restaurant_id == restaurant_id)
        .order_by(MenuItem.category, MenuItem.name)
        .all()
    )
