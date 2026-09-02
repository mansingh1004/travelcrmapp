/// Public surface of the calendar feature. Import this instead of reaching into
/// api/ or presentation/, so the internal layout can change without touching
/// call sites. Dart equivalent of a JS `index.js` barrel.
library;

export 'api/calendar_api.dart';
export 'presentation/calendar_screen.dart';
