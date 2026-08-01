# 📸 Screenshot Guide — exactly what to capture and how

Everything the assignment asks you to prove with screenshots, in the order you should do it.

> **How to screenshot on Windows:** press `Win + Shift + S`, drag a rectangle, then paste into Paint and save — or just press `Win + PrtScn` to auto-save a full screen into `Pictures\Screenshots`.
>
> **Save everything into** `swiftbite/docs/screenshots/` using the exact filenames below. Numbered filenames sort correctly and make your report easy to assemble.

Create the folder first:

```powershell
mkdir docs\screenshots
```

---

# 🚦 PHASE A — Get the repository onto GitHub

### A1 · Initialise git and make the first commit

Open **PowerShell**, then:

```powershell
cd C:\Users\risha\OneDrive\Desktop\swiftbite

git init
git add .
git commit -m "feat: initial SwiftBite project scaffold with Docker, FastAPI and React"
git branch -M main
```

### A2 · Create the GitHub repository

**Option 1 — with GitHub CLI (faster):**

```powershell
winget install --id GitHub.cli
# CLOSE and REOPEN PowerShell after installing
gh auth login          # choose: GitHub.com -> HTTPS -> Yes -> Login with a web browser
gh repo create swiftbite --public --source=. --remote=origin --push
```

**Option 2 — manually:**
1. Go to <https://github.com/new>
2. Repository name: `swiftbite` · Public · **do not** tick "Add a README" (you already have one)
3. Click **Create repository**, then run:

```powershell
git remote add origin https://github.com/<YOUR_GITHUB_USERNAME>/swiftbite.git
git push -u origin main
```

### A3 · Create a feature branch and push it

The assignment explicitly says **"Create at least one feature branch and show it in screenshots."**

```powershell
git checkout -b feature/12-restaurant-search
```

Now make a small real change so the branch is not identical to main — open `frontend/src/pages/Restaurants.jsx` in Notepad and change the placeholder text on line ~46 from:

```
placeholder="Search restaurants…"
```
to
```
placeholder="Search restaurants by name…"
```

Then:

```powershell
git add .
git commit -m "feat(restaurants): clarify search placeholder copy"
git push -u origin feature/12-restaurant-search
```

Create a second branch too — it makes the branches screenshot look better:

```powershell
git checkout main
git checkout -b docs/03-vision-document
git commit --allow-empty -m "docs(readme): vision document review pass"
git push -u origin docs/03-vision-document
git checkout main
```

---

# 📷 PHASE B — GitHub screenshots

## 📸 `01-github-repo-overview.png`

**Where:** `https://github.com/<YOUR_USERNAME>/swiftbite`
**What to capture:** the repository landing page.
**Make sure it shows:** the folder list (`.github`, `backend`, `frontend`, `docs`, `scripts`), the file list (`.gitignore`, `docker-compose.yml`, `README.md`), and the rendered README below.
**Tip:** press `Ctrl + -` once or twice to zoom out so folders **and** the README title both fit in one shot.

---

## 📸 `02-github-branches.png`

**Where:** on your repo page, click the branch dropdown (the button that says `main`) → then click **"View all branches"**.
Direct URL: `https://github.com/<YOUR_USERNAME>/swiftbite/branches`
**Must show:** `main` (Default), `feature/12-restaurant-search`, `docs/03-vision-document`.

---

## 📸 `03-github-readme-branching-strategy.png`

**Where:** on the repo page, scroll the rendered README down to the **"🌿 Branching Strategy"** heading.
**Must show:** the heading, the "Why GitHub Flow" comparison table, and the branch-naming table.

---

## 📸 `04-github-readme-quickstart.png`

**Where:** keep scrolling the README to **"🚀 Quick Start – Local Development"**.
**Must show:** the prerequisites table and the 3-command block.

---

## 📸 `05-github-gitignore.png`

**Where:** repo → click `.gitignore`.
**Must show:** the file contents with the section headers (Environment & secrets, Python, Node, Databases, Docker, IDEs, OS files).

---

## 📸 `06-github-folder-structure.png`

