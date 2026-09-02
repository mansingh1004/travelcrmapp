import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/utils/jwt.dart';
import '../token_store.dart';

/// Attaches `Authorization: Bearer <jwt>` and enforces expiry client-side.
///
/// The server issues a 24-hour token and offers **no refresh endpoint**, so an
/// expired token is a dead end: the only correct move is to clear it and let
/// the router send the user to Login.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokens, required this.onUnauthenticated});

  final TokenStore tokens;

  /// Invoked when the session is over. The app clears state and routes to Login.
  final Future<void> Function() onUnauthenticated;

  /// Endpoints that must never carry a token, and must never trigger a logout.
  ///
  /// The staff login is the only unauthenticated call the app makes.
  /// `/api/auth/change-password` is NOT here — it needs the Bearer token even
  /// though the server marks the path permitAll.
  static const _publicPaths = <String>{
    '/api/auth/user/login',
  };

  bool _isPublic(String path) => _publicPaths.any(path.contains);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_isPublic(options.path)) {
      return handler.next(options);
    }

    final token = tokens.token ?? await tokens.load();

    if (token == null) {
      _signOut('no stored token', options);
      await onUnauthenticated();
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: 'No session',
          message: 'Not signed in',
        ),
        true,
      );
    }

    if (Jwt.isExpired(token)) {
      _signOut('token expired', options);
      await tokens.clear();
      await onUnauthenticated();
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          error: 'Session expired',
          message: 'Session expired',
        ),
        true,
      );
    }

    options.headers['Authorization'] = 'Bearer $token';
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    if (status == 401 && !_isPublic(err.requestOptions.path)) {
      _signOut('401 from server', err.requestOptions);
      await tokens.clear();
      await onUnauthenticated();
    }
    return handler.next(err);
  }

  /// Signing the user out mid-session is drastic and hard to diagnose after the
  /// fact, so every path that does it says why and on whose behalf.
  void _signOut(String reason, RequestOptions options) {
    if (kDebugMode) {
      debugPrint('[auth] forced sign-out ($reason) on ${options.method} ${options.path}');
    }
  }
}
