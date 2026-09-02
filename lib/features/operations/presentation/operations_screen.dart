import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/operations.dart';
import '../../../domain/entities/operations_enums.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../providers/operations_controller.dart';
import '../../../router/safe_pop.dart';

/// Operations board — departures in the window, nearest first.
///
/// Every number here is server-computed: the tab counts use the same predicate
/// as their lists, readiness and severity are derived against the tenant's
/// clock, and the headline cards count the whole window rather than the page.
class OperationsScreen extends ConsumerStatefulWidget {
  const OperationsScreen({super.key});

  @override
  ConsumerState<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends ConsumerState<OperationsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 320) {
      ref.read(opsBoardControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(opsBoardControllerProvider);
    final query = ref.watch(opsQueryProvider);
    final counts = ref.watch(opsTabCountsProvider).value ?? const <OpsBoardTab, int>{};
    final summary = ref.watch(opsSummaryProvider).value;

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
      body: Column(
        children: [
          _WindowBar(
            from: query.from,
            to: query.to,
            onToday: () => ref.read(opsQueryProvider.notifier).setDay(DateTime.now()),
            onTomorrow: () => ref
                .read(opsQueryProvider.notifier)
                .setDay(DateTime.now().add(const Duration(days: 1))),
            onWeek: () {
              final now = DateTime.now();
              ref
                  .read(opsQueryProvider.notifier)
                  .setWindow(now, now.add(const Duration(days: 7)));
            },
            onAll: () => ref.read(opsQueryProvider.notifier).setWindow(null, null),
          ),
          if (summary != null) _SummaryStrip(summary: summary),
          _TabStrip(
            selected: query.tab,
            counts: counts,
            onSelect: (tab) => ref.read(opsQueryProvider.notifier).setTab(tab),
          ),
          Expanded(
            child: switch (async) {
              AsyncLoading() when async.value == null => const SkeletonList(),
              AsyncError(:final error) => ErrorStateView(
                  failure: asFailure(error),
                  onRetry: () => ref.read(opsBoardControllerProvider.notifier).refresh(),
                ),
              _ => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => ref.read(opsBoardControllerProvider.notifier).refresh(),
                  child: async.value!.rows.isEmpty
                      ? _emptyState(query)
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(AppSpacing.gutter),
                          itemCount:
                              async.value!.rows.length + (async.value!.hasMore ? 1 : 0),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.x12),
                          itemBuilder: (context, index) {
                            final rows = async.value!.rows;
                            if (index >= rows.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: AppSpacing.x20),
                                child: Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              );
                            }
                            final row = rows[index];
                            return _OpsCard(
                              row: row,
                              onTap: () =>
                                  context.push(Routes.operationsDetailFor(row.bookingId)),
                            );
                          },
                        ),
                ),
            },
          ),
        ],
      ),
    );
  }

  Widget _emptyState(OpsQuery query) {
    return ListView(
      children: [
        SizedBox(
          height: 380,
          child: query.tab == OpsBoardTab.all
              ? const EmptyStateView(
                  icon: Ic.checkCircle,
                  title: 'Nothing departing',
                  message: 'No bookings depart in this window.',
                )
              : EmptyStateView(
                  icon: Ic.checkCircle,
                  title: 'Nothing here',
                  message: 'No booking is in "${query.tab.label}" right now.',
                  actionLabel: 'Show all',
                  onAction: () =>
                      ref.read(opsQueryProvider.notifier).setTab(OpsBoardTab.all),
                ),
        ),
      ],
    );
  }
}

/// Today / Tomorrow / This week / All — the spec's window shortcuts.
class _WindowBar extends StatelessWidget {
  const _WindowBar({
    required this.from,
    required this.to,
    required this.onToday,
    required this.onTomorrow,
    required this.onWeek,
    required this.onAll,
  });

  final DateTime? from;
  final DateTime? to;
  final VoidCallback onToday;
  final VoidCallback onTomorrow;
  final VoidCallback onWeek;
  final VoidCallback onAll;

  bool _isSameDay(DateTime? a, DateTime b) =>
      a != null && a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final singleDay = from != null && to != null && _isSameDay(from, to!);

