import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/booking.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../providers/payments_controller.dart';
import 'widgets/record_payment_sheet.dart';
import '../../../router/safe_pop.dart';

/// Payments — outstanding first, then what has been collected.
///
/// There is no global payments collection on this server: money lives under
/// bookings. So the receivable list is the bookings that still owe, and the
/// summary comes from `GET /api/bookings/stats`. Nothing is summed client-side.
class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  bool _showCollected = false;

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(paymentStatsProvider).value;
    final async = _showCollected
        ? ref.watch(collectedProvider)
        : ref.watch(receivablesProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Payments', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: Column(
        children: [
          if (stats != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AppSpacing.x12,
                AppSpacing.gutter,
                0,
              ),
              child: _SummaryCard(stats: stats),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: Row(
              children: [
                _Tab(
                  label: 'Receivable',
                  active: !_showCollected,
                  onTap: () => setState(() => _showCollected = false),
                ),
                const SizedBox(width: AppSpacing.x8),
                _Tab(
                  label: 'Collected',
                  active: _showCollected,
                  onTap: () => setState(() => _showCollected = true),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (async) {
              AsyncLoading() => const SkeletonList(),
              AsyncError(:final error) => ErrorStateView(
                  failure: asFailure(error),
                  onRetry: () => ref
                    ..invalidate(receivablesProvider)
                    ..invalidate(collectedProvider),
                ),
              AsyncData(:final value) => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    ref
                      ..invalidate(receivablesProvider)
                      ..invalidate(collectedProvider)
                      ..invalidate(paymentStatsProvider);
                  },
                  child: value.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: 360,
                              child: EmptyStateView(
                                icon: Ic.wallet,
                                title: _showCollected
                                    ? 'Nothing collected yet'
                                    : 'Nothing outstanding',
                                message: _showCollected
                                    ? 'Recorded payments will appear here.'
                                    : 'Every booking is fully paid.',
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.gutter,
                            0,
                            AppSpacing.gutter,
                            AppSpacing.x24,
                          ),
                          itemCount: value.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.x12),
                          itemBuilder: (context, index) => _PaymentRow(
                            booking: value[index],
                            showCollected: _showCollected,
                            onRecord: () => RecordPaymentSheet.show(
                              context,
                              bookingId: value[index].id,
                              customerName: value[index].customerName,
                              balance: value[index].pendingAmount,
                            ),
                            onOpen: () =>
                                context.push(Routes.bookingDetailFor(value[index].id)),
                          ),
                        ),
                ),
            },
          ),
        ],
      ),
    );
  }
}

/// The dark summary card from the prototype — every figure server-computed.
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.stats});

  final BookingStats stats;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      gradient: AppGradients.inkHero,
      borderColor: AppColors.ink,
      shadow: AppShadows.darkGlow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Outstanding',
            style: AppType.caption.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          Text(
            Inr.format(stats.totalPending),
            style: AppType.monoHero.copyWith(color: AppColors.onPrimary),
          ),
          const SizedBox(height: AppSpacing.x16),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: 'Collected',
                  value: Inr.compact(stats.totalCollected),
                ),
              ),
              Expanded(
                child: _Stat(
                  label: 'Billed',
                  value: Inr.compact(stats.totalRevenue),
                ),
              ),
              if (stats.totalRefunded > 0)
                Expanded(
                  child: _Stat(
                    label: 'Refunded',
                    value: Inr.compact(stats.totalRefunded),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppType.caption.copyWith(
            color: AppColors.onPrimary.withValues(alpha: 0.65),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(value, style: AppType.monoStrong.copyWith(color: AppColors.onPrimary)),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: active,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          child: Container(
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.chip),
              border: Border.all(color: active ? AppColors.primary : AppColors.border),
            ),
            child: Text(
              label,
              style: AppType.tab.copyWith(
                color: active ? AppColors.onPrimary : AppColors.body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.booking,
    required this.showCollected,
    required this.onRecord,
    required this.onOpen,
  });

  final Booking booking;
  final bool showCollected;
  final VoidCallback onRecord;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final days = booking.daysToTravel;
    // Money owed on a trip that has already left is the thing to chase first.
    final overdue = days != null && days < 0 && booking.pendingAmount > 0;
    final payment = booking.paymentStatus;

    return AppCard(
      onTap: onOpen,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.customerName.isEmpty
                          ? 'Unnamed booking'
                          : booking.customerName,
                      style: AppType.h3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      [
                        if (booking.code != null) booking.code!,
                        if (booking.travelDate != null)
                          AppDate.display(booking.travelDate),
                      ].join(' · '),
                      style: AppType.bodySm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (payment != null)
                StatusChip(
                  label: payment.label,
                  palette: StatusColors.paymentStatus(payment),
                  dense: true,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showCollected ? 'Collected' : 'Outstanding',
                      style: AppType.caption.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      Inr.format(
                        showCollected ? booking.paidAmount : booking.pendingAmount,
                      ),
                      style: AppType.monoStrong.copyWith(
                        color: overdue
                            ? AppColors.danger
                            : showCollected
                                ? AppColors.success
                                : AppColors.ink,
                      ),
                    ),
                    if (overdue) ...[
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        'Travelled ${-days} day${days == -1 ? '' : 's'} ago',
                        style: AppType.caption.copyWith(
                          fontSize: 11,
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!showCollected)
                FilledButton(
                  onPressed: onRecord,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x16,
                      vertical: AppSpacing.x10,
                    ),
                  ),
                  child: const Text('Record'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x10),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: booking.paidFraction,
              minHeight: 5,
              backgroundColor: AppColors.line,
              valueColor: AlwaysStoppedAnimation(
                overdue
                    ? AppColors.danger
                    : booking.pendingAmount > 0
                        ? AppColors.warn
                        : AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
