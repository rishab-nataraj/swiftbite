"""Seed the database with demo restaurants, menus and a demo user."""
from sqlalchemy.orm import Session

from app.core.security import hash_password
from app.models import MenuItem, Restaurant, User

RESTAURANTS = [
    {
        "name": "Tandoori Junction",
        "cuisine": "North Indian",
        "description": "Clay-oven kebabs, rich curries and fresh naan.",
        "rating": 4.5,
        "delivery_fee": 29.0,
        "eta_minutes": 32,
        "menu": [
            ("Butter Chicken", "Creamy tomato gravy, boneless chicken", 289.0, "Mains", False),
            ("Paneer Tikka Masala", "Char-grilled paneer in spiced gravy", 249.0, "Mains", True),
            ("Garlic Naan", "Tandoor-baked, brushed with butter", 59.0, "Breads", True),
            ("Dal Makhani", "Slow-cooked black lentils", 199.0, "Mains", True),
            ("Gulab Jamun (2 pc)", "Warm milk dumplings in syrup", 89.0, "Desserts", True),
        ],
    },
    {
        "name": "Bella Napoli",
        "cuisine": "Italian",
        "description": "Wood-fired Neapolitan pizza and handmade pasta.",
        "rating": 4.6,
        "delivery_fee": 39.0,
        "eta_minutes": 28,
        "menu": [
            ("Margherita Pizza", "San Marzano tomato, fior di latte, basil", 329.0, "Pizza", True),
            ("Pepperoni Pizza", "Double pepperoni, mozzarella", 429.0, "Pizza", False),
            ("Penne Arrabbiata", "Chilli-tomato sauce, garlic, parsley", 299.0, "Pasta", True),
            ("Garlic Bread", "Toasted sourdough, herb butter", 149.0, "Sides", True),
            ("Tiramisu", "Mascarpone, espresso, cocoa", 199.0, "Desserts", True),
        ],
    },
    {
        "name": "Wok This Way",
        "cuisine": "Chinese",
        "description": "Street-style Indo-Chinese, tossed to order.",
        "rating": 4.3,
        "delivery_fee": 25.0,
        "eta_minutes": 25,
        "menu": [
            ("Veg Hakka Noodles", "Wok-tossed noodles with crunchy veg", 189.0, "Noodles", True),
            ("Chilli Chicken (Dry)", "Crispy chicken, peppers, soy glaze", 259.0, "Starters", False),
            ("Veg Manchurian", "Fried veg balls in tangy gravy", 209.0, "Mains", True),
            ("Schezwan Fried Rice", "Spicy, smoky, wok-charred", 199.0, "Rice", True),
            ("Spring Rolls (4 pc)", "Shredded veg, crisp pastry", 139.0, "Starters", True),
        ],
    },
    {
        "name": "The Burger Lab",
        "cuisine": "American",
        "description": "Smashed patties, brioche buns, loaded fries.",
        "rating": 4.4,
        "delivery_fee": 19.0,
        "eta_minutes": 22,
        "menu": [
            ("Classic Cheeseburger", "Smashed beef patty, cheddar, pickles", 249.0, "Burgers", False),
            ("Crispy Paneer Burger", "Spiced paneer, slaw, chipotle mayo", 219.0, "Burgers", True),
            ("Loaded Cheese Fries", "Fries, cheese sauce, jalapenos", 169.0, "Sides", True),
            ("Chicken Wings (6 pc)", "Buffalo or BBQ glaze", 279.0, "Sides", False),
            ("Chocolate Shake", "Thick, malted, real cocoa", 149.0, "Beverages", True),
        ],
    },
    {
        "name": "Green Bowl Co.",
        "cuisine": "Healthy",
        "description": "Salads, grain bowls and cold-pressed juices.",
        "rating": 4.1,
        "delivery_fee": 35.0,
        "eta_minutes": 20,
        "menu": [
            ("Quinoa Power Bowl", "Quinoa, chickpea, avocado, tahini", 319.0, "Bowls", True),
            ("Caesar Salad", "Romaine, parmesan, herb croutons", 259.0, "Salads", True),
            ("Grilled Chicken Bowl", "Brown rice, greens, lemon herb chicken", 349.0, "Bowls", False),
            ("Cold Pressed Orange", "250 ml, no added sugar", 129.0, "Beverages", True),
            ("Overnight Oats", "Oats, chia, banana, almond", 179.0, "Breakfast", True),
        ],
    },
    {
        "name": "Sushi Sen",
        "cuisine": "Japanese",
        "description": "Fresh nigiri, maki rolls and ramen.",
        "rating": 4.7,
        "delivery_fee": 49.0,
        "eta_minutes": 38,
        "menu": [
            ("Salmon Nigiri (4 pc)", "Sushi rice, fresh salmon", 449.0, "Sushi", False),
            ("Avocado Maki (6 pc)", "Avocado, cucumber, sesame", 299.0, "Sushi", True),
            ("Shoyu Ramen", "Soy broth, noodles, egg, scallion", 389.0, "Ramen", False),
            ("Edamame", "Steamed, sea salt", 159.0, "Starters", True),
            ("Matcha Cheesecake", "Baked, ceremonial-grade matcha", 229.0, "Desserts", True),
        ],
    },
]


def seed(db: Session) -> None:
    """Insert demo data only if the restaurants table is empty (idempotent)."""
    if db.query(Restaurant).first():
        print("[seed] data already present - skipping")
        return

    for entry in RESTAURANTS:
        restaurant = Restaurant(
            name=entry["name"],
            cuisine=entry["cuisine"],
            description=entry["description"],
            rating=entry["rating"],
            delivery_fee=entry["delivery_fee"],
            eta_minutes=entry["eta_minutes"],
            is_open=True,
        )
        for name, desc, price, category, is_veg in entry["menu"]:
            restaurant.menu_items.append(
                MenuItem(
                    name=name,
                    description=desc,
                    price=price,
                    category=category,
                    is_veg=is_veg,
                    is_available=True,
                )
            )
        db.add(restaurant)

    if not db.query(User).filter(User.email == "demo@swiftbite.com").first():
        db.add(
            User(
                name="Demo Customer",
                email="demo@swiftbite.com",
                hashed_password=hash_password("demo1234"),
                phone="9876543210",
                address="Block A, VIT Vellore, Tamil Nadu 632014",
                role="customer",
            )
        )

    db.commit()
    print(f"[seed] inserted {len(RESTAURANTS)} restaurants + demo user")
