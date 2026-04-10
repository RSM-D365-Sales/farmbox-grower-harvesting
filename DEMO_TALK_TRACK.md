# FarmBox Greens — 20-Minute Demo Talk Track

> **Requirement:** Show grow cycle tracking (seed-to-harvest, tray/rack), harvest scheduling, yield management for 1–3 day shelf-life.

---

## Opening (1 min)

> "FarmBox Greens is a 100% indoor hydroponic operation in Seattle's Georgetown neighborhood — acquired by Charlie's Produce in 2016. Everything we grow has a shelf life measured in days, not weeks. Living lettuce, baby greens, microgreens — some of these products go from harvest to customer plate in under 24 hours. That means our scheduling has to be precise, our yield tracking has to be real-time, and our ERP integration can't have a 'we'll sync it later' mentality."
>
> "Let me show you how we manage that end-to-end."

---

## Act 1 — The Dashboard (2 min)

**Navigate to:** Dashboard (`/`)

> "This is the operations dashboard. At a glance, the team sees six KPIs that tell them whether today is under control or not."

**Call out these KPIs:**

| KPI | What to say |
|-----|-------------|
| **Active Fields** | "How many of our grow zones have active cycles — we have 10 hydroponic zones, from NFT lettuce bays to vertical rack microgreen rooms." |
| **Harvest Ready** | "This is the number we start every morning with — how many zones have product ready to cut or pull today." |
| **Short Lead-Time Crops** | "This is the critical one. Any crop with a lead time of 48 hours or less — that's most of our microgreens — gets flagged here. Those can't sit. They move today or they don't move." |
| **Pending D365 Sync** | "Every yield we record automatically queues for sync to D365 F&SCM. If this number climbs, we know there's an integration issue." |

**Point at the two charts:**

> "Grow cycles by phase gives us the pipeline view — how much is in field prep, growing, harvest-ready. The yield-by-grade donut tells us quality. We're targeting 90%+ Grade A. Anything below that and we're looking at process."

**Click "View all" on Upcoming Harvests → transitions to Harvest Scheduling (or just note it).**

---

## Act 2 — Grow Zones & Crops Setup (2 min)

**Navigate to:** Manage Fields (`/setup/fields`)

> "Before we get into cycles, let me show the foundation. These are our grow zones — not 'fields' in the traditional sense. Each one is a controlled hydroponic environment."

**Point out 2–3 zones:**

- **GH-1 Bay A** — "1,200 square feet of NFT channels growing living butter lettuce. That's about a 30-by-40-foot bay."
- **Micro Room A** — "600 square feet of canopy — that's 150 square feet of floor space with 4-level vertical racks. Six racks, each rack four shelves. This is where the 8–10 day microgreens happen."
- **Propagation House** — "320 square feet — our seedling nursery. Rockwool cubes, germination chamber. Plugs grow here before transplant into the greenhouses."

> "Notice every zone has a grow method — NFT, DWC, Vertical Racks, Rockwool — and a status. This is a hydroponic operation, so there's no soil type, there's a grow method."

**Navigate to:** Manage Crops (`/setup/crops`)

> "Here are our 19 crop SKUs across four categories."

**Highlight the yield column and lead times:**

- **Living Butter Lettuce** — "2 heads per square foot per cycle, 35-day grow, 18-hour lead time. Sold with roots on — that's how we get 14-day shelf life on a living product."
- **Microgreens — Pea Shoots** — "0.35 lbs per square foot, 10-day cycle, 6-hour lead time. Six hours. That's seed-to-ship in under 10 days, and once it's cut, you have about 5 days of shelf life. These show up as 'Short Lead' flags throughout the system."
- **Baby Arugula** — "0.30 lbs per square foot, 18-day cycle. DWC dense-seeded, single cut."

> "The yield-per-square-foot-per-cycle metric is the industry standard for indoor operations. It lets us calculate expected output from any zone for any crop."

---

## Act 3 — Grow Cycle Tracking: Seed to Harvest (5 min)

**Navigate to:** Grow Cycles (`/grow-cycles`)

> "This is the heart of the operation. Every tray, every bay, every rack — tracked as a grow cycle from prep to completion."

**Show the phase pipeline filter — click through a couple phases:**

> "We filter by phase. Right now you can see we have cycles in every stage — field prep, planting, growing, harvest-ready, and harvesting. Let me walk through a couple."

**Click into a harvest-ready cycle** (e.g., Living Butter Lettuce in GH-1 Bay B):

> "This butter lettuce cycle in Bay B has been growing for 35 days. Let's look at the detail."

**On the Grow Cycle Detail page, call out:**

1. **Phase Progress Bar** — "Six-step pipeline: field prep, planting, growing, harvest-ready, harvesting, complete. This cycle is at harvest-ready — the heads are formed, roots are healthy, ready for live pack."

