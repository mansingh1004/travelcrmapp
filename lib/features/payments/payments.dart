/// Public surface of the payments feature. Import this instead of reaching into
/// api/ or presentation/, so the internal layout can change without touching
/// call sites. Dart equivalent of a JS `index.js` barrel.
library;

export 'api/payment_api.dart';
export 'presentation/payments_screen.dart';
