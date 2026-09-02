import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/app_toast.dart';
import '../providers/auth_controller.dart';
import 'widgets/auth_field.dart';

/// Real sign-in against `POST /api/auth/user/login`.
///
/// The running backend is **username-keyed** (the identifier resolves against
/// the `username` column; an email address matches nothing), multi-tenant via
/// the JWT's `tenantId` claim — so there is no workspace picker. It has no
/// self-registration and no forgot-password endpoint: accounts and resets are
/// handled by the tenant admin, and the links below say exactly that.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  bool _obscure = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // The backend does not apply @Valid to /auth/login, so its DTO constraints
    // never run (`API_GAPS.md` **G-07**) — the client validates first.
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(username: _username.text, password: _password.text);
      // The router's redirect moves us to the dashboard.
    } on Failure catch (f) {
      if (!mounted) return;
      setState(() => _error = f.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not sign in. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If the session ended by itself, say so once.
    ref.listen<AuthState>(authControllerProvider, (_, next) {
      if (next is AuthSignedOut && next.reason != null && mounted) {
        AppToast.show(context, title: 'Signed out', message: next.reason!);
      }
    });

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppGradients.page,
        ),
        child: SafeArea(
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x28,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    // IntrinsicHeight bounds the Column so the Spacers can
                    // flex inside a scrollview without unbounded-height errors.
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          _brandMark(),
                          const SizedBox(height: AppSpacing.x22),
                          Text('TravelCRM', style: AppType.display),
                          const SizedBox(height: AppSpacing.x8),
                          Text(
                            'Sales, quotations and operations for travel agencies. '
                            'Sign in to continue.',
                            style: AppType.body,
                          ),
                          const SizedBox(height: AppSpacing.x30),
                          AuthField(
                            label: 'Username',
                            controller: _username,
                            hintText: 'e.g. travel_agent',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.username],
                            enabled: !_busy,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Username is required'
                                : null,
                          ),
                          const SizedBox(height: AppSpacing.x12),
                          AuthField(
                            label: 'Password',
                            controller: _password,
                            hintText: '••••••••',
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            enabled: !_busy,
                            onFieldSubmitted: (_) => _submit(),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Password is required'
                                : null,
                            trailing: Semantics(
                              button: true,
                              label: _obscure
                                  ? 'Show password'
                                  : 'Hide password',
                              child: InkWell(
                                onTap: () =>
                                    setState(() => _obscure = !_obscure),
                                borderRadius: BorderRadius.circular(
                                  AppRadii.chip,
                                ),
                                child: SizedBox(
                                  width: AppSpacing.minTouchTarget,
                                  height: AppSpacing.minTouchTarget,
                                  child: Center(
                                    child: AppIcon(
                                      _obscure ? Ic.user : Ic.checkCircle,
                                      size: 18,
                                      color: AppColors.faint,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_error != null) ...[
                            const SizedBox(height: AppSpacing.x12),
                            _ErrorBanner(message: _error!),
                          ],
                          const SizedBox(height: AppSpacing.x22),
                          _signInButton(),
                          const SizedBox(height: AppSpacing.x18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _link(
                                'Forgot password?',
                                color: AppColors.muted,
                                onTap: _showAdminHelp,
                              ),
                              _link(
                                'Need an account?',
                                color: AppColors.primary,
                                onTap: _showAdminHelp,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: AppSpacing.x26,
                              bottom: AppSpacing.x8,
                            ),
                            child: Center(
                              child: Text(
                                'TravelCRM · connected to your agency workspace',
                                style: AppType.caption.copyWith(
                                  fontSize: 11,
                                  color: AppColors.faint,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The server has no self-registration or forgot-password endpoint — both
  /// are admin-managed — so these links explain that instead of opening a form
  /// that could never submit.
  void _showAdminHelp() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Accounts are managed by your admin', style: AppType.h2),
              const SizedBox(height: AppSpacing.x10),
              Text(
                'Your workspace administrator creates sign-ins and resets '
                'passwords. Ask them for a new account or a password reset — '
                'once signed in, you can change your own password from Profile.',
                style: AppType.body,
              ),
              const SizedBox(height: AppSpacing.x20),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _brandMark() => Container(
    width: 56,
    height: 56,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      boxShadow: AppShadows.brandLift,
    ),
    child: const AppIcon(Ic.plane, size: 26, color: AppColors.onPrimary),
  );

  Widget _signInButton() => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: AppRadii.rField,
      boxShadow: _busy ? null : AppShadows.primaryButton,
    ),
    child: SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton(
        onPressed: _busy ? null : _submit,
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.rField),
          textStyle: AppType.buttonLarge,
        ),
        child: _busy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sign in'),
                  SizedBox(width: AppSpacing.x8),
                  AppIcon(
                    Ic.chevronRight,
                    size: 18,
                    color: AppColors.onPrimary,
                  ),
                ],
              ),
      ),
    ),
  );

  Widget _link(
    String label, {
    required Color color,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x10),
      child: Text(
        label,
        style: AppType.chip.copyWith(fontSize: 12.5, color: color),
      ),
    ),
  );
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x12),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: AppRadii.rTile,
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppIcon(Ic.alert, size: 17, color: AppColors.danger),
          const SizedBox(width: AppSpacing.x10),
          Expanded(
            child: Text(
              message,
              style: AppType.bodySm.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}
