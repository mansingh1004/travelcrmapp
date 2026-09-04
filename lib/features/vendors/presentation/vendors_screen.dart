import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../router/safe_pop.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../api/vendor_api.dart';
import 'vendor_detail_screen.dart';
import 'widgets/vendor_chips.dart';
import 'widgets/vendor_form_sheet.dart';

/// What the list is currently narrowed to.
///
/// Held as one object so a change to any facet is a single rebuild and a single
/// request, rather than three.
typedef VendorFilter = ({String? search, String? status, String? type});

final vendorFilterProvider =
    NotifierProvider<VendorFilterNotifier, VendorFilter>(
  VendorFilterNotifier.new,
);

class VendorFilterNotifier extends Notifier<VendorFilter> {
  Timer? _debounce;

  @override
  VendorFilter build() {
    ref.onDispose(() => _debounce?.cancel());
    return (search: null, status: null, type: null);
  }

  /// Debounced: the search runs on the server, so a request per keystroke
  /// would be a request per keystroke.
  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final trimmed = query.trim();
      state = (
        search: trimmed.isEmpty ? null : trimmed,
        status: state.status,
        type: state.type,
      );
    });
  }

  void setStatus(String? status) =>
      state = (search: state.search, status: status, type: state.type);

  void setType(String? type) =>
      state = (search: state.search, status: state.status, type: type);
}

final vendorsProvider = FutureProvider.autoDispose<List<Vendor>>((ref) async {
  final filter = ref.watch(vendorFilterProvider);
  final page = await ref.watch(vendorApiProvider).getVendors(
        search: filter.search,
        status: filter.status,
        type: filter.type,
      );
  return page.content;
});

/// Vendors — the agency's suppliers.
///
/// **Not part of Masters**, and not by accident. A hotel or a vehicle in the
/// catalog is a thing with a name and a price; a vendor is a relationship with
/// a ledger — outstanding, total business, credit terms — its own lifecycle
/// (`PATCH /{id}/status`) and its own permissions. The desktop console draws
/// the same line: `features/vendors` there is a feature of its own too.
///
/// Searching and filtering happen server-side, so what is on screen is the
/// whole result rather than the first page narrowed locally.
class VendorsScreen extends ConsumerStatefulWidget {
  const VendorsScreen({super.key});

