# requesT — Design & Brand Identity

> Pronounced **"requestee"**

## 1. Brand Personality

requesT sits at the intersection of **urgency** and **trust**. A user
opens this app when something is broken, needed, or time-sensitive —
the tone should feel calm, capable, and direct, never gimmicky.

Three words: **Direct. Dependable. Fast.**

Think of the emotional arc: *"I have a problem"* → *"I've been heard
and matched"* → *"It's handled."* The design should visually reinforce
that arc — friction at the start dissolving into clarity and
confirmation.

## 2. Naming & Wordmark

- App name: **requesT**
- Stylization: lowercase "request" with a **capital T** — this is the
  single most distinctive brand element. The capital T should be
  treated as a small logomark opportunity (e.g. the T's crossbar can
  double as a pin/marker glyph, a checkmark stroke, or a location pin
  silhouette in the icon-only lockup).
- Always pronounced "requestee" — consider a tagline or first-run
  moment that teaches this ("request → requesT → say it: 'requestee'")
  since the silent capitalization isn't self-explanatory from text alone.

## 3. Color Palette

The palette needs two moods: **urgency/action** (for the "I have a
problem" moment) and **trust/calm** (for ratings, verified shops,
completed jobs). Avoid a palette that's *only* alarm-red — that would
make the whole app feel like a crisis tool.

| Role | Color | Hex | Usage |
|---|---|---|---|
| Primary (Action) | Signal Coral | `#FF5A47` | CTA buttons, "Post a request," active states |
| Primary Dark | Ember | `#D6402F` | Pressed states, hover on primary |
| Trust / Verified | Deep Teal | `#0F6B5C` | Verified badges, ratings, completed status |
| Trust Light | Mint Wash | `#DFF3EE` | Backgrounds behind trust signals, success toasts |
| Neutral Ink | Charcoal | `#1C1E21` | Primary text |
| Neutral Mid | Slate | `#6B7280` | Secondary text, metadata (distance, time) |
| Neutral Bg | Paper | `#F7F6F3` | App background — warm off-white, not clinical white |
| Surface | White | `#FFFFFF` | Cards, sheets |
| Alert / Urgent | Amber | `#F2A93B` | Urgency tags ("Same-day," "Emergency") |
| Divider | Mist | `#E7E5E1` | Borders, separators |

**Rationale:** Coral carries urgency without the stop-sign aggression
of pure red. Teal is the counterweight — it's the color of "resolved"
and "verified," so a user should start a flow in coral and land on
teal when a job is booked/completed.

## 4. Dark Theme

Dark mode is a required surface, not an optional palette swap. Signal
Coral at full saturation vibrates uncomfortably against near-black
backgrounds, so the dark palette desaturates and slightly lightens
the accent colors rather than reusing the light-mode hex values
directly.

| Role | Color | Hex | Usage |
|---|---|---|---|
| Primary (Action) | Coral Glow | `#FF7A68` | CTA buttons, "Post a request," active states |
| Primary Dark | Ember Deep | `#E0503D` | Pressed states, hover on primary |
| Trust / Verified | Teal Glow | `#3FA98D` | Verified badges, ratings, completed status |
| Trust Surface | Teal Wash | `#123A32` | Backgrounds behind trust signals, success toasts |
| Neutral Ink | Off-White | `#F2F1EE` | Primary text |
| Neutral Mid | Fog | `#9CA3AF` | Secondary text, metadata (distance, time) |
| Neutral Bg | Near-Black | `#121314` | App background |
| Surface | Charcoal Panel | `#1C1E21` | Cards, sheets |
| Surface Raised | Slate Panel | `#26282C` | Elevated cards, modals |
| Alert / Urgent | Amber Glow | `#F5BE63` | Urgency tags ("Same-day," "Emergency") |
| Divider | Iron | `#33353A` | Borders, separators |

**Dark mode principles:**

- **Desaturate, then lighten:** Every accent color (coral, teal,
  amber) gets a lighter, slightly less saturated variant for dark
  backgrounds — this keeps contrast comfortable (WCAG AA minimum
  against Near-Black) without the neon effect of using light-mode
  hex values as-is.
- **No pure black:** Background is `#121314`, not `#000000` — pure
  black next to Coral Glow creates excessive contrast and eye strain
  during quick glance usage.
- **Elevation via lightness, not shadow:** Since shadows barely read
  on dark backgrounds, elevate surfaces (cards, modals, sheets) with
  progressively lighter panel colors (`#1C1E21` → `#26282C`) instead
  of relying on drop shadows.