2. **Field Details card** — "GH-1 Bay B, 1,200 square feet of NFT canopy. This tells the crew exactly where to go."

3. **Crop Details card** — "Butter lettuce, Bibb variety, 35-day cycle. Target yield is 2 heads per square foot — so for this 1,200 sq ft bay, we expect about 2,400 heads."

4. **Key Dates card** — "Prep started 37 days ago, planted 35 days ago, expected harvest is today. Everything lines up."

5. **Harvest Schedules** (at bottom) — "And here's the schedule already attached — 5 AM to 9 AM today, team assigned. We'll look at that in detail next."

**Go back to Grow Cycles list. Show a microgreens cycle** (Micro Room A — Pea Shoots):

> "Now here's where the speed matters. Pea shoots — planted 10 days ago, already in the harvesting phase. This is a 10-day seed-to-harvest cycle on vertical racks. The note says 'Pea shoots at 4-inch height — daily cutting in progress.' We're cutting these racks in shifts."

**Show the 'advance phase' button on a growing cycle:**

> "As cycles progress, the team advances them through phases right here — one click moves a cycle from 'growing' to 'harvest-ready,' or from 'harvesting' to 'complete.' No paperwork, no whiteboard. The system is the source of truth."

**Briefly show the Propagation House cycles:**

> "We even track propagation. These romaine plugs in rockwool will be transplanted to GH-1 in 10 days. The system knows what's coming before the greenhouse even has space."

---

## Act 4 — Harvest Scheduling (4 min)

**Navigate to:** Harvest Scheduling (`/harvest-scheduling`)

> "Once a cycle hits harvest-ready, we schedule the actual harvest. This is where crew assignment, timing, and logistics come together."

**Show the status filter pills — click 'scheduled':**

> "We have four states: scheduled, in-progress, completed, and cancelled. Let's look at what's on deck."

**Point out 2–3 schedule cards:**

1. **Living Butter Lettuce — GH-1 Bay B, today 5–9 AM:**
   > "Sarah Mitchell is the lead, David and Elena are harvesting, Jake Williams is on delivery coordination. The note says 'Pull living heads with roots — pack in clamshells for Charlie's morning truck.' That's specific enough that a new team member could execute it."

2. **Pea Shoots — Micro Room A, today 4:30–7 AM (in-progress):**
   > "This one's already in-progress. Ryan Cooper leading, Amara on harvest. Note says 'racks 1-3 complete, racks 4-6 underway.' We track rack-by-rack on these microgreen rooms."

3. **Spring Mix — GH-2 Bay B, today 6–10 AM:**
   > "Cut at 3 inches, wash and spin dry, pack in 1-lb clamshells. Lisa Park is assigned for quality check on this one."

**Show the status action buttons:**

> "Once harvest starts, the lead clicks 'Start Harvest.' When it's done — 'Mark Complete.' If there's a problem — like the power outage we had two days ago — you cancel and the system tracks it. No harvest data is lost."

