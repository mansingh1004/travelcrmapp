import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../../../domain/entities/auth_session.dart';

/// Auth state for the whole app. The router watches this to guard routes.
sealed class AuthState {
  const AuthState();
}

/// Startup: reading the stored token. The router shows a splash while this is
/// the state, so the app never flashes Login before auto-login resolves.
final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class AuthSignedOut extends AuthState {
  const AuthSignedOut({this.reason});

  /// Set when the session ended by itself, so Login can explain why.
  final String? reason;
}

final class AuthSignedIn extends AuthState {
  const AuthSignedIn(this.session);

  final AuthSession session;
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Kick off session restore, but return synchronously so the router has a
    // state to read immediately.
    Future.microtask(restore);
    return const AuthUnknown();
  }

  /// Auto-login on relaunch. There is no refresh token, so a lapsed JWT simply
  /// means signed out (`API_GAPS.md` **G-06**).
  Future<void> restore() async {
    final session = await ref.read(authRepositoryProvider).restoreSession();
    state = session == null ? const AuthSignedOut() : AuthSignedIn(session);
  }

  /// Throws a `Failure` on bad credentials; the Login screen catches it.
  ///
  /// Username-keyed — the running backend resolves the identifier against the
  /// `username` column only.
  Future<void> login({required String username, required String password}) async {
    final session = await ref.read(authRepositoryProvider).login(
          username: username,
          password: password,
        );
    state = AuthSignedIn(session);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthSignedOut();
  }

  /// Called by the auth interceptor when the token is missing or expired
  /// mid-request. Distinct from [logout] so Login can say what happened.
  Future<void> forceSignOut() async {
    if (state is AuthSignedOut) return;
    await ref.read(authRepositoryProvider).logout();
    state = const AuthSignedOut(reason: 'Your session expired. Please sign in again.');
  }

  AuthSession? get session => switch (state) {
        AuthSignedIn(:final session) => session,
        _ => null,
      };
}

/// Convenience: the current session, or null.
final sessionProvider = Provider<AuthSession?>((ref) {
  final state = ref.watch(authControllerProvider);
  return state is AuthSignedIn ? state.session : null;
});
