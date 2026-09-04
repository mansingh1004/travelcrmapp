import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/formatters/phone.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../router/safe_pop.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../api/vendor_api.dart';
import 'vendors_screen.dart' show vendorsProvider;
import 'widgets/vendor_chips.dart';
import 'widgets/vendor_form_sheet.dart';

final vendorDetailProvider =
    FutureProvider.autoDispose.family<Vendor, int>(
  (ref, id) => ref.watch(vendorApiProvider).getVendor(id),
);

/// One supplier in full — who to call, and where the account stands.
///
/// The two halves an agent needs on the road: the phone number, and whether
/// this vendor is owed money. Bank details, GST, PAN and credit terms are on
/// the record but not shown; they are console material and putting them on a
/// phone screen invites reading an account number aloud in a taxi.
class VendorDetailScreen extends ConsumerWidget {
  const VendorDetailScreen({super.key, required this.vendorId});

  final int vendorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(vendorDetailProvider(vendorId));

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Vendor', style: AppType.h2),
        actions: [
          if (async.value != null)
            _VendorMenu(vendor: async.value!),
        ],
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (async) {
        AsyncLoading() => const SkeletonList(itemCount: 3, itemHeight: 150),
        AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () => ref.invalidate(vendorDetailProvider(vendorId)),
          ),
        AsyncData(:final value) => _Detail(vendor: value),
      },
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.invalidate(vendorDetailProvider(vendor.id)),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppAvatar(initials: _initials(vendor.name), seed: vendor.name),
                    const SizedBox(width: AppSpacing.x12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vendor.name, style: AppType.h3),
                          if (vendor.code != null) ...[
                            const SizedBox(height: AppSpacing.x4),
                            Text(vendor.code!, style: AppType.monoXs),
                          ],
                        ],
                      ),
                    ),
                    if (vendor.status != null)
                      VendorStatusChip(status: vendor.status!),
                  ],
                ),
                const SizedBox(height: AppSpacing.x12),
                Wrap(
                  spacing: AppSpacing.x6,
                  runSpacing: AppSpacing.x6,
                  children: [
                    if (vendor.type != null) VendorTypeChip(type: vendor.type!),
                    if (vendor.payStatus != null)
                      VendorPayChip(payStatus: vendor.payStatus!),
                  ],
                ),
                if (!vendor.bookable) ...[
                  const SizedBox(height: AppSpacing.x12),
                  // Said plainly, because the booking form hides this vendor
                  // and the agent would otherwise go looking for it.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppIcon(Ic.alert, size: 15, color: AppColors.warn),
                      const SizedBox(width: AppSpacing.x8),
                      Expanded(
                        child: Text(
                          'Not offered when a booking is placed while this '
                          'vendor is ${statusLabel(vendor.status!).toLowerCase()}.',
                          style: AppType.bodySm,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          _LedgerCard(vendor: vendor),
          const SizedBox(height: AppSpacing.x12),
          _ContactCard(vendor: vendor),
          if (vendor.services.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Services', style: AppType.h3),
                  const SizedBox(height: AppSpacing.x12),
                  Wrap(
                    spacing: AppSpacing.x6,
                    runSpacing: AppSpacing.x6,
                    children: [
                      for (final service in vendor.services)
                        VendorTypeChip(type: service),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x24),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}

/// What has been bought from this vendor, and what is still owed.
class _LedgerCard extends StatelessWidget {
  const _LedgerCard({required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    final pct = (vendor.paidFraction * 100).round();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account', style: AppType.h3),
          const SizedBox(height: AppSpacing.x12),
          Row(
            children: [
              Expanded(
                child: _Figure(label: 'Business', value: vendor.totalBusiness),
              ),
              Expanded(
                child: _Figure(label: 'Paid', value: vendor.totalPaid),
              ),
              Expanded(
                child: _Figure(
                  label: 'Outstanding',
                  value: vendor.outstanding,
                  accent: vendor.outstanding > 0
                      ? AppColors.warn
                      : AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x14),
          Row(
            children: [
              Text('Settled', style: AppType.captionSm),
              const Spacer(),
              Text('$pct%', style: AppType.monoXs),
            ],
          ),
          const SizedBox(height: AppSpacing.x6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: vendor.paidFraction,
              minHeight: 6,
              backgroundColor: AppColors.track,
              valueColor: AlwaysStoppedAnimation(
                pct == 100 ? AppColors.success : AppColors.primary,
              ),
            ),
          ),
          if (vendor.totalBusiness == 0) ...[
            const SizedBox(height: AppSpacing.x8),
            Text(
              'No business booked with this vendor yet.',
              style: AppType.captionSm.copyWith(color: AppColors.faint),
            ),
          ],
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.label, required this.value, this.accent});

  final String label;
  final double value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppType.overline),
        const SizedBox(height: AppSpacing.x4),
        Text(
          Inr.compact(value),
          style: AppType.monoStrong.copyWith(color: accent),
        ),
      ],
    );
  }
}

/// The reason an agent opens this screen on the road.
class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      if (vendor.contactPerson != null)
        _Row(icon: Ic.user, text: vendor.contactPerson!),
      if (vendor.phone != null)
        _Row(
          icon: Ic.phone,
          text: vendor.phone!,
          onTap: () => _launch(context, Uri.parse(Phone.dialUri(vendor.phone!))),
        ),
      if (vendor.whatsapp != null || vendor.phone != null)
        _Row(
          icon: Ic.wa,
          text: vendor.whatsapp ?? vendor.phone!,
          accent: AppColors.success,
          onTap: () => _launch(
            context,
            Uri.parse(Phone.whatsAppUri(vendor.whatsapp ?? vendor.phone!)),
          ),
        ),
      if (vendor.email != null)
        _Row(
          icon: Ic.send,
          text: vendor.email!,
          onTap: () => _launch(context, Uri.parse('mailto:${vendor.email}')),
        ),
      if (vendor.city != null)
        _Row(
          icon: Ic.pin,
          text: [vendor.city, vendor.state].whereType<String>().join(', '),
        ),
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact', style: AppType.h3),
          const SizedBox(height: AppSpacing.x4),
          for (final row in rows) row,
        ],
      ),
    );
  }

  static Future<void> _launch(BuildContext context, Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        AppToast.error(context, 'Could not open', uri.toString());
      }
    }
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.text,
    this.onTap,
    this.accent,
  });

  final String icon;
  final String text;
  final VoidCallback? onTap;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.tile),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x10),
        child: Row(
          children: [
            AppIcon(icon, size: 16, color: accent ?? AppColors.muted),
            const SizedBox(width: AppSpacing.x12),
            Expanded(
              child: Text(
                text,
                style: AppType.body,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onTap != null)
              const AppIcon(Ic.chevronRight, size: 14, color: AppColors.faint),
          ],
        ),
      ),
    );
  }
}

