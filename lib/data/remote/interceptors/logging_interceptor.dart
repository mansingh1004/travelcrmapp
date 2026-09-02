import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Request/response logging for debug builds.
///
/// Redacts the `Authorization` header and any password field so a shared log or
/// a screen recording never leaks a credential.
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  static const _redacted = '***';

  bool get _enabled => kDebugMode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_enabled) {
      _log('→ ${options.method} ${options.uri}');
      final auth = options.headers['Authorization'];
      if (auth != null) _log('   auth: Bearer $_redacted');
      final body = _redactBody(options.data);
      if (body != null) _log('   body: $body');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (_enabled) {
      _log('← ${response.statusCode} ${response.requestOptions.method} '
          '${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_enabled) {
      _log('✗ ${err.response?.statusCode ?? err.type.name} '
          '${err.requestOptions.method} ${err.requestOptions.uri}');
      final data = err.response?.data;
      if (data != null) _log('   ${_truncate(data.toString())}');
    }
    handler.next(err);
  }

  Object? _redactBody(Object? data) {
    if (data is Map) {
      return {
        for (final entry in data.entries)
          entry.key: _isSecret(entry.key.toString()) ? _redacted : entry.value,
      };
    }
    return data == null ? null : _truncate(data.toString());
  }

  bool _isSecret(String key) {
    final k = key.toLowerCase();
    return k.contains('password') || k.contains('otp') || k.contains('token');
  }

  String _truncate(String s) => s.length <= 500 ? s : '${s.substring(0, 500)}…';

  /// `debugPrint`, not `developer.log`: only the former reaches `adb logcat`,
  /// which is where these lines are actually read on a device.
  void _log(String message) => debugPrint('[http] $message');
}
