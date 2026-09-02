# API_CONTRACT.md

The API surface this app consumes, read from the **running** backend's source.

> ### Which backend
>
> The GitHub repo named in the brief — `vetotech12345/travelcrmbackend` @ `f6f825d` —
> is a **stale snapshot**: 2 controllers, 7 endpoints, auth + leads only. Its
> `/api/auth/login` returns **404** on the live server.
>
> The backend actually running on `:8080` is **`C:\travelcrmbackend`** — Spring Boot
> 3.5.3, ~457 Java files, **35 controllers**, a multi-tenant SaaS. It was found from
> the running JVM's `-classpath`. This document describes **that** server. Neither
> repository was modified.

- **Stack:** Spring Boot 3.5.3 · Java 21 · PostgreSQL · JWT (HS256) · multi-tenant
- **Base URL (dev):** `http://localhost:8080`, reached from the Android emulator as
  `http://10.0.2.2:8080` ([app_config.dart](lib/core/constants/app_config.dart))

---

## 1. Authentication

| Aspect | Reality |
|---|---|
| Staff login | `POST /api/auth/user/login` — **not** `/api/auth/login` |
| Identifier | **username**, not email. `LoginRequestDTO.getLoginIdentifier()` resolves against the `username` column only; a real email address authenticates no one. The legacy `email` field is accepted as an alias for the same value. |
| Response | A **bare** `LoginResponseDTO` — no `ApiResponse` envelope |
| JWT claims | `sub` = username, `role`, `tenantId`, `tv` (token version). 24 h. |
| Refresh | **None.** Expiry is detected client-side from `exp`; the only recovery is to sign in again. |
| Enforcement | Real. `JwtAuthFilter` runs, `anyRequest().authenticated()`, and `@PreAuthorize` gates almost every endpoint. |
| Self-registration | **None.** Accounts are created by an admin via `POST /api/users`. |
| Forgot password | **None.** Only the authenticated `POST /api/auth/change-password`. |

```jsonc
// POST /api/auth/user/login  { "username": "...", "password": "..." }
{
  "name": "Demo Admin", "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiJ9...", "tokenType": "Bearer",
  "id": "e1842c0d-…", "email": "org@demo.crm", "username": "tenant_admin",
  "role": "TENANT_ADMIN", "mfaRequired": false, "mustChangePassword": false
}
```

**permitAll whitelist** (everything else needs a Bearer token): `OPTIONS /**` ·
`/api/auth/**` · `POST /api/webhooks/**` · `GET /api/public/**` ·
`GET /api/notifications/stream` · `GET /actuator/health`.

**Demo credentials** (`DevDataSeeder.java:170`, tenant 1): `tenant_admin`,
`manager`, `travel_agent`, `staff`, `accountant` — all `Password@123`.

---

## 2. Envelopes

**A. `ApiResponse<T>`** — single objects and unpaged lists:

```jsonc
{ "success": true, "message": "…", "data": {…}, "errors": null,
  "statusCode": 200, "timestamp": "2026-08-31T12:00:00" }
```

**B. `PagedApiResponse<T>`** — every paged list. `data` is a **flat array**, with
paging in a sibling object (not a nested Spring `Page`):

```jsonc
{ "success": true, "message": "…", "data": [ … ],
  "pagination": { "page": 0, "size": 20, "totalElements": 42, "totalPages": 3,
                  "first": true, "last": false, "hasNext": true,
                  "hasPrevious": false, "sortBy": "createdAt", "sortDir": "desc" },
  "timestamp": "…" }
```

**C. Bare DTO** — the three login endpoints only.

`@JsonInclude(NON_NULL)` throughout: an absent key means null, and for
permission-gated fields it means *not permitted to see* — which is not zero.

---

## 3. Errors

One shape for every non-2xx, from `GlobalExceptionHandler` and the security
handlers alike:

```jsonc
{ "success": false, "status": 403, "code": "PERMISSION_DENIED",
  "message": "…", "fieldErrors": { "phone": "…" },
  "traceId": "fbbe942b3840", "timestamp": "…" }
```

