/// Public surface of the inbox feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'presentation/chat_screen.dart';
export 'presentation/inbox_screen.dart';
