/// Public surface of the operations feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'presentation/operations_detail_screen.dart';
export 'presentation/operations_screen.dart';
export 'providers/operations_controller.dart';
