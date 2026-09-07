/// Public surface of the quotations feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'presentation/quotation_create_screen.dart';
export 'presentation/quotation_edit_screen.dart';
export 'presentation/quotation_preview_screen.dart';
export 'presentation/quotations_screen.dart';
export 'providers/quotations_controller.dart';
