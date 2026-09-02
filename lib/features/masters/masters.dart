/// Public surface of the masters feature.
///
/// Import this file rather than reaching into the folder's subdirectories, so
/// the internal layout (api/, presentation/, widgets/) can move without
/// touching every call site. This is the Dart equivalent of a JS `index.js`
/// barrel: only what is exported here is meant to be used from outside.
library;

export 'api/masters_api.dart';
export 'presentation/geography_screen.dart';
export 'presentation/masters_screen.dart';
