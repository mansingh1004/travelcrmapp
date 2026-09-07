# TravelCRM mobile — working notes

Flutter client for the TravelCRM backend. Production API is
`https://api.mytripsafar.com`; the same server also serves the React console at
`mytripsafar.com`. **The backend is read-only from here — never change it.**

## Where code goes

```
lib/
  core/       theme, icons, formatters, constants, errors, di.dart
  data/       dto/ mappers/ remote/ repositories/ services/
  domain/     entities/ repositories/
  features/   one folder per feature
  router/     routes + go_router config
  widgets/    widgets shared across features
```

### Every feature is a folder with a barrel

```
lib/features/<name>/
  <name>.dart          barrel — the feature's public surface
  api/                 API class, when it belongs to this feature (see below)
  presentation/        screens, and widgets/ under it
  providers/           Riverpod notifiers and providers
```

**Import a feature only through its barrel.** `import '../../leads/leads.dart';`
— never `../../leads/providers/leads_controller.dart`. The barrel is what lets
the inside move without breaking call sites, and `app_router.dart` and
`core/di.dart` both go through it. A file the barrel does not export is private
to the feature; if another feature needs it, add the export deliberately rather
than reaching past it.

Inside a feature, relative imports are fine and expected.

### Which API classes live in a feature, and which don't

Both locations are correct — the rule is who consumes the class:

* **`features/<name>/api/`** when only that feature's own screens use it.
  calendar, masters, notifications, payments, reminders, reports, search,
  vendors.
* **`lib/data/services/`** when `lib/data/repositories/` consumes it — auth,
  booking, customer, lead, operations, quotation — or when two features share
  it (`company_api` for profile+settings, `task_api` for calendar+leads).

Moving the repository-backed ones into features would make the data layer
import the feature layer and invert the `features → data → domain/core`
dependency direction. Leave them where they are.

### Layering is deliberately non-uniform

Modules with mutations and enum vocabularies (leads, customers, bookings,
quotations, operations) get entity + mapper + repository. Read-only ones
(calendar, payments ledger, masters, notifications, reports, company/profile,
communication) stop at the API class with inline models. This is a decision,
not an inconsistency — don't "fix" it by adding empty repository layers.

### Shared state does not live in screen files

A provider read by more than one feature belongs in that feature's
`providers/`, exported from the barrel — see `features/profile/providers/`.

## Building

Base URL is a compile-time constant, so release builds must pass it:

```
flutter build apk --release --split-per-abi \
  --dart-define=API_BASE_URL=https://api.mytripsafar.com
```

Forget the `--dart-define` and the app silently falls back to
`http://10.0.2.2:8080`, the emulator's alias for the host — it builds fine and
then fails on every real device. Debug builds want that default, which is why
cleartext HTTP is enabled only in `android/app/src/debug/AndroidManifest.xml`.

Release signing reads `android/key.properties` (gitignored). Without it the
build falls back to debug keys, and such an APK will not install over a
properly signed one.

## Before committing

`flutter analyze` clean and `flutter test` green. Endpoint behaviour has bitten
this project repeatedly — probe a new endpoint with curl before trusting a
field name, and add the captured payload under `test/_live/`.

## Stack pins

Riverpod 3 (hand-written Notifier/AsyncNotifier — no riverpod_generator;
`StateProvider` and `valueOrNull` do not exist), freezed 3 (classes need
`abstract`), flutter_secure_storage 11, Dio 5. Fonts are bundled in
`assets/fonts/` on purpose: `google_fonts` fetches over HTTP on first paint and
ANRs on an offline device.
