# 📋 SwiftBite — User Stories

**Total: 25 user stories** · Tracked as GitHub Issues on the SwiftBite project board.

Every story follows the standard form:

> **As a** `<role>`, **I want** `<capability>`, **so that** `<benefit>`.

Each story carries: a MoSCoW priority, a story-point estimate (Fibonacci), an epic label, and testable acceptance criteria in Given/When/Then form.

**Story point scale:** 1 = trivial · 2 = small · 3 = medium · 5 = large · 8 = very large
**Total committed points:** 96

---

## Epic index

| Epic | Stories | Points |
|------|---------|--------|
| 🔐 Authentication & Accounts | US-01 – US-04 | 13 |
| 🔍 Discovery & Search | US-05 – US-08 | 13 |
| 🍽 Menu & Browsing | US-09 – US-11 | 10 |
| 🛒 Cart Management | US-12 – US-15 | 12 |
| 💳 Checkout & Ordering | US-16 – US-19 | 18 |
| 📍 Order Tracking & History | US-20 – US-22 | 13 |
| 🍳 Restaurant Operations | US-23 – US-24 | 10 |
| ⚙️ Platform & DevOps | US-25 | 7 |

---

# 🔐 Epic 1 — Authentication & Accounts

---

### US-01 · Customer registration

> **As a** new customer, **I want** to create an account with my email and password, **so that** I can place orders and have my details remembered.

- **Priority:** 🔴 Must Have
- **Points:** 3
- **Labels:** `user-story`, `must-have`, `epic:auth`, `backend`, `frontend`

**Acceptance criteria**

- **Given** I am on `/register`, **when** I submit a valid name, email and password (≥ 6 chars), **then** an account is created and I am signed in automatically.
- **Given** I submit an email that already exists, **when** the form is sent, **then** I see the error "Email already registered" and no duplicate account is created.
- **Given** I submit a password shorter than 6 characters, **when** the form is sent, **then** validation blocks submission.
- **Given** an account is created, **then** the password is stored bcrypt-hashed — never in plain text.
- **Given** registration succeeds, **then** the response contains a JWT and the user object.

**Definition of Done:** `POST /api/auth/register` returns `201`; UI redirects to the restaurant list; password hash verified in the database.

---

### US-02 · Customer login

> **As a** returning customer, **I want** to sign in with my email and password, **so that** I can access my cart, orders and saved address.

- **Priority:** 🔴 Must Have
- **Points:** 3
- **Labels:** `user-story`, `must-have`, `epic:auth`, `backend`, `frontend`

**Acceptance criteria**

- **Given** correct credentials, **when** I submit the login form, **then** I receive a JWT valid for 24 hours and land on the restaurant list.
- **Given** an incorrect password, **when** I submit, **then** I see "Incorrect email or password" and receive HTTP `401`.
- **Given** an unregistered email, **then** the same generic error appears (no account enumeration).
- **Given** I am signed in, **then** my name appears in the navigation bar.

**Definition of Done:** `POST /api/auth/login` returns a bearer token; token attached to all subsequent requests.

---

### US-03 · Stay signed in across sessions

> **As a** customer, **I want** to remain signed in when I close and reopen the browser, **so that** I do not have to log in every single time.

- **Priority:** 🟡 Should Have
- **Points:** 2
- **Labels:** `user-story`, `should-have`, `epic:auth`, `frontend`

**Acceptance criteria**

- **Given** I sign in successfully, **then** the JWT and user profile are written to `localStorage`.
- **Given** I refresh the page or reopen the browser, **then** I am still signed in and the navbar shows my name.
- **Given** I click "Sign out", **then** `localStorage` is cleared and I am returned to the public restaurant list.
- **Given** my token has expired, **when** I call a protected endpoint, **then** I receive `401` and am redirected to login.

**Definition of Done:** Session survives a hard refresh; DevTools → Application → Local Storage shows `sb_token` and `sb_user`.

---

### US-04 · Protected routes

> **As the** system, **I want** to block unauthenticated users from checkout and order pages, **so that** orders are always attributable to a real account.

- **Priority:** 🔴 Must Have
- **Points:** 5
- **Labels:** `user-story`, `must-have`, `epic:auth`, `backend`, `frontend`, `security`

