/// Public surface of the reports feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'api/reports_api.dart';
export 'presentation/reports_screen.dart';
