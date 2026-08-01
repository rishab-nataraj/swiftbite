#!/usr/bin/env bash
# =====================================================================
#  SwiftBite - bulk-create 25 GitHub Issues from the user stories
#  For macOS / Linux / Git Bash / WSL
# =====================================================================
#
#  BEFORE YOU RUN THIS:
#    1. Install GitHub CLI:  https://cli.github.com/
#    2. Authenticate:        gh auth login
#    3. cd into your repo:   cd /path/to/swiftbite
#    4. Make executable:     chmod +x scripts/create_issues.sh
#    5. Run:                 ./scripts/create_issues.sh
# =====================================================================

set -euo pipefail

echo "==> Checking GitHub CLI..."
gh auth status || { echo "Run 'gh auth login' first."; exit 1; }

# ---------------------------------------------------------------------
# Step 1: create labels (safe to re-run)
# ---------------------------------------------------------------------
echo ""
echo "==> Creating labels..."

create_label() {
  gh label create "$1" --color "$2" --description "$3" 2>/dev/null \
    && echo "  + $1" || echo "  = $1 (already exists)"
}

create_label "user-story"      "1d76db" "A user story from the product backlog"
create_label "must-have"       "d73a4a" "MoSCoW: Must Have"
create_label "should-have"     "fbca04" "MoSCoW: Should Have"
create_label "could-have"      "0e8a16" "MoSCoW: Could Have"
create_label "wont-have"       "cfd3d7" "MoSCoW: Won't Have this time"
create_label "epic:auth"       "5319e7" "Epic: Authentication and Accounts"
create_label "epic:discovery"  "5319e7" "Epic: Discovery and Search"
create_label "epic:menu"       "5319e7" "Epic: Menu and Browsing"
create_label "epic:cart"       "5319e7" "Epic: Cart Management"
create_label "epic:checkout"   "5319e7" "Epic: Checkout and Ordering"
create_label "epic:tracking"   "5319e7" "Epic: Order Tracking and History"
create_label "epic:restaurant" "5319e7" "Epic: Restaurant Operations"
create_label "epic:devops"     "5319e7" "Epic: Platform and DevOps"
create_label "backend"         "006b75" "FastAPI / Python work"
create_label "frontend"        "bfd4f2" "React / Vite work"
create_label "docker"          "2496ed" "Containerisation work"
create_label "security"        "b60205" "Security-related"
create_label "ux"              "f9d0c4" "User experience"
create_label "accessibility"   "c2e0c6" "Accessibility"
create_label "documentation"   "0075ca" "Documentation"

# ---------------------------------------------------------------------
# Step 2: create the 25 issues
# ---------------------------------------------------------------------
echo ""
echo "==> Creating 25 issues..."

new_story() {
  local title="$1"; local labels="$2"; local body="$3"
  gh issue create --title "$title" --label "$labels" --body "$body"
}


# --- Issue 1 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** new customer, **I want** to create an account with my email and password, **so that** I can place orders and have my details remembered.

## Priority
:red_circle: **Must Have** | **Story Points:** 3 | **Epic:** Authentication & Accounts

## Acceptance Criteria
- [ ] **Given** I am on `/register`, **when** I submit a valid name, email and password (>= 6 chars), **then** an account is created and I am signed in automatically
- [ ] **Given** I submit an email that already exists, **then** I see "Email already registered" and no duplicate is created
- [ ] **Given** a password shorter than 6 characters, **then** validation blocks submission
- [ ] **Given** an account is created, **then** the password is stored bcrypt-hashed, never plain text
- [ ] **Given** registration succeeds, **then** the response contains a JWT and the user object

## Definition of Done
`POST /api/auth/register` returns 201; UI redirects to the restaurant list; password hash verified in the database.

## Technical Notes
- Backend: `backend/app/routers/auth.py`
- Frontend: `frontend/src/pages/Register.jsx`
STORY_EOF
)
new_story "US-01: Customer registration" "user-story,must-have,epic:auth,backend,frontend" "$BODY"

# --- Issue 2 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** returning customer, **I want** to sign in with my email and password, **so that** I can access my cart, orders and saved address.

## Priority
:red_circle: **Must Have** | **Story Points:** 3 | **Epic:** Authentication & Accounts

