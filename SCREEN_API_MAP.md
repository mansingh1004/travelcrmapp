# SCREEN_API_MAP.md

Every screen mapped to the endpoints it calls. All 25 are **live against the real
backend** — see [API_CONTRACT.md](API_CONTRACT.md) for the shapes and
[API_GAPS.md](API_GAPS.md) for what is deliberately narrower than the brief.

| # | Screen | Endpoints |
|---|---|---|
| 1 | Login | `POST /api/auth/user/login` |
| 2 | Dashboard | `GET /api/leads/stats/summary` · `GET /api/leads?followUpDueBy=…&activeOnly=true` |
| 3 | Leads list | `GET /api/leads` (search/stage/type/date/activeOnly/followUpDueBy) · `GET /api/leads/stats/summary` for tab counts |
| 4 | Create lead (5 steps) | `POST /api/leads` · `GET /api/leads/meta/sources` · `GET /api/leads/assignment/recommendation` · `POST /api/leads/{id}/logs` for the first follow-up |
| 5 | Lead detail | `GET /api/leads/{id}` · `GET /api/leads/{id}/logs` · `PATCH /api/leads/{id}/stage` |
| 6 | Log follow-up sheet | `POST /api/leads/{id}/logs` |
| 7 | Customers list | `GET /api/customers` · `GET /api/customers/stats` |
| 8 | Customer 360 | `GET /api/customers/{id}/summary` · `GET /api/customers/{id}` |
| 9 | Quotations list | `GET /api/quotations` (search + stage) |
| 10 | Quotation preview | `GET /api/quotations/{id}` · `PATCH /{id}/stage` · `GET /{id}/share-link` · `POST /{id}/send-whatsapp` · `/send-email` |
| 11 | Itinerary | rendered inside lead detail and quotation preview |
| 12 | Bookings list | `GET /api/bookings` · `/filter` · `/search` · `/stats` |
| 13 | Booking detail | `GET /api/bookings/{id}` · `/{id}/services` · `PATCH /{id}/status` |
| 14 | Operations board | `GET /api/operations/board` · `/tab-counts` · `/summary` |
| 15 | Operations detail | `GET /api/operations/bookings/{id}/checkpoints` · `PUT /api/operations/checkpoints/{id}` |
| 16 | Calendar | `GET /api/calendar` · `GET /api/calendar/summary` |
| 17 | Inbox | `GET /api/communication/conversations` |
| 18 | Chat | `GET /api/communication/conversations/{id}/messages` · `POST /api/communication/messages/whatsapp` · `/conversations/{id}/notes` · `PUT /{id}/read` |
| 19 | Payments | `GET /api/bookings` (for `pendingAmount`) · `GET /api/bookings/stats` · `GET`/`POST /api/bookings/{id}/payments` |
| 20 | Notifications | `GET /api/notifications` · `/unread-count` · `PUT /{id}/read` · `/read-all` |
| 21 | Reports | `GET /api/dashboard/analytics?period=` |
| 22 | Masters | `GET /api/hotels` · `/api/vehicles` · `/api/sightseeings` · `/api/vendors` |
| 23 | Profile | `GET`/`PUT /api/me/profile` · `GET /api/company` |
| 24 | Settings | `GET /api/company` · `POST /api/auth/change-password` |
| 25 | Global search | `GET /api/search` |

---

## Screens that assemble from more than one source

**Payments (19).** The server has no global payments collection — money lives
under bookings. So the receivable list is the bookings whose server-computed
`pendingAmount` is above zero, sorted by travel date (that is when the money
actually has to land), and the summary card is `GET /api/bookings/stats`. Nothing
is summed client-side.

**Dashboard (2).** Counts and money come from `/api/leads/stats/summary`, which
aggregates in the database over the caller's row scope — not from counting the
rows that happen to be loaded. The follow-up queue is a second, filtered
`/api/leads` call.

**Reports (21).** One endpoint backs the whole screen. Profit fields are
permission-gated and arrive null without `BOOKING_PROFIT_READ`; the profit card
is then replaced rather than shown as ₹0.

---

## Permission-dependent screens

These call an endpoint a lower-privileged role cannot reach. A 403 maps to
`PermissionFailure`, and the screen hides that section or explains itself — it
never offers a retry that cannot succeed, and never renders a permission gap as
a zero.

| Screen | Needs | Without it |
|---|---|---|
| Reports | `CRM_FULL` | "Reports are restricted" |
| Customers stat tabs | `CRM_FULL` | tabs render without counts |
| Bookings / Payments summary | `CRM_FULL` | summary card omitted |
| Masters → Vendors | `VENDOR_READ` | that tab explains itself; other tabs work |
| Inbox | `COMM_READ` | "Inbox is restricted" |
| Booking profit, Reports profit | `BOOKING_PROFIT_READ` | profit figures omitted, not zeroed |

---

## Deep links between screens

- Lead → Booking, via `convertedBookingPublicId`
- Booking → Customer and → originating Lead
- Operations → Booking
- Calendar event → Booking or Lead, by `referenceType` + `referencePublicId`
- Notification → Lead / Booking / Customer, same mechanism
- Global search hit → Lead detail (other record types report that they have no
  screen rather than silently doing nothing)
