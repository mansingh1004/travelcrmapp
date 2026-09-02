import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/entities/booking_enums.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../providers/bookings_controller.dart';
import '../../../router/safe_pop.dart';

/// Booking detail — payment summary, travel, service rows and ops readiness.
///
/// Readiness is derived from the real per-service `status` values rather than
/// a readiness field, because the server has none: all confirmed → Ready, some
/// → Partially ready, none → Critical.
class BookingDetailScreen extends ConsumerWidget {
  const BookingDetailScreen({super.key, required this.publicId});

  final String publicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(bookingDetailProvider(publicId));

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Booking', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (async) {
        AsyncLoading() => const SkeletonList(itemCount: 3, itemHeight: 150),
        AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () => ref.invalidate(bookingDetailProvider(publicId)),
          ),
        AsyncData(:final value) => _Detail(booking: value),
      },
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref
          ..invalidate(bookingDetailProvider(booking.id))
          ..invalidate(bookingServicesProvider(booking.id));
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.customerName.isEmpty ? 'Unnamed booking' : booking.customerName,
                  style: AppType.h1,
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  [
                    if (booking.code != null) booking.code!,
                    if (booking.destination != null) booking.destination!,
                  ].join(' · '),
                  style: AppType.bodySm,
                ),
                const SizedBox(height: AppSpacing.x14),
                Wrap(
                  spacing: AppSpacing.x8,
                  runSpacing: AppSpacing.x8,
                  children: [
                    _StatusChipPicker(booking: booking),
                    if (booking.paymentStatus != null)
                      StatusChip(
                        label: booking.paymentStatus!.label,
                        palette: StatusColors.paymentStatus(booking.paymentStatus!),
                      ),
                    if (booking.overseas)
                      const StatusChip(label: 'Overseas', palette: StatusColors.neutral),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          _PaymentCard(booking: booking),
          const SizedBox(height: AppSpacing.x12),
          _Section(
            title: 'Travel',
            rows: [
              if (booking.travelDate != null)
                ('Travel date', AppDate.display(booking.travelDate)),
              if (booking.daysToTravel != null)
                (
                  'Countdown',
                  booking.daysToTravel! < 0
                      ? 'Travelled ${-booking.daysToTravel!} days ago'
                      : booking.daysToTravel == 0
                          ? 'Travels today'
                          : 'In ${booking.daysToTravel} days'
                ),
              if (booking.bookingDate != null)
                ('Booked on', AppDate.display(booking.bookingDate)),
              if (booking.destination != null) ('Destination', booking.destination!),
              if (booking.agentName != null) ('Agent', booking.agentName!),
              if (booking.vendorName != null) ('Vendor', booking.vendorName!),
              if (booking.tripSummary != null) ('Trip', booking.tripSummary!),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          _ServicesCard(bookingId: booking.id),
          if (booking.services.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Services booked', style: AppType.h3),
                  const SizedBox(height: AppSpacing.x12),
                  Wrap(
                    spacing: AppSpacing.x8,
                    runSpacing: AppSpacing.x8,
                    children: [
                      for (final service in booking.services)
                        StatusChip(label: service, palette: StatusColors.neutral),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (booking.leadId != null || booking.customerId != null) ...[
            const SizedBox(height: AppSpacing.x12),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (booking.customerId != null)
                    _LinkRow(
                      icon: Ic.user,
                      label: 'View customer',
                      onTap: () =>
                          context.push(Routes.customerDetailFor(booking.customerId!)),
                    ),
                  if (booking.leadId != null)
                    _LinkRow(
                      icon: Ic.users,
                      label: 'View originating lead',
                      onTap: () => context.push(Routes.leadDetailFor(booking.leadId!)),
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
}

/// The status chip, which opens a picker and commits via `PATCH .../status`.
class _StatusChipPicker extends ConsumerWidget {
  const _StatusChipPicker({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = booking.status;

    return Semantics(
      button: true,
      label: 'Status: ${status?.label ?? 'not set'}. Tap to change.',
      child: InkWell(
        onTap: () => _pick(context, ref),
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: StatusChip(
          label: status?.label ?? 'Set status',
          palette:
              status == null ? StatusColors.neutral : StatusColors.bookingStatus(status),
          trailingIcon: Ic.chevronDown,
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final picked = await showModalBottomSheet<BookingStatus>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.x16),
                child: Text('Change status', style: AppType.h2),
              ),
              for (final status in BookingStatus.values)
                ListTile(
                  onTap: () => Navigator.of(context).pop(status),
                  leading: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: StatusColors.bookingStatus(status).foreground,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(status.label, style: AppType.fieldValue),
                  trailing: status == booking.status
                      ? const AppIcon(Ic.check, size: 18, color: AppColors.primary)
                      : null,
                ),
              const SizedBox(height: AppSpacing.x8),
            ],
          ),
        ),
      ),
    );

    if (picked == null || picked == booking.status || !context.mounted) return;

    // Cancelling a booking has refund and accounting consequences, so it goes
    // through its own endpoint rather than a plain status change.
    if (picked == BookingStatus.cancelled) {
      AppToast.error(
        context,
        'Use the cancellation flow',
        'Cancelling triggers refund and credit-note handling, which this screen '
            'does not cover yet.',
      );
      return;
    }

    try {
      final updated =
          await ref.read(bookingRepositoryProvider).changeStatus(booking.id, picked);
      ref.read(bookingsControllerProvider.notifier).upsert(updated);
      ref
        ..invalidate(bookingDetailProvider(booking.id))
        ..invalidate(bookingStatsProvider);
      if (context.mounted) {
        AppToast.show(context, title: 'Status updated', message: 'Now ${picked.label}.');
      }
    } on Failure catch (f) {
      if (context.mounted) AppToast.error(context, 'Could not update status', f.message);
    }
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      gradient: AppGradients.brandHero,
      borderColor: AppColors.primaryDeep,
      shadow: AppShadows.heroGlow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total payable',
            style: AppType.caption.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          Text(
            Inr.format(booking.totalPayable),
            style: AppType.monoDisplay.copyWith(color: AppColors.onPrimary),
          ),
          const SizedBox(height: AppSpacing.x12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: booking.paidFraction,
              minHeight: 6,
              backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.onPrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          Row(
            children: [
              Expanded(
                child: _MiniStat(label: 'Paid', value: Inr.compact(booking.paidAmount)),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'Balance',
                  value: Inr.compact(booking.pendingAmount),
                  emphasise: booking.pendingAmount > 0,
                ),
              ),
              if (booking.refundedAmount > 0)
                Expanded(
                  child: _MiniStat(
                    label: 'Refunded',
                    value: Inr.compact(booking.refundedAmount),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          const Divider(height: 1, color: Color(0x33FFFFFF)),
          const SizedBox(height: AppSpacing.x10),
          // Tax is shown, never computed — the server owns GST and TCS.
          Row(
            children: [
              Expanded(
                child: _MiniStat(label: 'Base', value: Inr.compact(booking.customerAmount)),
              ),
              Expanded(child: _MiniStat(label: 'GST', value: Inr.compact(booking.gst))),
              if (booking.tcs > 0)
                Expanded(child: _MiniStat(label: 'TCS', value: Inr.compact(booking.tcs))),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    this.emphasise = false,
  });

  final String label;
  final String value;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppType.caption.copyWith(
            color: AppColors.onPrimary.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: AppType.monoStrong.copyWith(
            color: emphasise ? AppColors.warnBg : AppColors.onPrimary,
          ),
        ),
      ],
    );
  }
}

/// Service rows plus the readiness summary derived from their statuses.
class _ServicesCard extends ConsumerWidget {
  const _ServicesCard({required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(bookingServicesProvider(bookingId));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Services', style: AppType.h3),
              const Spacer(),
              if (async.value != null && async.value!.isNotEmpty)
                _ReadinessChip(services: async.value!),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          switch (async) {
            AsyncLoading() => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.x20),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            AsyncError() => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
                child: Text('Could not load services.', style: AppType.bodySm),
              ),
            AsyncData(:final value) => value.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
                    child: Text('No services added yet.', style: AppType.bodySm),
                  )
                : Column(
                    children: [
                      for (final service in value)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.x12),
                          child: _ServiceRow(service: service),
                        ),
                    ],
                  ),
          },
        ],
      ),
    );
  }
}

