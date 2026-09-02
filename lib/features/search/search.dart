/// Public surface of the search feature. Import this instead of reaching into
/// api/ or presentation/, so the internal layout can change without touching
/// call sites. Dart equivalent of a JS `index.js` barrel.
library;

export 'api/search_api.dart';
export 'presentation/search_screen.dart';
