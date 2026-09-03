import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../masters/api/masters_api.dart';
import '../../../masters/presentation/widgets/form_fields.dart';
import '../../../masters/presentation/widgets/geography_providers.dart';

/// The vehicles the tenant can quote.
final quoteVehiclesProvider = FutureProvider.autoDispose<List<DropdownOption>>(
  (ref) => ref.watch(mastersApiProvider).getQuoteVehicles(),
);

/// One vehicle line on a quotation.
///
/// Returns a `QuotationRequestDto.VehicleItem` map. Picking from the master
/// only fills `model`; the line is the quotation's own, and the backend's own
/// comment says a hand-typed line with no master id "must keep working
/// untouched".
class VehicleRowSheet extends ConsumerStatefulWidget {
  const VehicleRowSheet({super.key, this.row});

  /// The existing line, or null when adding.
  final Map<String, dynamic>? row;

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    Map<String, dynamic>? row,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: VehicleRowSheet(row: row),
      ),
    );
  }

  @override
  ConsumerState<VehicleRowSheet> createState() => _VehicleRowSheetState();
}

class _VehicleRowSheetState extends ConsumerState<VehicleRowSheet> {
  static const _types = ['Sedan', 'SUV', 'Tempo Traveller', 'Bus', 'Luxury'];

  late final _model = TextEditingController(text: _string('model'));
  late final _pickup = TextEditingController(text: _string('pickup'));
  late final _drop = TextEditingController(text: _string('drop'));
  late final _qty = TextEditingController(
    text: _number('qty')?.toString() ?? '1',
  );
  late final _price = TextEditingController(
    text: (_number('pricePerVehicle') ?? _number('price'))?.toString() ?? '',
  );

  late String? _type = _string('type');
  String? _error;

  String? _string(String key) {
    final value = widget.row?[key];
    return value is String && value.isNotEmpty ? value : null;
  }

  num? _number(String key) {
    final value = widget.row?[key];
    return value is num ? value : null;
  }

  @override
  void dispose() {
    _model.dispose();
    _pickup.dispose();
    _drop.dispose();
    _qty.dispose();
    _price.dispose();
    super.dispose();
  }

  void _submit() {
    final model = _model.text.trim();
    if (model.isEmpty && (_type == null || _type!.isEmpty)) {
      setState(() => _error = 'Choose a vehicle, or at least give it a type.');
      return;
    }
    final price = double.tryParse(_price.text.trim().replaceAll(',', ''));
    if (_price.text.trim().isNotEmpty && price == null) {
      setState(() => _error = 'The price must be a number.');
      return;
    }

    // Preserve whatever the incoming row carried — the master and marketplace
    // ids, `rateSource`, the image — since nothing here edits them.
    final row = <String, dynamic>{...?widget.row};
    row['model'] = model.isEmpty ? null : model;
    row['type'] = _type;
    row['pickup'] = _pickup.text.trim().isEmpty ? null : _pickup.text.trim();
    row['drop'] = _drop.text.trim().isEmpty ? null : _drop.text.trim();
    row['qty'] = int.tryParse(_qty.text.trim()) ?? 1;
    row['pricePerVehicle'] = price;
    Navigator.of(context).pop(row);
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(quoteVehiclesProvider);

    return SheetScaffold(
      title: widget.row == null ? 'Add vehicle' : 'Edit vehicle',
      subtitle:
          'The line is stored on the quotation — picking from your '
          'masters only fills the fields.',
      error: _error,
      busy: false,
      submitLabel: widget.row == null ? 'Add line' : 'Save line',
      onSubmit: _submit,
      children: [
        SheetPicker<String>(
          label: 'From your vehicles',
          hint: 'Pick a vehicle',
          enabled: true,
          value: _model.text.trim().isEmpty ? null : _model.text.trim(),
          options: asyncOptions(vehicles),
          optionValue: (o) => o.label,
          onChanged: (value) => setState(() => _model.text = value ?? ''),
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Vehicle',
          controller: _model,
          enabled: true,
          hint: 'Or type it',
          textCapitalization: TextCapitalization.words,
          maxLength: 150,
        ),
        const SizedBox(height: AppSpacing.x14),
        Text('Type', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        Wrap(
          spacing: AppSpacing.x8,
          runSpacing: AppSpacing.x8,
          children: [
            for (final type in _types)
              SheetChip(
                label: type,
                active: _type == type,
                onTap: () =>
                    setState(() => _type = _type == type ? null : type),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Pick-up',
          controller: _pickup,
          enabled: true,
          hint: 'Airport, hotel…',
          textCapitalization: TextCapitalization.words,
          maxLength: 200,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Drop',
          controller: _drop,
          enabled: true,
          hint: 'Where the trip ends',
          textCapitalization: TextCapitalization.words,
          maxLength: 200,
        ),
        const SizedBox(height: AppSpacing.x14),
        Row(
          children: [
            Expanded(
              child: SheetField(
                label: 'Vehicles',
                controller: _qty,
                enabled: true,
                keyboardType: TextInputType.number,
                maxLength: 3,
              ),
            ),
            const SizedBox(width: AppSpacing.x10),
            Expanded(
              child: SheetField(
                label: 'Price per vehicle',
                controller: _price,
                enabled: true,
                hint: '₹',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                maxLength: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