class _ReadinessChip extends StatelessWidget {
  const _ReadinessChip({required this.services});

  final List<BookingService> services;

  @override
  Widget build(BuildContext context) {
    // Cancelled rows do not count against readiness.
    final live = services.where((s) => s.status != ServiceItemStatus.cancelled).toList();
    if (live.isEmpty) return const SizedBox.shrink();

    final confirmed = live.where((s) => s.isConfirmed).length;

    final (label, palette) = switch (confirmed) {
      _ when confirmed == live.length => (
          'Ready',
          const StatusPalette(AppColors.success, AppColors.successBg),
        ),
      0 => ('Critical', const StatusPalette(AppColors.danger, AppColors.dangerBg)),
      _ => (
          '$confirmed/${live.length} ready',
          const StatusPalette(AppColors.warn, AppColors.warnBg),
        ),
    };

    return StatusChip(label: label, palette: palette, dense: true);
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.service});

  final BookingService service;

  @override
  Widget build(BuildContext context) {
    final status = service.status;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.title ?? service.type ?? 'Service',
                style: AppType.fieldValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (service.vendorName != null || service.confirmationNumber != null) ...[
                const SizedBox(height: AppSpacing.x2),
                Text(
                  [
                    if (service.vendorName != null) service.vendorName!,
                    if (service.confirmationNumber != null) service.confirmationNumber!,
                  ].join(' · '),
                  style: AppType.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x8),
        if (status != null)
          StatusChip(
            label: status.label,
            palette: StatusColors.serviceStatus(status),
            dense: true,
          ),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.icon, required this.label, required this.onTap});

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x16,
          vertical: AppSpacing.x14,
        ),
        child: Row(
          children: [
            AppIcon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: AppSpacing.x12),
            Expanded(child: Text(label, style: AppType.fieldValue)),
            const AppIcon(Ic.chevronRight, size: 16, color: AppColors.faint),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppType.h3),
          const SizedBox(height: AppSpacing.x12),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 118,
                    child: Text(label, style: AppType.caption),
                  ),
                  Expanded(child: Text(value, style: AppType.fieldValue)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
