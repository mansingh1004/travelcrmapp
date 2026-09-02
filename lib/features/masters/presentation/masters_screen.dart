import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../api/masters_api.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../../../router/safe_pop.dart';
import 'geography_screen.dart';
import 'widgets/hotel_form_sheet.dart';
import 'widgets/sightseeing_form_sheet.dart';
import 'widgets/vehicle_form_sheet.dart';

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
/// The tenant keeps its own **hotels, vehicles and sightseeing** here: add,
/// edit and delete. **Vendors are browse-only** — that catalog carries
/// commercial terms, documents and ledger links that belong on the desktop
/// console, not on a phone.
///
/// Rows that belong to the platform rather than the tenant — a hotel synced
/// from the Marketplace, a vehicle shared across tenants — appear in the lists
/// like any other row and are never editable: the server rejects every change
/// this app can make to them, so no edit or delete is offered.
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
        actions: [
          // Geography is a drill-down of its own rather than two more tabs:
          // a city always belongs to a destination, and six tabs on this row
          // would each be too narrow to read.
          IconButton(
            tooltip: 'Destinations & cities',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const GeographyScreen()),
            ),
            icon: const AppIcon(Ic.pin, size: 18, color: AppColors.body),
          ),
          // Vendors are the one catalog this app does not write to.
          if (_writable(kind))
            TextButton.icon(
              onPressed: () => _add(context, ref, kind),
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
                                icon: switch (kind) {
                                  MasterKind.hotels => Ic.bed,
                                  MasterKind.vehicles => Ic.car,
                                  MasterKind.sightseeing => Ic.pin,
                                  MasterKind.vendors => Ic.grid,
                                },
                                title: 'No ${kind.label.toLowerCase()}',
                                message: _writable(kind)
                                    ? 'Add what you sell here so it is ready '
                                        'when you build a quotation.'
                                    : 'This catalog is empty.',
                                actionLabel:
                                    _writable(kind) ? 'Add ${kind.singular}' : null,
                                onAction: _writable(kind)
                                    ? () => _add(context, ref, kind)
                                    : null,
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
                              _Row(row: value[index], kind: kind),
                        ),
                ),
            },
          ),
        ],
      ),
    );
  }
}

/// Whether this app writes to a catalog at all.
///
/// Hotels, vehicles and sightseeing are the tenant's own. Vendors are not
/// edited here — the catalog carries commercial terms, documents and ledger
/// links that belong on the desktop console.
bool _writable(MasterKind kind) => kind != MasterKind.vendors;

/// Opens the create sheet for the current tab, and refreshes on save.
Future<void> _add(BuildContext context, WidgetRef ref, MasterKind kind) async {
  // An if-chain rather than a switch: only one branch ever runs, but a switch
  // over awaited arms reads as a `BuildContext` used across an async gap.
  String? saved;
  if (kind == MasterKind.hotels) {
    saved = await HotelFormSheet.show(context);
  } else if (kind == MasterKind.vehicles) {
    saved = await VehicleFormSheet.show(context);
  } else if (kind == MasterKind.sightseeing) {
    saved = await SightseeingFormSheet.show(context);
  }
  if (saved == null) return;

  ref.invalidate(masterRowsProvider);
  // The toast is raised here, not inside the sheet: by the time the sheet has
  // popped, its own context is deactivated and `ScaffoldMessenger.of` on it
  // throws. This screen is still mounted.
  if (context.mounted) {
    AppToast.success(context, 'Added', saved);
  }
}

