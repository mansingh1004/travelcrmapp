import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/quotation.dart';
import '../../../domain/entities/quotation_enums.dart';
import '../../../domain/repositories/quotation_repository.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../providers/quotations_controller.dart';
import '../../../router/safe_pop.dart';

/// Quotations list — search, four stage tabs, value per card.
///
/// **Four tabs, not eight.** `QuotationStage` on this backend is Draft / Sent /
/// Approved / Rejected; the prototype's Viewed, Negotiation and Expired have no
/// server value, so they are not shown as tabs that could never fill.
class QuotationsScreen extends ConsumerStatefulWidget {
  const QuotationsScreen({super.key});

  @override
  ConsumerState<QuotationsScreen> createState() => _QuotationsScreenState();
}

class _QuotationsScreenState extends ConsumerState<QuotationsScreen> {
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
      ref.read(quotationsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(quotationsControllerProvider);
    final filter = ref.watch(quotationFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Quotations', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.x12,
              AppSpacing.gutter,
              AppSpacing.x12,
            ),
            child: SizedBox(
              height: 42,
              child: TextField(
                controller: _searchController,
                onChanged: (q) => ref.read(quotationFilterProvider.notifier).setQuery(q),
                style: AppType.fieldValue,
                cursorColor: AppColors.primary,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search customer, destination, quote no.',
                  fillColor: AppColors.canvas,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: AppSpacing.x12, right: AppSpacing.x8),
                    child: AppIcon(Ic.search, size: 18, color: AppColors.faint),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
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
            ),
          ),
          _StageTabs(
            selected: filter.stage,
            // The server's count for the filter in force. Per-stage counts for
            // the *other* tabs would need one request each, so only the active
            // tab shows a number rather than showing four guesses.
            activeCount: async.value?.totalElements,
            onSelect: (s) => ref.read(quotationFilterProvider.notifier).setStage(s),
          ),
          if (async.value != null && async.value!.quotations.isNotEmpty)
            _ValueStrip(state: async.value!),
          Expanded(
            child: switch (async) {
              AsyncLoading() when async.value == null => const SkeletonList(),
              AsyncError(:final error) => ErrorStateView(
                  failure: asFailure(error),
                  onRetry: () => ref.read(quotationsControllerProvider.notifier).refresh(),
                ),
              _ => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () =>
                      ref.read(quotationsControllerProvider.notifier).refresh(),
                  child: async.value!.quotations.isEmpty
                      ? _emptyState(filter)
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(AppSpacing.gutter),
                          itemCount: async.value!.quotations.length +
                              (async.value!.hasMore ? 1 : 0),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.x12),
                          itemBuilder: (context, index) {
                            final rows = async.value!.quotations;
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
                            final quotation = rows[index];
                            return QuotationCard(
                              quotation: quotation,
                              onTap: () => context
                                  .push(Routes.quotationPreviewFor(quotation.id)),
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

  Widget _emptyState(QuotationFilter filter) {
    final filtered = filter.appliedCount > 0;

    return ListView(
      children: [
        SizedBox(
          height: 420,
          child: filtered
              ? EmptyStateView(
                  icon: Ic.search,
                  title: 'No matching quotations',
                  message: 'No quotation matches these filters.',
                  actionLabel: 'Clear filters',
                  onAction: () {
                    _searchController.clear();
                    ref.read(quotationFilterProvider.notifier).clear();
                  },
                )
              : const EmptyStateView(
                  icon: Ic.file,
                  title: 'No quotations yet',
                  message: 'Build a quotation from a lead to see it here.',
                ),
        ),
      ],
    );
  }
}

/// Total of the rows currently loaded. Labelled as such — the server exposes no
/// pipeline-value aggregate for quotations, so this must not read as one.
class _ValueStrip extends StatelessWidget {
  const _ValueStrip({required this.state});

  final QuotationsState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.x12,
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(
              value: Inr.compact(state.loadedValue),
              label: 'Value loaded',
              caption: '${state.quotations.length} of ${state.totalElements}',
              color: AppColors.primaryDeep,
            ),
          ),
          const SizedBox(width: AppSpacing.x10),
          Expanded(
            child: _Stat(
              value: '${state.approvedCount}',
              label: 'Approved',
              // Of the rows in hand, not of every quotation ever raised — the
              // list endpoint reports no per-stage totals.
              caption: 'of ${state.quotations.length} loaded',
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
    required this.caption,
    required this.color,
  });

  final String value;
  final String label;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.x12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppType.monoStrong.copyWith(color: color, fontSize: 17),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(label, style: AppType.caption.copyWith(fontSize: 11)),
          Text(
            caption,
            style: AppType.caption.copyWith(fontSize: 10, color: AppColors.faint),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StageTabs extends StatelessWidget {
  const _StageTabs({
    required this.selected,
    required this.onSelect,
    this.activeCount,
  });

  final QuotationStage? selected;
  final int? activeCount;
  final ValueChanged<QuotationStage?> onSelect;

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
              active: selected == null,
              count: selected == null ? activeCount : null,
              onTap: () => onSelect(null),
            ),
            for (final stage in QuotationStage.values) ...[
              const SizedBox(width: AppSpacing.x8),
              _Tab(
                label: stage.label,
                active: selected == stage,
                count: selected == stage ? activeCount : null,
                palette: StatusColors.quotationStage(stage),
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
    required this.active,
    required this.onTap,
    this.palette,
    this.count,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final StatusPalette? palette;
  final int? count;

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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? accent : AppColors.canvas,
            borderRadius: BorderRadius.circular(AppRadii.chip),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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

class QuotationCard extends StatelessWidget {
  const QuotationCard({super.key, required this.quotation, required this.onTap});

  final QuotationSummary quotation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stage = quotation.stage;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The reference line. The list endpoint sends no quote number, so
          // this carries the version and template it does send.
          Row(
            children: [
              Expanded(
                child: Text(
                  [
                    if (quotation.version != null) 'v${quotation.version}',
                    quotation.templateStyle.label.toUpperCase(),
                  ].join(' · '),
                  style: AppType.monoSm.copyWith(color: AppColors.faint),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (stage != null)
                StatusChip(
                  label: stage.label,
                  palette: StatusColors.quotationStage(stage),
                  dense: true,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quotation.customerName.isEmpty
                          ? 'Unnamed customer'
                          : quotation.customerName,
                      style: AppType.rowTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      quotation.displayTitle,
                      style: AppType.bodySm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (quotation.travelDate != null) ...[
                      const SizedBox(height: AppSpacing.x4),
                      Text(
                        'Travel ${AppDate.display(quotation.travelDate)}',
                        style: AppType.caption,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Inr.format(quotation.grandTotal),
                    style: AppType.monoStrong.copyWith(fontSize: 15),
                  ),
                  if (quotation.createdAt != null) ...[
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      AppDate.displayShort(quotation.createdAt),
                      style: AppType.caption.copyWith(fontSize: 10),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.x10),
          _CardActions(quotation: quotation, onOpen: onTap),
        ],
      ),
    );
  }
}

/// The card's primary action, matching the spec's `Preview` pill.
/// The card's action strip — the spec's six round icons, then the `Preview`
/// pill pushed to the right.
///
/// Every icon here is a real endpoint. The one exception is **edit**: the
/// quotation builder (11 service blocks and the pricing engine) is not built
/// yet, so that icon opens the same "not built" screen the drawer does rather
/// than pretending to edit.
class _CardActions extends ConsumerStatefulWidget {
  const _CardActions({required this.quotation, required this.onOpen});

  final QuotationSummary quotation;
  final VoidCallback onOpen;

  @override
  ConsumerState<_CardActions> createState() => _CardActionsState();
}

class _CardActionsState extends ConsumerState<_CardActions> {
  /// Set while a request is open, so a second tap cannot send the customer a
  /// second copy or leave two duplicate drafts behind.
  bool _busy = false;

  String get _id => widget.quotation.id;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CardAction(
          icon: Ic.file,
          tooltip: 'Open',
          tint: AppColors.slate,
          onTap: widget.onOpen,
        ),
        _CardAction(
          icon: Ic.edit,
          tooltip: 'Edit',
          tint: AppColors.slate,
          onTap: () => context.push(Routes.quotationCreate),
        ),
        _CardAction(
          icon: Ic.send,
          tooltip: 'Email to customer',
          tint: AppColors.primary,
          busy: _busy,
          onTap: () => _run(
            () => ref.read(quotationRepositoryProvider).sendEmail(_id),
            title: 'Quotation sent',
            body: 'Emailed to $_who.',
          ),
        ),
        // The spec's sixth icon is **Duplicate**. It is not shown: the route
        // exists (`POST /api/quotations/{id}/duplicate`) and this app calls it
        // correctly, but on this backend build the copy trips a database
        // constraint and comes back 409 for every quotation tried. The call is
        // kept wired in `QuotationRepository.duplicate` so the icon is a
        // one-line change once the server accepts it.
        _CardAction(
          icon: Ic.download,
          tooltip: 'Open PDF',
          tint: AppColors.slate,
          busy: _busy,
          onTap: _openPdf,
        ),
        _CardAction(
          icon: Ic.wa,
          tooltip: 'Send on WhatsApp',
          tint: AppColors.success,
          busy: _busy,
          onTap: () => _run(
            () => ref.read(quotationRepositoryProvider).sendWhatsApp(_id),
            title: 'Sent on WhatsApp',
            body: 'Delivered to $_who.',
          ),
        ),
        const Spacer(),
        _PreviewButton(onTap: widget.onOpen),
      ],
    );
  }

  String get _who => widget.quotation.customerName.isEmpty
      ? 'the customer'
      : widget.quotation.customerName;

  /// Runs one request with the strip locked, then reports either way.
  Future<void> _run(
    Future<void> Function() action, {
    required String title,
    required String body,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) AppToast.success(context, title, body);
    } on Failure catch (f) {
      if (mounted) AppToast.error(context, 'Could not send', f.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Opens the quotation PDF. The authenticated `/pdf` route streams bytes the
  /// browser could not fetch without a token, so this uses the public link the
  /// server mints for exactly this — the same URL the customer receives.
  Future<void> _openPdf() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final link = await ref.read(quotationRepositoryProvider).getShareLink(_id);
      if (!mounted) return;
      if (link == null) {
        AppToast.error(context, 'No PDF', 'This quotation has no public link yet.');
        return;
      }
      final ok = await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        AppToast.error(context, 'Could not open', 'No app available to open the PDF.');
      }
    } on Failure catch (f) {
      if (mounted) AppToast.error(context, 'Could not open PDF', f.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _CardAction extends StatelessWidget {
  const _CardAction({
    required this.icon,
    required this.tooltip,
    required this.tint,
    required this.onTap,
    this.busy = false,
  });

  final String icon;
  final String tooltip;
  final Color tint;
  final VoidCallback onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.x6),
      child: Tooltip(
        message: tooltip,
        child: Semantics(
          button: true,
          label: tooltip,
          child: InkWell(
            onTap: busy ? null : onTap,
            borderRadius: BorderRadius.circular(AppRadii.tile),
            child: Container(
              width: 31,
              height: 31,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: busy ? 0.05 : 0.1),
                borderRadius: BorderRadius.circular(AppRadii.tile),
              ),
              child: AppIcon(
                icon,
                size: 15,
                color: busy ? AppColors.faint : tint,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewButton extends StatelessWidget {
  const _PreviewButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x12,
          vertical: AppSpacing.x8,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Preview',
        style: AppType.tab.copyWith(color: AppColors.onPrimary),
      ),
    );
  }
}
