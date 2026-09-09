/// Public surface of the leads feature.
///
/// Import this file from outside the feature rather than reaching into
/// api/, presentation/ or providers/, so the internal layout can change
/// without touching call sites. The Dart equivalent of a JS `index.js`.
library;

export 'presentation/lead_create_screen.dart';
export 'presentation/lead_detail_screen.dart';
export 'presentation/lead_edit_screen.dart';
export 'presentation/leads_screen.dart';
export 'providers/lead_detail_provider.dart';
export 'providers/leads_controller.dart';
export 'presentation/widgets/lead_card.dart';
