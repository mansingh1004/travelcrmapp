import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/operations.dart';
import '../../../domain/entities/operations_enums.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../providers/operations_controller.dart';
import '../../../router/safe_pop.dart';

/// Operations detail — one booking's nine checkpoints.
///
/// Severity and "ready to travel" are **derived server-side** at read time, so
/// after any change the screen re-reads rather than recomputing locally.
class OperationsDetailScreen extends ConsumerWidget {
  const OperationsDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(opsDetailProvider(bookingId));

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Operations', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (async) {
        AsyncLoading() => const SkeletonList(itemCount: 3, itemHeight: 140),
        // A 404 here is not a failure. The server provisions the operations
        // record when the booking is confirmed, so an unconfirmed booking
        // legitimately has none — and "Something went wrong · Retry" invites a
        // retry that can never succeed.
        AsyncError(:final error) when asFailure(error) is NotFoundFailure =>
          const EmptyStateView(
            icon: Ic.target,
            title: 'No operations yet',
            message: 'The checklist is created when the booking is confirmed. '
                'Confirm the booking to start tracking its services.',
          ),
        AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () => ref.invalidate(opsDetailProvider(bookingId)),
          ),
        AsyncData(:final value) => _Detail(detail: value),
      },
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.detail});

  final OpsDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final severity = detail.severity;
    final outstanding = detail.checkpoints.where((c) => c.isOutstanding).toList();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.invalidate(opsDetailProvider(detail.bookingId)),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          if (severity != null &&
              (severity == OpsSeverity.critical || severity == OpsSeverity.warning))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x12),
              child: _SeverityBanner(detail: detail, severity: severity),
            ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        detail.bookingCode ?? 'Booking',
                        style: AppType.h1,
                      ),
                    ),
                    StatusChip(
                      label: detail.readyToTravel ? 'Ready to travel' : 'Not ready',
                      palette: detail.readyToTravel
                          ? const StatusPalette(AppColors.success, AppColors.successBg)
                          : const StatusPalette(AppColors.warn, AppColors.warnBg),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x12),
                if (detail.departureAt != null)
                  _Row(
                    label: 'Departs',
                    value: AppDate.dateTime(detail.departureAt),
                    // A time the server only assumed must not read as confirmed.
                    hint: detail.departureSourceLabel,
                  ),
                if (detail.hoursToDeparture != null)
                  _Row(
                    label: 'Countdown',
                    value: detail.hoursToDeparture! < 0
                        ? 'Departed ${-detail.hoursToDeparture!}h ago'
                        : 'In ${detail.hoursToDeparture}h',
                  ),
                if (detail.tripEndDate != null)
                  _Row(label: 'Returns', value: AppDate.display(detail.tripEndDate)),
                if (detail.pickupLocation != null)
                  _Row(
                    label: 'Pickup',
                    value: detail.pickupLocation!,
                    hint: detail.pickupAt == null
                        ? null
                        : AppDate.dateTime(detail.pickupAt),
                  ),
                if (detail.dropLocation != null)
                  _Row(
                    label: 'Drop',
                    value: detail.dropLocation!,
                    hint: detail.dropAt == null ? null : AppDate.dateTime(detail.dropAt),
                  ),
                if (detail.opsOwnerName != null)
                  _Row(label: 'Ops owner', value: detail.opsOwnerName!),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _LinkRow(
                  icon: Ic.package,
                  label: 'View booking',
                  onTap: () =>
                      context.push(Routes.bookingDetailFor(detail.bookingId)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Checkpoints', style: AppType.h3),
                    const Spacer(),
                    Text(
                      '${detail.confirmedCount}/${detail.checkpoints.length} done',
                      style: AppType.monoSm,
                    ),
                  ],
                ),
                if (detail.checkpoints.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
                    child: Text(
                      'No checkpoints yet — generate the trip plan from the '
                      'booking first.',
                      style: AppType.bodySm,
                    ),
                  )
                else
                  // Outstanding first: the point of this screen is what still
                  // needs doing, not a full audit trail.
                  Column(
                    children: [
                      for (final checkpoint in [
                        ...outstanding,
                        ...detail.checkpoints.where((c) => !c.isOutstanding),
                      ])
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.x12),
                          child: _CheckpointRow(
                            bookingId: detail.bookingId,
                            checkpoint: checkpoint,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x24),
        ],
      ),
    );
  }
}

