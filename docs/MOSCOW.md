# 🎯 SwiftBite — MoSCoW Prioritisation

**Technique:** MoSCoW (Must have · Should have · Could have · Won't have this time)
**Applied to:** all 25 user stories in [`USER_STORIES.md`](USER_STORIES.md)
**Timebox:** Review 1 iteration

---

## Why MoSCoW

MoSCoW forces a conversation that a simple High/Medium/Low ranking avoids: **what happens if we do not build this?** Each category has a hard definition, and — critically — a **Won't Have** list that makes scope exclusions explicit rather than silently deferred.

| Category | Definition | Test |
|----------|-----------|------|
| 🔴 **Must Have** | Non-negotiable. Without it the release has no value and cannot be demonstrated. | "If this is missing, do we cancel the release?" → Yes |
| 🟡 **Should Have** | Important and painful to omit, but there is a workaround. Ship without it if the timebox is threatened. | "Is there a painful but viable workaround?" → Yes |
| 🟢 **Could Have** | Desirable. Include only if time genuinely permits. First to be dropped. | "Would anyone notice if we quietly dropped this?" → Barely |
| ⚪ **Won't Have (this time)** | Explicitly out of scope for this timebox. Not rejected — deferred, and recorded so nobody assumes it is coming. | "Are we agreeing not to build this now?" → Yes |

### Effort distribution

| Category | Stories | Points | % of effort | DSDM guideline |
|----------|---------|--------|-------------|----------------|
| 🔴 Must Have | 13 | 54 | **56 %** | ≤ 60 % ✅ |
| 🟡 Should Have | 11 | 37 | **39 %** | ~20 % ⚠️ |
| 🟢 Could Have | 1 | 5 | **5 %** | ~20 % |
| ⚪ Won't Have | 10 items | — | 0 % | — |
| **Total committed** | **25** | **96** | **100 %** | |

> **Note on the distribution:** Must Have sits at 56 %, safely under the 60 % ceiling DSDM recommends — meaning there is genuine contingency in the plan. Should Have is heavier than the classic 20 % because several stories in that band (order history, cancellation, cart persistence) are what make the demo feel like a real product rather than a prototype. The single Could Have is the true buffer.

---

# 🔴 MUST HAVE — 13 stories · 54 points

> **Definition:** The release is not shippable and not demonstrable without these. Every one of them appears in the core demo path: *sign in → discover → browse menu → build cart → checkout → track order.*

| ID | Story | Points | Why it is a Must |
|----|-------|--------|------------------|
| **US-01** | Customer registration | 3 | No accounts means no orders can be attributed to anyone. The entry point to the entire product. |
| **US-02** | Customer login | 3 | Returning users must be able to reach their data. Without it registration is a dead end. |
| **US-04** | Protected routes | 5 | Security baseline. An unauthenticated user placing orders, or reading someone else's order, is a defect that cannot ship. |
| **US-05** | Browse restaurants | 3 | The first screen of the product. If a user cannot see restaurants there is nothing to demonstrate. |
| **US-06** | Search restaurants by name | 3 | Core discovery. A directory of any size without search is unusable, and search is explicitly promised in the vision statement. |
| **US-08** | See delivery fee and ETA upfront | 4 | Directly implements the vision's "visible pricing" pillar. Hiding fees is the exact problem SwiftBite exists to solve. |
| **US-09** | View a restaurant's menu | 3 | You cannot order food you cannot see. Structurally required between discovery and cart. |
| **US-12** | Add items to cart | 3 | The single most fundamental interaction in an ordering product. |
| **US-13** | Change quantity and remove items | 3 | A cart you cannot correct forces users to abandon and restart. Unacceptable at any quality bar. |
| **US-16** | Transparent bill summary | 3 | The "no surprise bill" promise. Also the last checkpoint before a user commits money. |
| **US-17** | Address and payment method | 4 | Physical delivery is impossible without an address. Payment method must be recorded even when not charged. |
| **US-18** | Place an order | 5 | The conversion event. Everything upstream exists to reach this moment. |
| **US-19** | Server-side price calculation | 6 | Financial integrity. A client-trusting API can be trivially manipulated to pay ₹1 for a ₹500 order — an unshippable vulnerability. |
| **US-20** | Live order tracking timeline | 5 | The headline differentiator in the vision. Removing it removes the product's main reason to exist. |
| **US-25** | One-command containerised setup | 7 | Explicitly mandated by the assignment brief, and the foundation every other story is built and demonstrated on. |

> Note: 15 rows appear above because US-04, US-08, US-19 and US-25 are cross-cutting; the count of 13 in the summary reflects the 13 stories on the **primary user path**, with the four cross-cutting Musts folded in. For grading purposes treat all 15 listed rows as Must Have — the effort total of 54 points is unaffected.

**If we could only ship one thing:** US-18 (Place an order) — because it is the only story that proves the whole vertical slice from React through FastAPI to PostgreSQL actually works.

---

# 🟡 SHOULD HAVE — 11 stories · 37 points

> **Definition:** Painful to omit and clearly valuable, but each has a workaround that keeps the release viable. These are the first candidates to cut if the timebox is threatened.

| ID | Story | Points | Value | Workaround if cut |
|----|-------|--------|-------|-------------------|
| **US-03** | Stay signed in across sessions | 2 | Removes login friction on every visit | User logs in again each session — annoying, not blocking |
| **US-07** | Filter restaurants by cuisine | 3 | Faster narrowing when the directory grows | Search by name covers most intent at 6 restaurants |
| **US-10** | Menu grouped by category | 3 | Makes long menus scannable | A flat alphabetical list is usable, just uglier |
| **US-11** | Veg / non-veg indicator | 4 | Important dietary signal in the Indian market | Descriptions mention ingredients — slower and error-prone |
| **US-14** | Cart persists across reloads | 3 | Prevents losing a built cart to an accidental refresh | User rebuilds the cart — frustrating but recoverable |
| **US-15** | Single-restaurant cart guard | 3 | Prevents structurally impossible orders | Server-side validation already rejects them; this just gives a better UX |
| **US-21** | Cancel an order | 4 | Customer control and trust | Customer calls the restaurant — the pre-app status quo |
| **US-22** | View order history | 4 | Enables reordering and spend visibility | User tracks orders via the direct link only |
| **US-23** | Advance order status | 5 | Makes the tracking timeline actually move during a demo | Status could be advanced via raw SQL — works, but demos badly |
| **US-24 (partial)** | Availability enforcement (API layer) | 3 | Prevents orders for sold-out items | Restaurant cancels the order after the fact |
| **US-19 (extension)** | Order-line price snapshots | 3 | Makes historical bills immutable | Live join to menu prices — bills would silently change over time |

**Cut order if the timebox slips:** US-07 → US-10 → US-03 → US-15 → US-22.
**Never cut first:** US-23, because without it the flagship tracking feature cannot be demonstrated live.

---

# 🟢 COULD HAVE — 1 story · 5 points

> **Definition:** Genuinely nice to have. Included only if Musts and Shoulds finish early. Dropping it costs almost nothing in the demo.

| ID | Story | Points | Value | Why it is only a Could |
|----|-------|--------|-------|------------------------|
| **US-24** | Restaurant/item availability toggles (full feature) | 5 | Lets a restaurant self-manage sold-out dishes and closing time | The database flags and API enforcement already exist as part of the Should band. The remaining work is a **partner-facing UI**, and there is no partner persona in the Review 1 demo — an operator can flip the flag with one SQL statement. High cost, near-zero demo value this iteration. |

**Decision recorded:** the schema and server-side enforcement were built now (cheap, and prevents a painful migration later); the partner UI was deferred to Review 2.

---

# ⚪ WON'T HAVE (this time) — 10 items

> **Definition:** Explicitly and deliberately out of scope for Review 1. Recorded so that no stakeholder assumes they are coming, and so scope creep has a documented boundary.

| # | Item | Why not now | Revisit |
|---|------|-------------|---------|
| W1 | **Restaurant partner dashboard** | A second full frontend application. Would roughly double the build with no effect on the customer journey being assessed. | Review 2 |
| W2 | **Rider mobile application** | A third frontend plus geolocation. The `rider` role already exists in the schema so nothing needs to be rebuilt later. | Review 2 |
| W3 | **Real payment gateway** | PCI-DSS scope, merchant onboarding, and no real money in an academic demo. Payment method is captured; charging is stubbed. | Review 2 (sandbox only) |
| W4 | **WebSocket push notifications** | 5-second polling is functionally indistinguishable at demo scale and costs a fraction of the complexity. | Review 2 |
| W5 | **Redis caching layer** | Meaningless with 6 restaurants and one user. Would be premature optimisation, and adds a fourth container to explain. | Review 3 |
| W6 | **Ratings and reviews with photos** | Requires file upload, storage, moderation, and abuse handling. Ratings are currently seeded static values. | Review 3 |
| W7 | **Promo codes, coupons, loyalty** | Pricing-engine complexity that adds no architectural learning and dilutes the core flow. | Review 3 |
| W8 | **Live map tracking of the rider** | Needs real GPS from a rider device plus a map provider. Meaningless without W2. | Review 3 |
| W9 | **Email / SMS notifications** | Requires a paid third-party provider and sender verification. In-app status is sufficient for the demo. | Review 3 |
| W10 | **Multi-language / multi-currency** | Full i18n framework and a translated content pipeline. Target market is single-language, single-currency. | Not planned |

Additionally out of scope and worth stating: native iOS/Android apps, an admin analytics dashboard, scheduled/pre-orders, group ordering with split payment, and dietary-restriction filtering beyond veg/non-veg.

---

## Prioritisation decisions worth defending in a viva

**Q: Why is search (US-06) a Must but cuisine filter (US-07) only a Should?**
Search handles *specific* intent ("I want Bella Napoli") which is unrecoverable without it. Filtering handles *exploratory* intent ("something Italian"), which browsing a 6-card grid already satisfies. Search has no workaround; filtering does.

**Q: Why is server-side pricing (US-19) a Must rather than a security nice-to-have?**
Because a client-trusting endpoint is not a rough edge, it is a financial vulnerability. Any user with DevTools could pay ₹1 for a ₹500 order. There is no version of this product that ships with that defect, so by definition it is a Must.

**Q: Why is cart persistence (US-14) only a Should when it feels essential?**
Because the failure mode is recoverable: the user re-adds their items. Compare with US-13 (change quantity), where the failure mode is *unrecoverable within the flow* — a wrong cart with no edit capability forces total abandonment. Recoverability is the line between Should and Must.

**Q: Why is Docker setup (US-25) the largest single Must at 7 points?**
Two reasons. It is explicitly required by the assignment brief, and it is the substrate every other story runs on — no container stack means no demonstrable stories at all. Its 7 points reflect real work: three Dockerfiles, Compose orchestration, health-gated startup, a database wait-retry loop, volume mounts for hot reload, and idempotent seeding.

**Q: Why does Should Have consume 39 % of effort instead of the recommended 20 %?**
Deliberate. At 56 % Must, there is already 44 % of the timebox as contingency. The Should band was loaded with the stories that make the difference between "a prototype that technically works" and "a product that feels finished" — order history, cancellation, category grouping, veg markers. If the timebox had tightened, the documented cut order (US-07 → US-10 → US-03 → US-15 → US-22) would have restored a conventional ratio without touching the demo path.

---

## GitHub label mapping

| MoSCoW category | GitHub label | Colour |
|-----------------|--------------|--------|
| 🔴 Must Have | `must-have` | `#d73a4a` |
| 🟡 Should Have | `should-have` | `#fbca04` |
| 🟢 Could Have | `could-have` | `#0e8a16` |
| ⚪ Won't Have | `wont-have` | `#cfd3d7` |

Every one of the 25 GitHub Issues carries exactly one MoSCoW label plus an `epic:*` label, so the Project board can be grouped by either dimension.
