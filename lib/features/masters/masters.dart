/// Public surface of the masters feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'api/masters_api.dart';
export 'presentation/geography_screen.dart';
export 'presentation/masters_screen.dart';
export 'presentation/widgets/form_fields.dart';
export 'presentation/widgets/geography_providers.dart';