**Acceptance criteria**

- **Given** I am signed out, **when** I navigate to `/checkout` or `/orders`, **then** I am redirected to `/login`.
- **Given** I call `POST /api/orders` with no `Authorization` header, **then** the API returns `401`.
- **Given** I send a malformed or tampered JWT, **then** the API returns `401` with "Could not validate credentials".
- **Given** I am signed in as user A, **when** I request user B's order by ID, **then** I receive `404` — never another user's data.

**Definition of Done:** Route guard implemented in `App.jsx`; `get_current_user` dependency enforced on every protected endpoint.

---

# 🔍 Epic 2 — Discovery & Search

---

### US-05 · Browse restaurants

> **As a** hungry customer, **I want** to see a list of available restaurants with key details, **so that** I can decide where to order from.

- **Priority:** 🔴 Must Have
- **Points:** 3
- **Labels:** `user-story`, `must-have`, `epic:discovery`, `backend`, `frontend`

**Acceptance criteria**

- **Given** I open the home page, **then** I see a responsive grid of restaurant cards.
- **Given** a restaurant card, **then** it shows name, description, rating, cuisine, ETA and delivery fee.
- **Given** multiple restaurants, **then** they are sorted by rating in descending order.
- **Given** the list is still loading, **then** a loading state is shown rather than an empty screen.

**Definition of Done:** `GET /api/restaurants` returns seeded restaurants; grid renders at desktop, tablet and mobile widths.

---

### US-06 · Search restaurants by name

> **As a** customer with a specific craving, **I want** to search restaurants by name, **so that** I can find a place without scrolling.

- **Priority:** 🔴 Must Have
- **Points:** 3
- **Labels:** `user-story`, `must-have`, `epic:discovery`, `backend`, `frontend`

**Acceptance criteria**

- **Given** I type into the search box, **then** results update automatically after a 250 ms debounce — no button press needed.
- **Given** I type "burger" in any case, **then** "The Burger Lab" appears (case-insensitive partial match).
- **Given** no restaurant matches, **then** an empty state with a magnifier icon and helpful message is shown.
- **Given** I clear the search box, **then** the full list returns.

**Definition of Done:** `GET /api/restaurants?search=` uses `ILIKE '%term%'`; debounce prevents a request per keystroke.

---

### US-07 · Filter restaurants by cuisine

> **As a** customer, **I want** to filter restaurants by cuisine type, **so that** I can narrow the list to the kind of food I feel like.

- **Priority:** 🟡 Should Have
- **Points:** 3
- **Labels:** `user-story`, `should-have`, `epic:discovery`, `backend`, `frontend`

**Acceptance criteria**

- **Given** the home page loads, **then** filter chips are generated dynamically from the distinct cuisines in the database — not hardcoded.
- **Given** I click a cuisine chip, **then** only restaurants of that cuisine are shown and the chip is visually active.
- **Given** a chip is active, **when** I click "All", **then** the filter clears.
- **Given** both a search term and a cuisine chip are active, **then** both filters apply together.

**Definition of Done:** `GET /api/restaurants/cuisines` powers the chips; combined `?search=&cuisine=` works.

---

### US-08 · See delivery fee and ETA before opening a menu

> **As a** budget-conscious customer, **I want** to see the delivery fee and estimated time on the restaurant card itself, **so that** I am not surprised by fees at checkout.

- **Priority:** 🔴 Must Have
- **Points:** 4
- **Labels:** `user-story`, `must-have`, `epic:discovery`, `frontend`, `ux`

**Acceptance criteria**

- **Given** any restaurant card, **then** the delivery fee is displayed in ₹ and the ETA in minutes.
- **Given** a restaurant's rating, **then** it is shown to one decimal place with a star glyph.
- **Given** the restaurant detail page, **then** the same fee and ETA are repeated in the header.
- **Given** the checkout page, **then** the delivery fee shown matches the one advertised on the card exactly.

**Definition of Done:** Fee consistency verified across listing → menu → cart → checkout → order.

---

# 🍽 Epic 3 — Menu & Browsing

---

### US-09 · View a restaurant's menu

> **As a** customer, **I want** to view a restaurant's full menu with prices and descriptions, **so that** I can choose what to order.