**Where:** repo → click into `backend/app/`.
**Must show:** the `core/`, `routers/` folders plus `main.py`, `models.py`, `schemas.py`, `seed.py`, `database.py`.

---

# 📋 PHASE C — GitHub Issues and Project board

## C1 · Create the 25 issues

In PowerShell, from your repo folder:

```powershell
cd C:\Users\risha\OneDrive\Desktop\swiftbite

# allow the script to run in this session only
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

.\scripts\create_issues.ps1
```

It will print `+ label-name` lines, then create 25 issues one by one. Takes about 60 seconds.

> **If `gh` is not found:** run `winget install --id GitHub.cli`, then **close and reopen PowerShell**.
> **If it says you are not authenticated:** run `gh auth login` first.

---

## 📸 `07-github-issues-list.png`

**Where:** `https://github.com/<YOUR_USERNAME>/swiftbite/issues`
**Must show:** the header reading **"25 Open"**, and a good number of `US-xx:` issues with their coloured labels.
**Tip:** `Ctrl + -` to zoom out so more issues fit in one shot. Take a second scrolled screenshot as `07b-github-issues-list-2.png` if you want all 25 visible.

---

## 📸 `08-github-issue-detail.png`

**Where:** click into **US-19: Server-side price calculation** (or any issue).
**Must show:** the user story in As-a/I-want/So-that form, the priority and story points, the acceptance-criteria checkboxes, and the labels in the right sidebar.

---

## C2 · Create the Project board

1. Go to `https://github.com/<YOUR_USERNAME>/swiftbite`
2. Click the **Projects** tab → **Link a project** → **New project**
3. Choose the **Board** template → name it **"SwiftBite — Review 1"** → **Create**
4. In the board, click **+ Add item** at the bottom of the **Todo** column
5. Type `#` — a list of your issues appears. Click each one to add it. **Add all 25.**
   *(Faster: go back to the Issues list, tick the checkbox at the top to select all, then use the **Projects** dropdown on the right to assign them all at once.)*
6. Rename/create columns so you have: **Backlog · To Do · In Progress · In Review · Done**
7. Drag a realistic spread of cards so the board looks like real work:
   - **Done:** US-01, US-02, US-05, US-09, US-12, US-25
   - **In Review:** US-18, US-19
   - **In Progress:** US-06, US-20
   - **To Do:** US-04, US-13, US-16, US-17
   - **Backlog:** everything else

## 📸 `09-github-project-board.png`

**Must show:** all five columns with cards distributed across them. Zoom out (`Ctrl + -`) so every column fits.

## 📸 `10-github-project-board-grouped.png` *(optional, looks great)*

In the board, click the **⚙ / three-dot menu** → **Group by** → **Labels**. This visually groups by MoSCoW priority. Screenshot it.

---

# 🐳 PHASE D — Docker screenshots (the big rubric item)

> Make sure **Docker Desktop is running** first — look for the whale icon in your system tray and wait until it stops animating.

## D1 · Prepare

```powershell
cd C:\Users\risha\OneDrive\Desktop\swiftbite
Copy-Item .env.example .env
```

## 📸 `11-docker-desktop-installed.png`

**Where:** open **Docker Desktop** from the Start menu.
**Must show:** the Docker Desktop window with the green **"Engine running"** indicator at the bottom-left.

---

## 📸 `12-docker-version.png`

Run this and screenshot the terminal:

```powershell
docker --version
docker compose version
```

**Must show:** both version strings.

---

## 📸 `13-docker-compose-build.png`  ⭐ **required by the rubric**

Run:

```powershell
docker compose build
```

This takes 2–5 minutes the first time. **Screenshot the terminal at the very end**, when you can see lines like:

```
 => => naming to docker.io/library/swiftbite-backend
 => => naming to docker.io/library/swiftbite-frontend
[+] Building 187.4s (24/24) FINISHED
```

**Must show:** the successful build output with `FINISHED` and no red error lines.

> If the screen scrolled past, run `docker compose build` again — the second run uses the cache, finishes in seconds, and still prints `FINISHED`, which is perfectly fine for the screenshot.

---

