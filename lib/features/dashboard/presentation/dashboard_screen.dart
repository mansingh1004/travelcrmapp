import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/lead.dart';
import '../../../domain/entities/lead_enums.dart';
import '../../../domain/repositories/lead_repository.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/state_views.dart';
import '../../auth/providers/auth_controller.dart';
import '../../leads/presentation/widgets/lead_card.dart';
import '../../leads/providers/leads_controller.dart';

/// Today's follow-up queue — `GET /api/leads?followUpDueBy=today`, i.e. the
/// leads whose follow-up is due today or already overdue.
final _followUpsProvider = FutureProvider.autoDispose<List<Lead>>((ref) async {
  final page = await ref.watch(leadRepositoryProvider).getLeads(
        size: 20,
        sortBy: 'followUpDate',
        sortDir: 'asc',
        filter: LeadFilter(followUpDueBy: DateTime.now(), activeOnly: true),
      );
  return page.leads;
});

/// The lead roll-up — `GET /api/leads/stats/summary`, computed in the database
/// over the caller's row scope for the tenant's current month.
final _statsProvider = FutureProvider.autoDispose<LeadStats>(
  (ref) => ref.watch(leadRepositoryProvider).getStats(),
);

/// Dashboard.
///
/// Every figure comes from real server aggregates, not from counting the rows
/// that happen to be loaded. The prototype's quotation, operations and payment
/// tiles wait on those screens being wired — the endpoints exist.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final stats = ref.watch(_statsProvider);

    return switch (stats) {
      AsyncLoading() => const SkeletonList(),
      AsyncError(:final error) => ErrorStateView(
          failure: asFailure(error),
          onRetry: () => ref.invalidate(_statsProvider),
        ),
      AsyncData(:final value) => _Content(
          greetingName: session?.displayName ?? 'there',
          stats: value,
        ),
    };
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.greetingName, required this.stats});

  final String greetingName;
  final LeadStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final followUps = ref.watch(_followUpsProvider);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref
          ..invalidate(_statsProvider)
          ..invalidate(_followUpsProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          Text(_greeting(now), style: AppType.caption),
          const SizedBox(height: AppSpacing.x2),
          Text(greetingName, style: AppType.h1Large),
          const SizedBox(height: AppSpacing.x16),
          _PipelineCard(stats: stats),
          const SizedBox(height: AppSpacing.x16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.x12,
            crossAxisSpacing: AppSpacing.x12,
            // The spec's tile is 12px padding + a 28px icon + a 21px figure +
            // an 11px label ≈ 104pt tall against ~175pt of width. Still leaves
            // room for text scaled to 1.3x.
            childAspectRatio: 1.62,
            children: [
              _KpiTile(
                label: 'New leads',
                value: stats.byStage[LeadStage.newLead] ?? 0,
                icon: Ic.users,
                palette: StatusColors.stage(LeadStage.newLead),
                onTap: () => _openLeads(ref, context, stage: LeadStage.newLead),
              ),
              _KpiTile(
                label: 'Hot leads',
                value: stats.hotLeads,
                icon: Ic.flame,
                palette: StatusColors.priority(LeadType.hot),
                onTap: () => _openLeads(ref, context, type: LeadType.hot),
              ),
              _KpiTile(
                label: 'Follow-ups due',
                value: stats.followUpsDueToday + stats.followUpsOverdue,
                icon: Ic.clock,
                // Overdue follow-ups are the number worth reacting to.
                palette: stats.followUpsOverdue > 0
                    ? const StatusPalette(AppColors.danger, AppColors.dangerBg)
                    : StatusColors.stage(LeadStage.followUp),
                caption: stats.followUpsOverdue > 0
                    ? '${stats.followUpsOverdue} overdue'
                    : null,
                onTap: () => _openLeads(ref, context, followUpDue: true),
              ),
              _KpiTile(
                label: 'Quotations sent',
                value: stats.proposalSentLeads,
                icon: Ic.file,
                palette: StatusColors.stage(LeadStage.proposalSent),
                onTap: () => _openLeads(ref, context, stage: LeadStage.proposalSent),
              ),
              _KpiTile(
                label: 'Won this month',
                value: stats.convertedInPeriod,
                icon: Ic.target,
                palette: StatusColors.stage(LeadStage.converted),
                caption: stats.conversionRate == null
                    ? null
                    : '${stats.conversionRate!.toStringAsFixed(0)}% conversion',
                onTap: () => _openLeads(ref, context, stage: LeadStage.converted),
              ),
              _KpiTile(
                label: 'Lost',
                value: stats.lostLeads,
                icon: Ic.close,
                palette: StatusColors.stage(LeadStage.lost),
                onTap: () => _openLeads(ref, context, stage: LeadStage.lost),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x24),
          Row(
            children: [
              Text("Today's follow-ups", style: AppType.h2),
              const Spacer(),
              TextButton(
                onPressed: () => _openLeads(ref, context, followUpDue: true),
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          switch (followUps) {
            AsyncLoading() => const SkeletonList(itemCount: 2, itemHeight: 150),
            AsyncError() => AppCard(
                child: Text('Could not load follow-ups.', style: AppType.bodySm),
              ),
            AsyncData(:final value) => value.isEmpty
                ? AppCard(
                    child: Row(
                      children: [
                        const AppIcon(Ic.checkCircle, size: 20, color: AppColors.success),
                        const SizedBox(width: AppSpacing.x12),
                        Expanded(
                          child: Text(
                            'Nothing due today. Nice.',
                            style: AppType.bodySm,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      for (final lead in value.take(5))
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.x12),
                          child: LeadCard(
                            lead: lead,
                            onTap: () => context.push(Routes.leadDetailFor(lead.id)),
                          ),
                        ),
                    ],
                  ),
          },
          const SizedBox(height: AppSpacing.x24),
        ],
      ),
    );
  }

  /// Deep-link into the leads list with the filter pre-applied server-side.
  void _openLeads(
    WidgetRef ref,
    BuildContext context, {
    LeadStage? stage,
    LeadType? type,
    bool followUpDue = false,
  }) {
    ref.read(leadFilterProvider.notifier).set(
          LeadFilter(
            stage: stage,
            type: type,
            followUpDueBy: followUpDue ? DateTime.now() : null,
            activeOnly: followUpDue ? true : null,
          ),
        );
    context.go(Routes.leads);
  }

  String _greeting(DateTime now) {
    if (now.hour < 12) return 'Good morning';
    if (now.hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}

/// Active pipeline value and quoted value — the money roll-up the server
/// computes. Replaces the prototype's monthly-target card, which has no
/// backing entity.
class _PipelineCard extends StatelessWidget {
  const _PipelineCard({required this.stats});

  final LeadStats stats;

  @override
  Widget build(BuildContext context) {
    final total = stats.totalLeads;
    final active = stats.activeLeads;
    final ratio = total == 0 ? 0.0 : (active / total).clamp(0.0, 1.0);

    return AppCard(
      gradient: AppGradients.brandHero,
      borderColor: AppColors.primaryDeep,
      shadow: AppShadows.heroGlow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active pipeline',
                style: AppType.caption.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.75),
                ),
              ),
              const Spacer(),
              Text(
                '$active of $total leads',
                style: AppType.caption.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x8),
          Text(
            Inr.compact(stats.activePipelineValue),
            style: AppType.monoDisplay.copyWith(color: AppColors.onPrimary),
          ),
          const SizedBox(height: AppSpacing.x12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.onPrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Quoted',
                  value: Inr.compact(stats.quotedValue),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'New this month',
                  value: '${stats.createdInPeriod}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

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
            color: AppColors.onPrimary.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(value, style: AppType.monoStrong.copyWith(color: AppColors.onPrimary)),
      ],
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.palette,
    required this.onTap,
    this.caption,
  });

  final String label;
  final int value;
  final String icon;
  final StatusPalette palette;
  final VoidCallback onTap;

  /// Optional second line, e.g. "3 overdue".
  final String? caption;

  @override
  Widget build(BuildContext context) {
    // Packed, not spaced: the spec stacks icon → figure → label with fixed 9px
    // and 2px gaps. A `Spacer` here pushed the figure to the bottom and left a
    // hole the design does not have.
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: palette.background,
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                ),
                child: AppIcon(icon, size: 16, color: palette.foreground),
              ),
              const Spacer(),
              // The spec puts the delta up here beside the icon, not under the
              // label — it reads as an annotation on the figure.
              if (caption != null)
                Flexible(
                  child: Text(
                    caption!,
                    style: AppType.navLabel.copyWith(color: palette.foreground),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x8),
          Text('$value', style: AppType.monoDisplay, maxLines: 1),
          const SizedBox(height: AppSpacing.x2),
          Text(
            label,
            style: AppType.caption.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
