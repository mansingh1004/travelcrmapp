import 'package:dio/dio.dart';

import '../../core/constants/app_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'token_store.dart';

/// Builds the single [Dio] instance the app uses.
///
/// Presentation code never sees this type — only repositories do.
abstract final class DioClient {
  static Dio create({
    required TokenStore tokens,
    required Future<void> Function() onUnauthenticated,
    String? baseUrl,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: const {
          'Accept': 'application/json, text/plain',
          'Content-Type': 'application/json',
        },
        // Non-2xx must raise, so the failure mapper is the single place that
        // decides what an error means.
        validateStatus: (status) => status != null && status >= 200 && status < 300,
        // `/api/auth/*` replies with `text/plain` and `/api/leads/*` with JSON,
        // so the transformer is left to decide per response rather than being
        // forced to `ResponseType.json`.
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokens: tokens, onUnauthenticated: onUnauthenticated),
      RetryInterceptor(dio: dio),
      const LoggingInterceptor(),
    ]);

    return dio;
  }
}
