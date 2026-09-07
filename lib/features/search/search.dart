/// Public surface of the search feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'api/search_api.dart';
export 'presentation/search_screen.dart';