## Acceptance Criteria
- [ ] **Given** correct credentials, **then** I receive a JWT valid for 24 hours and land on the restaurant list
- [ ] **Given** an incorrect password, **then** I see "Incorrect email or password" and receive HTTP 401
- [ ] **Given** an unregistered email, **then** the same generic error appears (no account enumeration)
- [ ] **Given** I am signed in, **then** my name appears in the navigation bar

## Definition of Done
`POST /api/auth/login` returns a bearer token; token attached to all subsequent requests.
STORY_EOF
)
new_story "US-02: Customer login" "user-story,must-have,epic:auth,backend,frontend" "$BODY"

# --- Issue 3 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** to remain signed in when I close and reopen the browser, **so that** I do not have to log in every time.

## Priority
:yellow_circle: **Should Have** | **Story Points:** 2 | **Epic:** Authentication & Accounts

## Acceptance Criteria
- [ ] **Given** I sign in, **then** the JWT and profile are written to `localStorage`
- [ ] **Given** I refresh or reopen the browser, **then** I am still signed in
- [ ] **Given** I click "Sign out", **then** `localStorage` is cleared and I return to the public list
- [ ] **Given** an expired token, **then** protected endpoints return 401 and I am redirected to login

## Definition of Done
Session survives a hard refresh; DevTools shows `sb_token` and `sb_user`.
STORY_EOF
)
new_story "US-03: Stay signed in across sessions" "user-story,should-have,epic:auth,frontend" "$BODY"

# --- Issue 4 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As the** system, **I want** to block unauthenticated users from checkout and order pages, **so that** orders are always attributable to a real account.

## Priority
:red_circle: **Must Have** | **Story Points:** 5 | **Epic:** Authentication & Accounts

## Acceptance Criteria
- [ ] **Given** I am signed out, **when** I navigate to `/checkout` or `/orders`, **then** I am redirected to `/login`
- [ ] **Given** no `Authorization` header on `POST /api/orders`, **then** the API returns 401
- [ ] **Given** a malformed or tampered JWT, **then** the API returns 401 "Could not validate credentials"
- [ ] **Given** I am user A requesting user B's order, **then** I receive 404 - never another user's data

## Definition of Done
Route guard in `App.jsx`; `get_current_user` dependency enforced on every protected endpoint.
STORY_EOF
)
new_story "US-04: Protected routes and authorisation" "user-story,must-have,epic:auth,backend,frontend,security" "$BODY"

# --- Issue 5 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** hungry customer, **I want** to see a list of available restaurants with key details, **so that** I can decide where to order from.

## Priority
:red_circle: **Must Have** | **Story Points:** 3 | **Epic:** Discovery & Search

## Acceptance Criteria
- [ ] **Given** I open the home page, **then** I see a responsive grid of restaurant cards
- [ ] **Given** a card, **then** it shows name, description, rating, cuisine, ETA and delivery fee
- [ ] **Given** multiple restaurants, **then** they are sorted by rating descending
- [ ] **Given** the list is loading, **then** a loading state is shown rather than an empty screen

## Definition of Done
`GET /api/restaurants` returns seeded restaurants; grid renders at desktop, tablet and mobile widths.
STORY_EOF
)
new_story "US-05: Browse restaurants" "user-story,must-have,epic:discovery,backend,frontend" "$BODY"

# --- Issue 6 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer with a specific craving, **I want** to search restaurants by name, **so that** I can find a place without scrolling.

## Priority
:red_circle: **Must Have** | **Story Points:** 3 | **Epic:** Discovery & Search

## Acceptance Criteria
- [ ] **Given** I type in the search box, **then** results update after a 250 ms debounce with no button press
- [ ] **Given** I type "burger" in any case, **then** "The Burger Lab" appears (case-insensitive partial match)
- [ ] **Given** no match, **then** an empty state with a helpful message is shown
- [ ] **Given** I clear the box, **then** the full list returns

## Definition of Done
`GET /api/restaurants?search=` uses ILIKE; debounce prevents a request per keystroke.
STORY_EOF
)
new_story "US-06: Search restaurants by name" "user-story,must-have,epic:discovery,backend,frontend" "$BODY"

# --- Issue 7 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** to filter restaurants by cuisine type, **so that** I can narrow the list to the kind of food I feel like.

## Priority
:yellow_circle: **Should Have** | **Story Points:** 3 | **Epic:** Discovery & Search

