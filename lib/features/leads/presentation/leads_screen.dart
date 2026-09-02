import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/errors/failure.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/lead_enums.dart';
import '../../../domain/repositories/lead_repository.dart';
import '../../../router/routes.dart';
import '../../../widgets/state_views.dart';
import '../providers/leads_controller.dart';
import 'widgets/lead_card.dart';

/// The leads list: search, stage tabs, sort, pull-to-refresh and pagination.
///
/// Search, stage/type filters, date ranges and sorting are all applied **in the
/// database** by `GET /api/leads`, and the tab counts come from
/// `GET /api/leads/stats/summary` — so both are global totals, not per-page.
class LeadsScreen extends ConsumerStatefulWidget {
  const LeadsScreen({super.key});

  @override
  ConsumerState<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends ConsumerState<LeadsScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

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
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 320) {
      ref.read(leadsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(leadsControllerProvider);
    final filter = ref.watch(leadFilterProvider);
    final counts = ref.watch(leadStageCountsProvider).value ?? const <LeadStage, int>{};

    return Column(
      children: [
        _SearchBar(
          controller: _searchController,
          onChanged: (q) => ref.read(leadFilterProvider.notifier).setQuery(q),
          onSort: _showSortSheet,
          onFilter: _showFilterSheet,
          sortLabel: ref.watch(leadSortProvider).label,
          appliedFilters: filter.appliedCount,
        ),
        _StageTabs(
          selected: filter.stage,
          counts: counts,
          total: counts.values.fold(0, (sum, c) => sum + c),
          onSelect: (stage) => ref.read(leadFilterProvider.notifier).setStage(stage),
        ),
        // Only over a loaded, non-empty list: the empty state carries its own
        // "Create lead" CTA, and a count of nothing is noise.
        if (async.value != null && async.value!.leads.isNotEmpty)
          _ResultBar(
            total: async.value!.totalElements,
            scope: filter.stage?.label.toLowerCase() ?? 'all',
            onAdd: () => context.push(Routes.leadCreate),
          ),
        Expanded(
          child: switch (async) {
            AsyncLoading() when async.value == null => const SkeletonList(),
            AsyncError(:final error) => ErrorStateView(
                failure: asFailure(error),
                onRetry: () => ref.read(leadsControllerProvider.notifier).refresh(),
              ),
            _ => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => ref.read(leadsControllerProvider.notifier).refresh(),
                child: async.value!.leads.isEmpty
                    ? _emptyState(filter)
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(AppSpacing.gutter),
                        itemCount: async.value!.leads.length + (async.value!.hasMore ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x12),
                        itemBuilder: (context, index) {
                          final leads = async.value!.leads;
                          if (index >= leads.length) {
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
                          final lead = leads[index];
                          return LeadCard(
                            lead: lead,
                            onTap: () => context.push(Routes.leadDetailFor(lead.id)),
                          );
                        },
                      ),
              ),
          },
        ),
      ],
    );
  }

  Widget _emptyState(LeadFilter filter) {
    final filtered = filter.appliedCount > 0;

    // ListView so pull-to-refresh still works on an empty list.
    return ListView(
      children: [
        SizedBox(
          height: 420,
          child: filtered
              ? EmptyStateView(
                  icon: Ic.search,
                  title: 'No matching leads',
                  message: 'No lead matches these filters.',
                  actionLabel: 'Clear filters',
                  onAction: () {
                    _searchController.clear();
                    ref.read(leadFilterProvider.notifier).clear();
                  },
                )
              : EmptyStateView(
                  icon: Ic.users,
                  title: 'No leads yet',
                  message: 'Create your first lead to start tracking enquiries.',
                  actionLabel: 'Create lead',
                  onAction: () => context.push(Routes.leadCreate),
                ),
        ),
      ],
    );
  }

  Future<void> _showSortSheet() async {
    final current = ref.read(leadSortProvider);

    final picked = await showModalBottomSheet<LeadSort>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SheetGrabber(),
              const _SheetTitle('Sort leads'),
              for (final sort in LeadSort.values)
                ListTile(
                  onTap: () => Navigator.of(context).pop(sort),
                  title: Text(sort.label, style: AppType.fieldValue),
                  trailing: sort == current
                      ? const AppIcon(Ic.check, size: 18, color: AppColors.primary)
                      : null,
                ),
              const SizedBox(height: AppSpacing.x8),
            ],
          ),
        ),
      ),
    );

    if (picked != null) ref.read(leadSortProvider.notifier).set(picked);
  }

  Future<void> _showFilterSheet() async {
    final applied = await showModalBottomSheet<LeadFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (context) => _FilterSheet(initial: ref.read(leadFilterProvider)),
    );

    if (applied != null) ref.read(leadFilterProvider.notifier).set(applied);
  }
}

