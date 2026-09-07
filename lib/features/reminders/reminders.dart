/// Public surface of the reminders feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'api/booking_reminder_api.dart';
export 'api/reminder_api.dart';
export 'presentation/reminders_screen.dart';