    final todayActive = singleDay && _isSameDay(from, now);
    final tomorrowActive =
        singleDay && _isSameDay(from, now.add(const Duration(days: 1)));
    final weekActive = from != null && to != null && !singleDay;
    final allActive = from == null && to == null;

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.x12,
        AppSpacing.gutter,
        AppSpacing.x12,
      ),
      child: Row(
        children: [
          _Pill(label: 'Today', active: todayActive, onTap: onToday),
          const SizedBox(width: AppSpacing.x8),
          _Pill(label: 'Tomorrow', active: tomorrowActive, onTap: onTomorrow),
          const SizedBox(width: AppSpacing.x8),
          _Pill(label: 'This week', active: weekActive, onTap: onWeek),
          const SizedBox(width: AppSpacing.x8),
          _Pill(label: 'All open', active: allActive, onTap: onAll),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.active, required this.onTap});

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
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.canvas,
              borderRadius: BorderRadius.circular(AppRadii.chip),
            ),
            child: Text(
              label,
              style: AppType.tab.copyWith(
                color: active ? AppColors.onPrimary : AppColors.body,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

/// Ready / Action needed / Urgent, plus balance still owed across the window.
class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.summary});

  final OpsSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.x12,
      ),
      child: Row(
        children: [
          _Stat(
            label: 'Ready',
            value: '${summary.ready}',
            color: AppColors.success,
          ),
          _Stat(
            label: 'Action',
            value: '${summary.actionNeeded}',
            color: AppColors.warn,
          ),
          _Stat(
            label: 'Urgent',
            value: '${summary.urgent}',
            color: AppColors.danger,
          ),
          _Stat(
            label: 'Balance',
            value: Inr.compact(summary.balancePending),
            color: AppColors.primaryDeep,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppType.monoStrong.copyWith(color: color)),
          const SizedBox(height: AppSpacing.x2),
          Text(
            label,
            style: AppType.caption.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TabStrip extends StatelessWidget {
  const _TabStrip({
    required this.selected,
    required this.counts,
    required this.onSelect,
  });

  final OpsBoardTab selected;
  final Map<OpsBoardTab, int> counts;
  final ValueChanged<OpsBoardTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          0,
          AppSpacing.gutter,
          AppSpacing.x12,
        ),
        child: Row(
          children: [
            for (final tab in OpsBoardTab.values) ...[
              if (tab != OpsBoardTab.values.first) const SizedBox(width: AppSpacing.x8),
              _Tab(
                label: tab.label,
                count: counts[tab],
                active: tab == selected,
                palette: _paletteFor(tab),
                onTap: () => onSelect(tab),
              ),
            ],
          ],
        ),
      ),
    );
  }

  StatusPalette? _paletteFor(OpsBoardTab tab) => switch (tab) {
        OpsBoardTab.urgent ||
        OpsBoardTab.departingToday =>
          const StatusPalette(AppColors.danger, AppColors.dangerBg),
        OpsBoardTab.actionNeeded ||
        OpsBoardTab.holdExpiring ||
        OpsBoardTab.paymentPending =>
          const StatusPalette(AppColors.warn, AppColors.warnBg),
        OpsBoardTab.ready => const StatusPalette(AppColors.success, AppColors.successBg),
        _ => null,
      };
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
    this.palette,
  });

  final String label;
  final int? count;
  final bool active;
  final VoidCallback onTap;
  final StatusPalette? palette;

  @override
  Widget build(BuildContext context) {
    final accent = palette?.foreground ?? AppColors.primary;

    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
          decoration: BoxDecoration(
            color: active ? accent : AppColors.canvas,
            borderRadius: BorderRadius.circular(AppRadii.chip),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: AppType.tab.copyWith(
                  color: active ? AppColors.onPrimary : AppColors.body,
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: AppSpacing.x6),
                Text(
                  '$count',
                  style: AppType.monoSm.copyWith(
                    color: active
                        ? AppColors.onPrimary.withValues(alpha: 0.8)
                        : AppColors.faint,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A board row: departure countdown, per-dimension readiness, balance.
class _OpsCard extends StatelessWidget {
  const _OpsCard({required this.row, required this.onTap});

  final OpsBoardRow row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final overall = row.overallStatus;
    final days = row.daysToDeparture;
    final imminent = days != null && days >= 0 && days <= 2;

    return AppCard(
      onTap: onTap,
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
                      row.customerName.isEmpty ? 'Unnamed booking' : row.customerName,
                      style: AppType.h3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      [
                        if (row.bookingCode != null) row.bookingCode!,
                        if (row.destination != null) row.destination!,
                      ].join(' · '),
                      style: AppType.bodySm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (overall != null)
                StatusChip(
                  label: overall.label,
                  palette: StatusColors.opsOverall(overall),
                  dense: true,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          Wrap(
            spacing: AppSpacing.x14,
            runSpacing: AppSpacing.x6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (row.departureLabel != null)
                _Meta(
                  icon: Ic.clock,
                  text: row.departureLabel!,
                  color: imminent ? AppColors.danger : null,
                ),
              if (row.travelDate != null)
                _Meta(icon: Ic.calendar, text: AppDate.displayShort(row.travelDate)),
              if (row.pax > 0) _Meta(icon: Ic.users, text: '${row.pax} pax'),
              if (row.suppliersTotal > 0)
                _Meta(icon: Ic.checkCircle, text: row.supplierLabel),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          _ReadinessRow(readiness: row.readiness),
          if (row.balanceDue > 0) ...[
            const SizedBox(height: AppSpacing.x10),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.x10),
            Row(
              children: [
                const AppIcon(Ic.wallet, size: 15, color: AppColors.warn),
                const SizedBox(width: AppSpacing.x8),
                Text(
                  '${Inr.format(row.balanceDue)} still due',
                  style: AppType.monoSm.copyWith(color: AppColors.warn),
                ),
                const Spacer(),
                if (row.opsOwnerName != null)
                  Text(row.opsOwnerName!, style: AppType.caption),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// The eight readiness dimensions as a compact dot row.
class _ReadinessRow extends StatelessWidget {
  const _ReadinessRow({required this.readiness});

  final Map<OpsDimension, OpsReadinessStatus> readiness;

  @override
  Widget build(BuildContext context) {
    // Dimensions the server marked N/A are omitted rather than shown grey —
    // an absent row is clearer than a row that reads as "not done".
    final shown = readiness.entries
        .where((e) => e.value != OpsReadinessStatus.notApplicable)
        .toList();
    if (shown.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.x8,
      runSpacing: AppSpacing.x6,
      children: [
        for (final entry in shown)
          StatusChip(
            label: entry.key.label,
            palette: StatusColors.opsReadiness(entry.value),
            dense: true,
          ),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text, this.color});

  final String icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(icon, size: 14, color: color ?? AppColors.faint),
        const SizedBox(width: AppSpacing.x6),
        Text(
          text,
          style: color == null ? AppType.monoSm : AppType.monoSm.copyWith(color: color),
        ),
      ],
    );
  }
}
