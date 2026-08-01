# ✅ Submission Checklist — Digital Assignment 1 / Review 1

Every line item in the assignment brief, mapped to exactly where it is satisfied. Work top to bottom.

---

## 1️⃣ Vision document as Markdown in README.md

> *"Vision document (Project Name & Overview, Problem it Solves, Target Users (Personas), Vision Statement, Key Features / Goals, Success Metrics, Assumptions & Constraints) as Markdown in your repo's README.md."*

| Required section | Where it is | Done |
|------------------|-------------|------|
| Project Name & Overview | `README.md` → *Vision Document → §1* | ☐ |
| Problem It Solves | `README.md` → *§2* (broken down by all 3 stakeholder groups) | ☐ |
| Target Users (Personas) | `README.md` → *§3* (4 full personas with goals + frustrations) | ☐ |
| Vision Statement | `README.md` → *§4* (formal For/Who/Is/That/Unlike/Our-product template) | ☐ |
| Key Features / Goals | `README.md` → *§5* (25 implemented + 10 planned) | ☐ |
| Success Metrics | `README.md` → *§6* (product + technical + process metrics with targets) | ☐ |
| Assumptions & Constraints | `README.md` → *§7* (17 assumptions, 4 constraint categories) | ☐ |

**Action:** Open `README.md` and replace every placeholder:

- `<YOUR NAME>` → your name
- `<YOUR REG NO>` → your registration number
- `<YOUR SLOT>` → your slot
- `<YOUR_GITHUB_USERNAME>` → your GitHub username (appears **5 times**)
- `<N>` → your team size
- `<PASTE YOUR FIGMA SHARE LINK HERE>` → your Figma link

> **Fast way:** open the file in VS Code / Notepad, press `Ctrl + H`, replace each one.

☐ All placeholders replaced
☐ README renders correctly on GitHub (check the repo page, not just locally)

---

## 2️⃣ 25 user stories in GitHub Projects using GitHub Issues

> *"25 user stories in GitHub Projects using GitHub Issues."*

☐ GitHub CLI installed (`winget install --id GitHub.cli`)
☐ Authenticated (`gh auth login`)
☐ Ran `.\scripts\create_issues.ps1` from the repo root
☐ Issues page shows **25 Open**
☐ Every issue has a `user-story` label, one MoSCoW label, and one `epic:*` label
☐ GitHub Project (Board) created and named **"SwiftBite — Review 1"**
☐ All 25 issues added to the board
☐ Board has 5 columns: Backlog · To Do · In Progress · In Review · Done
☐ Cards distributed realistically across columns (not all in one pile)
☐ Screenshot `07-github-issues-list.png` taken
☐ Screenshot `09-github-project-board.png` taken

**Backup reference:** the full text of all 25 stories is in [`USER_STORIES.md`](USER_STORIES.md), and a machine-readable version is in [`../scripts/user_stories.csv`](../scripts/user_stories.csv).

---

## 3️⃣ MoSCoW prioritisation

> *"MoSCoW prioritisation and Figma wireframes (6 screens) using Figma free."*

☐ [`MOSCOW.md`](MOSCOW.md) is in the repo
☐ Must Have — 54 points documented with justification per story
☐ Should Have — 37 points documented with the workaround for each
☐ Could Have — 5 points documented
☐ **Won't Have** — 10 items explicitly listed with reasons and revisit dates
☐ Every GitHub Issue carries its MoSCoW label
☐ *(Optional, looks great)* Board grouped by label → screenshot `10-github-project-board-grouped.png`

> **Viva prep:** the "Prioritisation decisions worth defending" section at the bottom of `MOSCOW.md` pre-answers the five questions you are most likely to be asked.

---

## 4️⃣ Figma wireframes — 6 screens

☐ Figma account created (free tier)
☐ New file created, one page
☐ Colour styles + text styles set up (Step 0 in the guide)
☐ 8 reusable components built
☐ Screen 1 — `01 — Restaurant Discovery`
☐ Screen 2 — `02 — Login`
☐ Screen 3 — `03 — Restaurant Menu`
☐ Screen 4 — `04 — Cart`
☐ Screen 5 — `05 — Checkout`
☐ Screen 6 — `06 — Order Tracking`
☐ All frames 1440 × 900, arranged 3 × 2 on one page
☐ Share link set to **"Anyone with the link → can view"**
☐ Link pasted into README under *Project Artefacts*
☐ Screenshot `36-figma-wireframes-all.png` taken
☐ 6 individual frames exported at 2x PNG

**Full step-by-step build instructions:** [`FIGMA_WIREFRAME_GUIDE.md`](FIGMA_WIREFRAME_GUIDE.md)

---

## 5️⃣ Architecture diagram in Draw.io