Clients branch on `code`, never on `message`:

| `code` | HTTP | Client behaviour |
|---|---|---|
| `VALIDATION_ERROR` | 400 | field errors arrive **structured** in `fieldErrors` |
| `BAD_REQUEST`, `MALFORMED_REQUEST` | 400 | show `message` |
| `UNAUTHENTICATED` | 401 | clear token, route to Login |
| `PERMISSION_DENIED` | 403 | **hide the section** — signing in again cannot fix it |
| `MODULE_NOT_ENABLED` | 403 | the tenant's plan lacks the module |
| `NOT_FOUND` | 404 | empty state |
| `CONFLICT`, `DUPLICATE_RESOURCE` | 409 | show `message` |
| `RATE_LIMITED` | 429 | back off; `Retry-After` in seconds |
| `INTERNAL_ERROR` | 500 | retry offered |
| `MAINTENANCE` | 503 | retry offered |

Mapped in [failure_mapper.dart](lib/data/remote/failure_mapper.dart) onto the
sealed `Failure` type.

---

## 4. House rules

1. **`publicId` (UUID) only.** Internal `Long` ids never cross the API. Every
   detail route and every mutation is keyed by publicId.
2. **Enums serialise as display names** where the DTO has `@JsonValue` —
   `"New Lead"`, `"Google Ads"`, `"Flight / Airport"`. `@JsonCreator` accepts
   either form case-insensitively on write. Booking, operations and notification
   enums have **no** `@JsonValue` and use constant names. Each Dart enum records
   which it is.
3. **Money is server-computed.** GST, TCS, `totalPayable`, `pendingAmount`,
   `netProfit`, quotation discount/markup/tax — all derived server-side and
   **rejected if sent in a request**. The app formats; it never calculates.
4. **Derived-at-read fields.** Ops severity, readiness and `readyToTravel` are
   computed against the **tenant's** clock at read time. After a mutation the app
   re-reads rather than patching locally, so a device clock cannot mislabel one.
5. **Soft delete** everywhere, with `/api/trash` to restore.
6. **Permissions are per-endpoint** `@PreAuthorize` keys. A 403 is a normal
   outcome for a lower-privileged role, not an error.

---

## 5. Endpoints in use

### Auth & identity
| Method | Path | Permission |
|---|---|---|
| POST | `/api/auth/user/login` | — |
| POST | `/api/auth/change-password` | authenticated |
| GET · PUT | `/api/me/profile` | authenticated |
| GET | `/api/company` | authenticated |

### Leads
| Method | Path | Permission |
|---|---|---|
| GET | `/api/leads` | `LEAD_READ` |
| GET | `/api/leads/{publicId}` | `LEAD_READ` |
| POST | `/api/leads` | `LEAD_CREATE` |
| PUT | `/api/leads/{publicId}` | `LEAD_UPDATE` |
| PATCH | `/api/leads/{publicId}/stage` | `LEAD_UPDATE` |
| DELETE | `/api/leads/{publicId}` | `LEAD_DELETE` |
| GET · POST | `/api/leads/{publicId}/logs` | `LEAD_READ` / `LEAD_UPDATE` |
| GET | `/api/leads/stats/summary` | `LEAD_READ` |
| GET | `/api/leads/meta/sources` | `LEAD_READ`/`CREATE`/`UPDATE` |
| GET | `/api/leads/assignment/recommendation` | `LEAD_CREATE` |

`GET /api/leads` filters **in the database**: `search`, `stage`, `leadType`,
`fromDate`, `toDate`, `activeOnly`, `followUpDueBy`, plus `page`/`size`/`sortBy`/
`sortDir`. `sortBy` is whitelisted — `createdAt`, `updatedAt`, `customerName`,
`leadCode`, `travelDate`, `followUpDate`, `budget`, `leadStage`, `leadType`.
Never send `stage=Active`; use `activeOnly=true`.

