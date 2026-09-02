# TravelCRM — mobile app

A Flutter client for the TravelCRM backend: leads, quotations, bookings,
operations, payments and communication for travel agencies in India.

All 25 screens run against the real API. There is **no mock data in the app** —
fakes exist only in tests.

---

## Running it

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed / json_serializable
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

`10.0.2.2` is the Android emulator's alias for the host machine, which is where
the backend listens (`:8080`). On a physical device use the host's LAN address.

| Define | Default | Purpose |
|---|---|---|
| `API_BASE_URL` | `http://10.0.2.2:8080` | backend root |
| `ENABLE_NETWORK_LOGS` | `true` | request/response lines in `adb logcat`, tagged `[http]` |

Release build:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://your-host
```

### Signing in

Staff login is **username-keyed**, not email. The seeded demo users
(`DevDataSeeder`, tenant 1) are `tenant_admin`, `manager`, `travel_agent`,
`staff` and `accountant`, all with `Password@123`.

There is no self-registration and no forgot-password: accounts and resets are
handled by a tenant admin. Signed-in users can change their own password from
Settings.

---

## The backend

> The repo named in the original brief — `vetotech12345/travelcrmbackend` — is a
> **stale snapshot** (7 endpoints) whose `/api/auth/login` 404s on the live
> server. The backend actually running is a different, much larger codebase:
> Spring Boot 3.5.3, 35 controllers, multi-tenant.
>
> **No backend file was modified.** Both repositories are clean:
>
> ```
> $ git -C .../travelcrmbackend status --porcelain   # (nothing)
> $ git -C C:/travelcrmbackend status --porcelain    # (nothing)
> ```

Read [API_CONTRACT.md](API_CONTRACT.md) before touching the data layer — auth,
the two envelopes, the error `code` vocabulary and the house rules
(publicId-only, display-name enums, server-computed money) are all there.

---

## Architecture

```
lib/
  core/        theme tokens, icons, formatters (₹ lakh/crore, dd MMM yyyy), errors, di
  data/        dio client + interceptors, api services, dtos, mappers, repositories
  domain/      entities, repository interfaces
  features/<x>/presentation + providers
  widgets/     AppScaffold, StatusChip, SkeletonList, EmptyState, ErrorState, toasts
  router/      go_router config with an auth guard
```

Presentation never touches Dio. Screens read from a provider and render
`loading / empty / error / data`; every list has pull-to-refresh and pagination
where the endpoint pages.

**The layering is not uniform, on purpose.** Modules with mutations and enum
vocabularies (leads, customers, bookings, quotations, operations) get the full
stack, because the mapper is what stops one malformed row from blanking a page
and the repository interface is what makes the screens testable. Read-only
modules (calendar, payments ledger, masters, notifications, reports, company)
stop at the API class — an entity and mapper there would be indirection with
nothing to absorb.

### Design system

Plus Jakarta Sans and IBM Plex Mono are **bundled** (`assets/fonts/`). They are
deliberately not loaded through `google_fonts`: that package fetches faces over
HTTP on first paint, which hangs the UI thread on an offline device.

Charts use a separate categorical palette
([chart_colors.dart](lib/core/constants/chart_colors.dart)) validated for
colourblind separation and contrast — the brand accents fail that check
(`purple` beside `primary` is ΔE 0.4 under deuteranopia). Status colours are
reserved for status and never reused as chart series.

---

## Checks

```bash
flutter analyze   # 0 issues
flutter test      # 42 passing
```

Tests cover the envelope parsers, the failure mapper, the lead mapper and
formatters, plus widget tests for the leads screen's loading, empty, error and
server-side-filter behaviour.

---

## Documents

| File | Contents |
|---|---|
| [API_CONTRACT.md](API_CONTRACT.md) | auth, envelopes, error codes, house rules, endpoints in use |
| [SCREEN_API_MAP.md](SCREEN_API_MAP.md) | each of the 25 screens → its endpoints |
| [API_GAPS.md](API_GAPS.md) | what is deliberately not built, and why; client bugs found and fixed |
