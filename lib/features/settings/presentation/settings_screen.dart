import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/company_api.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../auth/providers/auth_controller.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../../router/safe_pop.dart';

/// Settings.
///
/// **Read-mostly by design.** Company profile, branding, tax rates, WhatsApp
/// and email configuration all require `SETTINGS_MANAGE` and are edited on the
/// web console, where the file uploads and template editors live. This screen
/// shows the current configuration and offers the one change a signed-in user
/// can always make: their own password.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref.watch(companyProvider);
    final session = ref.watch(sessionProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Settings', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async => ref.invalidate(companyProvider),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            Text('COMPANY', style: AppType.overline),
            const SizedBox(height: AppSpacing.x8),
            switch (company) {
              AsyncData(:final value) => _CompanyCard(company: value),
              AsyncError(:final error) => AppCard(
                  child: Text(
                    error is Failure
                        ? error.message
                        : 'Could not load your agency details.',
                    style: AppType.bodySm,
                  ),
                ),
              _ => const SkeletonList(itemCount: 1, itemHeight: 160),
            },
            const SizedBox(height: AppSpacing.x16),
            Text('ACCOUNT', style: AppType.overline),
            const SizedBox(height: AppSpacing.x8),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _Row(
                    icon: Ic.user,
                    label: 'Profile',
                    value: session?.displayName,
                    onTap: () => context.push(Routes.profile),
                  ),
                  _Row(
                    icon: Ic.shield,
                    label: 'Change password',
                    onTap: () => _changePassword(context, ref),
                  ),
                  _Row(
                    icon: Ic.bell,
                    label: 'Notifications',
                    onTap: () => context.push(Routes.notifications),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x16),
            Text('MANAGED ON THE WEB CONSOLE', style: AppType.overline),
            const SizedBox(height: AppSpacing.x8),
            // Naming these rather than hiding them: an agent looking for
            // "where do I change the GST rate" should find the answer here.
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ManagedRow(
                    icon: Ic.building,
                    label: 'Company profile & branding',
                    detail: 'Logo, letterhead, signature and seal',
                  ),
                  _ManagedRow(
                    icon: Ic.receipt,
                    label: 'Tax rates & invoice numbering',
                    detail: 'GST and TCS rates applied to every quotation',
                  ),
                  _ManagedRow(
                    icon: Ic.wa,
                    label: 'WhatsApp & email',
                    detail: 'Business number, templates and auto-send',
                  ),
                  _ManagedRow(
                    icon: Ic.users,
                    label: 'Branches & users',
                    detail: 'Who can sign in and what they may do',
                    last: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x16),
            AppCard(
              padding: EdgeInsets.zero,
              child: _Row(
                icon: Ic.logout,
                label: 'Sign out',
                danger: true,
                onTap: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.x24),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword(BuildContext context, WidgetRef ref) async {
    final current = TextEditingController();
    final next = TextEditingController();

    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
        child: _PasswordSheet(current: current, next: next),
      ),
    );

    if (submitted != true) {
      current.dispose();
      next.dispose();
      return;
    }

    try {
      await ref.read(authApiProvider).changePassword(
            currentPassword: current.text,
            newPassword: next.text,
          );
      if (context.mounted) {
        AppToast.success(
          context,
          'Password changed',
          'Use the new password next time you sign in.',
        );
      }
    } on Failure catch (f) {
      if (context.mounted) {
        AppToast.error(context, 'Could not change password', f.message);
      }
    } finally {
      current.dispose();
      next.dispose();
    }
  }
}

class _PasswordSheet extends StatefulWidget {
  const _PasswordSheet({required this.current, required this.next});

  final TextEditingController current;
  final TextEditingController next;

  @override
  State<_PasswordSheet> createState() => _PasswordSheetState();
}

class _PasswordSheetState extends State<_PasswordSheet> {
  String? _error;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x16),
            Text('Change password', style: AppType.h2),
            const SizedBox(height: AppSpacing.x16),
            _Field(controller: widget.current, label: 'Current password'),
            const SizedBox(height: AppSpacing.x12),
            _Field(controller: widget.next, label: 'New password'),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.x10),
              Text(
                _error!,
                style: AppType.bodySm.copyWith(color: AppColors.danger),
              ),
            ],
            const SizedBox(height: AppSpacing.x18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  // The server enforces a 6-character minimum; checking here
                  // avoids spending a round trip on a rejection.
                  if (widget.current.text.isEmpty) {
                    setState(() => _error = 'Enter your current password.');
                    return;
                  }
                  if (widget.next.text.length < 6) {
                    setState(
                      () => _error = 'The new password must be at least 6 characters.',
                    );
                    return;
                  }
                  Navigator.of(context).pop(true);
                },
                child: const Text('Change password'),
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: AppType.fieldValue,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        labelText: label,
        fillColor: AppColors.canvas,
        border: const OutlineInputBorder(
          borderRadius: AppRadii.rTile,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.rTile,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadii.rTile,
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  const _CompanyCard({required this.company});

  final Company company;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      if (company.prefix != null) ('Code prefix', company.prefix!),
      if (company.gstin != null) ('GSTIN', company.gstin!),
      if (company.tan != null) ('TAN', company.tan!),
      if (company.phone != null) ('Phone', company.phone!),
      if (company.email != null) ('Email', company.email!),
      if (company.whatsappNumber != null) ('WhatsApp', company.whatsappNumber!),
      if (company.address != null) ('Address', company.address!),
      if (company.status != null) ('Status', company.status!),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(company.name, style: AppType.h2),
          if (company.createdDate != null) ...[
            const SizedBox(height: AppSpacing.x4),
            Text('On TravelCRM since ${company.createdDate}', style: AppType.caption),
          ],
          const SizedBox(height: AppSpacing.x14),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 110, child: Text(label, style: AppType.caption)),
                  Expanded(child: Text(value, style: AppType.fieldValue)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.danger = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final String? value;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x16,
          vertical: AppSpacing.x14,
        ),
        child: Row(
          children: [
            AppIcon(icon, size: 18, color: color),
            const SizedBox(width: AppSpacing.x12),
            Expanded(
              child: Text(
                label,
                style: danger
                    ? AppType.fieldValue.copyWith(color: AppColors.danger)
                    : AppType.fieldValue,
              ),
            ),
            if (value != null) ...[
              Text(value!, style: AppType.caption),
              const SizedBox(width: AppSpacing.x8),
            ],
            if (!danger)
              const AppIcon(Ic.chevronRight, size: 16, color: AppColors.faint),
          ],
        ),
      ),
    );
  }
}

/// A setting this app deliberately does not edit, and where it lives instead.
class _ManagedRow extends StatelessWidget {
  const _ManagedRow({
    required this.icon,
    required this.label,
    required this.detail,
    this.last = false,
  });

  final String icon;
  final String label;
  final String detail;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : AppSpacing.x14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon(icon, size: 17, color: AppColors.muted),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppType.fieldValue),
                const SizedBox(height: AppSpacing.x2),
                Text(detail, style: AppType.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