> *"Title · One single page/diagram (landscape) · frontend → backend → data/cache → deployment/infra · Frontend, Backend, Database, Containerization, Deployment · arrows for data flow · labels/icons · legend/key"*

| Brief requirement | How `architecture.drawio` satisfies it | ☐ |
|-------------------|----------------------------------------|---|
| **Title** | "SwiftBite — Food Ordering & Delivery Platform · System Architecture" at the top, with a stack subtitle | ☐ |
| **Single page, landscape** | One page, 1600 × 900 landscape | ☐ |
| **Main flow frontend → backend → data → infra** | Left-to-right: Client → Presentation → Application → Data, with the infrastructure band running along the bottom | ☐ |
| **Frontend** | Teal zone: React 18 + Vite, pages, router, context store, api client, proxy | ☐ |
| **Backend** | Orange zone: FastAPI + Uvicorn, middleware, routers, security layer, business logic, ORM | ☐ |
| **Database** | Indigo zone: PostgreSQL 16 cylinder + the 5 tables + the pgdata volume | ☐ |
| **Containerization** | Every tier labelled with its container name; infra band covers images, network, healthchecks, volumes | ☐ |
| **Deployment** | Infra band: docker-compose.yml, bridge network, healthchecks, images, dev volumes, GitHub Actions CI | ☐ |
| **Arrows for data flow** | 7 numbered arrows — solid for requests, dashed for responses | ☐ |
| **Labels / icons** | Emoji icons on every node; every arrow labelled with protocol and payload | ☐ |
| **Legend / key** | Bottom-left box: 6 colour swatches + solid vs dashed arrow meanings + "planned component" style | ☐ |
| **Optional: cache** | Redis shown as a dashed "planned — Review 3" node | ☐ |
| **Optional: auth layer** | Red-highlighted Security Layer node inside the backend | ☐ |
| **Bonus** | "Example request flow — Place an order" panel walking through all 7 steps | ☐ |

☐ Opened `docs/architecture.drawio` at <https://app.diagrams.net> (File → Open From → Device)
☐ Exported `docs/architecture.png` at 200% zoom
☐ Exported `docs/architecture.pdf` (landscape, fit to page)
☐ Screenshot `38-drawio-architecture.png` taken

---

## 6️⃣ Dev setup — Create and organise your GitHub repository

> *"Add a proper folder structure · Add a good .gitignore file · In your README.md, clearly explain your branching strategy · GitHub Flow is recommended · Create at least one feature branch and show it in screenshots."*

☐ Repository created and pushed to GitHub
☐ Folder structure: `backend/`, `frontend/`, `docs/`, `scripts/`, `.github/workflows/`
☐ Backend internally organised into `app/core/` and `app/routers/`
☐ Frontend internally organised into `src/pages/`, `src/components/`, `src/api/`
☐ `.gitignore` present, covering Python, Node, Docker, databases, secrets, IDEs, OS files
☐ README explains **GitHub Flow** with a comparison table against Git Flow
☐ README documents the branch naming convention with 7 branch types
☐ README documents Conventional Commits with real examples from this repo
☐ README lists the branch protection rules on `main`
☐ At least one feature branch created and pushed — `feature/12-restaurant-search`
☐ A second branch pushed — `docs/03-vision-document`
☐ Screenshot `02-github-branches.png` shows all branches
☐ Screenshot `03-github-readme-branching-strategy.png` taken

---

## 7️⃣ Dev setup — Set up Docker for local development

> *"Install Docker Desktop · Create Dockerfile(s) in your repo · Add clear instructions in README.md under a section called 'Quick Start – Local Development' · Take screenshots as proof."*

☐ Docker Desktop installed and running
☐ `backend/Dockerfile` present (Python 3.11-slim, layer-cached deps, healthcheck)
☐ `frontend/Dockerfile` present (Node 20-alpine, Vite dev server)
☐ `frontend/Dockerfile.prod` present (multi-stage → nginx) — **extra credit**
☐ `docker-compose.yml` orchestrates all 3 services
☐ `.dockerignore` in both backend and frontend
☐ README has a section titled **exactly** "🚀 Quick Start – Local Development"
☐ Quick Start lists prerequisites with version numbers
☐ Quick Start gives the exact 3 commands
☐ Quick Start lists all service URLs
☐ Quick Start includes demo credentials
☐ Quick Start includes a smoke test
☐ Quick Start includes everyday Docker commands
☐ Quick Start includes a troubleshooting table
☐ Screenshot `11-docker-desktop-installed.png` taken

---

## 8️⃣ Dev setup — Document your local development tools

> *"Document Your Local Development Tools In your README.md"*

