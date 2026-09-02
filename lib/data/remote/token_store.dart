import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_config.dart';

/// The JWT's only home. Nothing else reads or writes secure storage.
///
/// Held in memory as well as on disk so the auth interceptor can attach the
/// header synchronously without awaiting a platform channel on every request.
class TokenStore {
  TokenStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              // v11 defaults to AES-GCM with RSA-OAEP key wrapping on Android;
              // no extra hardening flags are needed.
              aOptions: AndroidOptions(),
              // Readable after the first unlock so a background refresh works,
              // but never restored to a different device.
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  final FlutterSecureStorage _storage;

  static const _kProfile = 'auth_profile';

  String? _cached;
  String? _cachedProfile;
  bool _loaded = false;

  /// Current token without touching disk. Valid once [load] has run.
  String? get token => _cached;

  /// Persisted `LoginResponseDTO` profile JSON (name/email/role/publicId).
  String? get profileJson => _cachedProfile;

  /// Read the persisted token + profile into memory. Called once at startup,
  /// and again by the auth interceptor whenever the in-memory copy is empty.
  ///
  /// A **failed** read is not cached. The keystore can fail transiently — most
  /// visibly right after the OS kills the process under memory pressure — and
  /// latching that as "no token" would sign the user out for the rest of the
  /// session even though their session is perfectly valid. Only a read that
  /// actually completed is treated as authoritative.
  Future<String?> load() async {
    if (_loaded) return _cached;
    try {
      final token = await _storage.read(key: AppConfig.kAuthToken);
      final profile = await _storage.read(key: _kProfile);
      _cached = token;
      _cachedProfile = profile;
      _loaded = true;
    } catch (_) {
      // Leave `_loaded` false so the next request retries the read rather than
      // inheriting a failure that may already have passed.
      _cached = null;
      _cachedProfile = null;
    }
    return _cached;
  }

  Future<void> save(String token, {String? profileJson}) async {
    _cached = token;
    _cachedProfile = profileJson;
    _loaded = true;
    await _storage.write(key: AppConfig.kAuthToken, value: token);
    if (profileJson != null) {
      await _storage.write(key: _kProfile, value: profileJson);
    }
  }

  Future<void> clear() async {
    _cached = null;
    _cachedProfile = null;
    _loaded = true;
    await _storage.delete(key: AppConfig.kAuthToken);
    await _storage.delete(key: _kProfile);
  }
}
