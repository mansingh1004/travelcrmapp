import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/quotation_api.dart';
import '../../../router/routes.dart';
import '../../../router/safe_pop.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import 'widgets/hotel_row_sheet.dart';
import 'widgets/vehicle_row_sheet.dart';

/// The quotation as raw JSON, so unedited sections survive a save intact.
final quotationDocumentProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>(
      (ref, publicId) =>
          ref.watch(quotationApiProvider).getQuotationRaw(publicId),
    );

/// Choose the hotels and vehicles on a draft, then save.
///
/// **The whole document goes back on every save.**
/// `quotationMapper.applyRequest` re-maps every section, so a body that omits
/// `sightseeing` erases the sightseeing. This screen therefore edits a copy of
/// the fetched JSON and PUTs all of it — the sections it has no editor for
/// (flights, cruises, add-ons, day plans) ride along untouched.
///
/// The only arithmetic done here is each section's own total — `computeTotals`
/// sums the six section `amount` scalars and never reads the rows, so a section
/// saved without one silently falls out of the quotation's total. Discount,
/// markup, tax, the grand total and the per-head figure stay server-side and
/// are only ever displayed.
class QuotationEditScreen extends ConsumerStatefulWidget {
  const QuotationEditScreen({super.key, required this.publicId});

  final String publicId;

  @override
  ConsumerState<QuotationEditScreen> createState() =>
      _QuotationEditScreenState();
}

class _QuotationEditScreenState extends ConsumerState<QuotationEditScreen> {
  /// The working copy. Null until the first load lands.
  Map<String, dynamic>? _doc;
  bool _dirty = false;
  bool _saving = false;

  List<Map<String, dynamic>> _rows(String section, String listKey) {
    final s = _doc?[section];
    if (s is! Map) return const [];
    final list = s[listKey];
    if (list is! List) return const [];
    return list.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }

  void _writeRows(
    String section,
    String listKey,
    List<Map<String, dynamic>> rows,
  ) {
    final doc = _doc!;
    final existing = doc[section];
    final section0 = existing is Map
        ? Map<String, dynamic>.from(existing)
        : <String, dynamic>{};
    section0[listKey] = rows;
    // A section with rows must be marked included, or `amountIfIncluded` zeroes
    // it on write: the flag, not the rows, decides whether the money counts.
    section0['included'] = rows.isNotEmpty;
    section0['title'] ??= section == 'hotel' ? 'Accommodation' : 'Transport';
    section0['amount'] = sectionAmount(section, rows);
    doc[section] = section0;
    setState(() => _dirty = true);
  }

  Future<void> _editHotel({Map<String, dynamic>? row, int? index}) async {
    final result = await HotelRowSheet.show(context, row: row);
    if (result == null) return;
    final rows = _rows('hotel', 'hotels');
    if (index == null) {
      rows.add(result);
    } else {
      rows[index] = result;
    }
    _writeRows('hotel', 'hotels', rows);
  }

  Future<void> _editVehicle({Map<String, dynamic>? row, int? index}) async {
    final result = await VehicleRowSheet.show(context, row: row);
    if (result == null) return;
    final rows = _rows('vehicle', 'vehicles');
    if (index == null) {
      rows.add(result);
    } else {
      rows[index] = result;
    }
    _writeRows('vehicle', 'vehicles', rows);
  }

  void _removeRow(String section, String listKey, int index) {
    final rows = _rows(section, listKey)..removeAt(index);
    _writeRows(section, listKey, rows);
  }

  Future<void> _save() async {
    final doc = _doc;
    if (doc == null) return;

    setState(() => _saving = true);
    try {
      await ref
          .read(quotationApiProvider)
          .updateQuotationRaw(
            widget.publicId,
            QuotationApi.editableDocument(doc),
          );
      if (!mounted) return;
      // The preview reads its own copy, and the totals were just recomputed
      // server-side, so both have to be re-fetched.
      ref.invalidate(quotationDocumentProvider(widget.publicId));
      context.pushReplacement(Routes.quotationPreviewFor(widget.publicId));
    } on Failure catch (f) {
      if (mounted) {
        setState(() => _saving = false);
        AppToast.error(context, 'Could not save', f.message);
      }
    }
  }

