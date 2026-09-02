import 'package:dio/dio.dart';

import '../../core/errors/failure.dart';
import '../remote/failure_mapper.dart';

/// Result of `POST /api/auth/user/login` — the running backend's
/// `LoginResponseDTO`, returned **bare** (not enveloped).
class LoginResult {
  const LoginResult({
    required this.token,
    required this.name,
    required this.email,
    required this.username,
    required this.role,
    required this.publicId,
    this.mustChangePassword = false,
    this.mfaRequired = false,
  });

  final String token;
  final String name;
  final String email;
  final String username;
  final String role;

  /// The user's public UUID — the backend never exposes internal ids.
  final String publicId;

  final bool mustChangePassword;
  final bool mfaRequired;

  static LoginResult fromJson(Map<String, dynamic> json) => LoginResult(
        token: json['token'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        username: json['username'] as String? ?? '',
        role: json['role'] as String? ?? '',
        publicId: json['id'] as String? ?? '',
        mustChangePassword: json['mustChangePassword'] as bool? ?? false,
        mfaRequired: json['mfaRequired'] as bool? ?? false,
      );
}

/// Auth endpoints of the RUNNING backend (`C:\travelcrmbackend`, Spring Boot
/// 3.5.3) — **not** the stale GitHub snapshot, whose `/api/auth/login`,
/// `/register/*` and `/forgotpassword` do not exist on this server.
///
/// Staff login is **username-keyed**: `LoginRequestDTO.getLoginIdentifier()`
/// resolves `username` (or the legacy `email` alias) against the `username`
/// column only. There is no self-registration and no forgot-password endpoint —
/// accounts are created by a tenant admin via `/api/users`, and password
/// changes go through the authenticated `/api/auth/change-password`.
class AuthApi {
  const AuthApi(this._dio);

  final Dio _dio;

  /// `POST /api/auth/user/login` → bare `LoginResponseDTO` JSON.
  Future<LoginResult> login({required String username, required String password}) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/auth/user/login',
        data: {'username': username.trim(), 'password': password},
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ParseFailure(cause: 'Login response was not a JSON object');
      }

      final result = LoginResult.fromJson(data);
      if (result.token.isEmpty) {
        // MFA-gated logins return no token; the mobile app has no TOTP flow yet.
        if (result.mfaRequired) {
          throw const AuthFailure(
            message: 'This account requires MFA, which the mobile app does not '
                'support yet. Sign in from the web app.',
            code: 'MFA_REQUIRED',
          );
        }
        throw const ParseFailure(cause: 'Login returned no token');
      }
      return result;
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/auth/change-password` (authenticated).
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post<dynamic>(
        '/api/auth/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }
}
