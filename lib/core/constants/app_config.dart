/// Build-time configuration, supplied with `--dart-define`.
///
/// Nothing here is a secret: the backend expects no API key, and the only
/// credential in play is the user's own JWT, which lives in secure storage.
abstract final class AppConfig {
  /// Root of the Spring Boot server. Defaults to the Android emulator's alias
  /// for the host machine, since the backend binds `localhost:8080`
  /// (`application.properties:5`).
  ///
  /// ```
  /// flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
  /// ```
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);
  static const sendTimeout = Duration(seconds: 20);

  /// `GET /api/leads` page size. The backend defaults to 10.
  static const pageSize = 20;

  /// Verbose request/response logging. Off in release regardless.
  static const enableNetworkLogs = bool.fromEnvironment(
    'ENABLE_NETWORK_LOGS',
    defaultValue: true,
  );

  // ── Secure-storage / prefs keys ────────────────────────────────────────
  static const kAuthToken = 'auth_token';
  static const kLastRoute = 'last_route';
  static const kLandingScreen = 'landing_screen';
}