  Future<bool> _confirmDiscard() async {
    if (!_dirty || _saving) return true;
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Discard changes?', style: AppType.h3),
        content: Text(
          'The rows you added have not been saved to this quotation yet.',
          style: AppType.bodySm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(quotationDocumentProvider(widget.publicId));

    // Seed the working copy once; later rebuilds must not overwrite the edits.
    if (_doc == null) {
      final loaded = async.value;
      if (loaded != null) _doc = Map<String, dynamic>.from(loaded);
    }

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard() && context.mounted) context.backOrHome();
      },
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              if (await _confirmDiscard() && context.mounted) {
                context.backOrHome();
              }
            },
            icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
            tooltip: 'Back',
          ),
          title: Text('Services', style: AppType.h2),
          shape: const Border(bottom: BorderSide(color: AppColors.line)),
        ),
        body: switch (async) {
          AsyncLoading() => const SkeletonList(itemCount: 4, itemHeight: 96),
          AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () =>
                ref.invalidate(quotationDocumentProvider(widget.publicId)),
          ),
          AsyncData() => _Body(
            title: _doc?['title'] as String? ?? 'Quotation',
            hotels: _rows('hotel', 'hotels'),
            vehicles: _rows('vehicle', 'vehicles'),
            onAddHotel: () => _editHotel(),
            onEditHotel: (i, row) => _editHotel(row: row, index: i),
            onRemoveHotel: (i) => _removeRow('hotel', 'hotels', i),
            onAddVehicle: () => _editVehicle(),
            onEditVehicle: (i, row) => _editVehicle(row: row, index: i),
            onRemoveVehicle: (i) => _removeRow('vehicle', 'vehicles', i),
          ),
        },
        bottomNavigationBar: async.hasValue
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _saving || !_dirty ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onPrimary,
                              ),
                            )
                          : Text(_dirty ? 'Save quotation' : 'Nothing to save'),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.title,
    required this.hotels,
    required this.vehicles,
    required this.onAddHotel,
    required this.onEditHotel,
    required this.onRemoveHotel,
    required this.onAddVehicle,
    required this.onEditVehicle,
    required this.onRemoveVehicle,
  });

  final String title;
  final List<Map<String, dynamic>> hotels;
  final List<Map<String, dynamic>> vehicles;
  final VoidCallback onAddHotel;
  final void Function(int, Map<String, dynamic>) onEditHotel;
  final ValueChanged<int> onRemoveHotel;
  final VoidCallback onAddVehicle;
  final void Function(int, Map<String, dynamic>) onEditVehicle;
  final ValueChanged<int> onRemoveVehicle;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      children: [
        Text(title, style: AppType.h3),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Pick the hotels and vehicles. The server prices the quotation from '
          'these lines. Day plans, flights and add-ons stay on the desktop '
          'console and are left as they are.',
          style: AppType.bodySm,
        ),
        const SizedBox(height: AppSpacing.x18),
        _Section(
          label: 'Hotels',
          icon: Ic.bed,
          rows: [
            for (var i = 0; i < hotels.length; i++)
              _RowTile(
                title: hotels[i]['name'] as String? ?? 'Hotel',
                subtitle: _hotelSubtitle(hotels[i]),
                amount: _lineTotal(
                  hotels[i]['pricePerRoom'],
                  hotels[i]['rooms'],
                ),
                onTap: () => onEditHotel(i, hotels[i]),
                onRemove: () => onRemoveHotel(i),
              ),
          ],
          onAdd: onAddHotel,
          addLabel: 'Add hotel',
        ),
        const SizedBox(height: AppSpacing.x18),
        _Section(
          label: 'Vehicles',
          icon: Ic.car,
          rows: [
            for (var i = 0; i < vehicles.length; i++)
              _RowTile(
                title:
                    vehicles[i]['model'] as String? ??
                    vehicles[i]['type'] as String? ??
                    'Vehicle',
                subtitle: _vehicleSubtitle(vehicles[i]),
                amount: _lineTotal(
                  vehicles[i]['pricePerVehicle'] ?? vehicles[i]['price'],
                  vehicles[i]['qty'],
                ),
                onTap: () => onEditVehicle(i, vehicles[i]),
                onRemove: () => onRemoveVehicle(i),
              ),
          ],
          onAdd: onAddVehicle,
          addLabel: 'Add vehicle',
        ),
        const SizedBox(height: AppSpacing.x16),
      ],
    );
  }

  static String? _hotelSubtitle(Map<String, dynamic> row) {
    final parts = <String>[
      if (row['city'] is String && (row['city'] as String).isNotEmpty)
        row['city'] as String,
      if (row['roomType'] is String && (row['roomType'] as String).isNotEmpty)
        row['roomType'] as String,
      if (row['checkIn'] is String && (row['checkIn'] as String).isNotEmpty)
        '${row['checkIn']} → ${row['checkOut'] ?? ''}'.trim(),
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  static String? _vehicleSubtitle(Map<String, dynamic> row) {
    final parts = <String>[
      if (row['type'] is String && (row['type'] as String).isNotEmpty)
        row['type'] as String,
      if (row['pickup'] is String && (row['pickup'] as String).isNotEmpty)
        '${row['pickup']} → ${row['drop'] ?? ''}'.trim(),
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  /// What this line comes to, only so the row reads sensibly. The quotation's
  /// real totals are the server's.
  static String? _lineTotal(Object? unitPrice, Object? qty) {
    final price = unitPrice is num ? unitPrice.toDouble() : null;
    if (price == null || price <= 0) return null;
    final count = qty is num ? qty.toInt() : 1;
    return Inr.compact(price * (count <= 0 ? 1 : count));
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.icon,
    required this.rows,
    required this.onAdd,
    required this.addLabel,
  });

  final String label;
  final String icon;
  final List<Widget> rows;
  final VoidCallback onAdd;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppIcon(icon, size: 16, color: AppColors.muted),
            const SizedBox(width: AppSpacing.x8),
            Text(label, style: AppType.overline),
          ],
        ),
        const SizedBox(height: AppSpacing.x10),
        if (rows.isEmpty)
          AppCard(
            child: Text(
              'Nothing added yet.',
              style: AppType.bodySm.copyWith(color: AppColors.faint),
            ),
          )
        else
          for (final row in rows) ...[
            row,
            const SizedBox(height: AppSpacing.x8),
          ],
        const SizedBox(height: AppSpacing.x4),
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const AppIcon(Ic.plus, size: 15, color: AppColors.primary),
          label: Text(addLabel),
        ),
      ],
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.onTap,
    required this.onRemove,
  });

  final String title;
  final String? subtitle;
  final String? amount;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppType.rowTitle,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    subtitle!,
                    style: AppType.bodySm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (amount != null) ...[
            const SizedBox(width: AppSpacing.x10),
            Text(amount!, style: AppType.monoSm),
          ],
          IconButton(
            onPressed: onRemove,
            iconSize: 16,
            tooltip: 'Remove',
            icon: const AppIcon(Ic.trash, size: 16, color: AppColors.faint),
          ),
        ],
      ),
    );
  }
}

/// What one section costs, summed from its own lines.
///
/// This sum genuinely belongs to the client. `computeTotals` adds up the six
/// section `*Amount` scalars and never looks at the rows — verified against the
/// running backend, where a hotel section saved without an `amount` dropped
/// straight out of the grand total (₹47,900 → ₹13,800) while its rows sat on
/// the quotation looking correct. Everything downstream — discount, markup,
/// tax, the grand total, the per-head figure — is still the server's alone.
///
/// A row with no price contributes nothing; a missing or zero quantity counts
/// as one, which is what the sheets default to.
double sectionAmount(String section, List<Map<String, dynamic>> rows) {
  var total = 0.0;
  for (final row in rows) {
    final unit = section == 'hotel'
        ? row['pricePerRoom']
        : row['pricePerVehicle'] ?? row['price'];
    final count = section == 'hotel' ? row['rooms'] : row['qty'];
    if (unit is num) {
      final quantity = count is num && count > 0 ? count.toInt() : 1;
      total += unit.toDouble() * quantity;
    }
  }
  return total;
}
