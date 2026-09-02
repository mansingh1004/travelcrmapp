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
import '../../../domain/entities/booking_enums.dart';
import '../../../domain/repositories/booking_repository.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/dashed_divider.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../providers/bookings_controller.dart';

/// Bookings list — 5 status tabs, payment progress per card.
///
/// Money is displayed exactly as the server reports it; the balance comes from
/// `pendingAmount`, which accounts for adjustments and refunds the client
/// cannot see, so it is never recomputed as total − paid.
class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
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
      ref.read(bookingsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(bookingsControllerProvider);
    final filter = ref.watch(bookingFilterProvider);
    final stats = ref.watch(bookingStatsProvider).value;

    return Column(
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
              onChanged: (q) => ref.read(bookingFilterProvider.notifier).setQuery(q),
              style: AppType.fieldValue,
              cursorColor: AppColors.primary,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search customer, code, destination',
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
        _StatusTabs(
          selected: filter.status,
          stats: stats,
          onSelect: (s) => ref.read(bookingFilterProvider.notifier).setStatus(s),
        ),
        Expanded(
          child: switch (async) {
            AsyncLoading() when async.value == null => const SkeletonList(),
            AsyncError(:final error) => ErrorStateView(
                failure: asFailure(error),
                onRetry: () => ref.read(bookingsControllerProvider.notifier).refresh(),
              ),
            _ => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => ref.read(bookingsControllerProvider.notifier).refresh(),
                child: async.value!.bookings.isEmpty
                    ? _emptyState(filter)
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(AppSpacing.gutter),
                        itemCount:
                            async.value!.bookings.length + (async.value!.hasMore ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x12),
                        itemBuilder: (context, index) {
                          final rows = async.value!.bookings;
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
                          final booking = rows[index];
                          return BookingCard(
                            booking: booking,
                            onTap: () =>
                                context.push(Routes.bookingDetailFor(booking.id)),
                          );
                        },
                      ),
              ),
          },
        ),
      ],
    );
  }

  Widget _emptyState(BookingFilter filter) {
    final filtered = filter.appliedCount > 0;

    return ListView(
      children: [
        SizedBox(
          height: 420,
          child: filtered
              ? EmptyStateView(
                  icon: Ic.search,
                  title: 'No matching bookings',
                  message: 'No booking matches these filters.',
                  actionLabel: 'Clear filters',
                  onAction: () {
                    _searchController.clear();
                    ref.read(bookingFilterProvider.notifier).clear();
                  },
                )
              : const EmptyStateView(
                  icon: Ic.package,
                  title: 'No bookings yet',
                  message: 'Convert a won lead into a booking to see it here.',
                ),
        ),
      ],
    );
  }
}

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({
    required this.selected,
    required this.stats,
    required this.onSelect,
  });

  final BookingStatus? selected;
  final BookingStats? stats;
  final ValueChanged<BookingStatus?> onSelect;

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
              count: stats?.countFor(null),
              active: selected == null,
              onTap: () => onSelect(null),
            ),
            for (final status in BookingStatus.values) ...[
              const SizedBox(width: AppSpacing.x8),
              _Tab(
                label: status.label,
                count: stats?.countFor(status),
                active: selected == status,
                palette: StatusColors.bookingStatus(status),
                onTap: () => onSelect(selected == status ? null : status),
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

/// A booking row: status, dates, and the payment progress bar.
class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onTap});

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = booking.status;
    final payment = booking.paymentStatus;
    final days = booking.daysToTravel;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The reference is its own line at the top, with both states beside
          // it — the spec reads the card as "which booking, and how is it
          // doing" before it reads whose booking it is.
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.code ?? '—',
                  style: AppType.monoXs.copyWith(color: AppColors.body),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (status != null)
                StatusChip(
                  label: status.label,
                  palette: StatusColors.bookingStatus(status),
                  dense: true,
                ),
              if (status != null && payment != null)
                const SizedBox(width: AppSpacing.x6),
              if (payment != null)
                StatusChip(
                  label: payment.label,
                  palette: StatusColors.paymentStatus(payment),
                  dense: true,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x10),
          Row(
            children: [
              AppAvatar(
                initials: booking.initials,
                seed: booking.customerName,
                size: 38,
              ),
              const SizedBox(width: AppSpacing.x10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.customerName.isEmpty
                          ? 'Unnamed booking'
                          : booking.customerName,
                      style: AppType.rowTitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (booking.destination != null) ...[
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        booking.destination!,
                        style: AppType.bodySm,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x10),
          Wrap(
            spacing: AppSpacing.x14,
            runSpacing: AppSpacing.x6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (booking.travelDate != null)
                _Meta(
                  icon: Ic.calendar,
                  text: AppDate.display(booking.travelDate),
                  // Travel inside a week is the thing an agent must act on.
                  color: days != null && days >= 0 && days <= 7
                      ? AppColors.warn
                      : null,
                ),
              if (days != null && days >= 0 && days <= 7)
                _Meta(
                  icon: Ic.clock,
                  text: days == 0 ? 'Travels today' : 'In $days day${days == 1 ? '' : 's'}',
                  color: AppColors.warn,
                ),
              if (booking.agentName != null)
                _Meta(icon: Ic.user, text: booking.agentName!),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          const DashedDivider(),
          const SizedBox(height: AppSpacing.x12),
          // Spread across the full width, not bunched at the left: the three
          // figures are meant to be compared, and the eye needs them on the
          // card's own left / middle / right rails to do that at a glance.
          Row(
            children: [
              Expanded(
                child: _Money(
                  label: 'Booking',
                  value: Inr.compact(booking.totalPayable),
                ),
              ),
              Expanded(
                child: _Money(
                  label: 'Paid',
                  value: Inr.compact(booking.paidAmount),
                  align: CrossAxisAlignment.center,
                ),
              ),
              Expanded(
                child: _Money(
                  label: 'Balance',
                  value: Inr.compact(booking.pendingAmount),
                  emphasise: booking.pendingAmount > 0,
                  align: CrossAxisAlignment.end,
                ),
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
                booking.pendingAmount > 0 ? AppColors.warn : AppColors.success,
              ),
            ),
          ),
        ],
      ),
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
    // Sans, not mono: the spec keeps mono for figures and IDs, and sets these
    // meta lines in the UI face so they sit under the name rather than
    // competing with the amounts below.
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(icon, size: 12, color: color ?? AppColors.faint),
        const SizedBox(width: AppSpacing.x4),
        Text(text, style: AppType.bodySm.copyWith(color: color ?? AppColors.body)),
      ],
    );
  }
}

class _Money extends StatelessWidget {
  const _Money({
    required this.label,
    required this.value,
    this.emphasise = false,
    this.align = CrossAxisAlignment.start,
  });

  final String label;
  final String value;
  final bool emphasise;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Uppercase overline, not a sentence-case caption: these three read as
        // column headings over the figures, the way the spec sets them.
        Text(label.toUpperCase(), style: AppType.overline, maxLines: 1),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: emphasise
              ? AppType.monoStrong.copyWith(color: AppColors.warn)
              : AppType.monoStrong,
          maxLines: 1,
        ),
      ],
    );
  }
}
