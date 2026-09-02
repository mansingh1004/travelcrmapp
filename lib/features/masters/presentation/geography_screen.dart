import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../router/safe_pop.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../api/masters_api.dart';
import 'widgets/city_form_sheet.dart';
import 'widgets/destination_form_sheet.dart';
import 'widgets/geography_providers.dart';

/// The destinations the tenant can see, plus the global ones.
final destinationRowsProvider =
    FutureProvider.autoDispose<List<DestinationMaster>>(
  (ref) => ref.watch(mastersApiProvider).getDestinationRows(),
);

/// The cities under one destination.
final cityRowsProvider =
    FutureProvider.autoDispose.family<List<CityMaster>, int>(
  (ref, destinationId) => ref.watch(mastersApiProvider).getCityRows(destinationId),
);

/// Masters → Destinations, and the cities under each one.
///
/// A drill-down rather than two more tabs: a city always belongs to a
/// destination, and Masters already carries four tabs that would each shrink to
/// an unreadable width at six.
///
/// This screen exists because the rest of Masters depends on it. A hotel cannot
/// be saved without a destination, and both hotels and sightseeing resolve
/// their city *by name* against one and refuse to create it — so without this,
/// a fresh tenant could not add a hotel from the phone at all.
class GeographyScreen extends ConsumerWidget {
  const GeographyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(destinationRowsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Destinations', style: AppType.h2),
        actions: [
          TextButton.icon(
            onPressed: () => _addDestination(context, ref),
            icon: const AppIcon(Ic.plus, size: 16, color: AppColors.primary),
            label: const Text('Add'),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (async) {
        AsyncLoading() => const SkeletonList(itemCount: 6, itemHeight: 72),
        AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () => ref.invalidate(destinationRowsProvider),
          ),
        AsyncData(:final value) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => ref.invalidate(destinationRowsProvider),
            child: value.isEmpty
                ? ListView(
                    children: [
                      SizedBox(
                        height: 360,
                        child: EmptyStateView(
                          icon: Ic.pin,
                          title: 'No destinations',
                          message: 'Add the places you sell. Hotels and '
                              'sightseeing are filed under them.',
                          actionLabel: 'Add destination',
                          onAction: () => _addDestination(context, ref),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    itemCount: value.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x10),
                    itemBuilder: (context, index) =>
                        _DestinationRow(destination: value[index]),
                  ),
          ),
      },
    );
  }
}

Future<void> _addDestination(BuildContext context, WidgetRef ref) async {
  final saved = await DestinationFormSheet.show(context);
  if (saved == null) return;
  ref.invalidate(destinationRowsProvider);
  if (context.mounted) AppToast.success(context, 'Destination added', saved);
}

Future<void> _editDestination(
  BuildContext context,
  WidgetRef ref,
  DestinationMaster destination,
) async {
  // The list row carries no description, so the form is filled from the detail
  // endpoint rather than from the row it was tapped on.
  DestinationMaster detail;
  try {
    detail = await ref.read(mastersApiProvider).getDestination(destination.id);
  } on Failure catch (f) {
    if (context.mounted) AppToast.error(context, 'Could not open', f.message);
    return;
  }
  if (!context.mounted) return;

  final saved = await DestinationFormSheet.show(context, destination: detail);
  if (saved == null) return;
  ref.invalidate(destinationRowsProvider);
  if (context.mounted) AppToast.success(context, 'Destination saved', saved);
}

Future<void> _deleteDestination(
  BuildContext context,
  WidgetRef ref,
  DestinationMaster destination,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text('Delete ${destination.name}?', style: AppType.h3),
      content: Text(
        // Both sentences are the server's actual behaviour, not reassurance:
        // `assertDestinationDeletable` blocks on active bookings, and
        // `detachFromDestination` unhooks the cities instead of deleting them.
        'It moves to Trash. Its cities are kept but stop being listed under it. '
        'A destination used by an active booking cannot be deleted.',
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

  try {
    await ref.read(mastersApiProvider).deleteDestination(destination.id);
    ref.invalidate(destinationRowsProvider);
    ref.invalidate(destinationsProvider);
    if (context.mounted) {
      AppToast.success(context, 'Destination deleted', destination.name);
    }
  } on Failure catch (f) {
    // The 409 says which records still use it; the server's wording is better
    // than anything invented here.
    if (context.mounted) AppToast.error(context, 'Could not delete', f.message);
  }
}

enum _RowAction { edit, delete }

class _DestinationRow extends ConsumerWidget {
  const _DestinationRow({required this.destination});

  final DestinationMaster destination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A global destination belongs to the platform: `findByIdAndTenantId`
    // cannot see it for this tenant, so editing one answers 404.
    final editable = !destination.global;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.x14),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DestinationCitiesScreen(destination: destination),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        destination.name,
                        style: AppType.h3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (destination.global) ...[
                      const SizedBox(width: AppSpacing.x8),
                      const StatusChip(
                        label: 'Platform',
                        palette: StatusColors.neutral,
                        dense: true,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  [destination.countryName, destination.type]
                      .whereType<String>()
                      .join(' · '),
                  style: AppType.bodySm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (editable)
            SizedBox(
              width: 32,
              height: 32,
              child: PopupMenuButton<_RowAction>(
                tooltip: 'Destination actions',
                padding: EdgeInsets.zero,
                iconSize: 18,
                color: AppColors.surface,
                icon: const AppIcon(Ic.dots, size: 18, color: AppColors.faint),
                onSelected: (action) => switch (action) {
                  _RowAction.edit => _editDestination(context, ref, destination),
                  _RowAction.delete =>
                    _deleteDestination(context, ref, destination),
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
            )
          else
            const AppIcon(Ic.chevronRight, size: 16, color: AppColors.faint),
        ],
      ),
    );
  }
}

/// The cities under one destination.
class DestinationCitiesScreen extends ConsumerWidget {
  const DestinationCitiesScreen({super.key, required this.destination});