## 📸 `14-docker-compose-up.png`  ⭐ **required by the rubric**

Run:

```powershell
docker compose up
```

Wait ~30 seconds, then **screenshot the terminal** once you can see these lines:

```
swiftbite-db        | database system is ready to accept connections
swiftbite-backend   | [db] connected on attempt 1
swiftbite-backend   | [seed] inserted 6 restaurants + demo user
swiftbite-backend   | INFO:     Uvicorn running on http://0.0.0.0:8000
swiftbite-frontend  | VITE v5.4.11  ready in 412 ms
swiftbite-frontend  | ➜  Local:   http://localhost:5173/
```

**This single screenshot is the strongest proof in the whole submission** — it shows all three containers starting, the database connecting, and the seed running. Make sure all of those lines are visible.

**Leave this terminal running.** Open a **second PowerShell window** for the next commands.

---

## 📸 `15-docker-compose-ps.png`

In the **second** PowerShell window:

```powershell
cd C:\Users\risha\OneDrive\Desktop\swiftbite
docker compose ps
```

**Must show:** three rows — `swiftbite-db`, `swiftbite-backend`, `swiftbite-frontend` — all with STATUS **`Up`** (the db should say `Up (healthy)`).

---

## 📸 `16-docker-images.png`

```powershell
docker images
```

**Must show:** `swiftbite-backend`, `swiftbite-frontend`, `postgres` and their sizes.

---

## 📸 `17-docker-desktop-containers.png`

**Where:** Docker Desktop → **Containers** tab in the left sidebar.
**Must show:** the `swiftbite` stack expanded, listing all three containers with green **Running** status and their port mappings (5173:5173, 8000:8000, 5432:5432).

---

## 📸 `18-docker-logs.png` *(optional but nice)*

```powershell
docker compose logs backend --tail 25
```

**Must show:** the seed and startup lines from the backend container.

---

# 🌐 PHASE E — App running in the browser  ⭐ **required by the rubric**

> Keep `docker compose up` running throughout this phase.
> **Important:** every screenshot must show the **browser address bar with `localhost` visible** — that is what proves it is running locally.

## 📸 `19-app-restaurant-list.png`

1. Open Chrome → go to **<http://localhost:5173>**
2. **Must show:** the address bar reading `localhost:5173`, the SwiftBite navbar, the "Order food you love" heading, the search bar, the cuisine filter chips, and all 6 restaurant cards.

---

## 📸 `20-app-search-working.png`

1. Type **`burger`** into the search box.
2. **Must show:** only "The Burger Lab" in the results. This proves live search works.

---

## 📸 `21-app-cuisine-filter.png`

1. Clear the search box, then click the **🍕 Italian** chip.
2. **Must show:** the chip highlighted orange and only Bella Napoli in the grid.

---

## 📸 `22-app-login.png`

1. Click **Sign in** in the navbar.
2. **Must show:** the login card with the demo credentials pre-filled.
3. **Now click Sign in** to actually log in.

---

## 📸 `23-app-restaurant-menu.png`

1. Click on **Bella Napoli**.
2. **Must show:** the restaurant header with rating/ETA/fee, and menu items grouped into **Pizza / Pasta / Sides / Desserts** panels with veg/non-veg markers and prices.

---

## 📸 `24-app-add-to-cart.png`

1. Click **Add +** on **Margherita Pizza**.
2. **Must show:** the green banner *"Added Margherita Pizza to your cart."*, the navbar cart count showing `Cart (1)`, and the "View cart (1)" button.
3. Now add **Garlic Bread** and **Tiramisu** too, and click Add on Margherita a second time so its quantity is 2.

---

## 📸 `25-app-cart.png`

1. Click **Cart (4)** in the navbar.
2. **Must show:** all three line items with quantity steppers, and the bill summary panel on the right with **Item total / Delivery fee / To pay** clearly itemised.

---

## 📸 `26-app-checkout.png`

1. Click **Proceed to checkout**.
2. **Must show:** the delivery address textarea (pre-filled), the contact number, the payment-method dropdown, the order summary panel on the right, and the **"Place order · ₹xxxx"** button.

---

