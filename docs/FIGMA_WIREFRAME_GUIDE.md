# 🎨 Figma Wireframe Guide — 6 Screens

**What you are building:** 6 low-to-mid fidelity wireframes for SwiftBite, on **one page** of **one Figma file** (Figma free tier allows 3 files × 3 pages, so one page is plenty).

**Time needed:** 45–75 minutes if you follow this literally.

> ⚠️ **Do not skip the setup section.** Building the 8 reusable components first turns each screen from 20 minutes of drawing into 4 minutes of duplicating.

---

## 📐 Global specification

| Setting | Value |
|---------|-------|
| Frame size | **1440 × 900** (Figma preset: *Desktop → Desktop*) |
| Layout grid | 12 columns · 80 px margin · 24 px gutter |
| Frame spacing | 200 px horizontally, 200 px vertically |
| Arrangement | 3 frames across × 2 rows |
| Font | **Inter** (Figma's default — do not change it) |

### Colour styles to create first

Go to the right sidebar → click the **four dots** next to *Fill* → **+** → name each one.

| Style name | Hex | Used for |
|-----------|-----|----------|
| `Brand/Primary` | `#FF5A1F` | Buttons, logo, active states |
| `Brand/Primary Dark` | `#E04A12` | Button hover |
| `Brand/Tint` | `#FFF4EF` | Badges, notice backgrounds |
| `Ink/900` | `#16181D` | Headings, primary text |
| `Ink/500` | `#6B7280` | Secondary text, captions |
| `Ink/200` | `#E5E7EB` | Borders, dividers |
| `Surface/Page` | `#F7F7F8` | Frame backgrounds |
| `Surface/Card` | `#FFFFFF` | Cards and panels |
| `Status/Success` | `#16A34A` | Ratings, delivered, veg dot |
| `Status/Danger` | `#B91C1C` | Errors, cancelled, non-veg dot |

### Text styles to create

Select a text layer → right sidebar → **four dots** next to *Text* → **+**.

| Style name | Size / weight / line-height |
|-----------|------------------------------|
| `H1` | 30 / Bold (700) / 38 |
| `H2` | 20 / Semibold (600) / 28 |
| `Body` | 15 / Regular (400) / 24 |
| `Body Bold` | 15 / Semibold (600) / 24 |
| `Caption` | 13 / Regular (400) / 20 |
| `Button` | 15 / Semibold (600) / 20 |

---

## 🧩 Step 0 — Build 8 reusable components (do this first, 20 min)

Create these off to the left of your frames, then **right-click → Create component** (`Ctrl/Cmd + Alt + K`) on each.

### C1 — Navigation bar
- Rectangle **1440 × 64**, fill `Surface/Card`, bottom border 1px `Ink/200`
- Text "SwiftBite" at x=80, `H2`, fill `Brand/Primary`
- Right side (x≈1000 onward): "Restaurants" · "My Orders" in `Caption`, fill `Ink/500`
- Pill: rounded rect **110 × 36**, corner radius 999, fill `Brand/Primary`, label "Cart (2)" in `Button`, white
- "Sign out" ghost button: **90 × 34**, radius 10, 1.5px border `Brand/Primary`, transparent fill

### C2 — Primary button
Rounded rect **auto × 44**, radius 10, fill `Brand/Primary`, label `Button` in white, 20px horizontal padding.

### C3 — Ghost button
Same geometry, transparent fill, 1.5px border `Brand/Primary`, label in `Brand/Primary`.

### C4 — Restaurant card
- Container **340 × 250**, radius 14, fill `Surface/Card`, 1px border `Ink/200`
- Top image block **340 × 130**, fill a light peach `#FFD8C7`, with a 40px emoji centred (🍕/🍛/🍔…)
- Body padding 16px:
  - Restaurant name — `Body Bold`
  - Description — `Caption`, `Ink/500`
  - Meta row — `Caption`: `★ 4.5` in `Status/Success`, then `· Italian · 28 min · ₹39 delivery` in `Ink/500`

### C5 — Menu item row
- Frame **1000 × 92**, bottom border 1px `Ink/200`
- Left: 12×12 rounded square outline in `Status/Success` (veg) with a filled dot inside
- Then dish name `Body Bold`, description `Caption` `Ink/500`, price `Body Bold`
- Right, vertically centred: **C3 Ghost button** labelled "Add +"

### C6 — Quantity stepper
Rounded rect **100 × 36**, radius 8, 1px border `Ink/200`. Inside: `−`, `2`, `+` — the symbols in `Brand/Primary`, the number in `Body Bold`.

### C7 — Bill summary panel
- Container **340 × 220**, radius 14, fill `Surface/Card`, 1px border `Ink/200`, 24px padding
- "Bill summary" — `H2`
- Three rows in `Caption` `Ink/500`, label left / value right: "Item total", "Delivery fee"
- Divider 1px `Ink/200`
- "To pay" row in `H2`, `Ink/900`
- **C2 Primary button**, full width, at the bottom

### C8 — Tracking stage row
- 28×28 circle. **Done state:** fill `Status/Success`, white ✓. **Pending state:** fill `Ink/200`, white number.
- To its right: title `Body Bold`, subtitle `Caption` `Ink/500`
- A 2px vertical connector line below the circle (green if done, `Ink/200` if not)

---

# 🖼 Screen 1 — Restaurant Discovery (Home)

**Frame name:** `01 — Restaurant Discovery`
**Purpose:** the landing screen. Browse, search and filter restaurants.
**User stories covered:** US-05, US-06, US-07, US-08

### Build it

1. Create a **1440 × 900** frame, fill `Surface/Page`.
2. Place **C1 Navigation bar** at the very top (y=0).
3. At x=80, y=96: text **"Order food you love"** — `H1`.
4. At x=80, y=138: text **"Fresh from 6 restaurants near you."** — `Body`, `Ink/500`.
5. **Search bar** at x=80, y=180: rounded rect **1280 × 50**, radius 12, fill `Surface/Card`, 1px border `Ink/200`. Placeholder text "Search restaurants…" in `Body`, `Ink/500`, 18px left padding. Add a 🔍 icon at the right edge.
6. **Filter chips** at x=80, y=250 — a horizontal row, 8px gaps, each chip is a rounded rect height 36, radius 999, 16px horizontal padding, `Caption`:
   - `All` — **active state:** fill `Brand/Primary`, white text
   - `🍛 North Indian`, `🍕 Italian`, `🥡 Chinese`, `🍔 American`, `🥗 Healthy`, `🍣 Japanese` — fill `Surface/Card`, 1px border `Ink/200`, text `Ink/900`
7. **Restaurant grid** starting at x=80, y=320. Place **6 copies of C4**, arranged 3 across × 2 down, 20px gap (card 340 wide → 340+20+340+20+340 = 1080; centre or left-align at x=80).

   | Position | Name | Emoji | Meta |
   |----------|------|-------|------|
   | 1 | Sushi Sen | 🍣 | ★ 4.7 · Japanese · 38 min · ₹49 |
   | 2 | Bella Napoli | 🍕 | ★ 4.6 · Italian · 28 min · ₹39 |
   | 3 | Tandoori Junction | 🍛 | ★ 4.5 · North Indian · 32 min · ₹29 |
   | 4 | The Burger Lab | 🍔 | ★ 4.4 · American · 22 min · ₹19 |
   | 5 | Wok This Way | 🥡 | ★ 4.3 · Chinese · 25 min · ₹25 |
   | 6 | Green Bowl Co. | 🥗 | ★ 4.1 · Healthy · 20 min · ₹35 |

8. **Annotation (optional but impresses):** off to the right of the frame, add a small red text note: *"Sorted by rating DESC — no paid placement (see Vision §2)"* with an arrow pointing at the grid.

---

# 🖼 Screen 2 — Login / Sign In

**Frame name:** `02 — Login`
**Purpose:** authenticate a returning customer.
**User stories covered:** US-02, US-03

### Build it

1. New **1440 × 900** frame, fill `Surface/Page`.
2. Place **C1 Navigation bar** at y=0, but change the right side to show only a `Sign in` primary button (user is signed out).
3. **Centred card:** rounded rect **420 × 480**, radius 14, fill `Surface/Card`, 1px border `Ink/200`. Position at x=510, y=180. Padding 24px inside.
4. Inside the card, stacked vertically with 16px gaps:
   - **"Welcome back"** — `H1`
   - **"Sign in to order from your favourite restaurants."** — `Body`, `Ink/500`
   - Label **"Email address"** — `Caption`, semibold
   - Input field: rect **372 × 44**, radius 10, 1px border `Ink/200`, fill `Surface/Card`. Text inside: `demo@swiftbite.com` in `Body`
   - Label **"Password"** — `Caption`, semibold
   - Input field, same spec, text `••••••••`
   - **C2 Primary button**, full width (372), label **"Sign in"**
   - `Caption` `Ink/500`: **"New here? Create an account"** — style "Create an account" in `Brand/Primary`, semibold
   - `Caption` `Ink/500`: **"Demo login: demo@swiftbite.com / demo1234"**
5. **Error state variant (adds marks):** duplicate the card 500px to the right, and at the top of it add a rect **372 × 44**, radius 10, fill `#FEF2F2`, with text **"Incorrect email or password"** in `Status/Danger`, `Caption`. Label this copy "Error state" underneath.

---

# 🖼 Screen 3 — Restaurant Menu

**Frame name:** `03 — Restaurant Menu`
**Purpose:** browse a restaurant's dishes and add them to the cart.
**User stories covered:** US-09, US-10, US-11, US-12

### Build it

1. New **1440 × 900** frame, fill `Surface/Page`.
2. **C1 Navigation bar** at y=0.
3. At x=80, y=90: `Caption` `Ink/500` — **"← All restaurants"**
4. **Restaurant header panel** at x=80, y=118: rect **1280 × 150**, radius 14, fill `Surface/Card`, 1px border `Ink/200`, 24px padding.
   - Left side: **"Bella Napoli"** in `H1`; **"Wood-fired Neapolitan pizza and handmade pasta."** in `Body` `Ink/500`; meta row in `Caption`: `★ 4.6` green, then `· Italian · 28 min delivery · ₹39 fee`
   - Right side, vertically centred: **C2 Primary button** labelled **"View cart (2)"**
5. **Green notice bar** at x=80, y=288: rect **1280 × 44**, radius 10, fill `#F0FDF4`, text **"Added Margherita Pizza to your cart."** in `Status/Success`, `Caption`, 14px left padding.
6. **Category panel — "Pizza"** at x=80, y=350: rect **1280 × 240**, radius 14, fill `Surface/Card`, border 1px `Ink/200`, 24px padding.
   - Heading **"Pizza"** — `H2`
   - Two **C5 Menu item rows**:
     - 🟢 **Margherita Pizza** — "San Marzano tomato, fior di latte, basil" — **₹329** — [Add +]
     - 🔴 **Pepperoni Pizza** — "Double pepperoni, mozzarella" — **₹429** — [Add +]
7. **Category panel — "Pasta"** at x=80, y=610: rect **1280 × 160**, same styling.
   - Heading **"Pasta"** — `H2`
   - One row: 🟢 **Penne Arrabbiata** — "Chilli-tomato sauce, garlic, parsley" — **₹299** — [Add +]
8. **Category panel — "Desserts"** at x=80, y=790 (partially below the fold is fine — it shows scrolling):
   - Heading **"Desserts"**, one row: 🟢 **Tiramisu** — "Mascarpone, espresso, cocoa" — **₹199** — [Add +]

> 💡 Make one dish show a **disabled** "Unavailable" button (fill `Ink/200`, grey text) to demonstrate US-11 / US-24.

---

# 🖼 Screen 4 — Shopping Cart

**Frame name:** `04 — Cart`
**Purpose:** review and edit the order before paying.
**User stories covered:** US-13, US-14, US-15, US-16

### Build it

1. New **1440 × 900** frame, fill `Surface/Page`.
2. **C1 Navigation bar** at y=0.
3. x=80, y=96: **"Your cart"** — `H1`
4. x=80, y=138: **"From Bella Napoli"** — `Body` `Ink/500`, with "Bella Napoli" bold.
5. **Two-column layout** starting y=190:

   **Left column — items panel** at x=80, width **900**, height **320**, radius 14, fill `Surface/Card`, 1px border `Ink/200`, 24px padding.
   - Row 1: **Margherita Pizza** `Body Bold` / **₹329 each** `Body Bold` · right side: **C6 Quantity stepper** showing `2` · then line total **₹658** right-aligned
   - Divider 1px `Ink/200`
   - Row 2: **Garlic Bread** / **₹149 each** · stepper showing `1` · line total **₹149**
   - Divider
   - Row 3: **Tiramisu** / **₹199 each** · stepper showing `1` · line total **₹199**
   - At the bottom: **C3 Ghost button** labelled **"Clear cart"**

   **Right column — C7 Bill summary panel** at x=1020, y=190, width **340**:
   - "Bill summary" — `H2`
   - `Item total` → **₹1006**
   - `Delivery fee` → **₹39**
   - divider
   - **To pay** → **₹1045** (`H2`)
   - **C2 Primary button**, full width: **"Proceed to checkout"**

6. **Empty-state variant (recommended):** below the main layout at y=580, draw a smaller version showing a centred 🛒 emoji at 52px, **"Your cart is empty"** in `H2`, **"Browse restaurants and add something delicious."** in `Body` `Ink/500`, and a **C2** button **"Browse restaurants"**. Label it "Empty state".

---

# 🖼 Screen 5 — Checkout

**Frame name:** `05 — Checkout`
**Purpose:** confirm address and payment method, then place the order.
**User stories covered:** US-17, US-18, US-19

### Build it

1. New **1440 × 900** frame, fill `Surface/Page`.
2. **C1 Navigation bar** at y=0.
3. x=80, y=96: **"Checkout"** — `H1`
4. x=80, y=138: **"Confirm your address and payment method."** — `Body` `Ink/500`
5. **Left column — form panel** at x=80, y=190, **900 × 480**, radius 14, fill `Surface/Card`, 1px border `Ink/200`, 24px padding:
   - **"Delivery details"** — `H2`
   - Label **"Deliver to"** — `Caption` semibold
   - Textarea: rect **852 × 88**, radius 10, 1px border `Ink/200`. Text inside: *"Block A, VIT Vellore, Tamil Nadu 632014"* in `Body`
   - Label **"Contact number"**
   - Input **852 × 44**, radius 10, border `Ink/200`, fill `#F7F7F8` (read-only look), text `9876543210`
   - **"Payment method"** — `H2`, 24px above
   - Dropdown: rect **852 × 44**, radius 10, border `Ink/200`, text **"Cash on delivery"** with a `▾` chevron at the right edge
   - *(Optional: draw the open dropdown as a floating panel listing Cash on delivery / UPI / Credit-debit card / SwiftBite wallet)*
   - **C2 Primary button**, full width: **"Place order · ₹1045"**
6. **Right column — order summary panel** at x=1020, y=190, **340 × 300**, radius 14, fill `Surface/Card`, border `Ink/200`, 24px padding:
   - **"Order summary"** — `H2`
   - **"Bella Napoli"** — `Caption` `Ink/500`
   - `2 × Margherita Pizza` → **₹658**
   - `1 × Garlic Bread` → **₹149**
   - `1 × Tiramisu` → **₹199**
   - `Delivery fee` → **₹39**
   - divider, then **To pay → ₹1045** in `H2`
7. **Annotation (optional):** red note beside the button — *"Totals recomputed server-side from DB prices — client values ignored (US-19)"*.

---

# 🖼 Screen 6 — Order Tracking

**Frame name:** `06 — Order Tracking`
**Purpose:** show the live status of a placed order.
**User stories covered:** US-20, US-21, US-22

### Build it

1. New **1440 × 900** frame, fill `Surface/Page`.
2. **C1 Navigation bar** at y=0.
3. x=80, y=90: `Caption` `Ink/500` — **"← My orders"**
4. x=80, y=118: **"Order #1"** — `H1`.
   On the same line, right-aligned at x≈1250: **status badge** — rounded rect height 28, radius 999, 12px horizontal padding, fill `Brand/Tint`, text **"OUT FOR DELIVERY"** in `Brand/Primary`, `Caption` bold.
5. x=80, y=162: **"Placed on 01/08/2026, 7:42:15 pm"** — `Body` `Ink/500`
6. **Left column — live status panel** at x=80, y=210, **900 × 480**, radius 14, fill `Surface/Card`, 1px border `Ink/200`, 24px padding:
   - **"Live status"** — `H2`
   - Five **C8 Tracking stage rows**, 26px vertical gap, connected by a vertical line:

     | # | Circle | Title | Subtitle |
     |---|--------|-------|----------|
     | 1 | ✓ green | Order placed | We have received your order |
     | 2 | ✓ green | Order confirmed | Restaurant accepted your order |
     | 3 | ✓ green | Preparing your food | The kitchen is on it |
     | 4 | ✓ green | **Out for delivery** | Your rider is on the way |
     | 5 | `5` grey | Delivered | Enjoy your meal! |

     The connector line is `Status/Success` between stages 1–4 and `Ink/200` between 4–5.
   - At the bottom, a row of two buttons: **C2** "Simulate next stage →" and **C3** "Cancel order" *(show the Cancel button greyed/disabled with a small note "only available in PLACED / CONFIRMED")*
7. **Right column — bill panel** at x=1020, y=210, **340 × 300**, radius 14, fill `Surface/Card`, border `Ink/200`, 24px padding:
   - **"Bill"** — `H2`
   - `2 × Margherita Pizza` → **₹658**
   - `1 × Garlic Bread` → **₹149**
   - `1 × Tiramisu` → **₹199**
   - `Delivery fee` → **₹39**
   - divider, **Total → ₹1045** in `H2`
   - `Caption` `Ink/500`: **"Paying by:** COD" / **"Deliver to:** Block A, VIT Vellore, Tamil Nadu 632014"
8. **Annotation (optional):** *"Auto-refreshes every 5 s (US-20)"* with an arrow at the timeline.

---

## ✅ Final checks before you screenshot

- [ ] All 6 frames are named exactly: `01 — Restaurant Discovery` … `06 — Order Tracking`
- [ ] All 6 sit on **one page**, arranged 3 × 2, evenly spaced
- [ ] Every frame uses the same nav bar component
- [ ] Colour and text styles are applied (not hardcoded one-offs)
- [ ] Currency is consistent — ₹ everywhere, no decimals
- [ ] The cart total ₹1045 is identical on screens 4, 5 and 6

---

## 🔗 Publishing and linking your Figma file

1. Top-right → **Share**
2. Change *"Anyone at…"* to **"Anyone with the link"** → **"can view"**
3. **Copy link**
4. Paste it into `README.md` under **Project Artefacts** → *Figma file*

## 📸 Exporting for submission

**Whole-page overview (best single image for your report):**
1. Press `Shift + 1` to zoom-to-fit all frames
2. Take a full-window screenshot — Windows: `Win + Shift + S`
3. Save as `docs/screenshots/09-figma-wireframes-all.png`

**Individual frames:**
1. Select all 6 frames (`Ctrl/Cmd + A` on the canvas)
2. Right sidebar → **Export** → **+** → **2x** → **PNG**
3. Click **Export 6 layers**
4. Save into `docs/screenshots/wireframes/`

---

## 🎁 Optional extras that earn marks

| Extra | How | Why it helps |
|-------|-----|--------------|
| **Prototype links** | Prototype tab → drag from a button to the target frame. Wire: Screen 1 card → Screen 3; Screen 3 "View cart" → Screen 4; Screen 4 button → Screen 5; Screen 5 button → Screen 6 | Turns static wireframes into a clickable demo you can run in the viva |
| **Mobile variants** | Duplicate any 2 frames, resize to **390 × 844** (iPhone 14), stack the columns vertically | Evidences responsive thinking |
| **Annotation layer** | Red `Caption` text + arrows pointing at key elements, referencing US-IDs | Directly maps wireframes to your user stories for the grader |
| **Version history note** | Right-click canvas → *Add version to history* → name it "Review 1 submission" | Shows disciplined design process |
