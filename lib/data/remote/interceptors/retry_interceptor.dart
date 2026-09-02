import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

/// Retries transient network failures with exponential backoff.
///
/// Deliberately conservative:
///  * Only **idempotent** methods (GET) are retried. `POST /api/leads` must
///    never be replayed — the backend enforces unique email and phone, so a
///    retry of a request that actually succeeded would surface a spurious 409.
///  * Only connection/timeout errors and 502/503/504 are retried. A 500 is not,
///    because on this backend a 500 is usually a real, deterministic bug
///    (`API_GAPS.md` § D) that will fail identically every time.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxAttempts = 2,
    this.baseDelay = const Duration(milliseconds: 400),
  });

  final Dio dio;
  final int maxAttempts;
  final Duration baseDelay;

  static const _attemptKey = 'retry_attempt';

  static const _retryableStatuses = <int>{502, 503, 504};

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRetry(err)) return handler.next(err);

    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int? ?? 0) + 1;
    if (attempt > maxAttempts) return handler.next(err);

    // Exponential backoff with jitter, so a flapping server is not hammered by
    // every client at the same instant.
    final jitter = Random().nextInt(120);
    await Future<void>.delayed(baseDelay * (1 << (attempt - 1)) + Duration(milliseconds: jitter));

    options.extra[_attemptKey] = attempt;

    try {
      final response = await dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    if (err.requestOptions.method.toUpperCase() != 'GET') return false;

    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        true,
      DioExceptionType.badResponse => _retryableStatuses.contains(err.response?.statusCode),
      _ => false,
    };
  }
}