- **Priority:** 🔴 Must Have
- **Points:** 3
- **Labels:** `user-story`, `must-have`, `epic:menu`, `backend`, `frontend`

**Acceptance criteria**

- **Given** I click a restaurant card, **then** I navigate to `/restaurants/{id}` and see its complete menu.
- **Given** a menu item, **then** its name, description and price are shown.
- **Given** the restaurant header, **then** name, description, rating, cuisine, ETA and delivery fee are shown.
- **Given** an invalid restaurant ID, **then** a clear "Restaurant not found" message appears.

**Definition of Done:** `GET /api/restaurants/{id}` returns the restaurant with a nested `menu_items` array.

---

### US-10 · Menu grouped by category

> **As a** customer, **I want** menu items grouped into categories like Starters, Mains and Desserts, **so that** I can navigate a long menu quickly.

- **Priority:** 🟡 Should Have
- **Points:** 3
- **Labels:** `user-story`, `should-have`, `epic:menu`, `frontend`, `ux`

**Acceptance criteria**

- **Given** a menu with multiple categories, **then** items appear under a bold category heading in separate panels.
- **Given** a restaurant with only one category, **then** exactly one section renders — no empty sections.
- **Given** items within a category, **then** they are ordered consistently.

**Definition of Done:** Grouping performed client-side from the `category` field; verified across all 6 seeded restaurants.

---

### US-11 · Veg / non-veg indicator

> **As a** vegetarian customer, **I want** a clear veg/non-veg marker on every dish, **so that** I can order confidently without reading each description.

- **Priority:** 🟡 Should Have
- **Points:** 4
- **Labels:** `user-story`, `should-have`, `epic:menu`, `frontend`, `accessibility`

**Acceptance criteria**

- **Given** a vegetarian item, **then** a green square-with-dot marker appears before the name.
- **Given** a non-vegetarian item, **then** a red square-with-dot marker appears.
- **Given** the marker, **then** it uses the standard Indian FSSAI convention recognisable to the target market.
- **Given** an item marked `is_available = false`, **then** its Add button is disabled and reads "Unavailable".

**Definition of Done:** `is_veg` and `is_available` from the API drive the UI; unavailable items cannot be added.

---

# 🛒 Epic 4 — Cart Management

---

### US-12 · Add items to cart

> **As a** customer, **I want** to add menu items to my cart, **so that** I can order several dishes together.

- **Priority:** 🔴 Must Have
- **Points:** 3
- **Labels:** `user-story`, `must-have`, `epic:cart`, `frontend`

**Acceptance criteria**

- **Given** I click "Add +" on a dish, **then** it is added to the cart and the navbar count increases.
- **Given** I click "Add +" on a dish already in the cart, **then** its quantity increments rather than creating a duplicate line.
- **Given** an item is added, **then** a green confirmation banner names the item and disappears after ~1.6 s.
- **Given** items are in the cart, **then** a "View cart (n)" button appears in the restaurant header.

**Definition of Done:** Cart state managed in React Context; navbar badge always matches cart contents.

---

### US-13 · Change quantity and remove items

> **As a** customer, **I want** to increase, decrease or remove items in my cart, **so that** I can correct my order before paying.

- **Priority:** 🔴 Must Have
- **Points:** 3
- **Labels:** `user-story`, `must-have`, `epic:cart`, `frontend`

**Acceptance criteria**

- **Given** a cart line, **then** a `−` / quantity / `+` stepper is shown.
- **Given** I press `+`, **then** the quantity and the line total both increase.
- **Given** quantity is 1 and I press `−`, **then** the line is removed entirely.
- **Given** I remove the last line, **then** the cart resets to the empty state.
- **Given** I press "Clear cart", **then** all lines are removed at once.

**Definition of Done:** `changeQty()` filters out zero-quantity lines; totals recompute immediately.

---

### US-14 · Cart persists across page reloads

> **As a** customer, **I want** my cart to survive a page refresh or accidental tab close, **so that** I do not lose my selections.

- **Priority:** 🟡 Should Have
- **Points:** 3
- **Labels:** `user-story`, `should-have`, `epic:cart`, `frontend`

**Acceptance criteria**