## Acceptance Criteria
- [ ] **Given** the home page loads, **then** filter chips are generated dynamically from distinct cuisines in the DB, not hardcoded
- [ ] **Given** I click a chip, **then** only that cuisine shows and the chip is visually active
- [ ] **Given** an active chip, **when** I click "All", **then** the filter clears
- [ ] **Given** both a search term and a chip are active, **then** both filters apply together

## Definition of Done
`GET /api/restaurants/cuisines` powers the chips; combined `?search=&cuisine=` works.
STORY_EOF
)
new_story "US-07: Filter restaurants by cuisine" "user-story,should-have,epic:discovery,backend,frontend" "$BODY"

# --- Issue 8 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** budget-conscious customer, **I want** to see the delivery fee and estimated time on the restaurant card itself, **so that** I am not surprised by fees at checkout.

## Priority
:red_circle: **Must Have** | **Story Points:** 4 | **Epic:** Discovery & Search

## Acceptance Criteria
- [ ] **Given** any card, **then** the delivery fee is shown in INR and the ETA in minutes
- [ ] **Given** a rating, **then** it shows to one decimal place with a star glyph
- [ ] **Given** the restaurant detail page, **then** the same fee and ETA repeat in the header
- [ ] **Given** the checkout page, **then** the delivery fee matches the advertised one exactly

## Definition of Done
Fee consistency verified across listing -> menu -> cart -> checkout -> order.
STORY_EOF
)
new_story "US-08: See delivery fee and ETA before opening a menu" "user-story,must-have,epic:discovery,frontend,ux" "$BODY"

# --- Issue 9 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** to view a restaurant's full menu with prices and descriptions, **so that** I can choose what to order.

## Priority
:red_circle: **Must Have** | **Story Points:** 3 | **Epic:** Menu & Browsing

## Acceptance Criteria
- [ ] **Given** I click a card, **then** I navigate to `/restaurants/{id}` and see the complete menu
- [ ] **Given** a menu item, **then** name, description and price are shown
- [ ] **Given** the header, **then** name, description, rating, cuisine, ETA and delivery fee are shown
- [ ] **Given** an invalid restaurant ID, **then** a clear "Restaurant not found" message appears

## Definition of Done
`GET /api/restaurants/{id}` returns the restaurant with a nested `menu_items` array.
STORY_EOF
)
new_story "US-09: View a restaurant's menu" "user-story,must-have,epic:menu,backend,frontend" "$BODY"

# --- Issue 10 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** menu items grouped into categories like Starters, Mains and Desserts, **so that** I can navigate a long menu quickly.

## Priority
:yellow_circle: **Should Have** | **Story Points:** 3 | **Epic:** Menu & Browsing

## Acceptance Criteria
- [ ] **Given** multiple categories, **then** items appear under a bold heading in separate panels
- [ ] **Given** a single-category restaurant, **then** exactly one section renders with no empty sections
- [ ] **Given** items within a category, **then** they are ordered consistently

## Definition of Done
Grouping performed client-side from the `category` field; verified across all 6 seeded restaurants.
STORY_EOF
)
new_story "US-10: Menu grouped by category" "user-story,should-have,epic:menu,frontend,ux" "$BODY"

# --- Issue 11 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** vegetarian customer, **I want** a clear veg/non-veg marker on every dish, **so that** I can order confidently without reading each description.

## Priority
:yellow_circle: **Should Have** | **Story Points:** 4 | **Epic:** Menu & Browsing

## Acceptance Criteria
- [ ] **Given** a vegetarian item, **then** a green square-with-dot marker appears before the name
- [ ] **Given** a non-vegetarian item, **then** a red square-with-dot marker appears
- [ ] **Given** the marker, **then** it uses the standard FSSAI convention
- [ ] **Given** `is_available = false`, **then** the Add button is disabled and reads "Unavailable"

## Definition of Done
`is_veg` and `is_available` from the API drive the UI; unavailable items cannot be added.
STORY_EOF
)
new_story "US-11: Veg / non-veg indicator" "user-story,should-have,epic:menu,frontend,accessibility" "$BODY"

# --- Issue 12 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** to add menu items to my cart, **so that** I can order several dishes together.

## Priority
:red_circle: **Must Have** | **Story Points:** 3 | **Epic:** Cart Management

