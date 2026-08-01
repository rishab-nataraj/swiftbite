# 👋 START HERE

Everything for Digital Assignment 1 / Review 1 is in this folder. Follow these 6 steps in order.

**Total time: ~2.5 hours**, most of which is Figma and taking screenshots.

---

## Step 1 · Fill in your details (5 min)

Open `README.md` and press `Ctrl + H` (Find & Replace). Replace:

| Find | Replace with |
|------|--------------|
| `<YOUR NAME>` | your name |
| `<YOUR REG NO>` | your registration number |
| `<YOUR SLOT>` | your slot |
| `<YOUR_GITHUB_USERNAME>` | your GitHub username (5 occurrences) |
| `<N>` | your team size |

---

## Step 2 · Run the app (10 min)

Make sure **Docker Desktop is running** (whale icon in the system tray, not animating).

Open PowerShell:

```powershell
cd C:\Users\risha\OneDrive\Desktop\swiftbite
Copy-Item .env.example .env
docker compose up --build
```

First build takes 2–5 minutes. When you see `Local: http://localhost:5173/`, open that in Chrome.

**Log in with:** `demo@swiftbite.com` / `demo1234` (already pre-filled)

Then walk the flow: pick a restaurant → add items → Cart → Checkout → Place order → click "Simulate next stage" until Delivered.

**Also check:** <http://localhost:8000/docs> — your auto-generated API documentation.

---

## Step 3 · Push to GitHub + create the branch (10 min)

```powershell
cd C:\Users\risha\OneDrive\Desktop\swiftbite
git init
git add .
git commit -m "feat: initial SwiftBite project scaffold with Docker, FastAPI and React"
git branch -M main

winget install --id GitHub.cli
# CLOSE AND REOPEN PowerShell, then:
gh auth login
gh repo create swiftbite --public --source=. --remote=origin --push

# create the feature branch the assignment requires
git checkout -b feature/12-restaurant-search
git commit --allow-empty -m "feat(restaurants): clarify search placeholder copy"
git push -u origin feature/12-restaurant-search
git checkout main
```

---

## Step 4 · Create the 25 GitHub Issues (5 min)

```powershell
cd C:\Users\risha\OneDrive\Desktop\swiftbite
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\create_issues.ps1
```

Then on GitHub: **Projects → New project → Board**, add all 25 issues, spread them across columns.

---

## Step 5 · Figma wireframes (45–75 min)

Open [`docs/FIGMA_WIREFRAME_GUIDE.md`](docs/FIGMA_WIREFRAME_GUIDE.md) and follow it literally. It gives you exact frame sizes, colours, coordinates and content for all 6 screens.

Do **Step 0** first (building the 8 components) — it saves an hour.

---

## Step 6 · Architecture diagram + screenshots (40 min)

**Diagram:** go to <https://app.diagrams.net> → *File → Open From → Device* → pick `docs/architecture.drawio`. It's already built. Export as PNG and PDF.

**Screenshots:** open [`docs/SCREENSHOT_GUIDE.md`](docs/SCREENSHOT_GUIDE.md). It tells you the exact URL, the exact click, and what must be visible in each of the 39 screenshots.

---

## Before you submit

Run through [`docs/SUBMISSION_CHECKLIST.md`](docs/SUBMISSION_CHECKLIST.md) — every line of the assignment brief is mapped to where it's satisfied, with tick boxes.

It also has a **"Likely viva questions"** table at the bottom. Read it before your review.

---

## What's in this folder

| Path | What it is |
|------|-----------|
| `README.md` | **The vision document** (all 7 sections) + branching strategy + Quick Start + dev tools. This is deliverable #1. |
| `docs/USER_STORIES.md` | All 25 stories in full, with acceptance criteria |
| `docs/MOSCOW.md` | MoSCoW prioritisation with defensible justifications |
| `docs/FIGMA_WIREFRAME_GUIDE.md` | Step-by-step build guide for the 6 wireframes |
| `docs/architecture.drawio` | The Draw.io diagram, ready to import |
| `docs/SCREENSHOT_GUIDE.md` | 39 screenshots: where to go, what to click, what to capture |
| `docs/SUBMISSION_CHECKLIST.md` | Rubric-mapped final checklist + viva prep |
| `scripts/create_issues.ps1` | Creates all 25 GitHub Issues in one command |
| `backend/` | FastAPI + PostgreSQL — 20 working endpoints |
| `frontend/` | React 18 + Vite — 8 working pages |
| `docker-compose.yml` | One command starts everything |

---

## If something breaks

The **Troubleshooting** table in `README.md` covers the 9 most likely failures (port conflicts, Docker not running, empty database, hot reload not working). Check there first.

Most common fix, when the database looks wrong:

```powershell
docker compose down -v
docker compose up --build
```