`assignedUserId` (UUID) is **required** on create.

### Customers · Bookings · Quotations
| Method | Path | Permission |
|---|---|---|
| GET | `/api/customers` · `/{id}` · `/{id}/summary` · `/stats` | `CUSTOMER_READ`, stats `CRM_FULL` |
| GET | `/api/bookings` · `/{id}` · `/filter` · `/search` · `/stats` | `BOOKING_READ`, stats `CRM_FULL` |
| GET | `/api/bookings/{id}/services` · `/payments` | `BOOKING_READ` |
| POST | `/api/bookings/{id}/payments` | `BOOKING_READ` |
| PATCH | `/api/bookings/{id}/status` | `BOOKING_UPDATE` |
| GET | `/api/quotations` · `/{id}` · `/lead/{leadId}` · `/share-link` | `QUOTATION_READ` |
| PATCH | `/api/quotations/{id}/stage` | `QUOTATION_UPDATE` — stage is a **query param** |
| POST | `/api/quotations/{id}/send-whatsapp` · `/send-email` | `QUOTATION_UPDATE` |

`GET /api/bookings` **pages but takes no facets**; `/filter` and `/search` take
facets but are **unpaged**. The repository picks whichever fits and pages the
unpaged result itself.

### Operations · Calendar · Communication
| Method | Path | Permission |
|---|---|---|
| GET | `/api/operations/board` · `/tab-counts` · `/summary` | `BOOKING_READ` |
| GET | `/api/operations/bookings/{id}/checkpoints` | `BOOKING_READ` |
| PUT | `/api/operations/checkpoints/{id}` | `OPS_MANAGE` — **sparse** patch |
| GET | `/api/calendar` · `/summary` | `TASK_READ` / `CRM_FULL` |
| GET | `/api/communication/conversations` · `/{id}/messages` | `COMM_READ` |
| POST | `/api/communication/messages/whatsapp` · `/conversations/{id}/notes` | `COMM_SEND` |
| PUT | `/api/communication/conversations/{id}/read` | `COMM_READ` |

`GET /api/calendar` takes **ISO-8601 instants** for `from`/`to`, not the
`yyyy-MM-dd` everything else uses, and returns UTC instants that must be
converted to local. A bare date is silently ignored and the window falls back to
the current month.

WhatsApp free text is only accepted while the conversation's 24-hour window is
open (`freeTextAllowed`); outside it the server requires an approved template.

### Reports · Search · Notifications · Masters
| Method | Path | Permission |
|---|---|---|
| GET | `/api/dashboard/analytics?period=` | `CRM_FULL` |
| GET | `/api/search?q=&limit=` | authenticated; per-type inside |
| GET · PUT | `/api/notifications` · `/{id}/read` · `/read-all` | authenticated |
| GET | `/api/notifications/unread-count` | authenticated |
| GET | `/api/hotels` · `/api/vehicles` · `/api/sightseeings` | authenticated |
| GET | `/api/vendors` | `VENDOR_READ` |

`GET /api/search` always returns **200 with a list** — a query under two
characters comes back empty, and a caller lacking every read permission gets an
empty list rather than a 403.

---

## 6. Rate limits

In-memory fixed-window, per app instance. Login 50/min per IP; `GET /api/search`
120/min per user. A 429 carries `Retry-After` in seconds.

---

## 7. Where the full contract lives

The complete extraction — every endpoint, query param, request field, response
field and enum for all 35 controllers — was produced by 14 parallel readers over
the running backend's source and is saved as one JSON file per module:

```
<session scratchpad>/api_{auth-me-users, lead, customer, booking-core,
  booking-payments, quotation, operations, calendar-reminders-tasks,
  communication, notifications, masters-vendors, reports-dashboard,
  company-settings, common-search-trash}.json
```

See [SCREEN_API_MAP.md](SCREEN_API_MAP.md) for screen → endpoint, and
[API_GAPS.md](API_GAPS.md) for what is deliberately not built.