## Acceptance Criteria
- [ ] **Given** I click "Add +", **then** the item is added and the navbar count increases
- [ ] **Given** the item is already in the cart, **then** its quantity increments instead of duplicating the line
- [ ] **Given** an item is added, **then** a green confirmation banner names it and fades after ~1.6 s
- [ ] **Given** items in the cart, **then** a "View cart (n)" button appears in the restaurant header

## Definition of Done
Cart state in React Context; navbar badge always matches cart contents.
STORY_EOF
)
new_story "US-12: Add items to cart" "user-story,must-have,epic:cart,frontend" "$BODY"

# --- Issue 13 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** to increase, decrease or remove items in my cart, **so that** I can correct my order before paying.

## Priority
:red_circle: **Must Have** | **Story Points:** 3 | **Epic:** Cart Management

## Acceptance Criteria
- [ ] **Given** a cart line, **then** a minus / quantity / plus stepper is shown
- [ ] **Given** I press plus, **then** quantity and line total both increase
- [ ] **Given** quantity is 1 and I press minus, **then** the line is removed
- [ ] **Given** I remove the last line, **then** the cart resets to the empty state
- [ ] **Given** I press "Clear cart", **then** all lines are removed at once

## Definition of Done
`changeQty()` filters out zero-quantity lines; totals recompute immediately.
STORY_EOF
)
new_story "US-13: Change quantity and remove items" "user-story,must-have,epic:cart,frontend" "$BODY"

# --- Issue 14 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** my cart to survive a page refresh or accidental tab close, **so that** I do not lose my selections.

## Priority
:yellow_circle: **Should Have** | **Story Points:** 3 | **Epic:** Cart Management

## Acceptance Criteria
- [ ] **Given** items in the cart, **when** I refresh, **then** they are all still there with correct quantities
- [ ] **Given** I close and reopen the browser, **then** the cart is restored
- [ ] **Given** the cart changes, **then** `localStorage` updates immediately
- [ ] **Given** an order is placed, **then** the cart is cleared from `localStorage`

## Definition of Done
`useEffect` syncs cart to `localStorage` on every change; verified via DevTools.
STORY_EOF
)
new_story "US-14: Cart persists across page reloads" "user-story,should-have,epic:cart,frontend" "$BODY"

# --- Issue 15 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As the** system, **I want** to reset the cart when a customer adds an item from a different restaurant, **so that** impossible multi-restaurant orders can never be created.

## Priority
:yellow_circle: **Should Have** | **Story Points:** 3 | **Epic:** Cart Management

## Acceptance Criteria
- [ ] **Given** items from Restaurant A, **when** I add from Restaurant B, **then** the cart resets and holds only the new item
- [ ] **Given** the reset, **then** restaurant name and delivery fee update to the new restaurant
- [ ] **Given** the API receives a menu item not belonging to the specified restaurant, **then** it returns 400

## Definition of Done
Client guard in `addToCart()`; server-side validation in `place_order()` as the real enforcement.
STORY_EOF
)
new_story "US-15: Single-restaurant cart guard" "user-story,should-have,epic:cart,frontend,backend" "$BODY"

# --- Issue 16 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** to see item total, delivery fee and grand total clearly itemised, **so that** I know exactly what I am paying before I commit.

## Priority
:red_circle: **Must Have** | **Story Points:** 3 | **Epic:** Checkout & Ordering

## Acceptance Criteria
- [ ] **Given** the cart page, **then** a bill panel shows item total, delivery fee and "To pay" as separate rows
- [ ] **Given** the checkout page, **then** the same breakdown plus a per-item line list appears
- [ ] **Given** I change a quantity, **then** all totals update instantly
- [ ] **Given** any amount, **then** it renders in INR with no decimal places

## Definition of Done
Totals identical on cart, checkout and the final order record.
STORY_EOF
)
new_story "US-16: Transparent bill summary" "user-story,must-have,epic:checkout,frontend,ux" "$BODY"

# --- Issue 17 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** to confirm my delivery address and pick how I will pay, **so that** my food reaches the right place by my preferred method.

## Priority
:red_circle: **Must Have** | **Story Points:** 4 | **Epic:** Checkout & Ordering

## Acceptance Criteria
- [ ] **Given** a saved address, **then** the checkout field is pre-filled with it
- [ ] **Given** the address field, **then** it prompts for house/flat, street, landmark, city and PIN
- [ ] **Given** an empty address, **then** the form cannot be submitted
- [ ] **Given** the payment selector, **then** COD, UPI, Card and Wallet are all offered
- [ ] **Given** COD is default, **then** no gateway interaction is required

