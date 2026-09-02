import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/masters_api.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../../../router/safe_pop.dart';

final masterKindProvider =
    NotifierProvider<MasterKindNotifier, MasterKind>(MasterKindNotifier.new);

class MasterKindNotifier extends Notifier<MasterKind> {
  @override
  MasterKind build() => MasterKind.hotels;

  void set(MasterKind kind) => state = kind;
}

final masterSearchProvider =
    NotifierProvider<MasterSearchNotifier, String?>(MasterSearchNotifier.new);

class MasterSearchNotifier extends Notifier<String?> {
  Timer? _debounce;

  @override
  String? build() {
    ref.onDispose(() => _debounce?.cancel());
    return null;
  }

  void set(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      state = query.trim().isEmpty ? null : query.trim();
    });
  }
}

final masterRowsProvider = FutureProvider.autoDispose<List<MasterRow>>((ref) async {
  final kind = ref.watch(masterKindProvider);
  final search = ref.watch(masterSearchProvider);
  final page = await ref.watch(mastersApiProvider).getRows(kind, search: search);
  return page.content;
});

/// Masters — the hotel, vehicle, sightseeing and vendor catalogs.
///
/// Read-only: this app browses the catalogs, it does not maintain them. Rows
/// marked read-only are platform-synced and not the tenant's to edit at all.
class MastersScreen extends ConsumerStatefulWidget {
  const MastersScreen({super.key});

  @override
  ConsumerState<MastersScreen> createState() => _MastersScreenState();
}

class _MastersScreenState extends ConsumerState<MastersScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kind = ref.watch(masterKindProvider);
    final async = ref.watch(masterRowsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Masters', style: AppType.h2),
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
                onChanged: (q) => ref.read(masterSearchProvider.notifier).set(q),
                style: AppType.fieldValue,
                cursorColor: AppColors.primary,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search ${kind.label.toLowerCase()}',
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
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              0,
              AppSpacing.gutter,
              AppSpacing.x12,
            ),
            child: Row(
              children: [
                for (final k in MasterKind.values) ...[
                  if (k != MasterKind.values.first) const SizedBox(width: AppSpacing.x6),
                  Expanded(
                    child: Semantics(
                      button: true,
                      selected: k == kind,
                      child: InkWell(
                        onTap: () => ref.read(masterKindProvider.notifier).set(k),
                        borderRadius: BorderRadius.circular(AppRadii.chip),
                        child: Container(
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: k == kind ? AppColors.primary : AppColors.canvas,
                            borderRadius: BorderRadius.circular(AppRadii.chip),
                          ),
                          child: Text(
                            k.label,
                            style: AppType.tab.copyWith(
                              fontSize: 11.5,
                              color: k == kind ? AppColors.onPrimary : AppColors.body,
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
          ),
          Expanded(
            child: switch (async) {
              AsyncLoading() => const SkeletonList(itemCount: 6, itemHeight: 84),
              // Vendors need VENDOR_READ; the other catalogs only need a login.
              AsyncError(:final error) when error is PermissionFailure =>
                EmptyStateView(
                  icon: Ic.shield,
                  title: '${kind.label} are restricted',
                  message: error.message,
                ),
              AsyncError(:final error) => ErrorStateView(
                  failure: asFailure(error),
                  onRetry: () => ref.invalidate(masterRowsProvider),
                ),
              AsyncData(:final value) => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => ref.invalidate(masterRowsProvider),
                  child: value.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: 360,
                              child: EmptyStateView(
                                icon: Ic.grid,
                                title: 'No ${kind.label.toLowerCase()}',
                                message: 'This catalog is empty.',
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.gutter),
                          itemCount: value.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.x10),
                          itemBuilder: (context, index) => _Row(row: value[index]),
                        ),
                ),
            },
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.row});

  final MasterRow row;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Row(
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
                        row.title,
                        style: AppType.h3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (row.readOnly) ...[
                      const SizedBox(width: AppSpacing.x8),
                      const StatusChip(
                        label: 'Platform',
                        palette: StatusColors.neutral,
                        dense: true,
                      ),
                    ],
                  ],
                ),
                if (row.subtitle != null && row.subtitle!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    row.subtitle!,
                    style: AppType.bodySm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (row.tags.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x8),
                  Wrap(
                    spacing: AppSpacing.x6,
                    runSpacing: AppSpacing.x6,
                    children: [
                      for (final tag in row.tags)
                        StatusChip(
                          label: tag,
                          palette: StatusColors.neutral,
                          dense: true,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (row.trailing != null) ...[
            const SizedBox(width: AppSpacing.x10),
            Text(row.trailing!, style: AppType.monoSm),
          ],
        ],
      ),
    );
  }
}