/// Re-reads the row before editing, then opens the sheet.
///
/// The list row carries only what the list renders — a hotel's address and
/// contact person, a vehicle's notes, a sightseeing entry's description are
/// not in it — so the form is filled from the detail endpoint rather than from
/// the row, which would silently blank the fields it lacks on save.
Future<void> _edit(
  BuildContext context,
  WidgetRef ref,
  MasterKind kind,
  MasterRow row,
) async {
  final api = ref.read(mastersApiProvider);

  // Fetch first, then open: the sheet is built from the detail payload, and a
  // failed read should surface as a toast rather than an empty form.
  Object? detail;
  try {
    detail = switch (kind) {
      MasterKind.hotels => await api.getHotel(row.numericId!),
      MasterKind.vehicles => await api.getVehicle(row.id),
      MasterKind.sightseeing => await api.getSightseeing(row.numericId!),
      MasterKind.vendors => null,
    };
  } on Failure catch (f) {
    if (context.mounted) AppToast.error(context, 'Could not open', f.message);
    return;
  }
  if (!context.mounted || detail == null) return;

  // An if-chain rather than a switch: only one branch ever runs, but a switch
  // over awaited arms reads as a `BuildContext` used across an async gap.
  String? saved;
  if (detail is HotelMaster) {
    saved = await HotelFormSheet.show(context, hotel: detail);
  } else if (detail is VehicleMaster) {
    saved = await VehicleFormSheet.show(context, vehicle: detail);
  } else if (detail is SightseeingMaster) {
    saved = await SightseeingFormSheet.show(context, entry: detail);
  }
  if (saved == null) return;

  ref.invalidate(masterRowsProvider);
  if (context.mounted) {
    AppToast.success(context, 'Saved', saved);
  }
}

/// Confirms, then soft-deletes.
///
/// The server moves the row to Trash rather than removing it, and quotations
/// and bookings hold a name snapshot rather than a reference to it, so existing
/// records keep reading correctly. The wording says so.
Future<void> _delete(
  BuildContext context,
  WidgetRef ref,
  MasterKind kind,
  MasterRow row,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Delete ${row.title}?', style: AppType.h3),
      content: Text(
        'It moves to Trash and stops appearing when you build a quotation. '
        'Existing quotations and bookings are not affected.',
        style: AppType.bodySm,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  final api = ref.read(mastersApiProvider);
  try {
    switch (kind) {
      case MasterKind.hotels:
        await api.deleteHotel(row.numericId!);
      case MasterKind.vehicles:
        await api.deleteVehicle(row.id);
      case MasterKind.sightseeing:
        await api.deleteSightseeing(row.numericId!);
      case MasterKind.vendors:
        return;
    }
    ref.invalidate(masterRowsProvider);
    if (context.mounted) AppToast.success(context, 'Deleted', row.title);
  } on Failure catch (f) {
    if (context.mounted) AppToast.error(context, 'Could not delete', f.message);
  }
}

enum _RowAction { edit, delete }

class _Row extends ConsumerWidget {
  const _Row({required this.row, required this.kind});

  final MasterRow row;
  final MasterKind kind;

  /// A row of the tenant's own in a catalog this app writes to.
  ///
  /// Platform-synced hotels and global vehicles are excluded: the server
  /// rejects any edit to them, so offering one would only produce a 403 or 409.
  /// Vehicles are addressed by their UUID, the other two by a numeric id.
  bool get _editable =>
      _writable(kind) &&
      !row.readOnly &&
      (kind == MasterKind.vehicles ? row.id.isNotEmpty : row.numericId != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.x14),
      onTap: _editable ? () => _edit(context, ref, kind, row) : null,
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
          if (_editable) ...[
            const SizedBox(width: AppSpacing.x4),
            SizedBox(
              width: 32,
              height: 32,
              child: PopupMenuButton<_RowAction>(
                tooltip: 'Row actions',
                padding: EdgeInsets.zero,
                iconSize: 18,
                color: AppColors.surface,
                icon: const AppIcon(Ic.dots, size: 18, color: AppColors.faint),
                onSelected: (action) => switch (action) {
                  _RowAction.edit => _edit(context, ref, kind, row),
                  _RowAction.delete => _delete(context, ref, kind, row),
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: _RowAction.edit,
                    child: Row(
                      children: [
                        const AppIcon(Ic.edit, size: 16, color: AppColors.muted),
                        const SizedBox(width: AppSpacing.x10),
                        Text('Edit', style: AppType.body),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: _RowAction.delete,
                    child: Row(
                      children: [
                        const AppIcon(Ic.trash, size: 16, color: AppColors.danger),
                        const SizedBox(width: AppSpacing.x10),
                        Text(
                          'Delete',
                          style: AppType.body.copyWith(color: AppColors.danger),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