- **Trust-teal stays legible:** Teal Glow (`#3FA98D`) is tuned to
  keep verified badges and ratings readable at small caption sizes on
  dark surfaces, where the light-mode Deep Teal would look muddy.
- **Images/icons:** Line icons switch from Charcoal stroke to
  Off-White stroke; illustrated category tiles get a dark-mode variant
  rather than just an opacity/invert filter, so they don't look washed
  out.
- **System-driven by default:** Theme should follow the OS-level
  light/dark setting on first launch, with a manual override
  available in settings.

## 5. Typography

- **Display / Headings:** A confident, slightly condensed geometric
  sans — e.g. **Aeonik** or **Space Grotesk** as an open-source
  fallback. Used for the wordmark, section headers, and the shop
  name in listings. Should feel modern and a little technical (this
  is a matching/logistics product, not a lifestyle app).
- **Body / UI text:** A highly legible humanist sans — e.g.
  **Inter**. Used for descriptions, form inputs, ratings text, and
  all functional copy. Prioritize legibility at small sizes since
  users will be scanning shop lists quickly, often one-handed,
  possibly mid-emergency.
- **Numerals:** Tabular figures for ratings, prices, and distances so
  they align cleanly in list/grid views.
- **Scale (suggested):**
  - H1 / App title: 28–32px, Semibold
  - H2 / Section: 20px, Semibold
  - Body: 15–16px, Regular
  - Caption / metadata: 13px, Medium, Slate color

## 6. Iconography & Imagery

- Icons: rounded-corner line icons, 2px stroke — friendly but precise,
  not playful/cartoonish. Category icons (plumbing, electronics,
  tailoring, auto, etc.) should be immediately scannable at a glance.
- The **capital-T pin motif** from the wordmark should recur as the
  app's location marker on maps — this ties the brand mark to the
  actual utility of the app (finding a nearby place).
- Avoid stock-photo-style shop imagery; prefer simple illustrated
  category tiles for the "what's your issue?" entry screen, so it
  doesn't feel like a directory app.

## 7. Motion & Animation

Motion should communicate the emotional arc from §1: **tension →
resolution**.

- **Posting a request:** A short, slightly elastic "send" animation —
  the request card compresses and launches outward (200–250ms,
  ease-out with a small overshoot). Signals "this is now moving."
- **Matching / searching state:** A radar-style pulse or expanding-ring
  animation centered on the user's location pin, using Signal Coral
  fading to transparent. Communicates active searching without a
  generic spinner.
- **Results appearing:** Staggered fade+slide-up for each shop card
  (60–80ms delay between cards), so results feel like they're
  arriving rather than dumping in all at once.
- **Verified/trust badge reveal:** A quick teal checkmark draw-on
  (150ms path animation) when a user taps into a shop's reputation
  detail — small moment of reassurance.
- **Booking confirmation:** Transition from coral to teal — literally
  animate the accent color of the confirmation screen shifting from
  Signal Coral to Deep Teal, reinforcing "urgent problem" →
  "resolved/trusted" as a *visual* transition, not just a state change.
- **General principle:** Keep durations short (150–300ms), use
  ease-out for anything appearing and ease-in for anything dismissing.
  Avoid bouncy/playful easing outside the two moments above — this
  isn't a social/entertainment app.

## 8. UI Surfaces & Layout Principles

- **Cards over lists:** Shop matches render as cards (photo/icon,
  name, rating, distance, urgency-fit tag, price band) rather than
  dense table rows — scanning speed matters more than density here.
- **Sticky context:** Once a user posts a request, keep a persistent
  compact summary of "what you asked for" visible while browsing
  matches, so they never lose the thread of their original issue.
- **Two clear CTAs per shop card:** "Book appointment" (teal-outline)
  and "Request on-site" (coral-filled) — visually distinct because
  they're functionally different commitments.
- **Empty/loading states should never feel dead:** use the radar-pulse
  motion (§7) rather than static spinners or blank screens.

## 9. Voice & Microcopy

- Short, plain-language, no jargon. "What's going on?" instead of
  "Submit service request."
- Confirmations should sound human and specific: "Booked with
  Al-Noor Electronics for 4:30 PM" rather than "Appointment
  confirmed."
- Urgency framing without alarmism: "Same-day available" rather than
  "URGENT!!"