- **Given** items in the cart, **when** I refresh the page, **then** they are all still there with correct quantities.
- **Given** I close and reopen the browser, **then** the cart is restored.
- **Given** the cart changes, **then** `localStorage` is updated immediately.
- **Given** an order is placed successfully, **then** the cart is cleared from `localStorage`.

**Definition of Done:** `useEffect` syncs cart to `localStorage` on every change; verified via DevTools.

---

### US-15 · Single-restaurant cart guard

> **As the** system, **I want** to reset the cart when a customer adds an item from a different restaurant, **so that** impossible multi-restaurant orders can never be created.

- **Priority:** 🟡 Should Have
- **Points:** 3
- **Labels:** `user-story`, `should-have`, `epic:cart`, `frontend`, `backend`

**Acceptance criteria**

- **Given** my cart has items from Restaurant A, **when** I add an item from Restaurant B, **then** the cart resets and holds only the new item.
- **Given** the cart resets, **then** the restaurant name and delivery fee update to the new restaurant.
- **Given** the API receives an order with a menu item that does not belong to the specified restaurant, **then** it returns `400` with a clear message.

**Definition of Done:** Client guard in `addToCart()`; server-side validation in `place_order()` as the real enforcement.

---

# 💳 Epic 5 — Checkout & Ordering

---

### US-16 · Transparent bill summary

> **As a** customer, **I want** to see item total, delivery fee and grand total clearly itemised, **so that** I know exactly what I am paying before I commit.

- **Priority:** 🔴 Must Have
- **Points:** 3
- **Labels:** `user-story`, `must-have`, `epic:checkout`, `frontend`, `ux`

**Acceptance criteria**

- **Given** the cart page, **then** a bill panel shows item total, delivery fee and "To pay" as separate rows.
- **Given** the checkout page, **then** the same breakdown is repeated, plus a per-item line list.
- **Given** I change a quantity, **then** all totals update instantly.
- **Given** any amount, **then** it is rendered in ₹ with no decimal places.

**Definition of Done:** Totals identical on cart, checkout and the final order record.

---

### US-17 · Enter delivery address and choose payment method

> **As a** customer, **I want** to confirm my delivery address and pick how I will pay, **so that** my food reaches the right place by my preferred method.

- **Priority:** 🔴 Must Have
- **Points:** 4
- **Labels:** `user-story`, `must-have`, `epic:checkout`, `frontend`

**Acceptance criteria**

- **Given** I have a saved address on my profile, **then** the checkout address field is pre-filled with it.
- **Given** the address field, **then** it prompts for house/flat, street, landmark, city and PIN.
- **Given** the address field is empty, **then** the form cannot be submitted.
- **Given** the payment selector, **then** Cash on Delivery, UPI, Card and Wallet are all offered.
- **Given** COD is the default, **then** no payment gateway interaction is required.

**Definition of Done:** Address and payment method persist onto the created order record.

---

### US-18 · Place an order

> **As a** customer, **I want** to place my order with one click, **so that** the restaurant starts preparing my food.

- **Priority:** 🔴 Must Have
- **Points:** 5
- **Labels:** `user-story`, `must-have`, `epic:checkout`, `backend`, `frontend`

**Acceptance criteria**

- **Given** a valid cart and address, **when** I press "Place order", **then** an order is created and I am taken to its tracking page.
- **Given** the order is created, **then** its status is `PLACED` and `placed_at` is set to the current UTC time.
- **Given** the order is created, **then** the cart is cleared.
- **Given** the restaurant is closed (`is_open = false`), **then** the API rejects the order with `400` and a clear message.
- **Given** an empty items array, **then** the API returns `400` "Cart is empty".
- **Given** the button is pressed, **then** it disables and shows "Placing order…" to prevent double submission.

**Definition of Done:** `POST /api/orders` returns `201` with the full order object including line items.

---

### US-19 · Server-side price calculation

> **As the** business, **I want** all order totals recomputed on the server from database prices, **so that** a malicious client cannot pay less than the real price.

- **Priority:** 🔴 Must Have
- **Points:** 6
- **Labels:** `user-story`, `must-have`, `epic:checkout`, `backend`, `security`

**Acceptance criteria**