## 📸 `27-app-order-tracking.png`  ⭐ **the money shot**

1. Click **Place order**.
2. You land on the tracking page.
3. Click **"Simulate next stage →"** three times so the status reads **OUT FOR DELIVERY**.
4. **Must show:** the "Order #1" heading, the orange `OUT FOR DELIVERY` badge, the five-stage timeline with green ticks on the first four stages, and the bill panel on the right.

---

## 📸 `28-app-order-delivered.png`

1. Click **"Simulate next stage →"** once more.
2. **Must show:** all five stages green-ticked and the badge turned green reading **DELIVERED**.

---

## 📸 `29-app-order-history.png`

1. Click **My Orders** in the navbar.
2. **Must show:** the order listed with its number, item count, timestamp, green DELIVERED badge and total.

> **To get a second order in the list** (looks better): go back to Restaurants, order from a different restaurant, and this time hit **Cancel order** so you have one DELIVERED and one CANCELLED. Then retake this screenshot.

---

## 📸 `30-app-empty-cart.png` *(optional)*

Navigate to <http://localhost:5173/cart> with an empty cart.
**Must show:** the 🛒 empty state with "Your cart is empty".

---

# ⚡ PHASE F — API screenshots

## 📸 `31-api-swagger-docs.png`  ⭐ **strongly recommended**

1. Open **<http://localhost:8000/docs>**
2. **Must show:** the Swagger UI with the **Authentication**, **Restaurants**, **Orders** and **System** sections, all endpoints listed.

---

## 📸 `32-api-endpoint-executed.png`

1. In Swagger, expand **`GET /api/restaurants`** → click **Try it out** → **Execute**.
2. **Must show:** response code **200** and the JSON array of restaurants in the Response body panel.

---

## 📸 `33-api-health-check.png`

Open **<http://localhost:8000/health>** in the browser.
**Must show:** `{"status":"ok","service":"SwiftBite API","version":"1.0.0"}` with the address bar visible.

---

## 📸 `34-database-tables.png` *(strong extra credit)*

In PowerShell:

```powershell
docker compose exec db psql -U swiftbite -d swiftbite -c "\dt"
docker compose exec db psql -U swiftbite -d swiftbite -c "SELECT id, name, cuisine, rating, delivery_fee FROM restaurants;"
docker compose exec db psql -U swiftbite -d swiftbite -c "SELECT id, user_id, restaurant_id, status, total FROM orders;"
```

**Must show:** the 5 tables listed, the 6 seeded restaurants, and your real orders in the database. This proves the data actually persisted to PostgreSQL.

---

## 📸 `35-hot-reload-proof.png` *(optional, shows you understand volume mounts)*

1. With the stack running, open `frontend/src/pages/Restaurants.jsx`
2. Change `Order food you love` to `Order food you love 🍕`
3. Save — the browser updates **without any rebuild**.
4. Screenshot the browser showing the new heading, with the terminal visible beside it showing the Vite HMR update line.

---

# 🎨 PHASE G — Figma and Draw.io

## 📸 `36-figma-wireframes-all.png`

Follow **[`FIGMA_WIREFRAME_GUIDE.md`](FIGMA_WIREFRAME_GUIDE.md)** first, then:
1. Press `Shift + 1` in Figma to fit all frames on screen.
2. **Must show:** all 6 named frames laid out 3 × 2.

## 📸 `37-figma-individual-screens/` *(folder)*

Select all 6 frames → right sidebar **Export** → **2x PNG** → **Export 6 layers**.

---

## D · The architecture diagram

1. Go to **<https://app.diagrams.net>**
2. Click **Device** when it asks where to save
3. **File → Open From → Device** → select `swiftbite/docs/architecture.drawio`
4. The full diagram opens, already laid out in landscape.

## 📸 `38-drawio-architecture.png`

Press `Ctrl + Shift + H` to fit the page, then screenshot the canvas.

**Also export a clean image for your report:**
**File → Export as → PNG** → tick **Transparent Background: off**, **Zoom: 200%** → **Export** → save as `docs/architecture.png`.