☐ README has a **"🧰 Local Development Tools"** section covering:
  ☐ Core runtime tools (Docker, Compose, Git) with versions and purpose
  ☐ Backend stack — 9 libraries with versions
  ☐ Frontend stack — 6 tools with versions
  ☐ Data layer
  ☐ Recommended VS Code extensions with extension IDs
  ☐ Debugging and inspection tools
  ☐ Project management tools

---

## 9️⃣ Proof that everything works

> *"Screenshots of: Terminal showing successful docker build and docker run / docker-compose up · Your app running perfectly in the browser on localhost · GitHub repo page showing your branches and README"*

### Terminal proof
☐ `13-docker-compose-build.png` — build finishing with `FINISHED`, no errors
☐ `14-docker-compose-up.png` — all 3 services starting, db connected, seed run, Uvicorn + Vite ready
☐ `15-docker-compose-ps.png` — all three containers `Up`, db `(healthy)`

### Browser proof
☐ `19-app-restaurant-list.png` — app at `localhost:5173` with 6 restaurants
☐ `27-app-order-tracking.png` — live order tracking timeline
☐ Every browser screenshot shows the address bar with `localhost` visible

### GitHub proof
☐ `01-github-repo-overview.png` — repo page with folders + README
☐ `02-github-branches.png` — branches list
☐ `03-github-readme-branching-strategy.png` — branching strategy section

**Full instructions with exact commands:** [`SCREENSHOT_GUIDE.md`](SCREENSHOT_GUIDE.md)

---

## 🎁 Extra credit already built in (mention these in your viva)

| Extra | Where |
|-------|-------|
| Working full-stack app, not just a scaffold | 20 API endpoints, 8 frontend pages, complete order lifecycle |
| Auto-generated interactive API documentation | `localhost:8000/docs` (OpenAPI 3.1) |
| Server-side price computation (security) | `backend/app/routers/orders.py` — client prices ignored |
| Immutable order history | `order_items.name_snapshot` + `unit_price` frozen at order time |
| Container healthchecks + health-gated startup | `docker-compose.yml` `depends_on: condition: service_healthy` |
| Database wait-and-retry loop | `backend/app/database.py` `wait_for_db()` |
| Idempotent seeding | `backend/app/seed.py` — safe to restart |
| Hot reload inside Docker | Volume mounts + `usePolling` for Windows |
| Multi-stage production frontend image | `frontend/Dockerfile.prod` → nginx |
| GitHub Actions CI pipeline | `.github/workflows/ci.yml` — builds both images + compose smoke test |
| Automation scripts for issue creation | `scripts/create_issues.ps1` and `.sh` |
| Full JWT auth with bcrypt | `backend/app/core/security.py` |
| Cross-user data isolation | Every order query filtered by `user_id` from the JWT |

---

## 📤 Final submission bundle

Depending on what your faculty asks for, prepare:

☐ **GitHub repository URL** — `https://github.com/<YOUR_USERNAME>/swiftbite`
☐ **GitHub Project board URL** — `https://github.com/users/<YOUR_USERNAME>/projects/1`
☐ **Figma share link** — view access for anyone with the link
☐ **`architecture.pdf`** — the exported Draw.io diagram
☐ **A report document** (if required) containing:
  - Cover page: name, reg no, slot, course, faculty
  - The vision document (copy from README)
  - The 25 user stories table
  - The MoSCoW breakdown
  - The 6 wireframe images
  - The architecture diagram
  - All screenshots with captions
  - The repository and Figma links

☐ **Everything committed and pushed to `main`**

```powershell
cd C:\Users\risha\OneDrive\Desktop\swiftbite
git add .
git commit -m "docs: final Review 1 submission"
git push origin main
```

---

## 🎤 Likely viva questions — and where your answer lives

| Question | Your answer |
|----------|-------------|
| "Why did you choose this architecture?" | README → *Architecture*; three-tier separation, each tier independently deployable |
| "Why FastAPI over Django or Flask?" | Async support, automatic OpenAPI docs, Pydantic validation built in — show them `/docs` |
| "How do you prevent a user from tampering with prices?" | US-19 — server recomputes every total from `menu_items.price`; demo it in Swagger by sending a fake price |
| "Why GitHub Flow?" | README → *Branching Strategy*; the comparison table against Git Flow |
| "How would you scale this?" | The Redis node in the diagram, plus stateless JWT auth meaning the backend scales horizontally |
| "Why is X only a Should Have?" | MOSCOW.md → *Prioritisation decisions worth defending* |
| "What is out of scope and why?" | MOSCOW.md → *Won't Have* — 10 items with reasons and revisit dates |
| "Show me it actually works" | `docker compose up` live, then walk the full order flow in the browser |
| "How does a new developer get started?" | One command: `docker compose up --build` — that is US-25 |
| "What happens if the database is slow to start?" | `wait_for_db()` retry loop + Compose healthcheck gating |