- **Given** an order request, **then** the API ignores any price sent by the client and reads `menu_items.price` from the database.
- **Given** a tampered request with `price: 1`, **then** the stored order total reflects the real menu price.
- **Given** an order line, **then** `unit_price` and `name_snapshot` are frozen at order time so historical bills never change.
- **Given** a menu item marked unavailable, **then** the order is rejected with `400`.
- **Given** a menu item that belongs to a different restaurant, **then** the order is rejected with `400`.

**Definition of Done:** Verified by sending a tampered payload through Swagger UI and confirming the stored total is correct.

---

# 📍 Epic 6 — Order Tracking & History

---

### US-20 · Live order tracking timeline

> **As a** customer, **I want** to watch my order move through clear stages in real time, **so that** I know when to expect my food.

- **Priority:** 🔴 Must Have
- **Points:** 5
- **Labels:** `user-story`, `must-have`, `epic:tracking`, `backend`, `frontend`

**Acceptance criteria**

- **Given** an active order, **then** a five-stage vertical timeline is shown: Placed → Confirmed → Preparing → Out for delivery → Delivered.
- **Given** the current stage, **then** all completed stages show a green tick and a connected green line.
- **Given** the page is open, **then** it re-fetches the order every 5 seconds without any user action.
- **Given** the order status changes, **then** the timeline and the status badge update automatically.
- **Given** a delivered order, **then** the badge turns green; **given** a cancelled order, **then** it turns red and the timeline is replaced by a cancellation message.

**Definition of Done:** `setInterval` polling with cleanup on unmount; verified by advancing status in another tab.

---

### US-21 · Cancel an order

> **As a** customer, **I want** to cancel my order if I change my mind early, **so that** I am not charged for food I no longer want.

- **Priority:** 🟡 Should Have
- **Points:** 4
- **Labels:** `user-story`, `should-have`, `epic:tracking`, `backend`, `frontend`

**Acceptance criteria**

- **Given** my order is `PLACED` or `CONFIRMED`, **then** a "Cancel order" button is visible.
- **Given** the order has reached `PREPARING` or beyond, **then** the cancel button is hidden and the API returns `400` "Order can no longer be cancelled".
- **Given** I cancel, **then** the status becomes `CANCELLED` and a red badge is shown.
- **Given** I try to cancel another user's order, **then** the API returns `404`.

**Definition of Done:** `POST /api/orders/{id}/cancel` enforces the state rule server-side, not just in the UI.

---

### US-22 · View order history

> **As a** returning customer, **I want** to see all my past orders, **so that** I can check what I spent and reorder favourites.

- **Priority:** 🟡 Should Have
- **Points:** 4
- **Labels:** `user-story`, `should-have`, `epic:tracking`, `backend`, `frontend`

**Acceptance criteria**

- **Given** I open "My Orders", **then** all my orders are listed newest first.
- **Given** an order row, **then** it shows order number, item count, timestamp, status badge and total.
- **Given** I click a row, **then** I open that order's tracking page.
- **Given** I have no orders, **then** a friendly empty state with a "Order something" button is shown.
- **Given** another user's orders exist, **then** they never appear in my list.

**Definition of Done:** `GET /api/orders` filters strictly on `user_id` from the JWT.

---

# 🍳 Epic 7 — Restaurant Operations

---

### US-23 · Advance order status

> **As a** restaurant partner, **I want** to move an order through its preparation stages, **so that** the customer always sees an accurate status.

- **Priority:** 🟡 Should Have
- **Points:** 5
- **Labels:** `user-story`, `should-have`, `epic:restaurant`, `backend`, `frontend`

**Acceptance criteria**

- **Given** an order, **then** `PATCH /api/orders/{id}/status` accepts only the six valid statuses.
- **Given** an invalid status string, **then** the API returns `400` listing the valid values.
- **Given** a status change, **then** the customer's tracking page reflects it within 5 seconds.
- **Given** the demo build, **then** a "Simulate next stage →" button on the tracking page exercises this endpoint so the flow is demonstrable without a partner dashboard.

**Definition of Done:** Full lifecycle `PLACED → DELIVERED` demonstrable end-to-end in the UI.

---

### US-24 · Mark items and restaurants unavailable

> **As a** restaurant owner, **I want** to mark a dish sold out or my restaurant closed, **so that** I never receive orders I cannot fulfil.