  @override
  ConsumerState<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends ConsumerState<VendorsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final saved = await VendorFormSheet.show(context);
    if (saved == null) return;
    ref.invalidate(vendorsProvider);
    if (mounted) AppToast.success(context, 'Vendor added', saved);
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(vendorFilterProvider);
    final async = ref.watch(vendorsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Vendors', style: AppType.h2),
        actions: [
          TextButton.icon(
            onPressed: _add,
            icon: const AppIcon(Ic.plus, size: 16, color: AppColors.primary),
            label: const Text('Add'),
          ),
        ],
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
                onChanged: (q) =>
                    ref.read(vendorFilterProvider.notifier).search(q),
                style: AppType.fieldValue,
                cursorColor: AppColors.primary,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search name, code, city',
                  fillColor: AppColors.canvas,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.x12,
                      right: AppSpacing.x8,
                    ),
                    child: AppIcon(Ic.search, size: 18, color: AppColors.faint),
                  ),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
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
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            padding: const EdgeInsets.only(bottom: AppSpacing.x12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.gutter,
              ),
              child: Row(
                children: [
                  _Facet(
                    label: 'All',
                    active: filter.status == null && filter.type == null,
                    onTap: () {
                      ref.read(vendorFilterProvider.notifier)
                        ..setStatus(null)
                        ..setType(null);
                    },
                  ),
                  for (final status in VendorApi.statuses) ...[
                    const SizedBox(width: AppSpacing.x6),
                    _Facet(
                      label: statusLabel(status),
                      active: filter.status == status,
                      onTap: () => ref
                          .read(vendorFilterProvider.notifier)
                          .setStatus(filter.status == status ? null : status),
                    ),
                  ],
                  for (final type in VendorApi.types) ...[
                    const SizedBox(width: AppSpacing.x6),
                    _Facet(
                      label: type,
                      active: filter.type == type,
                      onTap: () => ref
                          .read(vendorFilterProvider.notifier)
                          .setType(filter.type == type ? null : type),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Expanded(
            child: switch (async) {
              AsyncLoading() => const SkeletonList(itemCount: 5, itemHeight: 140),
              // Vendors need VENDOR_READ, which not every role has.
              AsyncError(:final error) when error is PermissionFailure =>
                EmptyStateView(
                  icon: Ic.shield,
                  title: 'Vendors are restricted',
                  message: error.message,
                ),
              AsyncError(:final error) => ErrorStateView(
                  failure: asFailure(error),
                  onRetry: () => ref.invalidate(vendorsProvider),
                ),
              AsyncData(:final value) => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => ref.invalidate(vendorsProvider),
                  child: value.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: 360,
                              child: EmptyStateView(
                                icon: Ic.building,
                                title: 'No vendors',
                                message: filter.search != null ||
                                        filter.status != null ||
                                        filter.type != null
                                    ? 'Nothing matches this filter.'
                                    : 'Add the hotels, airlines, transport '
                                        'operators and DMCs you buy from.',
                                actionLabel: 'Add vendor',
                                onAction: _add,
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.gutter),
                          itemCount: value.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.x10),
                          itemBuilder: (context, index) =>
                              VendorCard(vendor: value[index]),
                        ),
                ),
            },
          ),
        ],
      ),
    );
  }
}

/// One vendor, laid out like the console's own mobile card so the two products
/// read the same: identity, standing, then the money.
class VendorCard extends StatelessWidget {
  const VendorCard({super.key, required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.x14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VendorDetailScreen(vendorId: vendor.id),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(initials: _initials(vendor.name), seed: vendor.name),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.name,
                      style: AppType.rowTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (vendor.code != null) ...[
                      const SizedBox(height: AppSpacing.x2),
                      Text(vendor.code!, style: AppType.monoXs),
                    ],
                    if (vendor.city != null) ...[
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        [vendor.city, vendor.state]
                            .whereType<String>()
                            .join(', '),
                        style: AppType.captionSm,
                      ),
                    ],
                  ],
                ),
              ),
              if (vendor.status != null) VendorStatusChip(status: vendor.status!),
            ],
          ),
          const SizedBox(height: AppSpacing.x10),
          Wrap(
            spacing: AppSpacing.x6,
            runSpacing: AppSpacing.x6,
            children: [
              if (vendor.type != null) VendorTypeChip(type: vendor.type!),
              if (vendor.payStatus != null)
                VendorPayChip(payStatus: vendor.payStatus!),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          Row(
            children: [
              Expanded(
                child: _Money(label: 'Business', value: vendor.totalBusiness),
              ),
              const SizedBox(width: AppSpacing.x8),
              Expanded(
                child: _Money(
                  label: 'Outstanding',
                  value: vendor.outstanding,
                  // Money still owed is the number an agent is looking for.
                  accent: vendor.outstanding > 0
                      ? AppColors.warn
                      : AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}

class _Money extends StatelessWidget {
  const _Money({required this.label, required this.value, this.accent});

  final String label;
  final double value;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x12,
        vertical: AppSpacing.x8,
      ),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(AppRadii.tile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppType.overline),
          const SizedBox(height: AppSpacing.x4),
          Text(
            Inr.compact(value),
            style: AppType.monoStrong.copyWith(color: accent),
          ),
        ],
      ),
    );
  }
}

class _Facet extends StatelessWidget {
  const _Facet({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x14),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.canvas,
            borderRadius: BorderRadius.circular(AppRadii.chip),
          ),
          child: Center(
            widthFactor: 1,
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
