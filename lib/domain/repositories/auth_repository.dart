import '../entities/auth_session.dart';

/// Auth operations against the running backend.
///
/// Deliberately small: this server has **no self-registration** (accounts are
/// created by a tenant admin via `/api/users`) and **no forgot-password
/// endpoint** — only an authenticated change-password. Implementations throw a
/// `Failure` on error; they never return one.
abstract interface class AuthRepository {
  /// The signed-in session, or `null`. Reads secure storage on first call.
  Future<AuthSession?> restoreSession();

  /// Current session without touching disk.
  AuthSession? get currentSession;

  /// Staff login — **username**-keyed on this server, not email.
  Future<AuthSession> login({required String username, required String password});

  /// Authenticated self-service password change.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> logout();
}
