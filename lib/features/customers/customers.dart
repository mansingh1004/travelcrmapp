/// Public surface of the customers feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'presentation/customer_detail_screen.dart';
export 'presentation/customers_screen.dart';
export 'providers/customers_controller.dart';