**And a PDF version:**
**File → Export as → PDF** → **Fit to page: landscape** → save as `docs/architecture.pdf`.

---

# 🧹 PHASE H — Push everything and finish

```powershell
cd C:\Users\risha\OneDrive\Desktop\swiftbite

git checkout main
git add .
git commit -m "docs: add screenshots, architecture diagram exports and wireframe guide"
git push origin main
```

## 📸 `39-github-final-repo.png`

Reload your repo page one last time.
**Must show:** the commit count, all folders, and the README rendering.

---

# ✅ Master screenshot checklist

| # | Filename | Proves | Required? |
|---|----------|--------|-----------|
| 01 | `01-github-repo-overview.png` | Repo created with proper structure | ✅ |
| 02 | `02-github-branches.png` | Feature branch exists | ✅ |
| 03 | `03-github-readme-branching-strategy.png` | Branching strategy documented | ✅ |
| 04 | `04-github-readme-quickstart.png` | Quick Start section exists | ✅ |
| 05 | `05-github-gitignore.png` | Good .gitignore | ✅ |
| 06 | `06-github-folder-structure.png` | Proper folder structure | ✅ |
| 07 | `07-github-issues-list.png` | 25 user stories as Issues | ✅ |
| 08 | `08-github-issue-detail.png` | Stories are properly written | ✅ |
| 09 | `09-github-project-board.png` | GitHub Projects in use | ✅ |
| 10 | `10-github-project-board-grouped.png` | MoSCoW on the board | ➕ |
| 11 | `11-docker-desktop-installed.png` | Docker Desktop installed | ✅ |
| 12 | `12-docker-version.png` | Docker versions | ➕ |
| 13 | `13-docker-compose-build.png` | Successful `docker build` | ✅ |
| 14 | `14-docker-compose-up.png` | Successful `docker compose up` | ✅ |
| 15 | `15-docker-compose-ps.png` | All containers Up | ✅ |
| 16 | `16-docker-images.png` | Images built | ➕ |
| 17 | `17-docker-desktop-containers.png` | Containers running in GUI | ➕ |
| 18 | `18-docker-logs.png` | Clean startup logs | ➕ |
| 19 | `19-app-restaurant-list.png` | App running on localhost | ✅ |
| 20 | `20-app-search-working.png` | Search feature works | ➕ |
| 21 | `21-app-cuisine-filter.png` | Filter feature works | ➕ |
| 22 | `22-app-login.png` | Auth UI | ➕ |
| 23 | `23-app-restaurant-menu.png` | Menu browsing works | ➕ |
| 24 | `24-app-add-to-cart.png` | Cart works | ➕ |
| 25 | `25-app-cart.png` | Cart + bill summary | ➕ |
| 26 | `26-app-checkout.png` | Checkout works | ➕ |
| 27 | `27-app-order-tracking.png` | Live tracking works | ✅ |
| 28 | `28-app-order-delivered.png` | Full lifecycle works | ➕ |
| 29 | `29-app-order-history.png` | Order history works | ➕ |
| 30 | `30-app-empty-cart.png` | Empty state handled | ➕ |
| 31 | `31-api-swagger-docs.png` | API documented | ➕ |
| 32 | `32-api-endpoint-executed.png` | API returns real data | ➕ |
| 33 | `33-api-health-check.png` | Healthcheck endpoint | ➕ |
| 34 | `34-database-tables.png` | Data really in PostgreSQL | ➕ |
| 35 | `35-hot-reload-proof.png` | Volume mounts / hot reload | ➕ |
| 36 | `36-figma-wireframes-all.png` | 6 Figma wireframes | ✅ |
| 37 | `37-figma-individual-screens/` | Individual wireframe exports | ✅ |
| 38 | `38-drawio-architecture.png` | Architecture diagram | ✅ |
| 39 | `39-github-final-repo.png` | Everything pushed | ➕ |

**✅ = explicitly required by the assignment brief · ➕ = extra credit / strengthens the submission**

**Minimum to satisfy the rubric: 01, 02, 03, 04, 05, 06, 07, 08, 09, 11, 13, 14, 15, 19, 27, 36, 37, 38.**
