import 'package:dio/dio.dart';

import '../../core/errors/failure.dart';

/// Turns a [DioException] into a typed [Failure].
///
/// The running backend's `GlobalExceptionHandler` returns
/// `{ success:false, status, code, message, traceId, timestamp }` — e.g.
/// `code: "UNAUTHENTICATED" | "NOT_FOUND" | ...` — and some responses use the
/// `ApiResponse` failure envelope `{ success:false, message, errors,
/// statusCode }`. Both shapes are read here; `message` is written for display.
/// [treat500AsNotFound] is kept for callers that know a 500 means "no match".
abstract final class FailureMapper {
  static Failure from(DioException e, {bool treat500AsNotFound = false}) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TimeoutFailure(cause: e);

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkFailure(cause: e);

      case DioExceptionType.cancel:
        // The auth interceptor cancels requests when there is no usable token.
        return const AuthFailure.sessionExpired();

      case DioExceptionType.badCertificate:
        return ServerFailure(
          message: 'The server certificate could not be verified.',
          status: null,
          code: 'BAD_CERTIFICATE',
          cause: e,
        );

      case DioExceptionType.badResponse:
        return _fromResponse(e, treat500AsNotFound: treat500AsNotFound);
    }
  }

  static Failure _fromResponse(DioException e, {required bool treat500AsNotFound}) {
    final status = e.response?.statusCode;
    final body = e.response?.data;
    final serverMessage = _messageOf(body);

    switch (status) {
      case 400:
        final code = _errorCodeOf(body);
        if (code == 'VALIDATION_ERROR') {
          return ValidationFailure(
            message: _humaniseValidation(serverMessage),
            fieldErrors: _parseFieldErrors(serverMessage),
            cause: e,
          );
        }
        return ValidationFailure(
          message: serverMessage ?? 'That request was not valid.',
          code: code ?? 'BAD_REQUEST',
          cause: e,
        );

      case 401:
        return AuthFailure(
          message: serverMessage ?? 'Invalid username or password.',
          cause: e,
        );

      case 403:
        // Signing in again cannot fix a 403 — the role lacks the permission,
        // or the plan lacks the module. Screens hide the section instead of
        // offering a retry.
        if (_errorCodeOf(body) == 'MODULE_NOT_ENABLED') {
          return const PermissionFailure.moduleNotEnabled();
        }
        return PermissionFailure(
          message: serverMessage ?? 'You do not have permission to view this.',
          cause: e,
        );

      case 404:
        return NotFoundFailure(message: serverMessage ?? 'Not found.', cause: e);

      case 409:
        return ConflictFailure(
          message: serverMessage ?? 'That record already exists.',
          cause: e,
        );

      case 429:
        return RateLimitedFailure(
          message: serverMessage ?? 'Too many requests. Please wait a moment.',
          retryAfterSeconds: int.tryParse(
            e.response?.headers.value('Retry-After') ?? '',
          ),
          cause: e,
        );

      case 500:
        // Callers that know a 500 can mean "no match" opt into this so the UI
        // shows an empty state rather than a crash banner.
        if (treat500AsNotFound) {
          return NotFoundFailure(message: serverMessage ?? 'No match found.', cause: e);
        }
        return ServerFailure(status: 500, cause: e);

      default:
        return ServerFailure(
          message: serverMessage ?? 'Something went wrong. Please try again.',
          status: status,
          cause: e,
        );
    }
  }

  /// The backend returns JSON for handled exceptions but `text/plain` from every
  /// `/api/auth/*` handler, so both shapes have to be read.
  static String? _messageOf(Object? body) {
    if (body == null) return null;
    if (body is String) {
      final trimmed = body.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    if (body is Map) {
      final m = body['message'];
      if (m is String && m.trim().isNotEmpty) return m.trim();
    }
    return null;
  }

  static String? _errorCodeOf(Object? body) {
    if (body is Map) {
      // Running backend: `code`; legacy snapshot used `error`.
      final code = body['code'] ?? body['error'];
      if (code is String && code.isNotEmpty) return code;
    }
    return null;
  }

  /// The backend stringifies a Java map into `message`:
  /// `Validation failed: {phone=Enter a valid…, email=Enter a valid…}`.
  /// Show the first constraint rather than the raw dump.
  static String _humaniseValidation(String? raw) {
    if (raw == null) return 'Please check the highlighted fields.';
    final errors = _parseFieldErrors(raw);
    if (errors.isEmpty) return raw;
    return errors.values.first;
  }

  static Map<String, String> _parseFieldErrors(String? raw) {
    if (raw == null) return const {};
    final open = raw.indexOf('{');
    final close = raw.lastIndexOf('}');
    if (open == -1 || close <= open) return const {};

    final inner = raw.substring(open + 1, close);
    if (inner.trim().isEmpty) return const {};

    final result = <String, String>{};
    // Entries are `key=value`, comma-separated. Values may contain spaces but
    // not `=`, which makes a simple split safe enough for display purposes.
    for (final part in inner.split(RegExp(r',\s*(?=[A-Za-z_][A-Za-z0-9_]*=)'))) {
      final eq = part.indexOf('=');
      if (eq <= 0) continue;
      final key = part.substring(0, eq).trim();
      final value = part.substring(eq + 1).trim();
      if (key.isNotEmpty && value.isNotEmpty) result[key] = value;
    }
    return result;
  }
}
