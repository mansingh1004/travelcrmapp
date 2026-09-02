import '../../core/utils/jwt.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../remote/token_store.dart';
import '../services/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api, this._tokens);

  final AuthApi _api;
  final TokenStore _tokens;

  AuthSession? _session;

  @override
  AuthSession? get currentSession => _session;

  @override
  Future<AuthSession?> restoreSession() async {
    final token = await _tokens.load();
    final session = AuthSession.restore(token, _tokens.profileJson);

    // There is no refresh endpoint, so an expired token is simply discarded.
    if (session == null || session.isExpired) {
      if (token != null) await _tokens.clear();
      _session = null;
      return null;
    }

    _session = session;
    return session;
  }

  @override
  Future<AuthSession> login({required String username, required String password}) async {
    final result = await _api.login(username: username, password: password);

    final session = AuthSession(
      token: result.token,
      username: result.username,
      name: result.name,
      email: result.email,
      role: result.role,
      publicId: result.publicId,
      issuedAt: Jwt.issuedAt(result.token),
      expiresAt: Jwt.expiry(result.token),
    );

    await _tokens.save(result.token, profileJson: session.toStorageJson());
    _session = session;
    return session;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _api.changePassword(currentPassword: currentPassword, newPassword: newPassword);

  @override
  Future<void> logout() async {
    // Stateless JWT server — signing out is local: drop token and session.
    _session = null;
    await _tokens.clear();
  }
}
