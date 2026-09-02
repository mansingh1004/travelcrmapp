import 'dart:convert';

/// Minimal JWT reader.
///
/// The app needs this because `POST /api/auth/login` returns **only the raw
/// token** — there is no `/auth/me` and the login response carries no user
/// object (`API_CONTRACT.md` §4.1). The token's `sub` claim is therefore the
/// only identity the client can ever show.
///
/// It also has to check `exp` locally: the backend permits every request
/// regardless of token (`API_GAPS.md` **G-05**), so an expired session would
/// otherwise never be detected.
///
/// This only *reads* the payload. It does not and cannot verify the HS256
/// signature — the secret lives on the server.
abstract final class Jwt {
  /// Decoded payload claims, or `null` if [token] is not a well-formed JWT.
  static Map<String, dynamic>? payload(String? token) {
    if (token == null || token.isEmpty) return null;
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final normalised = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalised));
      final json = jsonDecode(decoded);
      return json is Map<String, dynamic> ? json : null;
    } catch (_) {
      return null;
    }
  }

  /// The `sub` claim — the user's email, which is all the backend puts in.
  static String? subject(String? token) => payload(token)?['sub'] as String?;

  /// Expiry instant, or `null` when the token has no `exp`.
  static DateTime? expiry(String? token) {
    final exp = payload(token)?['exp'];
    if (exp is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
  }

  /// Issue instant.
  static DateTime? issuedAt(String? token) {
    final iat = payload(token)?['iat'];
    if (iat is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(iat * 1000);
  }

  /// True when the token is absent, malformed, or past `exp`.
  ///
  /// [leeway] guards against a request that is in flight when the token lapses.
  static bool isExpired(String? token, {Duration leeway = const Duration(seconds: 30)}) {
    final exp = expiry(token);
    if (exp == null) return true;
    return DateTime.now().add(leeway).isAfter(exp);
  }

  /// True when the token parses and has not expired.
  static bool isValid(String? token) => payload(token) != null && !isExpired(token);
}