## Definition of Done
Address and payment method persist onto the created order record.
STORY_EOF
)
new_story "US-17: Enter delivery address and choose payment method" "user-story,must-have,epic:checkout,frontend" "$BODY"

# --- Issue 18 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** to place my order with one click, **so that** the restaurant starts preparing my food.

## Priority
:red_circle: **Must Have** | **Story Points:** 5 | **Epic:** Checkout & Ordering

## Acceptance Criteria
- [ ] **Given** a valid cart and address, **then** an order is created and I land on its tracking page
- [ ] **Given** the order is created, **then** status is `PLACED` and `placed_at` is set
- [ ] **Given** the order is created, **then** the cart is cleared
- [ ] **Given** the restaurant is closed, **then** the API rejects with 400 and a clear message
- [ ] **Given** an empty items array, **then** the API returns 400 "Cart is empty"
- [ ] **Given** the button is pressed, **then** it disables and shows "Placing order..." to prevent double submission

## Definition of Done
`POST /api/orders` returns 201 with the full order object including line items.
STORY_EOF
)
new_story "US-18: Place an order" "user-story,must-have,epic:checkout,backend,frontend" "$BODY"

# --- Issue 19 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As the** business, **I want** all order totals recomputed on the server from database prices, **so that** a malicious client cannot pay less than the real price.

## Priority
:red_circle: **Must Have** | **Story Points:** 6 | **Epic:** Checkout & Ordering

## Acceptance Criteria
- [ ] **Given** an order request, **then** the API ignores client-supplied prices and reads `menu_items.price` from the DB
- [ ] **Given** a tampered request with `price: 1`, **then** the stored total reflects the real menu price
- [ ] **Given** an order line, **then** `unit_price` and `name_snapshot` are frozen at order time
- [ ] **Given** an unavailable menu item, **then** the order is rejected with 400
- [ ] **Given** a menu item from a different restaurant, **then** the order is rejected with 400

## Definition of Done
Verified by sending a tampered payload through Swagger UI and confirming the stored total is correct.
STORY_EOF
)
new_story "US-19: Server-side price calculation" "user-story,must-have,epic:checkout,backend,security" "$BODY"

# --- Issue 20 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** to watch my order move through clear stages in real time, **so that** I know when to expect my food.

## Priority
:red_circle: **Must Have** | **Story Points:** 5 | **Epic:** Order Tracking & History

## Acceptance Criteria
- [ ] **Given** an active order, **then** a five-stage vertical timeline shows Placed -> Confirmed -> Preparing -> Out for delivery -> Delivered
- [ ] **Given** the current stage, **then** completed stages show a green tick and connected green line
- [ ] **Given** the page is open, **then** it re-fetches every 5 seconds with no user action
- [ ] **Given** a status change, **then** timeline and badge update automatically
- [ ] **Given** a delivered order, **then** the badge turns green; cancelled turns red with a cancellation message

## Definition of Done
`setInterval` polling with cleanup on unmount; verified by advancing status in another tab.
STORY_EOF
)
new_story "US-20: Live order tracking timeline" "user-story,must-have,epic:tracking,backend,frontend" "$BODY"

# --- Issue 21 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** customer, **I want** to cancel my order if I change my mind early, **so that** I am not charged for food I no longer want.

## Priority
:yellow_circle: **Should Have** | **Story Points:** 4 | **Epic:** Order Tracking & History

## Acceptance Criteria
- [ ] **Given** status `PLACED` or `CONFIRMED`, **then** a "Cancel order" button is visible
- [ ] **Given** status `PREPARING` or beyond, **then** the button is hidden and the API returns 400
- [ ] **Given** I cancel, **then** status becomes `CANCELLED` with a red badge
- [ ] **Given** I try to cancel another user's order, **then** the API returns 404

## Definition of Done
`POST /api/orders/{id}/cancel` enforces the state rule server-side, not just in the UI.
STORY_EOF
)
new_story "US-21: Cancel an order" "user-story,should-have,epic:tracking,backend,frontend" "$BODY"

# --- Issue 22 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** returning customer, **I want** to see all my past orders, **so that** I can check what I spent and reorder favourites.

