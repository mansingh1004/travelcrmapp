/// Public surface of the reports feature. Import this instead of reaching into
/// api/ or presentation/, so the internal layout can change without touching
/// call sites. Dart equivalent of a JS `index.js` barrel.
library;

export 'api/reports_api.dart';
export 'presentation/reports_screen.dart';
