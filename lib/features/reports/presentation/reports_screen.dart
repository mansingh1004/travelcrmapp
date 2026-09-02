import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/chart_colors.dart';
import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/analytics.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/state_views.dart';
import '../../../router/safe_pop.dart';

/// Which period the report covers. These are the server's own tokens.
enum ReportPeriod {
  today('today', 'Today'),
  week('week', 'Week'),
  month('month', 'Month'),
  quarter('quarter', 'Quarter'),
  year('year', 'Year');

  const ReportPeriod(this.wire, this.label);

  final String wire;
  final String label;
}

final reportPeriodProvider =
    NotifierProvider<ReportPeriodNotifier, ReportPeriod>(ReportPeriodNotifier.new);

class ReportPeriodNotifier extends Notifier<ReportPeriod> {
  @override
  ReportPeriod build() => ReportPeriod.month;

  void set(ReportPeriod period) => state = period;
}

final analyticsProvider = FutureProvider.autoDispose<Analytics>((ref) {
  final period = ref.watch(reportPeriodProvider);
  return ref.watch(reportsApiProvider).getAnalytics(period: period.wire);
});

/// Reports — KPIs, revenue over time, lead sources, destinations and agents.
///
/// Charts follow one rule each: a single measure over time or across agents is
/// **one hue** (rank is already carried by bar length and order, so colouring
/// by rank would invent a category); lead sources are a real categorical split
/// and use the validated ordered palette, folding the tail into "Other".
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(analyticsProvider);
    final period = ref.watch(reportPeriodProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Reports', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: Column(
        children: [
          _PeriodBar(
            selected: period,
            onSelect: (p) => ref.read(reportPeriodProvider.notifier).set(p),
          ),
          Expanded(
            child: switch (async) {
              AsyncLoading() => const SkeletonList(itemCount: 4, itemHeight: 130),
              // A 403 here means the role cannot see tenant-wide numbers, which
              // is not something a retry can fix — say so instead.
              AsyncError(:final error) when error is PermissionFailure =>
                EmptyStateView(
                  icon: Ic.shield,
                  title: 'Reports are restricted',
                  message: error.message,
                ),
              AsyncError(:final error) => ErrorStateView(
                  failure: asFailure(error),
                  onRetry: () => ref.invalidate(analyticsProvider),
                ),
              AsyncData(:final value) => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => ref.invalidate(analyticsProvider),
                  child: _Report(analytics: value),
                ),
            },
          ),
        ],
      ),
    );
  }
}

class _Report extends StatelessWidget {
  const _Report({required this.analytics});

  final Analytics analytics;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      children: [
        // Headline numbers are stat tiles, not charts: a single value has no
        // shape to read.
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.x12,
          crossAxisSpacing: AppSpacing.x12,
          childAspectRatio: 1.5,
          children: [
            _Kpi(label: 'Revenue', value: Inr.compact(analytics.revenue)),
            _Kpi(label: 'Leads', value: '${analytics.totalLeads}'),
            _Kpi(
              label: 'Conversion',
              value: '${analytics.conversionRate.toStringAsFixed(1)}%',
              caption: '${analytics.convertedLeads} converted',
            ),
            if (analytics.canSeeProfit)
              _Kpi(
                label: 'Profit',
                value: Inr.compact(analytics.totalProfit ?? analytics.profit),
                caption: analytics.netMargin == null
                    ? null
                    : '${analytics.netMargin!.toStringAsFixed(1)}% margin',
              )
            else
              _Kpi(label: 'Hot leads', value: '${analytics.hotLeads}'),
          ],
        ),
        if (analytics.revenueTimeline.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x16),
          _TimelineChart(points: analytics.revenueTimeline),
        ],
        if (analytics.leadSources.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x12),
          _SourcesChart(sources: analytics.leadSources),
        ],
        if (analytics.topPerformers.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x12),
          _AgentsChart(agents: analytics.topPerformers),
        ],
        if (analytics.topDestinations.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x12),
          _DestinationsChart(destinations: analytics.topDestinations),
        ],
        const SizedBox(height: AppSpacing.x24),
      ],
    );
  }
}