  final DestinationMaster destination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(cityRowsProvider(destination.id));

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text(destination.name, style: AppType.h2),
        actions: [
          TextButton.icon(
            onPressed: () => _addCity(context, ref, destination),
            icon: const AppIcon(Ic.plus, size: 16, color: AppColors.primary),
            label: const Text('Add'),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (async) {
        AsyncLoading() => const SkeletonList(itemCount: 5, itemHeight: 64),
        AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () => ref.invalidate(cityRowsProvider(destination.id)),
          ),
        AsyncData(:final value) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async =>
                ref.invalidate(cityRowsProvider(destination.id)),
            child: value.isEmpty
                ? ListView(
                    children: [
                      SizedBox(
                        height: 360,
                        child: EmptyStateView(
                          icon: Ic.pin,
                          title: 'No cities yet',
                          message: 'A hotel or sightseeing entry can only use a '
                              'city that exists here.',
                          actionLabel: 'Add city',
                          onAction: () => _addCity(context, ref, destination),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    itemCount: value.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x10),
                    itemBuilder: (context, index) => _CityRow(
                      city: value[index],
                      destination: destination,
                    ),
                  ),
          ),
      },
    );
  }
}

Future<void> _addCity(
  BuildContext context,
  WidgetRef ref,
  DestinationMaster destination,
) async {
  final saved = await CityFormSheet.show(
    context,
    destinationId: destination.id,
    destinationName: destination.name,
  );
  if (saved == null) return;
  ref.invalidate(cityRowsProvider(destination.id));
  if (context.mounted) AppToast.success(context, 'City added', saved);
}

class _CityRow extends ConsumerWidget {
  const _CityRow({required this.city, required this.destination});

  final CityMaster city;
  final DestinationMaster destination;

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final saved = await CityFormSheet.show(
      context,
      destinationId: destination.id,
      destinationName: destination.name,
      city: city,
    );
    if (saved == null) return;
    ref.invalidate(cityRowsProvider(destination.id));
    if (context.mounted) AppToast.success(context, 'City saved', saved);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete ${city.name}?', style: AppType.h3),
        content: Text(
          // `assertCityDeletable` blocks the delete outright while anything
          // still points at the city, so promising otherwise would be a lie.
          'It moves to Trash. A city still used by a hotel, sightseeing, '
          'transport or add-on cannot be deleted.',
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

    try {
      await ref.read(mastersApiProvider).deleteCity(city.id);
      ref.invalidate(cityRowsProvider(destination.id));
      ref.invalidate(citiesProvider(destination.id));
      if (context.mounted) AppToast.success(context, 'City deleted', city.name);
    } on Failure catch (f) {
      if (context.mounted) AppToast.error(context, 'Could not delete', f.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.x14),
      onTap: () => _edit(context, ref),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(city.name, style: AppType.rowTitle),
                if (city.state != null) ...[
                  const SizedBox(height: AppSpacing.x4),
                  Text(city.state!, style: AppType.bodySm),
                ],
              ],
            ),
          ),
          SizedBox(
            width: 32,
            height: 32,
            child: PopupMenuButton<_RowAction>(
              tooltip: 'City actions',
              padding: EdgeInsets.zero,
              iconSize: 18,
              color: AppColors.surface,
              icon: const AppIcon(Ic.dots, size: 18, color: AppColors.faint),
              onSelected: (action) => switch (action) {
                _RowAction.edit => _edit(context, ref),
                _RowAction.delete => _delete(context, ref),
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
      ),
    );
  }
}