## Priority
:yellow_circle: **Should Have** | **Story Points:** 4 | **Epic:** Order Tracking & History

## Acceptance Criteria
- [ ] **Given** I open "My Orders", **then** all my orders are listed newest first
- [ ] **Given** a row, **then** it shows order number, item count, timestamp, status badge and total
- [ ] **Given** I click a row, **then** I open that order's tracking page
- [ ] **Given** no orders, **then** a friendly empty state with an "Order something" button is shown
- [ ] **Given** other users' orders exist, **then** they never appear in my list

## Definition of Done
`GET /api/orders` filters strictly on `user_id` from the JWT.
STORY_EOF
)
new_story "US-22: View order history" "user-story,should-have,epic:tracking,backend,frontend" "$BODY"

# --- Issue 23 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** restaurant partner, **I want** to move an order through its preparation stages, **so that** the customer always sees an accurate status.

## Priority
:yellow_circle: **Should Have** | **Story Points:** 5 | **Epic:** Restaurant Operations

## Acceptance Criteria
- [ ] **Given** an order, **then** `PATCH /api/orders/{id}/status` accepts only the six valid statuses
- [ ] **Given** an invalid status string, **then** the API returns 400 listing valid values
- [ ] **Given** a status change, **then** the customer's tracking page reflects it within 5 seconds
- [ ] **Given** the demo build, **then** a "Simulate next stage" button exercises this endpoint

## Definition of Done
Full lifecycle PLACED -> DELIVERED demonstrable end-to-end in the UI.
STORY_EOF
)
new_story "US-23: Advance order status through the lifecycle" "user-story,should-have,epic:restaurant,backend,frontend" "$BODY"

# --- Issue 24 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** restaurant owner, **I want** to mark a dish sold out or my restaurant closed, **so that** I never receive orders I cannot fulfil.

## Priority
:green_circle: **Could Have** | **Story Points:** 5 | **Epic:** Restaurant Operations

## Acceptance Criteria
- [ ] **Given** `menu_items.is_available = false`, **then** the UI disables Add and the API rejects the item with 400
- [ ] **Given** `restaurants.is_open = false`, **then** any order is rejected with "Restaurant is currently closed"
- [ ] **Given** these flags, **then** they are enforced at the API layer so a stale client cannot bypass them
- [ ] **Given** a future iteration, **then** a partner dashboard will toggle them (out of scope for Review 1)

## Definition of Done
Both flags exist in the schema and are enforced in `place_order()`; toggled via SQL for the demo.
STORY_EOF
)
new_story "US-24: Mark items and restaurants unavailable" "user-story,could-have,epic:restaurant,backend" "$BODY"

# --- Issue 25 ---
BODY=$(cat <<'STORY_EOF'
## User Story
**As a** developer joining the team, **I want** to start the entire application with a single command, **so that** I can contribute on day one without fighting environment setup.

## Priority
:red_circle: **Must Have** | **Story Points:** 7 | **Epic:** Platform & DevOps

## Acceptance Criteria
- [ ] **Given** only Docker installed, **when** I run `docker compose up --build`, **then** all three services start successfully
- [ ] **Given** startup, **then** the backend waits for Postgres to be healthy before accepting traffic
- [ ] **Given** first boot, **then** the DB is seeded with 6 restaurants, 30 menu items and a demo user; re-seeding is skipped later
- [ ] **Given** the stack is up, **then** the app is at localhost:5173 and API docs at localhost:8000/docs
- [ ] **Given** a source edit, **then** the change appears without rebuilding the image
- [ ] **Given** `docker compose down`, **then** data survives; `down -v` wipes and re-seeds
- [ ] **Given** the README, **then** Quick Start, tooling, troubleshooting and branching strategy are documented

## Definition of Done
A teammate clones the repo on a clean machine and reaches a working app in under 5 minutes.
STORY_EOF
)
new_story "US-25: One-command containerised local setup" "user-story,must-have,epic:devops,docker,documentation" "$BODY"

echo ""
echo "=================================================="
echo " DONE - 25 issues created."
echo "=================================================="
echo ""
echo "Next steps:"
echo "  1. Open your repo on GitHub -> Issues tab -> screenshot it"
echo "  2. Go to Projects -> New project -> Board -> add all 25 issues"
echo "  3. Move a few issues into 'In Progress' / 'Done' -> screenshot the board"
echo ""
gh issue list --limit 30