class _SeverityBanner extends StatelessWidget {
  const _SeverityBanner({required this.detail, required this.severity});

  final OpsDetail detail;
  final OpsSeverity severity;

  @override
  Widget build(BuildContext context) {
    final palette = StatusColors.opsSeverity(severity);
    final outstanding = detail.checkpoints.where((c) => c.isOutstanding).length;

    return AppCard(
      background: palette.background,
      borderColor: palette.foreground.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon(Ic.alert, size: 18, color: palette.foreground),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  severity.label,
                  style: AppType.h3.copyWith(color: palette.foreground),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  outstanding == 0
                      ? 'This booking needs attention before departure.'
                      : '$outstanding checkpoint${outstanding == 1 ? '' : 's'} still '
                          'outstanding before departure.',
                  style: AppType.bodySm.copyWith(color: palette.foreground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One checkpoint, with a status picker that commits a sparse patch.
class _CheckpointRow extends ConsumerWidget {
  const _CheckpointRow({required this.bookingId, required this.checkpoint});

  final String bookingId;
  final OpsCheckpointFact checkpoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = checkpoint.status;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      checkpoint.label,
                      style: AppType.fieldValue,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (checkpoint.mandatory) ...[
                    const SizedBox(width: AppSpacing.x6),
                    Text('required', style: AppType.caption.copyWith(fontSize: 10)),
                  ],
                ],
              ),
              if (checkpoint.vendorName != null || checkpoint.referenceNo != null) ...[
                const SizedBox(height: AppSpacing.x2),
                Text(
                  [
                    if (checkpoint.vendorName != null) checkpoint.vendorName!,
                    if (checkpoint.referenceNo != null) checkpoint.referenceNo!,
                  ].join(' · '),
                  style: AppType.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (checkpoint.dueAt != null) ...[
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Due ${AppDate.dateTime(checkpoint.dueAt)}',
                  style: AppType.monoSm,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x8),
        Semantics(
          button: true,
          label: '${checkpoint.label} status: ${status?.label ?? 'unset'}. Tap to change.',
          child: InkWell(
            onTap: () => _pick(context, ref),
            borderRadius: BorderRadius.circular(AppRadii.chip),
            child: StatusChip(
              label: status?.label ?? 'Set',
              palette: status == null
                  ? StatusColors.neutral
                  : StatusColors.opsCheckpoint(status),
              dense: true,
              trailingIcon: Ic.chevronDown,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final picked = await showModalBottomSheet<OpsCheckpointStatus>(
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
                child: Text(checkpoint.label, style: AppType.h2),
              ),
              for (final status in OpsCheckpointStatus.values)
                ListTile(
                  onTap: () => Navigator.of(context).pop(status),
                  leading: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: StatusColors.opsCheckpoint(status).foreground,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(status.label, style: AppType.fieldValue),
                  trailing: status == checkpoint.status
                      ? const AppIcon(Ic.check, size: 18, color: AppColors.primary)
                      : null,
                ),
              const SizedBox(height: AppSpacing.x8),
            ],
          ),
        ),
      ),
    );

    if (picked == null || picked == checkpoint.status || !context.mounted) return;

    try {
      await ref.read(opsActionsProvider).setCheckpointStatus(
            bookingId,
            checkpoint.id,
            picked,
          );
      if (context.mounted) {
        AppToast.show(
          context,
          title: checkpoint.label,
          message: 'Marked ${picked.label.toLowerCase()}.',
        );
      }
    } on Failure catch (f) {
      if (context.mounted) {
        AppToast.error(context, 'Could not update checkpoint', f.message);
      }
    }
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

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.hint});

  final String label;
  final String value;

  /// Secondary line — e.g. how a departure time was arrived at.
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: AppType.caption)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppType.fieldValue),
                if (hint != null)
                  Text(hint!, style: AppType.caption.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
