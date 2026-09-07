/// Public surface of the calendar feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'api/calendar_api.dart';
export 'presentation/calendar_screen.dart';
export 'providers/calendar_controller.dart';
