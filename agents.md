# requesT — Agents & Core Purpose

> Pronounced **"requestee"**

## 1. The Problem

When someone needs a task done — a plumbing repair, a phone screen fix, a
tailoring job, a car service — they're stuck doing manual, low-trust
discovery:

- Search engines return SEO-optimized listings, not reliable ones.
- Reviews are scattered across Maps, Facebook groups, word of mouth.
- There's no fast way to say "this is my problem" and get matched to
  someone who can actually solve it, nearby, with a track record.

**requesT inverts the model.** Instead of the user searching for a shop
category, the user describes their *issue*, and the system does the
matching.

## 2. Core Purpose

requesT is a **task-first, trust-first local services platform**. The
user posts what they need done in plain language. The app interprets
the request, crawls/matches against nearby verified shops and service
centres, and surfaces ranked options by reliability — not just proximity
or ad spend.

The core loop:

1. **Post** — user describes the issue (text, and optionally photo/voice).
2. **Match** — the system classifies the request and searches nearby
   shops/centres capable of resolving it.
3. **Evaluate** — user sees a ranked list with ratings, reputation
   signals, distance, and price range.
4. **Act** — user books an appointment at the shop, or requests a
   worker be dispatched to their location.
5. **Close the loop** — after completion, the user rates the experience,
   feeding back into the shop's reputation score for future matches.

## 3. Key Agents / System Roles

This section defines the logical "agents" (functional actors) in the
system — not necessarily literal AI agents, but the distinct
responsibilities the app must model.

### 3.1 Requester (User) Agent
- Submits an issue/request.
- Provides location, urgency, and preference (in-shop vs. on-site).
- Reviews matches, books, pays, and rates post-completion.

### 3.2 Intake / Classification Agent
- Parses the free-text (or voice/photo) request.
- Classifies it into a service category and urgency tier.
- Extracts structured signals (e.g. "leaking pipe under sink" →
  plumbing, urgent, likely on-site).
- Asks clarifying questions when the request is ambiguous.

### 3.3 Discovery / Matching Agent
- Crawls and maintains a database of nearby shops/centres/workers.
- Filters by category match, distance, availability, and price band.
- Ranks by a **reliability score**, not just proximity — see §4.

### 3.4 Reputation Agent
- Aggregates ratings, completion rates, response times, and dispute
  history per shop/worker.
- Detects anomalies (review bombing, fake ratings, sudden reputation
  drops) to keep trust signals honest.
- Recalculates scores continuously as new jobs complete.

### 3.5 Provider (Shop/Worker) Agent
- Receives incoming requests matched to their category and area.
- Accepts/declines, sets appointment slots, or dispatches a worker.
- Updates job status (accepted → in progress → completed).

### 3.6 Scheduling & Dispatch Agent
- Handles two fulfilment modes:
  - **In-shop appointment** — books a time slot at the shop.
  - **On-site dispatch** — sends a worker to the requester's location.
- Manages conflicts, rescheduling, and cancellations.

### 3.7 Trust & Safety Agent
- Verifies shop/worker identity and credentials before they're
  listed as matchable.
- Monitors for fraudulent listings or fake shops.
- Handles disputes between requester and provider.

## 4. What "Reliable" Means Here

The differentiator of requesT is that ranking is **not** just
distance + star rating. Ranking should weigh:

- Verified completion history (jobs actually finished, not just booked)
- Response time to new requests
- Consistency of ratings over time (not just average)
- Dispute/complaint rate
- Optional verification badges (licensed, background-checked, etc.)

## 5. MVP Scope

**In scope for v1:**
- Post an issue (text-based)
- Category auto-classification
- Nearby shop discovery with ratings
- In-shop appointment booking
- On-site worker request
- Post-job rating

**Explicitly out of scope for v1** (future consideration):
- In-app payments/escrow
- Live worker tracking (map/ETA)
- Multi-language voice intake
- Shop-side analytics dashboard

## 6. Open Questions

- How is a "shop" onboarded/verified in the first place — self
  sign-up, manual vetting, or partnership outreach?
- Is on-site dispatch fulfilled by the shop's own staff, or by an
  independent worker pool the app manages?
- What's the monetization model — commission per booking, subscription
  for shops, or lead-gen fee?
