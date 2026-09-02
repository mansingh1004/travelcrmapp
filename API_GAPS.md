# API_GAPS.md

Where the app is deliberately narrower than the brief, and why. **No backend file
was changed** — both repositories are clean (verified with `git status`); every
item below is handled on the client.

---

## A · The brief named the wrong backend

The brief pointed at `github.com/vetotech12345/travelcrmbackend`. That repo has
**2 controllers and 7 endpoints** — auth and leads only.

Building against it produced an app whose login 404'd. Probing the live server
showed the whole `/api/auth/**` tree missing, and the running JVM's `-classpath`
pointed at **`C:\travelcrmbackend`** — a different, far larger codebase: Spring
Boot 3.5.3, ~457 Java files, 35 controllers.

Everything was rebuilt against the running server. The consequences of that
switch, all now handled:

| Assumption from the stale repo | Reality |
|---|---|
| `POST /api/auth/login`, email-keyed | `POST /api/auth/user/login`, **username**-keyed |
| Login returns a raw JWT as `text/plain` | Returns a bare `LoginResponseDTO` JSON |
| JWT has only `sub`/`iat`/`exp` | Also `role`, `tenantId`, `tv` |
| Auth not enforced (`permitAll`) | Fully enforced, with `@PreAuthorize` per endpoint |
| `Long` ids | **`publicId` UUIDs only** |
| Spring `Page` (`content`, `number`, …) | `PagedApiResponse` — flat `data[]` + sibling `pagination` |
| `LeadStage` has 6 values | 8, including Follow Up and Qualified |
| No filtering on `/api/leads` | 7 filters, all applied in the database |
| Self-registration + forgot-password | Neither exists — admin-managed |

## B · Features the brief describes that this app does not build

Not because the backend lacks them, but because they are large surfaces better
suited to the web console.

| Brief | Status | Why |
|---|---|---|
| **Quotation builder** — 11 service blocks, pricing engine, policy editors | Not built. Existing quotations are viewable and sendable. | The create/update payload is ~40 nested fields across six service arrays. On a phone this is a form nobody completes; the pricing block is also server-computed, so a partial builder would produce quotations the server would reject. |
| **Itinerary builder** — drag-reorder day cards, per-day hotel/vehicle/activity rows | Not built. Itineraries are **rendered** on lead detail and quotation preview. | Same reason: it is a desktop editing surface. Reading one on a phone is useful; authoring one is not. |
| **Settings editing** — branding, tax rates, WhatsApp templates, branches & users | Read-only. Settings names each area and where it is managed. | All need `SETTINGS_MANAGE` plus file uploads and template editors. The one change any user can make — their own password — **is** built. |
| **Guided demo mode** | Not built. | It would have to drive real screens against real data; with live tenant data it would create real leads and send real WhatsApp messages. |

## C · Things the server does that the client must respect

Not gaps — behaviours that shaped the implementation.

1. **WhatsApp's 24-hour window.** Free text is only accepted while
   `freeTextAllowed` is true. Outside it the server requires an approved
   template, which this app does not compose — so the composer is **disabled
   with an explanation**, rather than letting the send fail.
2. **Money is never computed here.** GST, TCS, `totalPayable`, `pendingAmount`,
   `netProfit` and every quotation total are server-derived and rejected if sent.
   The balance shown is `pendingAmount`, never `total − paid` — adjustments and
   refunds feed it too.
3. **Permission-gated fields arrive null.** Profit figures without
   `BOOKING_PROFIT_READ` are absent, not zero. The UI **omits the card**; showing
   ₹0 would be a false statement.
4. **Ops severity is derived at read time** against the tenant's clock. After any
   checkpoint change the app re-reads instead of patching locally, so a wrong
   device clock cannot mislabel a departure as urgent.
5. **Bookings paging and filtering are different endpoints.** `/api/bookings`
   pages without facets; `/filter` and `/search` take facets unpaged. The
   repository picks whichever fits and pages the unpaged result itself.
6. **Calendar uses ISO instants**, not `yyyy-MM-dd`, and returns UTC. A bare date
   is silently ignored server-side, so the client always sends instants and
   converts the response to local.
7. **`QuotationStage` has four values** — Draft / Sent / Approved / Rejected. The
   brief's eight-tab strip (Viewed, Negotiation, Expired) has no server
   equivalent, so four tabs are shown rather than four that could never fill.
8. **`PATCH /api/quotations/{id}/stage` takes the stage as a query param**, not a
   body — an easy thing to get wrong.

## D · Client-side defects found and fixed

Both were real bugs in this app, found by running it on a device.

| ID | Defect | Fix |
|---|---|---|
| **C-01** | `google_fonts` fetches its faces over HTTP on first paint. On a device without connectivity that blocked the UI thread and produced an **ANR** — an app cannot depend on the network to render its own typeface. | Fonts are **bundled** (`assets/fonts/`, 8 TTFs) and the package was removed. |
| **C-02** | `TokenStore.load()` cached a *failed* keystore read as "no token" (it set `_loaded = true` inside the catch). One transient failure — most visibly right after the OS killed the process under memory pressure — signed the user out for the rest of the session. | Only a **successful** read latches; a failure leaves the flag clear so the next request retries. |

## E · Things worth reporting to the backend team

Observations from reading the source. Nothing was changed.

1. **Committed credentials.** The stale GitHub repo's `application.properties`
   contains a live DB password, a Gmail app password and the JWT secret. Those
   should be rotated and moved to environment variables regardless of which repo
   is authoritative.
2. **Inconsistent paging contracts.** `GET /api/leads` is 0-based via
   `PagedApiResponse`; `GET /api/leads/logs/summary` is **1-based** with
   `perPage`, and puts pagination *inside* `data`. Three different shapes for the
   same idea is a steady source of client bugs.
3. **`GET /api/bookings/filter` returns every match unpaged.** On a tenant with
   thousands of bookings that is a large response and a slow screen.
4. **`GET /api/notifications` has been seen returning both a flat list and a
   nested page.** The client accepts either, but one shape would be better.
5. **Vendor DTOs expose both `id` (Long) and `publicId` (UUID)**, against the
   codebase's own publicId-only rule.