enum _VendorAction { edit, status }

class _VendorMenu extends ConsumerWidget {
  const _VendorMenu({required this.vendor});

  final Vendor vendor;

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final saved = await VendorFormSheet.show(context, vendor: vendor);
    if (saved == null) return;
    ref
      ..invalidate(vendorDetailProvider(vendor.id))
      ..invalidate(vendorsProvider);
    if (context.mounted) AppToast.success(context, 'Vendor saved', saved);
  }

  /// Its own route on the server, and its own dialog here: this is what stops
  /// a supplier being offered on new bookings.
  Future<void> _changeStatus(BuildContext context, WidgetRef ref) async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x16),
              child: Row(
                children: [
                  Text('Vendor status', style: AppType.h3),
                ],
              ),
            ),
            for (final status in VendorApi.statuses)
              ListTile(
                leading: VendorStatusChip(status: status),
                trailing: vendor.status == status
                    ? const AppIcon(Ic.check, size: 16, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(status),
              ),
            const SizedBox(height: AppSpacing.x8),
          ],
        ),
      ),
    );
    if (chosen == null || chosen == vendor.status) return;

    try {
      await ref.read(vendorApiProvider).changeStatus(vendor.id, chosen);
      ref
        ..invalidate(vendorDetailProvider(vendor.id))
        ..invalidate(vendorsProvider);
      if (context.mounted) {
        AppToast.success(context, 'Status updated', statusLabel(chosen));
      }
    } on Failure catch (f) {
      if (context.mounted) {
        AppToast.error(context, 'Could not update status', f.message);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_VendorAction>(
      tooltip: 'Vendor actions',
      color: AppColors.surface,
      icon: const AppIcon(Ic.dots, size: 18, color: AppColors.body),
      onSelected: (action) => switch (action) {
        _VendorAction.edit => _edit(context, ref),
        _VendorAction.status => _changeStatus(context, ref),
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _VendorAction.edit,
          child: Row(
            children: [
              const AppIcon(Ic.edit, size: 16, color: AppColors.muted),
              const SizedBox(width: AppSpacing.x10),
              Text('Edit', style: AppType.body),
            ],
          ),
        ),
        PopupMenuItem(
          value: _VendorAction.status,
          child: Row(
            children: [
              const AppIcon(Ic.shield, size: 16, color: AppColors.muted),
              const SizedBox(width: AppSpacing.x10),
              Text('Change status', style: AppType.body),
            ],
          ),
        ),
      ],
    );
  }
}
