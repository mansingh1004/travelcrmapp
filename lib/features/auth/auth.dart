/// Public surface of the auth feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'presentation/login_screen.dart';
export 'presentation/splash_screen.dart';
export 'providers/auth_controller.dart';