- **Priority:** 🟢 Could Have
- **Points:** 5
- **Labels:** `user-story`, `could-have`, `epic:restaurant`, `backend`

**Acceptance criteria**

- **Given** `menu_items.is_available = false`, **then** the UI disables its Add button and the API rejects it in an order with `400`.
- **Given** `restaurants.is_open = false`, **then** any order to that restaurant is rejected with "Restaurant is currently closed".
- **Given** these flags, **then** they are enforced at the API layer, so a stale client page cannot bypass them.
- **Given** a future iteration, **then** a partner dashboard will toggle these flags (out of scope for Review 1).

**Definition of Done:** Both flags exist in the schema and are enforced in `place_order()`; toggled via SQL for the demo.

---

# ⚙️ Epic 8 — Platform & DevOps

---

### US-25 · One-command containerised setup

> **As a** developer joining the team, **I want** to start the entire application with a single command, **so that** I can contribute on day one without fighting environment setup.

- **Priority:** 🔴 Must Have
- **Points:** 7
- **Labels:** `user-story`, `must-have`, `epic:devops`, `docker`, `documentation`

**Acceptance criteria**

- **Given** a machine with only Docker installed, **when** I run `docker compose up --build`, **then** all three services start successfully.
- **Given** the stack starts, **then** the backend waits for Postgres to be healthy before accepting traffic.
- **Given** the first boot, **then** the database is seeded with 6 restaurants, 30 menu items and a demo user — and re-seeding is skipped on later boots.
- **Given** the stack is up, **then** the app is reachable at `localhost:5173` and the API docs at `localhost:8000/docs`.
- **Given** I edit a source file, **then** the change is reflected without rebuilding the image (volume mounts + hot reload).
- **Given** `docker compose down`, **then** database data survives; **given** `docker compose down -v`, **then** it is wiped and re-seeded next start.
- **Given** the README, **then** Quick Start, tooling, troubleshooting and branching strategy are all documented.

**Definition of Done:** A teammate clones the repo on a clean machine and reaches a working app in under 5 minutes.

---

## Summary table — all 25 stories

| ID | Title | Epic | Priority | Points |
|----|-------|------|----------|--------|
| US-01 | Customer registration | Auth | 🔴 Must | 3 |
| US-02 | Customer login | Auth | 🔴 Must | 3 |
| US-03 | Stay signed in across sessions | Auth | 🟡 Should | 2 |
| US-04 | Protected routes | Auth | 🔴 Must | 5 |
| US-05 | Browse restaurants | Discovery | 🔴 Must | 3 |
| US-06 | Search restaurants by name | Discovery | 🔴 Must | 3 |
| US-07 | Filter restaurants by cuisine | Discovery | 🟡 Should | 3 |
| US-08 | See delivery fee and ETA upfront | Discovery | 🔴 Must | 4 |
| US-09 | View a restaurant's menu | Menu | 🔴 Must | 3 |
| US-10 | Menu grouped by category | Menu | 🟡 Should | 3 |
| US-11 | Veg / non-veg indicator | Menu | 🟡 Should | 4 |
| US-12 | Add items to cart | Cart | 🔴 Must | 3 |
| US-13 | Change quantity and remove items | Cart | 🔴 Must | 3 |
| US-14 | Cart persists across reloads | Cart | 🟡 Should | 3 |
| US-15 | Single-restaurant cart guard | Cart | 🟡 Should | 3 |
| US-16 | Transparent bill summary | Checkout | 🔴 Must | 3 |
| US-17 | Address and payment method | Checkout | 🔴 Must | 4 |
| US-18 | Place an order | Checkout | 🔴 Must | 5 |
| US-19 | Server-side price calculation | Checkout | 🔴 Must | 6 |
| US-20 | Live order tracking timeline | Tracking | 🔴 Must | 5 |
| US-21 | Cancel an order | Tracking | 🟡 Should | 4 |
| US-22 | View order history | Tracking | 🟡 Should | 4 |
| US-23 | Advance order status | Restaurant | 🟡 Should | 5 |
| US-24 | Mark items/restaurants unavailable | Restaurant | 🟢 Could | 5 |
| US-25 | One-command containerised setup | DevOps | 🔴 Must | 7 |
| | | | **Total** | **96** |