class _SheetGrabber extends StatelessWidget {
  const _SheetGrabber();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle(this.text, {this.trailing});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x16),
      child: Row(
        children: [
          Text(text, style: AppType.h2),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}

/// Stage, priority, follow-up and active-only — every facet a real query param.
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial});

  final LeadFilter initial;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late LeadStage? _stage = widget.initial.stage;
  late LeadType? _type = widget.initial.type;
  late bool _activeOnly = widget.initial.activeOnly ?? false;
  late DateTime? _followUpDueBy = widget.initial.followUpDueBy;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: _SheetGrabber()),
            _SheetTitle(
              'Filter leads',
              trailing: TextButton(
                onPressed: () => setState(() {
                  _stage = null;
                  _type = null;
                  _activeOnly = false;
                  _followUpDueBy = null;
                }),
                child: const Text('Reset'),
              ),
            ),
            const _FilterLabel('Stage'),
            _ChipRow<LeadStage>(
              values: LeadStage.values,
              selected: _stage,
              labelOf: (s) => s.label,
              paletteOf: StatusColors.stage,
              onSelect: (s) => setState(() => _stage = s),
            ),
            const _FilterLabel('Priority'),
            _ChipRow<LeadType>(
              values: LeadType.values,
              selected: _type,
              labelOf: (t) => t.label,
              paletteOf: StatusColors.priority,
              onSelect: (t) => setState(() => _type = t),
            ),
            const _FilterLabel('Follow-up'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
              child: Wrap(
                spacing: AppSpacing.x8,
                children: [
                  _Toggle(
                    label: 'Due today or earlier',
                    active: _followUpDueBy != null,
                    onTap: () => setState(
                      () => _followUpDueBy = _followUpDueBy == null ? DateTime.now() : null,
                    ),
                  ),
                  _Toggle(
                    label: 'Active pipeline only',
                    active: _activeOnly,
                    onTap: () => setState(() => _activeOnly = !_activeOnly),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                    LeadFilter(
                      // Search stays owned by the search field.
                      search: widget.initial.search,
                      stage: _stage,
                      type: _type,
                      // The server rejects a stage of "Active"; activeOnly is a
                      // separate predicate, so never send both.
                      activeOnly: _stage == null && _activeOnly ? true : null,
                      followUpDueBy: _followUpDueBy,
                    ),
                  ),
                  child: const Text('Apply filters'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  const _FilterLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x16,
          AppSpacing.x12,
          AppSpacing.x16,
          AppSpacing.x8,
        ),
        child: Text(text, style: AppType.overline),
      );
}

class _ChipRow<T> extends StatelessWidget {
  const _ChipRow({
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.paletteOf,
    required this.onSelect,
  });

  final List<T> values;
  final T? selected;
  final String Function(T) labelOf;
  final StatusPalette Function(T) paletteOf;
  final ValueChanged<T?> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x16),
      child: Wrap(
        spacing: AppSpacing.x8,
        runSpacing: AppSpacing.x8,
        children: [
          for (final value in values)
            _Toggle(
              label: labelOf(value),
              active: value == selected,
              accent: paletteOf(value).foreground,
              onTap: () => onSelect(value == selected ? null : value),
            ),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.active,
    required this.onTap,
    this.accent = AppColors.primary,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? accent : AppColors.canvas,
            borderRadius: BorderRadius.circular(AppRadii.chip),
            border: Border.all(color: active ? accent : AppColors.border),
          ),
          child: Text(
            label,
            style: AppType.tab.copyWith(
              color: active ? AppColors.onPrimary : AppColors.body,
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onSort,
    required this.onFilter,
    required this.sortLabel,
    required this.appliedFilters,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSort;
  final VoidCallback onFilter;
  final String sortLabel;
  final int appliedFilters;

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: SizedBox(
              height: 42,
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: AppType.fieldValue,
                cursorColor: AppColors.primary,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search name, phone, email',
                  fillColor: AppColors.canvas,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: AppSpacing.x12, right: AppSpacing.x8),
                    child: AppIcon(Ic.search, size: 18, color: AppColors.faint),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x8),
          _IconButton(
            icon: Ic.filter,
            label: appliedFilters == 0 ? 'Filter' : '$appliedFilters filters applied',
            badge: appliedFilters,
            onTap: onFilter,
          ),
          const SizedBox(width: AppSpacing.x8),
          _IconButton(icon: Ic.sort, label: 'Sort: $sortLabel', onTap: onSort),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge = 0,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.circular(AppRadii.tile),
              ),
              child: AppIcon(icon, size: 18, color: AppColors.body),
            ),
            if (badge > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$badge',
                    style: AppType.monoSm.copyWith(
                      fontSize: 10,
                      color: AppColors.onPrimary,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StageTabs extends StatelessWidget {
  const _StageTabs({
    required this.selected,
    required this.counts,
    required this.total,
    required this.onSelect,
  });

  final LeadStage? selected;
  final Map<LeadStage, int> counts;
  final int total;
  final ValueChanged<LeadStage?> onSelect;

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
            _Tab(
              label: 'All',
              count: total,
              active: selected == null,
              onTap: () => onSelect(null),
            ),
            for (final stage in LeadStage.values) ...[
              const SizedBox(width: AppSpacing.x8),
              _Tab(
                label: stage.label,
                count: counts[stage] ?? 0,
                active: selected == stage,
                palette: StatusColors.stage(stage),
                onTap: () => onSelect(selected == stage ? null : stage),
              ),
            ],
          ],
        ),
      ),
    );
  }
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
  final int count;
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
          ),
        ),
      ),
    );
  }
}

/// `19 leads · all` + the Add lead button, as in the prototype.
///
/// The count is [LeadsState.totalElements] — the server's total for the current
/// filter, not how many rows have been paged in, so it does not creep upward
/// as you scroll.
class _ResultBar extends StatelessWidget {
  const _ResultBar({required this.total, required this.scope, required this.onAdd});

  final int total;
  final String scope;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.x12,
        AppSpacing.gutter,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$total lead${total == 1 ? '' : 's'} · $scope',
              style: AppType.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          FilledButton(
            onPressed: onAdd,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x12,
                vertical: AppSpacing.x8,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppIcon(Ic.plus, size: 15, color: AppColors.onPrimary),
                const SizedBox(width: AppSpacing.x6),
                Text(
                  'Add lead',
                  style: AppType.tab.copyWith(color: AppColors.onPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