class _PeriodBar extends StatelessWidget {
  const _PeriodBar({required this.selected, required this.onSelect});

  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.x12,
        AppSpacing.gutter,
        AppSpacing.x12,
      ),
      child: Row(
        children: [
          for (final period in ReportPeriod.values) ...[
            if (period != ReportPeriod.values.first) const SizedBox(width: AppSpacing.x6),
            Expanded(
              child: Semantics(
                button: true,
                selected: period == selected,
                child: InkWell(
                  onTap: () => onSelect(period),
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: period == selected ? AppColors.primary : AppColors.canvas,
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                    ),
                    child: Text(
                      period.label,
                      style: AppType.tab.copyWith(
                        fontSize: 11.5,
                        color: period == selected
                            ? AppColors.onPrimary
                            : AppColors.body,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({required this.label, required this.value, this.caption});

  final String label;
  final String value;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppType.caption),
          const SizedBox(height: AppSpacing.x6),
          Text(value, style: AppType.monoDisplay, maxLines: 1),
          if (caption != null) ...[
            const SizedBox(height: AppSpacing.x2),
            Text(
              caption!,
              style: AppType.caption.copyWith(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Revenue over time. One measure, one hue — no legend, because the title
/// already names the series.
class _TimelineChart extends StatelessWidget {
  const _TimelineChart({required this.points});

  final List<TimelinePoint> points;

  @override
  Widget build(BuildContext context) {
    final max = points.fold<double>(0, (m, p) => p.revenue > m ? p.revenue : m);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue trend', style: AppType.h3),
          const SizedBox(height: AppSpacing.x16),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final point in points)
                  Expanded(
                    child: Padding(
                      // 2px of surface between bars so adjacent fills never
                      // touch and read as one block.
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            Inr.compact(point.revenue),
                            style: AppType.caption.copyWith(fontSize: 9),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          // Bars are anchored to the baseline with rounded
                          // tops only; a rounded bottom would float the bar
                          // off its own axis.
                          Container(
                            height: max <= 0
                                ? 2
                                : (point.revenue / max * 92).clamp(2, 92).toDouble(),
                            decoration: const BoxDecoration(
                              color: ChartColors.series,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x6),
                          Text(
                            point.label,
                            style: AppType.caption.copyWith(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lead sources — a genuine categorical split, so the ordered palette applies.
/// Past five, the tail folds into "Other" rather than getting invented hues.
class _SourcesChart extends StatelessWidget {
  const _SourcesChart({required this.sources});

  final List<NamedValue> sources;

  @override
  Widget build(BuildContext context) {
    final ranked = [...sources]..sort((a, b) => b.value.compareTo(a.value));
    final head = ranked.take(ChartColors.maxCategories).toList();
    final tail = ranked.skip(ChartColors.maxCategories);
    final rows = <(String, double, Color)>[
      for (var i = 0; i < head.length; i++)
        (head[i].name, head[i].value, ChartColors.at(i)),
      if (tail.isNotEmpty)
        (
          'Other',
          tail.fold<double>(0, (sum, s) => sum + s.value),
          ChartColors.other,
        ),
    ];

    final total = rows.fold<double>(0, (sum, r) => sum + r.$2);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lead sources', style: AppType.h3),
          const SizedBox(height: AppSpacing.x14),
          for (final (name, value, color) in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x12),
              child: _BarRow(
                label: name,
                // Every row is directly labelled, so identity never rests on
                // colour alone.
                value: '${value.toStringAsFixed(0)}'
                    '${total > 0 ? ' · ${(value / total * 100).toStringAsFixed(0)}%' : ''}',
                fraction: total <= 0 ? 0 : value / total,
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}

/// Agent performance. One measure ranked — one hue, because the ordering is
/// the ranking; a colour per row would imply a category that is not there.
class _AgentsChart extends StatelessWidget {
  const _AgentsChart({required this.agents});

  final List<AgentStat> agents;

  @override
  Widget build(BuildContext context) {
    final max = agents.fold<double>(0, (m, a) => a.revenue > m ? a.revenue : m);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Agent performance', style: AppType.h3),
          const SizedBox(height: AppSpacing.x14),
          for (final agent in agents.take(8))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x12),
              child: _BarRow(
                label: agent.name,
                value: '${Inr.compact(agent.revenue)} · '
                    '${agent.conversions}/${agent.leads}',
                fraction: max <= 0 ? 0 : agent.revenue / max,
                color: ChartColors.series,
              ),
            ),
        ],
      ),
    );
  }
}

class _DestinationsChart extends StatelessWidget {
  const _DestinationsChart({required this.destinations});

  final List<DestinationStat> destinations;

  @override
  Widget build(BuildContext context) {
    final max =
        destinations.fold<double>(0, (m, d) => d.revenue > m ? d.revenue : m);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top destinations', style: AppType.h3),
          const SizedBox(height: AppSpacing.x14),
          for (final destination in destinations.take(8))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x12),
              child: _BarRow(
                label: destination.name,
                value: '${Inr.compact(destination.revenue)} · '
                    '${destination.bookings} booking'
                    '${destination.bookings == 1 ? '' : 's'}',
                fraction: max <= 0 ? 0 : destination.revenue / max,
                color: ChartColors.series,
              ),
            ),
        ],
      ),
    );
  }
}

/// One labelled horizontal bar. The label and value sit in text ink, never the
/// series colour — the bar beside them carries the identity.
class _BarRow extends StatelessWidget {
  const _BarRow({
    required this.label,
    required this.value,
    required this.fraction,
    required this.color,
  });

  final String label;
  final String value;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label, $value',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppType.fieldValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.x8),
              Text(value, style: AppType.monoSm),
            ],
          ),
          const SizedBox(height: AppSpacing.x6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.line,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
