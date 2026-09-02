import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/phone.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/company_api.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../auth/providers/auth_controller.dart';
import '../../../router/safe_pop.dart';

final meProfileProvider = FutureProvider.autoDispose<MeProfile>(
  (ref) => ref.watch(companyApiProvider).getProfile(),
);

final companyProvider = FutureProvider.autoDispose<Company>(
  (ref) => ref.watch(companyApiProvider).getCompany(),
);

/// Profile — the signed-in user, their agency, and account actions.
///
/// Name and phone are editable; username, email and role are set by an admin
/// and shown read-only, because the server ignores them on update.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final profile = ref.watch(meProfileProvider);
    final company = ref.watch(companyProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Profile', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref
            ..invalidate(meProfileProvider)
            ..invalidate(companyProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          children: [
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.x18),
              child: Row(
                children: [
                  AppAvatar(
                    initials: profile.value == null
                        ? (session?.initials ?? '?')
                        : _initials(profile.value!.name),
                    seed: profile.value?.username ?? session?.username ?? '',
                    size: 58,
                  ),
                  const SizedBox(width: AppSpacing.x14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.value?.name.isNotEmpty ?? false
                              ? profile.value!.name
                              : session?.displayName ?? '—',
                          style: AppType.h2,
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        Text(
                          [
                            profile.value?.username ?? session?.username,
                            session?.roleLabel,
                          ].whereType<String>().where((s) => s.isNotEmpty).join(' · '),
                          style: AppType.bodySm,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x12),
            switch (profile) {
              AsyncData(:final value) => _Section(
                  title: 'Account',
                  rows: [
                    ('Name', value.name),
                    ('Username', value.username),
                    if (value.email != null) ('Email', value.email!),
                    if (value.phoneNumber != null)
                      ('Phone', Phone.display(value.phoneNumber!)),
                    if (value.role != null) ('Role', value.role!),
                  ],
                  onEdit: () => _editProfile(context, ref, value),
                ),
              AsyncError() => AppCard(
                  child: Text('Could not load your profile.', style: AppType.bodySm),
                ),
              _ => const AppCard(
                  child: SizedBox(
                    height: 60,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
            },
            const SizedBox(height: AppSpacing.x12),
            switch (company) {
              AsyncData(:final value) => _Section(
                  title: 'Agency',
                  rows: [
                    ('Name', value.name),
                    if (value.prefix != null) ('Code prefix', value.prefix!),
                    if (value.gstin != null) ('GSTIN', value.gstin!),
                    if (value.phone != null) ('Phone', value.phone!),
                    if (value.email != null) ('Email', value.email!),
                    if (value.address != null) ('Address', value.address!),
                    if (value.state != null) ('State', value.state!),
                    if (value.website != null) ('Website', value.website!),
                    if (value.tripsSold != null) ('Trips sold', '${value.tripsSold}'),
                    if (value.createdDate != null) ('On TravelCRM since', value.createdDate!),
                  ],
                ),
              AsyncError() => const SizedBox.shrink(),
              _ => const SizedBox.shrink(),
            },
            const SizedBox(height: AppSpacing.x12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _LinkRow(
                    icon: Ic.cog,
                    label: 'Settings',
                    onTap: () => context.push(Routes.settings),
                  ),
                  _LinkRow(
                    icon: Ic.bell,
                    label: 'Notifications',
                    onTap: () => context.push(Routes.notifications),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x12),
            AppCard(
              padding: EdgeInsets.zero,
              child: _LinkRow(
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

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Future<void> _editProfile(
    BuildContext context,
    WidgetRef ref,
    MeProfile profile,
  ) async {
    final nameController = TextEditingController(text: profile.name);
    final phoneController = TextEditingController(text: profile.phoneNumber ?? '');

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
        child: _EditSheet(
          nameController: nameController,
          phoneController: phoneController,
        ),
      ),
    );

    if (saved != true) {
      nameController.dispose();
      phoneController.dispose();
      return;
    }

    try {
      await ref.read(companyApiProvider).updateProfile(
            name: nameController.text,
            phoneNumber: phoneController.text.trim().isEmpty
                ? null
                : phoneController.text.trim(),
          );
      ref.invalidate(meProfileProvider);
      if (context.mounted) {
        AppToast.success(context, 'Profile updated', nameController.text.trim());
      }
    } on Failure catch (f) {
      if (context.mounted) AppToast.error(context, 'Could not save', f.message);
    } finally {
      nameController.dispose();
      phoneController.dispose();
    }
  }
}

class _EditSheet extends StatelessWidget {
  const _EditSheet({required this.nameController, required this.phoneController});

  final TextEditingController nameController;
  final TextEditingController phoneController;

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
            Text('Edit profile', style: AppType.h2),
            const SizedBox(height: AppSpacing.x4),
            Text(
              'Your username, email and role are managed by your admin.',
              style: AppType.caption,
            ),
            const SizedBox(height: AppSpacing.x16),
            TextField(
              controller: nameController,
              style: AppType.fieldValue,
              cursorColor: AppColors.primary,
              decoration: const InputDecoration(
                labelText: 'Name',
                fillColor: AppColors.canvas,
                border: OutlineInputBorder(
                  borderRadius: AppRadii.rTile,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadii.rTile,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadii.rTile,
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: AppType.fieldValue,
              cursorColor: AppColors.primary,
              decoration: const InputDecoration(
                labelText: 'Phone',
                fillColor: AppColors.canvas,
                border: OutlineInputBorder(
                  borderRadius: AppRadii.rTile,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadii.rTile,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadii.rTile,
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows, this.onEdit});

  final String title;
  final List<(String, String)> rows;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: AppType.h3),
              const Spacer(),
              if (onEdit != null)
                TextButton(onPressed: onEdit, child: const Text('Edit')),
            ],
          ),
          const SizedBox(height: AppSpacing.x8),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 130, child: Text(label, style: AppType.caption)),
                  Expanded(child: Text(value, style: AppType.fieldValue)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
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
            if (!danger)
              const AppIcon(Ic.chevronRight, size: 16, color: AppColors.faint),
          ],
        ),
      ),
    );
  }
}
