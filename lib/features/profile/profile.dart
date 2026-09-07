/// Public surface of the profile feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'presentation/profile_screen.dart';
export 'providers/profile_providers.dart';
