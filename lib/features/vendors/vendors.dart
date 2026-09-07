/// Public surface of the vendors feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'api/vendor_api.dart';
export 'presentation/vendor_detail_screen.dart';
export 'presentation/vendors_screen.dart';
