# 🛵 SwiftBite — Food Ordering & Delivery Platform

> **Software Engineering — Digital Assignment 1 / Review 1**
> **Student:** `Rishab Nataraj, Twissampati Bal` · **Reg. No:** `24BAI1166, ` · **Slot:** `D1+TD1`
> **Repository:** `https://github.com/rishab-nataraj/swiftbite`

![Stack](https://img.shields.io/badge/frontend-React%2018%20%2B%20Vite-61dafb)
![Stack](https://img.shields.io/badge/backend-FastAPI%200.115-009688)
![Stack](https://img.shields.io/badge/database-PostgreSQL%2016-336791)
![Stack](https://img.shields.io/badge/containerised-Docker%20Compose-2496ed)

---

## 📑 Table of Contents

1. [Vision Document](#-vision-document)
   - [Project Name & Overview](#1-project-name--overview)
   - [Problem It Solves](#2-problem-it-solves)
   - [Target Users (Personas)](#3-target-users-personas)
   - [Vision Statement](#4-vision-statement)
   - [Key Features / Goals](#5-key-features--goals)
   - [Success Metrics](#6-success-metrics)
   - [Assumptions & Constraints](#7-assumptions--constraints)
2. [Repository Structure](#-repository-structure)
3. [Branching Strategy](#-branching-strategy)
4. [Quick Start – Local Development](#-quick-start--local-development)
5. [Local Development Tools](#-local-development-tools)
6. [API Reference](#-api-reference)
7. [Architecture](#-architecture)
8. [Project Artefacts](#-project-artefacts)

---

# 🎯 Vision Document

## 1. Project Name & Overview

**SwiftBite** is a full-stack, containerised food ordering and delivery platform.

It connects three groups of people around a single transaction — **hungry customers**, **restaurant partners** who prepare the food, and **delivery riders** who carry it the last mile. A customer discovers nearby restaurants, browses a live menu, builds a cart, checks out, and then watches their order move through a real-time status timeline until it reaches their door.

The system is deliberately built as **three independently deployable tiers**:

| Tier | Technology | Responsibility |
|------|-----------|----------------|
| Presentation | React 18 + Vite + React Router | Browsing, cart, checkout, live tracking UI |
| Application | FastAPI (Python 3.11) + SQLAlchemy | Business rules, JWT auth, price computation, order lifecycle |
| Data | PostgreSQL 16 | Durable storage of users, restaurants, menus, orders |

The entire stack runs from a single command — `docker compose up --build` — so any team member reproduces an identical environment on any machine with zero manual setup.

---

## 2. Problem It Solves

### The problem in one sentence

Ordering food today is **fragmented, opaque and expensive** — for customers, for restaurants, and for riders alike.

### Broken down by stakeholder

**For customers**

- **Discovery is noisy.** Existing apps bury genuinely good local restaurants under paid-promotion carousels, so users scroll endlessly and default to the same three places.
- **The order goes dark after payment.** Once "Order Placed" appears, the customer has no idea whether the kitchen has even seen it. This uncertainty generates the single largest category of support calls in food delivery.
- **The final bill is a surprise.** Delivery fees, surge charges, packaging fees and platform fees are revealed late, causing cart abandonment at the last step.
- **Phone ordering fails silently.** Direct calls to restaurants produce wrong items, no written record, and no way to dispute.

**For restaurants**

- **Aggregator commissions of 18–30 %** erase the margin on an already thin-margin business.
- **No customer relationship.** The aggregator owns the customer data; the restaurant cannot see who its repeat customers are.
- **Menu changes are slow.** Marking a dish "sold out" often requires calling the aggregator's support line.
- **Tablet hell.** A restaurant on four platforms manages four tablets, four dashboards, four sets of order sounds.

**For riders**

- **Zero routing intelligence.** Riders receive an address and are left to figure out the rest.
- **Idle time is unpaid.** Poor batching means riders wait outside restaurants for food that is not ready.

### How SwiftBite addresses this

| Problem | SwiftBite's answer |
|---------|-------------------|
| Noisy discovery | Rating-sorted listing with instant search + cuisine filter chips, **no paid placement** |
| Order goes dark | Five-stage live tracking timeline (`PLACED → CONFIRMED → PREPARING → OUT_FOR_DELIVERY → DELIVERED`) polled every 5 s |
| Surprise pricing | Delivery fee shown on the restaurant card **before** the user opens the menu; running bill visible in cart and checkout |
| Price tampering | Order totals are recomputed **server-side** from the database — client-supplied prices are ignored entirely |
| Restaurant menu control | `is_available` flag per menu item; unavailable items are blocked at the API level, not just greyed out in the UI |
| Wrong items / no record | Every order stores an immutable `name_snapshot` and `unit_price` per line item, so historical bills never change if the menu changes later |
| Environment drift across the team | Whole stack containerised; identical on Windows, macOS and Linux |

---

## 3. Target Users (Personas)

### 👩‍💻 Persona 1 — Ananya Rao, "The Time-Poor Professional"

| Attribute | Detail |
|-----------|--------|
| **Age / Role** | 26 · Software Engineer at a product company |
| **Location** | Bengaluru — lives alone in a 1BHK |
| **Tech comfort** | Very high — lives on her phone, expects app-store-grade polish |
| **Order frequency** | 4–6 times a week (lunch at desk, dinner most weeknights) |
| **Average order value** | ₹350–500 |

**Goals**

- Get from "I'm hungry" to "order placed" in under 90 seconds.
- Reorder a known-good meal without re-browsing the whole menu.
- Know exactly when food will arrive so she can schedule a meeting around it.

**Frustrations**

- Being shown sponsored restaurants she has already rejected.
- The status stuck on "Preparing" for 25 minutes with no explanation.
- Having to re-enter her address on every order.

**How SwiftBite serves her**

- Cart persists in `localStorage` across page reloads and browser restarts.
- Address is pre-filled from her saved profile at checkout.
- The tracking screen auto-refreshes every 5 seconds — she never has to pull-to-refresh.
- "My Orders" list gives one-tap access to any past order.

---

### 🎓 Persona 2 — Rohit Mehta, "The Budget-Conscious Student"

| Attribute | Detail |
|-----------|--------|
| **Age / Role** | 20 · 3rd-year undergraduate, hostel resident |
| **Location** | Campus hostel, orders to the main gate |
| **Tech comfort** | High, but on an older Android phone with patchy Wi-Fi |
| **Order frequency** | 2–3 times a week, usually late night, often a group order |
| **Average order value** | ₹150–250 (split across friends) |

**Goals**

- Find the cheapest acceptable meal that will actually arrive.
- See the *total* including delivery before committing.
- Order from a place that is genuinely still open at 11 pm.

**Frustrations**

- ₹99 food + ₹60 in fees discovered only at the payment screen.
- Placing an order and having the restaurant cancel it because they had closed.

**How SwiftBite serves him**

- Delivery fee is printed on every restaurant card in the listing grid.
- Bill summary breaks out item total vs delivery fee vs total on both the cart and checkout screens.
- The API rejects orders to a closed restaurant (`is_open = false`) with a clear message instead of accepting and cancelling later.
- Cash-on-delivery is a first-class payment option.

---

### 🍳 Persona 3 — Suresh Kumar, "The Restaurant Owner"

| Attribute | Detail |
|-----------|--------|
| **Age / Role** | 41 · Owner-operator of a 20-seat North Indian restaurant |
| **Location** | Neighbourhood high street |
| **Tech comfort** | Moderate — comfortable with WhatsApp and a POS tablet, not with dashboards |
| **Volume** | 40–70 delivery orders a day |

**Goals**

- Receive orders reliably with correct item lists and quantities.
- Take a dish off the menu the moment the kitchen runs out of it.
- Pay less than the 25 % commission the incumbents charge.

**Frustrations**

- Refunds for items he no longer stocks but could not un-list quickly.
- Handwritten order slips that get lost between the counter and the kitchen.

**How SwiftBite serves him**

- Per-item `is_available` toggle enforced server-side at order time.
- Per-restaurant `is_open` flag that instantly stops new orders.
- Structured order records with exact quantities — no transcription step.
- Status transitions (`CONFIRMED → PREPARING → OUT_FOR_DELIVERY`) give the kitchen a shared source of truth with the customer.

---

### 🛵 Persona 4 — Imran Sheikh, "The Delivery Partner"

| Attribute | Detail |
|-----------|--------|
| **Age / Role** | 29 · Full-time delivery rider, own two-wheeler |
| **Tech comfort** | Moderate — one hand on the handlebar, needs large tap targets |
| **Volume** | 25–35 deliveries per shift |

**Goals**

- Pick up only when the food is genuinely ready.
- Have the delivery address complete and unambiguous.
- Mark deliveries complete in one tap.

**Frustrations**

- Waiting 15 minutes at a restaurant because the status said "ready" and it was not.
- Addresses like "near the temple" with no landmark or flat number.

**How SwiftBite serves him**

- `PREPARING → OUT_FOR_DELIVERY` transition is an explicit, timestamped event.
- The checkout form prompts for house/flat, street, landmark, city and PIN.
- A `rider` role exists in the user model, reserved for the rider-app iteration.

---

## 4. Vision Statement

> **For** urban customers, independent restaurants and delivery riders
> **who** are underserved by opaque, high-commission food-delivery aggregators,
> **SwiftBite is** a transparent, real-time food ordering and delivery platform
> **that** makes discovery honest, pricing visible before checkout, and every order traceable end-to-end.
>
> **Unlike** incumbent aggregators that monetise placement and hide fees until the final screen,
> **our product** ranks restaurants purely on rating, shows the complete bill from the very first screen, computes every price server-side, and gives all three parties one shared, live view of the same order.

**In one line:** *Honest discovery. Visible pricing. Live tracking. For everyone in the transaction.*

---

## 5. Key Features / Goals

### 🔑 Implemented in this iteration (Review 1)

| # | Feature | Description | Where |
|---|---------|-------------|-------|
| F1 | **User registration** | Email + password signup with server-side validation; bcrypt-hashed passwords | `POST /api/auth/register` |
| F2 | **User login (JWT)** | Stateless JWT auth, 24-hour expiry, `Authorization: Bearer` header | `POST /api/auth/login` |
| F3 | **Session persistence** | Token and profile stored in `localStorage`; user stays signed in across reloads | `src/store.jsx` |
| F4 | **Restaurant discovery** | Responsive card grid, sorted by rating descending | `GET /api/restaurants` |
| F5 | **Live search** | Debounced (250 ms), case-insensitive partial match on restaurant name | `?search=` |
| F6 | **Cuisine filter** | Dynamically generated filter chips from distinct cuisines in the DB | `GET /api/restaurants/cuisines` |
| F7 | **Menu browsing** | Menu grouped by category, veg/non-veg indicator, price, description | `GET /api/restaurants/{id}` |
| F8 | **Cart management** | Add, increment, decrement, auto-remove at zero, clear cart | `src/store.jsx` |
| F9 | **Single-restaurant guard** | Adding from a different restaurant resets the cart, preventing impossible orders | `addToCart()` |
| F10 | **Cart persistence** | Cart survives refresh and browser restart via `localStorage` | `src/store.jsx` |
| F11 | **Transparent bill** | Item total, delivery fee and grand total shown on cart and checkout | `Cart.jsx`, `Checkout.jsx` |
| F12 | **Checkout** | Address entry, contact display, four payment methods | `Checkout.jsx` |
| F13 | **Server-side pricing** | Totals recomputed from DB rows — client prices never trusted | `routers/orders.py` |
| F14 | **Order placement** | Atomic order + line-item creation with immutable price snapshots | `POST /api/orders` |
| F15 | **Live order tracking** | Five-stage visual timeline, auto-polled every 5 s | `OrderTracking.jsx` |
| F16 | **Order status API** | Restaurant/rider transitions with server-side state validation | `PATCH /api/orders/{id}/status` |
| F17 | **Order cancellation** | Allowed only in `PLACED` or `CONFIRMED` state | `POST /api/orders/{id}/cancel` |
| F18 | **Order history** | All past orders, newest first, with status badges | `GET /api/orders` |
| F19 | **Protected routes** | Checkout / orders redirect unauthenticated users to login | `App.jsx` |
| F20 | **Interactive API docs** | Auto-generated OpenAPI 3.1 Swagger UI | `http://localhost:8000/docs` |
| F21 | **Health endpoint** | Liveness probe used by the Docker healthcheck | `GET /health` |
| F22 | **Idempotent seeding** | 6 restaurants, 30 menu items and a demo user seeded on first boot only | `app/seed.py` |
| F23 | **Full containerisation** | Three services orchestrated by Docker Compose on a private bridge network | `docker-compose.yml` |
| F24 | **Hot reload in Docker** | Source volumes mounted so edits appear without rebuilding images | `docker-compose.yml` |
| F25 | **Production frontend image** | Multi-stage build → static bundle served by nginx with API reverse proxy | `Dockerfile.prod` |

### 🚧 Planned for future iterations

| # | Feature | Target |
|---|---------|--------|
| P1 | Restaurant partner dashboard (accept/reject, menu CRUD) | Review 2 |
| P2 | Rider mobile view with assignment queue | Review 2 |
| P3 | Payment gateway integration (Razorpay / Stripe sandbox) | Review 2 |
| P4 | WebSocket push instead of 5-second polling | Review 2 |
| P5 | Redis cache for the restaurant listing endpoint | Review 3 |
| P6 | Ratings & reviews with photo upload | Review 3 |
| P7 | Promo codes and first-order discounts | Review 3 |
| P8 | Live map tracking (Leaflet + OpenStreetMap) | Review 3 |
| P9 | Email / SMS notifications on status change | Review 3 |
| P10 | Admin analytics dashboard | Review 3 |

---

## 6. Success Metrics

### 🎯 Product metrics

| Metric | Definition | Target | How measured |
|--------|-----------|--------|--------------|
| Time to first order | Landing page → order confirmed | **< 90 seconds** | Client-side timing from first paint to `201` on `POST /orders` |
| Cart abandonment rate | Carts created that never become orders | **< 30 %** | `(carts − orders) / carts` |
| Search success rate | Searches that lead to opening a restaurant | **> 70 %** | Search events vs subsequent menu views |
| Order completion rate | Orders reaching `DELIVERED` | **> 95 %** | `DELIVERED / (DELIVERED + CANCELLED)` |
| Repeat order rate | Users placing ≥ 2 orders in 30 days | **> 40 %** | Distinct users with `COUNT(orders) ≥ 2` |
| Checkout drop-off | Users who open checkout but do not submit | **< 15 %** | Checkout page views vs order creations |

### ⚙️ Technical metrics

| Metric | Target | How measured |
|--------|--------|--------------|
| API p95 latency (read endpoints) | **< 200 ms** | Uvicorn access logs / `time curl` |
| API p95 latency (order placement) | **< 500 ms** | Same |
| Frontend First Contentful Paint | **< 1.5 s** | Chrome DevTools → Lighthouse |
| Cold start (`docker compose up` → app reachable) | **< 90 s** | Wall-clock timing |
| Backend image size | **< 400 MB** | `docker images` |
| API error rate (5xx) | **< 0.5 %** | Count of 5xx ÷ total requests |
| Database query count per page load | **≤ 3** | SQLAlchemy echo logging |
| Container uptime during a demo session | **100 %** | `docker compose ps` |

### 📚 Project / process metrics (Review 1 rubric)

| Metric | Target | Status |
|--------|--------|--------|
| User stories written and tracked as GitHub Issues | 25 | ✅ 25 |
| Stories classified under MoSCoW | 100 % | ✅ `docs/MOSCOW.md` |
| Wireframes produced in Figma | 6 screens | ✅ `docs/FIGMA_WIREFRAME_GUIDE.md` |
| Architecture diagram | 1 landscape page | ✅ `docs/architecture.drawio` |
| Services fully containerised | 3 / 3 | ✅ db, backend, frontend |
| Setup commands required by a new developer | **1** | ✅ `docker compose up --build` |
| README covers all 7 vision sections | 7 / 7 | ✅ this document |

---

## 7. Assumptions & Constraints

### ✅ Assumptions

**Business assumptions**

1. Restaurants are pre-onboarded by an operations team; there is no self-serve restaurant signup in this iteration.
2. Every restaurant serves a single delivery zone, so no geospatial radius check is required yet.
3. One order maps to exactly one restaurant — multi-restaurant baskets are out of scope.
4. Delivery fee is a flat per-restaurant value, not distance- or surge-based.
5. Riders are assigned by an external dispatch process; SwiftBite only reflects the resulting status.
6. Prices are in **INR (₹)**; there is no multi-currency support.
7. Cash on delivery is an acceptable and commonly used payment method in the target market.

**Technical assumptions**

8. Users access the app on a modern evergreen browser (Chrome, Edge, Firefox, Safari — last 2 versions).
9. The demo runs on a single machine; horizontal scaling is not exercised.
10. A 5-second polling interval is an acceptable stand-in for real-time push at demo scale.
11. `localStorage` is available and not blocked by the browser.
12. Docker Desktop is installed and running on the evaluator's machine.
13. Ports 5173, 8000 and 5432 are free on the host.
14. Seed data is representative enough to demonstrate every user flow.

**User assumptions**

15. Users have a valid email address and can set a password of at least 6 characters.
16. Users can supply a complete delivery address in free text.
17. Users understand a standard cart-and-checkout ecommerce pattern.

### ⛔ Constraints

**Academic constraints**

| Constraint | Detail |
|-----------|--------|
| Timeline | Review 1 scope must be complete by the submission deadline |
| Team size | `2` members |
| Tooling | Must use GitHub Projects/Issues, Figma (free tier), Draw.io, Docker — as mandated by the assignment |
| Deliverables | Vision doc in README, 25 issues, MoSCoW, 6 wireframes, architecture diagram, Docker proof screenshots |

**Technical constraints**

| Constraint | Detail | Consequence |
|-----------|--------|-------------|
| No paid cloud services | Everything must run locally | No managed DB, no S3, no hosted CI minutes beyond the free tier |
| Figma free tier | 3 files / 3 pages per file | All 6 wireframes live on a single page of one file |
| No real payment gateway | PCI compliance out of scope | Payment method is recorded but not charged |
| No SMS/email provider | Cost and verification overhead | Notifications deferred to a later review |
| Local-only deployment | No public URL | Demo is via `localhost` screenshots and a live walkthrough |
| Single Postgres instance | No replication | Acceptable at demo scale |
| No CDN | Static assets served directly | Acceptable at demo scale |
| Polling, not WebSockets | Simplicity for Review 1 | 5-second worst-case status latency |

**Scope constraints (explicitly out of scope for Review 1)**

- Restaurant partner dashboard UI
- Rider mobile application
- Real payment processing
- Map-based live rider tracking
- Ratings, reviews and photo uploads
- Promo codes, coupons and loyalty
- Push / email / SMS notifications
- Multi-language and multi-currency
- Native mobile apps (iOS / Android)
- Admin panel and analytics

**Security constraints acknowledged (dev-only settings)**

- CORS is `*` for local development; must be restricted to known origins before deployment.
- `SECRET_KEY` defaults to a placeholder; must be a long random secret in production.
- Database credentials in `.env.example` are demo values; real secrets must never be committed.
- HTTPS is not configured locally; TLS termination is a deployment-time concern.

---

# 📁 Repository Structure

```
swiftbite/
├── .github/
│   └── workflows/
│       └── ci.yml                    # GitHub Actions: lint + docker build check
├── backend/                          # ---------- FastAPI service ----------
│   ├── app/
│   │   ├── core/
│   │   │   ├── config.py             # Environment-driven settings
│   │   │   └── security.py           # bcrypt hashing, JWT create/verify
│   │   ├── routers/
│   │   │   ├── auth.py               # /api/auth/*
│   │   │   ├── restaurants.py        # /api/restaurants/*
│   │   │   └── orders.py             # /api/orders/*
│   │   ├── database.py               # Engine, session, wait-for-db retry
│   │   ├── models.py                 # SQLAlchemy ORM models (5 tables)
│   │   ├── schemas.py                # Pydantic request/response models
│   │   ├── seed.py                   # Idempotent demo data seeding
│   │   └── main.py                   # FastAPI app + router registration
│   ├── Dockerfile                    # Python 3.11-slim + uvicorn
│   ├── .dockerignore
│   └── requirements.txt
├── frontend/                         # ---------- React SPA ----------
│   ├── src/
│   │   ├── api/
│   │   │   └── client.js             # fetch wrapper, auth header injection
│   │   ├── components/
│   │   │   └── Navbar.jsx
│   │   ├── pages/
│   │   │   ├── Login.jsx
│   │   │   ├── Register.jsx
│   │   │   ├── Restaurants.jsx       # Screen 1 — discovery
│   │   │   ├── RestaurantMenu.jsx    # Screen 3 — menu
│   │   │   ├── Cart.jsx              # Screen 4 — cart
│   │   │   ├── Checkout.jsx          # Screen 5 — checkout
│   │   │   ├── OrderTracking.jsx     # Screen 6 — live tracking
│   │   │   └── Orders.jsx            # Order history
│   │   ├── App.jsx                   # Route table + auth guard
│   │   ├── store.jsx                 # Context: auth + cart state
│   │   ├── styles.css                # Design tokens + component styles
│   │   └── main.jsx                  # React entry point
│   ├── Dockerfile                    # Dev image (Vite dev server)
│   ├── Dockerfile.prod               # Multi-stage build → nginx
│   ├── nginx.conf                    # SPA fallback + /api reverse proxy
│   ├── .dockerignore
│   ├── index.html
│   ├── package.json
│   └── vite.config.js
├── docs/                             # ---------- Assignment artefacts ----------
│   ├── architecture.drawio           # Draw.io source (import this)
│   ├── USER_STORIES.md               # All 25 stories, full form
│   ├── MOSCOW.md                     # MoSCoW prioritisation + rationale
│   ├── FIGMA_WIREFRAME_GUIDE.md      # Step-by-step build guide, 6 screens
│   ├── SCREENSHOT_GUIDE.md           # Exactly what to capture and where
│   └── SUBMISSION_CHECKLIST.md       # Rubric-mapped final checklist
├── scripts/
│   ├── create_issues.sh              # Bulk-create 25 GitHub Issues (bash)
│   ├── create_issues.ps1             # Same, for Windows PowerShell
│   └── user_stories.csv              # Machine-readable story list
├── .env.example
├── .gitignore
├── docker-compose.yml
└── README.md                         # ← you are here
```

**Why this structure**

- `backend/` and `frontend/` are independent build contexts — each has its own `Dockerfile` and `.dockerignore`, so either can be deployed alone.
- Inside the backend, `routers/` separates HTTP concerns from `models.py` (persistence) and `schemas.py` (contracts) — a clean three-layer separation.
- `docs/` keeps assignment artefacts out of the application source tree.
- `scripts/` holds one-off automation that is not part of the running system.

---

# 🌿 Branching Strategy

SwiftBite follows **GitHub Flow** — the lightweight, single-long-lived-branch model recommended for small teams shipping continuously.

## Why GitHub Flow (and not Git Flow)

| Consideration | GitHub Flow | Git Flow |
|--------------|-------------|----------|
| Long-lived branches | 1 (`main`) | 5 (`main`, `develop`, `feature/*`, `release/*`, `hotfix/*`) |
| Suited to | Continuous delivery, small teams | Versioned releases, large teams |
| Merge complexity | Low | High |
| Learning curve | Minutes | Hours |
| Our situation | ✅ 3–4 members, weekly reviews, no versioned releases | ❌ overhead we do not need |

## The rules

1. **`main` is always deployable.** Anything merged to `main` must build and run.
2. **Never commit directly to `main`.** All work happens on a branch.
3. **Branch off `main`** for every unit of work, using a descriptive name.
4. **Commit early and often** with clear messages.
5. **Open a Pull Request** as soon as you want feedback — it does not have to be finished.
6. **Link the PR to its Issue** with `Closes #12`, so the Issue auto-closes on merge.
7. **At least one review approval** before merge.
8. **CI must be green** before merge.
9. **Squash-merge into `main`**, then **delete the branch**.

## Branch naming convention

```
<type>/<issue-number>-<short-kebab-description>
```

| Type | Used for | Example |
|------|----------|---------|
| `feature/` | New user-facing capability | `feature/12-restaurant-search` |
| `bugfix/` | Fixing broken behaviour | `bugfix/27-cart-total-rounding` |
| `hotfix/` | Urgent fix straight to `main` | `hotfix/31-login-500-error` |
| `docs/` | Documentation only | `docs/03-vision-document` |
| `chore/` | Tooling, deps, config | `chore/08-dockerfile-optimisation` |
| `refactor/` | Behaviour-preserving cleanup | `refactor/19-extract-order-service` |
| `test/` | Adding or fixing tests | `test/22-order-api-tests` |

## Commit message convention (Conventional Commits)

```
<type>(<scope>): <subject in imperative mood>
```

Examples used in this repository:

```
feat(auth): add JWT login and registration endpoints
feat(cart): persist cart to localStorage across sessions
fix(orders): recompute totals server-side to prevent tampering
docs(readme): add vision document with all seven sections
chore(docker): add healthcheck to backend container
refactor(api): extract fetch wrapper into api/client.js
```

## Branch lifecycle in practice

```
main ──●──────────────●─────────────────●────────────►
        \            /                 /
         \          /                 /
          ●───●───●                  /   feature/12-restaurant-search
                                    /
                    ●───●───●──────/        feature/18-order-tracking
```

## The exact commands

```bash
# 1. Start from an up-to-date main
git checkout main
git pull origin main

# 2. Create your feature branch
git checkout -b feature/12-restaurant-search

# 3. Work, then stage and commit
git add .
git commit -m "feat(restaurants): add debounced search and cuisine filter"

# 4. Push and set upstream
git push -u origin feature/12-restaurant-search

# 5. Open a PR on GitHub, reference the issue in the description:
#    Closes #12

# 6. After review approval and green CI, squash-merge on GitHub.

# 7. Clean up locally
git checkout main
git pull origin main
git branch -d feature/12-restaurant-search
```

## Branch protection rules configured on `main`

- ✅ Require a pull request before merging
- ✅ Require at least 1 approving review
- ✅ Require status checks to pass (GitHub Actions CI)
- ✅ Require branches to be up to date before merging
- ✅ Automatically delete head branches after merge
- ❌ Force pushes disabled
- ❌ Branch deletion disabled

---

# 🚀 Quick Start – Local Development

## Prerequisites

| Tool | Minimum version | Check with | Get it |
|------|----------------|------------|--------|
| **Docker Desktop** | 4.30+ | `docker --version` | <https://www.docker.com/products/docker-desktop/> |
| **Docker Compose** | v2 (bundled) | `docker compose version` | Included with Docker Desktop |
| **Git** | 2.40+ | `git --version` | <https://git-scm.com/downloads> |

> Nothing else is required. You do **not** need Python, Node.js or PostgreSQL installed on your machine — they all live inside containers.

---

## ▶️ Run the whole stack in 3 commands

```bash
# 1. Clone the repository
git clone https://github.com/<YOUR_GITHUB_USERNAME>/swiftbite.git
cd swiftbite

# 2. Create your local environment file
cp .env.example .env            # macOS / Linux / Git Bash
# Copy-Item .env.example .env   # Windows PowerShell

# 3. Build the images and start all three services
docker compose up --build
```

Wait until you see these lines in the terminal:

```
swiftbite-db        | database system is ready to accept connections
swiftbite-backend   | [db] connected on attempt 1
swiftbite-backend   | [seed] inserted 6 restaurants + demo user
swiftbite-backend   | INFO:     Uvicorn running on http://0.0.0.0:8000
swiftbite-frontend  | VITE v5.4.11  ready in 412 ms
swiftbite-frontend  | ➜  Local:   http://localhost:5173/
```

---

## 🌐 Where everything lives

| Service | URL | What you get |
|---------|-----|--------------|
| **Web app** | <http://localhost:5173> | The SwiftBite UI |
| **API — Swagger UI** | <http://localhost:8000/docs> | Interactive, executable API docs |
| **API — ReDoc** | <http://localhost:8000/redoc> | Clean reference documentation |
| **API — health check** | <http://localhost:8000/health> | `{"status":"ok", ...}` |
| **PostgreSQL** | `localhost:5432` | user `swiftbite` / pass `swiftbite` / db `swiftbite` |

---

## 🔐 Demo credentials

The database is seeded automatically on first boot:

```
Email:    demo@swiftbite.com
Password: demo1234
```

*(These are pre-filled on the login screen so you can sign in with one click.)*

Seeded content: **6 restaurants**, **30 menu items** across 6 cuisines.

---

## 🧪 Verify it works — the 60-second smoke test

```bash
# 1. Backend is alive
curl http://localhost:8000/health
# → {"status":"ok","service":"SwiftBite API","version":"1.0.0"}

# 2. Restaurants are seeded
curl http://localhost:8000/api/restaurants
# → JSON array of 6 restaurants

# 3. Login works and returns a JWT
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"demo@swiftbite.com","password":"demo1234"}'
# → {"access_token":"eyJ...","token_type":"bearer","user":{...}}

# 4. Frontend is serving
curl -I http://localhost:5173
# → HTTP/1.1 200 OK
```

Then in the browser, walk the full happy path:
**Sign in → pick a restaurant → add 2 items → Cart → Checkout → Place order → watch the tracking timeline.**

---

## 🛠 Everyday Docker commands

```bash
# Start in the background (detached)
docker compose up -d

# Start and force a rebuild after changing a Dockerfile or requirements.txt
docker compose up --build

# See which containers are running and their health
docker compose ps

# Tail logs from everything
docker compose logs -f

# Tail logs from one service
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f db

# Open a shell inside a container
docker compose exec backend bash
docker compose exec frontend sh

# Open a psql session against the database
docker compose exec db psql -U swiftbite -d swiftbite
#   \dt              list tables
#   SELECT * FROM restaurants;
#   \q               quit

# Stop the containers (data is preserved in the pgdata volume)
docker compose down

# Stop AND wipe the database volume — forces a fresh re-seed on next start
docker compose down -v

# Rebuild a single service from scratch, ignoring the cache
docker compose build --no-cache backend

# Restart one service
docker compose restart backend

# See image sizes
docker images | grep swiftbite
```

---

## 🧯 Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| `bind: address already in use` on 5173/8000/5432 | Another process owns the port | Stop it, or change the left-hand side of the port mapping in `docker-compose.yml` (e.g. `"5174:5173"`) |
| `Cannot connect to the Docker daemon` | Docker Desktop is not running | Launch Docker Desktop and wait for the whale icon to go steady |
| Backend logs `[db] not ready — retrying...` | Postgres is still booting | Normal — the retry loop handles it. It resolves within ~10 s |
| Restaurants list is empty | Volume has data from a failed first run | `docker compose down -v` then `docker compose up --build` |
| Frontend loads but every API call fails | Backend container is unhealthy | `docker compose logs backend` and read the traceback |
| Code edits do not appear | Volume mount missing or Windows file-watching issue | Confirm the `volumes:` block; `usePolling: true` is already set in `vite.config.js` |
| `npm install` fails during build | Stale layer cache | `docker compose build --no-cache frontend` |
| Login returns 401 with correct password | DB seeded before a code change | `docker compose down -v && docker compose up --build` |
| Windows: `cp: command not found` | You are in PowerShell, not Bash | Use `Copy-Item .env.example .env` |

---

# 🧰 Local Development Tools

## Core runtime — the only things you must install

| Tool | Version | Why we use it | Where it is configured |
|------|---------|---------------|------------------------|
| **Docker Desktop** | 4.30+ | Runs all three services in isolated containers so every machine is identical | `Dockerfile`, `docker-compose.yml` |
| **Docker Compose v2** | bundled | Declaratively orchestrates db → backend → frontend with health-gated startup | `docker-compose.yml` |
| **Git** | 2.40+ | Version control | `.gitignore` |

## Backend stack (runs inside the container)

| Tool | Version | Purpose |
|------|---------|---------|
| **Python** | 3.11-slim | Runtime |
| **FastAPI** | 0.115.6 | Async web framework; generates OpenAPI docs automatically |
| **Uvicorn** | 0.34.0 | ASGI server |
| **SQLAlchemy** | 2.0.36 | ORM — Python classes ↔ Postgres tables |
| **psycopg2-binary** | 2.9.10 | PostgreSQL driver |
| **Pydantic** | 2.10.4 | Request/response validation and serialisation |
| **python-jose** | 3.3.0 | JWT encoding and decoding |
| **passlib + bcrypt** | 1.7.4 / 4.0.1 | Password hashing |
| **email-validator** | 2.2.0 | Validates the `EmailStr` type |

## Frontend stack (runs inside the container)

| Tool | Version | Purpose |
|------|---------|---------|
| **Node.js** | 20-alpine | Runtime for the dev server and build |
| **React** | 18.3.1 | UI library |
| **Vite** | 5.4.11 | Dev server with HMR + production bundler |
| **React Router** | 6.28.0 | Client-side routing |
| **@vitejs/plugin-react** | 4.3.4 | JSX transform + Fast Refresh |
| **nginx** | 1.27-alpine | Serves the production bundle (`Dockerfile.prod`) |

## Data layer

| Tool | Version | Purpose |
|------|---------|---------|
| **PostgreSQL** | 16-alpine | Relational database |
| **Docker named volume** (`pgdata`) | — | Persists data across `docker compose down` |

## Recommended editor setup (VS Code)

| Extension | ID | Why |
|-----------|-----|-----|
| Docker | `ms-azuretools.vscode-docker` | Manage containers/images from the sidebar |
| Dev Containers | `ms-vscode-remote.remote-containers` | Attach the editor to a running container |
| Python | `ms-python.python` | IntelliSense for the backend |
| Pylance | `ms-python.vscode-pylance` | Fast type checking |
| ES7+ React snippets | `dsznajder.es7-react-js-snippets` | JSX shortcuts |
| ESLint | `dbaeumer.vscode-eslint` | JS linting |
| Prettier | `esbenp.prettier-vscode` | Consistent formatting |
| GitLens | `eamodio.gitlens` | Blame and history inline |
| Thunder Client | `rangav.vscode-thunder-client` | Test API endpoints without leaving the editor |

## Debugging and inspection tools

| Tool | Used for |
|------|----------|
| **Swagger UI** (`/docs`) | Executing every endpoint from the browser, including authenticated ones |
| **Chrome DevTools → Network** | Inspecting request/response payloads and timings |
| **Chrome DevTools → Application → Local Storage** | Verifying `sb_token`, `sb_user`, `sb_cart` |
| **React Developer Tools** | Inspecting component tree and Context state |
| **`docker compose logs -f`** | Live logs from all services |
| **`docker compose exec db psql`** | Direct SQL access |
| **`docker stats`** | Live CPU/memory usage per container |

## Project management tools

| Tool | Used for |
|------|----------|
| **GitHub Issues** | The 25 user stories, one issue each, labelled by MoSCoW priority |
| **GitHub Projects (board)** | Kanban: Backlog → To Do → In Progress → In Review → Done |
| **GitHub Actions** | CI: builds both images on every push and PR |
| **GitHub CLI (`gh`)** | Bulk-created the 25 issues via `scripts/create_issues.sh` |
| **Figma (free tier)** | The 6 wireframe screens |
| **Draw.io / diagrams.net** | The system architecture diagram |

---

# 🔌 API Reference

Base URL: `http://localhost:8000`
Interactive docs: **<http://localhost:8000/docs>**

## Authentication

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/api/auth/register` | ❌ | Create an account, returns JWT + user |
| `POST` | `/api/auth/login` | ❌ | Exchange credentials for a JWT |
| `GET` | `/api/auth/me` | ✅ | Current user profile |

## Restaurants

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `GET` | `/api/restaurants` | ❌ | List all; supports `?search=` and `?cuisine=` |
| `GET` | `/api/restaurants/cuisines` | ❌ | Distinct cuisine list for filter chips |
| `GET` | `/api/restaurants/{id}` | ❌ | Restaurant detail **including full menu** |
| `GET` | `/api/restaurants/{id}/menu` | ❌ | Menu items only |

## Orders

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/api/orders` | ✅ | Place an order (totals computed server-side) |
| `GET` | `/api/orders` | ✅ | Current user's order history, newest first |
| `GET` | `/api/orders/{id}` | ✅ | Single order — used by the tracking screen |
| `PATCH` | `/api/orders/{id}/status` | ✅ | Advance the order lifecycle |
| `POST` | `/api/orders/{id}/cancel` | ✅ | Cancel (only from `PLACED` or `CONFIRMED`) |

## System

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/health` | Liveness probe used by the Docker healthcheck |
| `GET` | `/docs` | Swagger UI |
| `GET` | `/redoc` | ReDoc |

## Order status state machine

```
PLACED ──► CONFIRMED ──► PREPARING ──► OUT_FOR_DELIVERY ──► DELIVERED
   │            │
   └────────────┴──────► CANCELLED     (customer-initiated, only from these two states)
```

## Data model (5 tables)

```
users (1) ──────< (N) orders (N) >────── (1) restaurants
                        │                       │
                        │ (1)                   │ (1)
                        ▼ (N)                   ▼ (N)
                   order_items (N) >───── (1) menu_items
```

| Table | Key columns |
|-------|-------------|
| `users` | `id`, `name`, `email` (unique), `hashed_password`, `phone`, `address`, `role` |
| `restaurants` | `id`, `name`, `cuisine`, `rating`, `delivery_fee`, `eta_minutes`, `is_open` |
| `menu_items` | `id`, `restaurant_id` → FK, `name`, `price`, `category`, `is_veg`, `is_available` |
| `orders` | `id`, `user_id` → FK, `restaurant_id` → FK, `status`, `subtotal`, `delivery_fee`, `total`, `payment_method`, `delivery_address`, `placed_at` |
| `order_items` | `id`, `order_id` → FK, `menu_item_id` → FK, `name_snapshot`, `unit_price`, `quantity` |

> **Design note:** `order_items` stores `name_snapshot` and `unit_price` rather than joining live to `menu_items`. This means a past order's bill is immutable even if the restaurant later renames a dish or changes its price.

---

# 🏗 Architecture

The full diagram lives at **`docs/architecture.drawio`** — open it at <https://app.diagrams.net> via *File → Open From → Device*.

```
┌──────────────┐   HTTPS/HTTP    ┌─────────────────────────────────────┐
│   Browser    │ ───────────────►│  Frontend Container                 │
│  (Chrome)    │                 │  React 18 + Vite  ·  port 5173      │
└──────────────┘ ◄─────────────── │  React Router · Context store       │
                    JSON          └───────────────┬─────────────────────┘
                                                  │  /api/*  (proxy)
                                                  ▼
                                  ┌─────────────────────────────────────┐
                                  │  Backend Container                  │
                                  │  FastAPI + Uvicorn  ·  port 8000    │
                                  │  ┌───────────────────────────────┐  │
                                  │  │ Routers: auth / restaurants / │  │
                                  │  │          orders               │  │
                                  │  ├───────────────────────────────┤  │
                                  │  │ Security: bcrypt + JWT        │  │
                                  │  ├───────────────────────────────┤  │
                                  │  │ SQLAlchemy ORM                │  │
                                  │  └───────────────────────────────┘  │
                                  └───────────────┬─────────────────────┘
                                                  │  TCP 5432
                                                  ▼
                                  ┌─────────────────────────────────────┐
                                  │  Database Container                 │
                                  │  PostgreSQL 16  ·  port 5432        │
                                  │  Volume: pgdata (persistent)        │
                                  └─────────────────────────────────────┘

           All three services share the private bridge network `swiftbite-net`,
           orchestrated by Docker Compose with health-gated startup ordering.
```

---

# 📦 Project Artefacts

| Deliverable | Location |
|------------|----------|
| Vision document (7 sections) | This README, [top section](#-vision-document) |
| 25 user stories (full form) | [`docs/USER_STORIES.md`](docs/USER_STORIES.md) |
| MoSCoW prioritisation | [`docs/MOSCOW.md`](docs/MOSCOW.md) |
| Figma wireframe build guide (6 screens) | [`docs/FIGMA_WIREFRAME_GUIDE.md`](docs/FIGMA_WIREFRAME_GUIDE.md) |
| Architecture diagram source | [`docs/architecture.drawio`](docs/architecture.drawio) |
| Screenshot capture guide | [`docs/SCREENSHOT_GUIDE.md`](docs/SCREENSHOT_GUIDE.md) |
| Final submission checklist | [`docs/SUBMISSION_CHECKLIST.md`](docs/SUBMISSION_CHECKLIST.md) |
| Issue bulk-creation scripts | [`scripts/`](scripts/) |
| GitHub Project board | `https://github.com/users/rishab-nataraj/projects/1` |
| Figma file | `<PASTE YOUR FIGMA SHARE LINK HERE>` |

---

<div align="center">

**SwiftBite** · Software Engineering Digital Assignment 1
Built with FastAPI, React and Docker.

</div>

## Software Design

SwiftBite uses a layered three-tier architecture: a React single-page app (presentation), a FastAPI backend (application) and PostgreSQL (data), each running in its own Docker container. Inside the backend, routers, models, schemas and security helpers are kept in separate modules, so each has one responsibility and new features such as the restaurant dashboard or rider queue can be added as new routers without touching existing code. Key choices include recomputing order prices on the server, storing item name and price snapshots on each order, and using stateless JWT authentication, all to keep the system secure, maintainable and easy to extend.

### Diagrams

| Diagram | Editable source | PNG export |
|---|---|---|
| System architecture | [architecture.drawio](docs/design/architecture.drawio) | ![SwiftBite architecture](docs/design/architecture.png) |

### UI design

Figma prototype: `<PASTE YOUR FIGMA SHARE LINK HERE>`

UI screenshots: see [docs/design/](docs/design/)