**Click '+ New Schedule' to show the form (don't submit):**

> "Creating a new schedule — you pick the grow cycle, but notice it only shows harvest-ready cycles. You can't schedule a harvest on something that's still growing. Set the date, time window, assign team members with these toggles, add notes, and go."

---

## Act 5 — Yield Management & Shelf-Life (4 min)

**Navigate to:** Yield Management (`/yield-management`)

> "After every harvest, the team records yield immediately. This is the bridge between the greenhouse and the ERP."

**Call out the KPIs:**

- **Total Yield** — "Running total across all recorded harvests."
- **Grade A %** — "This is our quality metric. We're grading A, B, C, or reject at the point of harvest. A is premium retail. B might go to a juice processor. Anything below that, we need to investigate."
- **Short Lead-Time Yield** — "How much of our yield is from crops with 48-hour-or-less lead time. These products have 5–7 day shelf lives — they need to ship the same day they're cut."

**Point at the "Yield by Crop" bar chart:**

> "Visual breakdown by crop. Butter lettuce dominates by volume because we're doing 2,400-head bay harvests, but on a revenue-per-square-foot basis, the microgreens outperform everything."

**Show the yield records table:**

> "Every record has the field, crop, quantity, grade, and when it was recorded. The pea shoots from this morning — 42 lbs, Grade A, racks 1-3. The spring mix from last week — 240 lbs Grade A, 18 lbs Grade B that went to the juice processor."

**Click '+ Record Yield' to show the form (don't submit):**

> "Recording a yield — select the grow cycle, enter quantity, unit, grade. When you save, two things happen: the yield record is created, and it's automatically queued for D365 sync. No extra step. That's critical for products with a 1-3 day shelf life — you can't afford a 24-hour data lag between harvesting and your ERP knowing it's in inventory."

**Transition to D365:**

> "Let me show you what that sync looks like on the D365 side."

---

## Act 6 — D365 Integration (2 min)

**Navigate to:** D365 Integration (`/d365`)

> "This is the sync queue. Every yield record, every harvest event — it flows here first, then to D365 F&SCM."

**Point at the KPIs (Pending / Processing / Synced / Failed):**

> "Green means data is flowing. If 'Failed' goes above zero, we have visibility into exactly what broke and a retry button to push it through."

**Briefly show the Demand & Inventory page** (`/d365/demand`):

> "Demand flows the other direction — from D365 into the greenhouse. These are real sales orders from PCC Community Markets, Metropolitan Market, Canlis, Whole Foods, Fred Meyer. The system shows remaining quantity and flags anything shipping in under 48 hours as urgent."

> "So the planning loop is: D365 tells us what customers need → we plan grow cycles to meet that demand → we harvest on schedule → yield data flows back to D365 as inventory. Closed loop."

**Briefly show Mappings** (`/d365/mappings`):

> "And the mapping layer connects our internal crop and field names to D365 item numbers and warehouse IDs. Living Butter Lettuce maps to FB-LBUT-001. The microgreen room maps to WH-GH. This is how the two systems speak the same language."

---

## Closing (1 min)

> "So to recap what we've covered:"
>
> 1. **Grow cycle tracking** — every zone in the facility, from propagation through harvest, tracked by phase with full crop and zone detail. NFT bays, DWC rafts, vertical rack microgreen rooms — each with their own grow method and canopy footprint.
>
> 2. **Harvest scheduling** — crew assignment, time windows, rack-level notes. Status management from scheduled through completion. Only harvest-ready cycles can be scheduled — the system enforces the workflow.
>
> 3. **Yield management for short shelf-life** — Grade-at-harvest, automatic D365 sync, short-lead-time flagging for anything under 48 hours. When your pea shoots have a 5-day shelf life and a 6-hour lead time, you need yield data in the ERP within minutes, not days.
>
> "This was built specifically for FarmBox Greens' operating model — indoor, hydroponic, perishable, fast-turn — with D365 F&SCM as the system of record for demand planning and inventory."
>
> "Questions?"

---

## Demo Navigation Cheat Sheet

| Time | Page | Route | Key Action |
|------|------|-------|------------|
| 0:00 | Opening | — | Set context: FarmBox + Charlie's Produce |
| 1:00 | Dashboard | `/` | KPIs, charts, pipeline overview |
| 3:00 | Manage Fields | `/setup/fields` | Show 2-3 zones + grow methods |
| 3:30 | Manage Crops | `/setup/crops` | Highlight yield/sqft, lead times, shelf life |
| 5:00 | Grow Cycles | `/grow-cycles` | Phase filters, advance buttons |
| 6:00 | Cycle Detail | `/grow-cycles/:id` | Butter lettuce detail — all 4 cards + progress bar |
| 8:00 | Cycle Detail | `/grow-cycles/:id` | Pea shoots — fast cycle, rack-level tracking |
| 10:00 | Harvest Scheduling | `/harvest-scheduling` | Cards with crew, status filters, action buttons |
| 12:00 | Harvest Scheduling | `/harvest-scheduling` | Show new schedule form (don't submit) |
| 14:00 | Yield Management | `/yield-management` | KPIs, grade chart, short-lead flag |
| 16:00 | Yield Management | `/yield-management` | Show record yield form (don't submit) |
| 17:00 | D365 Integration | `/d365` | Sync queue, connection health |
| 18:00 | D365 Demand | `/d365/demand` | Sales orders, inventory, urgent flags |
| 18:30 | D365 Mappings | `/d365/mappings` | Crop→Product, Field→Warehouse |
| 19:00 | Closing | — | Recap 3 pillars, invite questions |

---

## Talking Points If Asked

**"How does this handle multi-cut crops?"**
> Baby kale supports a second cut — the harvest note says "leave crowns for regrowth." The cycle stays in harvesting phase and gets another schedule.

**"What about the vertical racks — how do you track which rack?"**
> Rack-level detail goes in the harvest notes and zone naming. Micro Room A, Racks 1-6. The harvest in-progress note tells you exactly which racks are done.

**"What's the actual D365 integration architecture?"**
> Supabase Edge Functions proxy to D365 OData endpoints. Outbound: yield records auto-queue and push to D365 inventory journals. Inbound: sales orders and production orders pull from D365 on demand.

**"How do you handle a crop failure or rejected batch?"**
> Grade it as 'reject' in yield management. It still syncs to D365 so inventory accounting is accurate. The yield-by-grade donut on the dashboard makes it immediately visible.

**"What if D365 sync fails?"**
> Failed items stay in the queue with a retry button and error details. The 'Failed' KPI on the integration page turns red. Nothing is silently lost.
