import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/formatters/phone.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/customer.dart';
import '../../../domain/entities/customer_enums.dart';
import '../../../domain/repositories/customer_repository.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../providers/customers_controller.dart';
import '../../../router/safe_pop.dart';

/// Customers list — search, status tabs, lifetime value and trips per row.
///
/// Search and filters are applied by `GET /api/customers` in the database.
/// The stat tiles need CRM_FULL, so for a sub-agent they are simply absent.
class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
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
      ref.read(customersControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(customersControllerProvider);
    final filter = ref.watch(customerFilterProvider);
    final stats = ref.watch(customerStatsProvider).value;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Customers', style: AppType.h2),
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
                onChanged: (q) => ref.read(customerFilterProvider.notifier).setQuery(q),
                style: AppType.fieldValue,
                cursorColor: AppColors.primary,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search name, phone, email, code',
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
            onSelect: (s) => ref.read(customerFilterProvider.notifier).setStatus(s),
          ),
          Expanded(
            child: switch (async) {
              AsyncLoading() when async.value == null => const SkeletonList(),
              AsyncError(:final error) => ErrorStateView(
                  failure: asFailure(error),
                  onRetry: () => ref.read(customersControllerProvider.notifier).refresh(),
                ),
              _ => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => ref.read(customersControllerProvider.notifier).refresh(),
                  child: async.value!.customers.isEmpty
                      ? _emptyState(filter)
                      : ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(AppSpacing.gutter),
                          itemCount: async.value!.customers.length +
                              (async.value!.hasMore ? 1 : 0),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.x12),
                          itemBuilder: (context, index) {
                            final rows = async.value!.customers;
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
                            final customer = rows[index];
                            return _CustomerCard(
                              customer: customer,
                              onTap: () =>
                                  context.push(Routes.customerDetailFor(customer.id)),
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

  Widget _emptyState(CustomerFilter filter) {
    final filtered = filter.appliedCount > 0;

    return ListView(
      children: [
        SizedBox(
          height: 420,
          child: filtered
              ? EmptyStateView(
                  icon: Ic.search,
                  title: 'No matching customers',
                  message: 'No customer matches these filters.',
                  actionLabel: 'Clear filters',
                  onAction: () {
                    _searchController.clear();
                    ref.read(customerFilterProvider.notifier).clear();
                  },
                )
              : const EmptyStateView(
                  icon: Ic.users,
                  title: 'No customers yet',
                  message: 'Customers appear here once a lead is converted into '
                      'a booking.',
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

  final CustomerStatus? selected;
  final CustomerStats? stats;
  final ValueChanged<CustomerStatus?> onSelect;

  /// Counts come from the CRM_FULL stats endpoint; a sub-agent sees tabs with
  /// no numbers rather than numbers that would be wrong.
  int? _countFor(CustomerStatus? status) => switch (status) {
        null => stats?.total,
        CustomerStatus.active => stats?.active,
        CustomerStatus.inactive => stats?.inactive,
        CustomerStatus.blocked => stats?.blocked,
      };

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
              count: _countFor(null),
              active: selected == null,
              onTap: () => onSelect(null),
            ),
            for (final status in CustomerStatus.values) ...[
              const SizedBox(width: AppSpacing.x8),
              _Tab(
                label: status.label,
                count: _countFor(status),
                active: selected == status,
                palette: StatusColors.customerStatus(status),
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

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer, required this.onTap});

  final Customer customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final type = customer.type;
    final tier = customer.tier;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(initials: customer.initials, seed: customer.name),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            customer.name.isEmpty ? 'Unnamed customer' : customer.name,
                            style: AppType.rowTitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (type != null && type != CustomerType.individual) ...[
                          const SizedBox(width: AppSpacing.x8),
                          StatusChip(
                            label: type.label,
                            palette: StatusColors.customerType(type),
                            dense: true,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      [
                        Phone.display(customer.phone),
                        if (customer.locationLabel.isNotEmpty) customer.locationLabel,
                      ].join(' · '),
                      style: AppType.bodySm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.x10),
          Row(
            children: [
              _Metric(label: 'Lifetime', value: Inr.compact(customer.spent ?? 0)),
              const SizedBox(width: AppSpacing.x20),
              _Metric(label: 'Trips', value: '${customer.bookingCount}'),
              const Spacer(),
              if (customer.lastBooking != null)
                _Metric(
                  label: 'Last trip',
                  value: AppDate.displayShort(customer.lastBooking),
                )
              else if (tier != null)
                StatusChip(label: tier.label, palette: StatusColors.tier(tier), dense: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppType.caption.copyWith(fontSize: 11)),
        const SizedBox(height: AppSpacing.x2),
        Text(value, style: AppType.monoStrong),
      ],
    );
  }
}
