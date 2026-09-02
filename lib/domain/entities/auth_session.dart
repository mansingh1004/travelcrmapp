import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../core/utils/jwt.dart';

/// The signed-in session against the running backend.
///
/// Identity comes from the `LoginResponseDTO` (name, email, username, role,
/// public UUID), which is persisted alongside the token so a relaunch restores
/// the full profile without a network call. Expiry still comes from the JWT
/// `exp` claim (24 h), checked client-side.
///
/// JWT claims on this server: `sub` = username, `role`, `tenantId`, `tv`.
@immutable
class AuthSession {
  const AuthSession({
    required this.token,
    required this.username,
    required this.name,
    required this.email,
    required this.role,
    required this.publicId,
    this.issuedAt,
    this.expiresAt,
  });

  final String token;
  final String username;
  final String name;
  final String email;

  /// TENANT_ADMIN · MANAGER · TRAVEL_AGENT · STAFF · ACCOUNTANT
  final String role;

  /// Public UUID of the user — internal ids never cross the API.
  final String publicId;

  final DateTime? issuedAt;
  final DateTime? expiresAt;

  bool get isExpired => Jwt.isExpired(token);

  /// Human wording for the backend role constant.
  String get roleLabel => switch (role) {
        'TENANT_ADMIN' => 'Admin',
        'MANAGER' => 'Manager',
        'TRAVEL_AGENT' => 'Travel agent',
        'STAFF' => 'Staff',
        'ACCOUNTANT' => 'Accountant',
        'SUPER_ADMIN' => 'Super admin',
        _ => role,
      };

  String get displayName => name.isNotEmpty ? name : username;

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Serialised profile persisted next to the token.
  String toStorageJson() => jsonEncode({
        'username': username,
        'name': name,
        'email': email,
        'role': role,
        'publicId': publicId,
      });

  /// Rebuild from the stored token + profile JSON. Returns null when the token
  /// is unusable; profile fields fall back to JWT claims when absent.
  static AuthSession? restore(String? token, String? profileJson) {
    if (token == null || Jwt.payload(token) == null) return null;

    Map<String, dynamic> profile = const {};
    if (profileJson != null && profileJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(profileJson);
        if (decoded is Map<String, dynamic>) profile = decoded;
      } catch (_) {
        // Corrupt profile — fall back to claims.
      }
    }

    final claims = Jwt.payload(token)!;
    return AuthSession(
      token: token,
      username: profile['username'] as String? ?? claims['sub'] as String? ?? '',
      name: profile['name'] as String? ?? '',
      email: profile['email'] as String? ?? '',
      role: profile['role'] as String? ?? claims['role'] as String? ?? '',
      publicId: profile['publicId'] as String? ?? '',
      issuedAt: Jwt.issuedAt(token),
      expiresAt: Jwt.expiry(token),
    );
  }
}
