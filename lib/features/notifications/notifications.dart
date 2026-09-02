/// Public surface of the notifications feature. Import this instead of reaching into
/// api/ or presentation/, so the internal layout can change without touching
/// call sites. Dart equivalent of a JS `index.js` barrel.
library;

export 'api/notification_api.dart';
export 'presentation/notifications_screen.dart';
