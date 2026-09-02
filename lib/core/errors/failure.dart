import 'package:flutter/foundation.dart';

/// Typed failures. Every repository returns one of these instead of throwing,
/// so screens can render an error state without knowing about Dio.
///
/// The messages are written against the backend's real behaviour — including
/// the places where it returns the *wrong* status (`API_GAPS.md` § D), which is
/// why [ServerFailure] carries the raw status code.
@immutable
sealed class Failure {
  const Failure({required this.message, this.code, this.cause});

  /// User-facing, already phrased for display. Never a raw exception string.
  final String message;

  /// Shown in the error state's small print so support can act on it.
  final String? code;

  final Object? cause;

  @override
  String toString() => '$runtimeType(${code ?? '-'}): $message';
}

/// No usable connection, DNS failure, or the request never left the device.
final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Check your network and try again.',
    super.code = 'NETWORK',
    super.cause,
  });
}

/// Connect/send/receive timeout.
final class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'The server took too long to respond. Please try again.',
    super.code = 'TIMEOUT',
    super.cause,
  });
}

/// Credentials rejected (`UNAUTHENTICATED`), or the stored token has expired.
///
/// There is no refresh endpoint, so expiry is detected client-side from the
/// JWT's `exp` claim and the only recovery is to sign in again.
final class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Invalid username or password.',
    super.code = 'UNAUTHORIZED',
    super.cause,
  });

  /// Raised by the client when the stored JWT's `exp` has passed.
  const AuthFailure.sessionExpired()
      : super(
          message: 'Your session has expired. Please sign in again.',
          code: 'SESSION_EXPIRED',
        );
}

/// 403 — the signed-in user's role lacks the permission this call needs
/// (`PERMISSION_DENIED`), or their plan does not include the module
/// (`MODULE_NOT_ENABLED`).
///
/// Distinct from [AuthFailure] because signing in again cannot fix it: screens
/// hide the affected section rather than showing a retry.
final class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'You do not have permission to view this.',
    super.code = 'PERMISSION_DENIED',
    super.cause,
  });

  /// The tenant's plan does not include this module.
  const PermissionFailure.moduleNotEnabled()
      : super(
          message: 'This module is not enabled for your workspace.',
          code: 'MODULE_NOT_ENABLED',
        );
}

/// 429 — too many requests. The server sends `Retry-After` in seconds.
final class RateLimitedFailure extends Failure {
  const RateLimitedFailure({
    super.message = 'Too many requests. Please wait a moment and try again.',
    super.code = 'RATE_LIMITED',
    this.retryAfterSeconds,
    super.cause,
  });

  final int? retryAfterSeconds;
}

/// 400 / 422 — includes the backend's `VALIDATION_ERROR`, whose `message` is a
/// Java `Map.toString()` rather than structured JSON.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors = const {},
    super.cause,
  });

  /// Best-effort field map parsed out of the backend's stringified map.
  final Map<String, String> fieldErrors;
}

/// 404, or a lookup that found nothing.
final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'We could not find what you were looking for.',
    super.code = 'NOT_FOUND',
    super.cause,
  });
}

/// 409 — duplicate lead email or phone.
final class ConflictFailure extends Failure {
  const ConflictFailure({
    required super.message,
    super.code = 'CONFLICT',
    super.cause,
  });
}

/// Any other non-2xx. [status] is retained because several backend paths return
/// 500 where 400/404 is meant.
final class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Something went wrong on the server. Please try again.',
    required this.status,
    super.code = 'SERVER',
    super.cause,
  });

  final int? status;
}

/// The response arrived but did not match the documented shape.
final class ParseFailure extends Failure {
  const ParseFailure({
    super.message = 'We received an unexpected response from the server.',
    super.code = 'PARSE',
    super.cause,
  });
}

/// The screen requires an endpoint the backend does not implement.
///
/// This is what the 18 unbacked screens render (`API_GAPS.md` § A). It is a
/// first-class state, not an error — the UI shows a designed "not available
/// yet" panel naming [endpoint].
final class NotImplementedFailure extends Failure {
  const NotImplementedFailure({
    required this.endpoint,
    super.message = 'This feature is not available yet.',
    super.code = 'NO_BACKEND',
  });

  /// e.g. `GET /api/quotations` — shown so it is obvious what is missing.
  final String endpoint;
}

/// Narrows whatever an `AsyncValue` is carrying into a [Failure].
///
/// Anything the data layer throws deliberately is already a [Failure]. What is
/// left is a bug on this side of the wire — most often a DTO whose declared
/// type does not match what the server actually sends, which surfaces as a
/// `TypeError` from generated `fromJson` code.
///
/// Those are reported as [ParseFailure], **not** [ServerFailure]: a 200 that
/// this client could not read is a shape problem, and labelling it "server"
/// sends whoever is debugging it to the backend logs, where there is nothing
/// to find.
Failure asFailure(Object error) => switch (error) {
      Failure() => error,
      TypeError() || FormatException() => ParseFailure(cause: '$error'),
      _ => ServerFailure(status: null, cause: '$error'),
    };
