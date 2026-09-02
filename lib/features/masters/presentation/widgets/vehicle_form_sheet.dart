import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/theme/app_theme.dart';
import '../../api/masters_api.dart';
import 'form_fields.dart';

/// Create or edit one of the tenant's own vehicles.
///
/// `POST /api/vehicles` and `PUT /api/vehicles/{publicId}` — this catalog is
/// keyed by UUID, not by a numeric id.
///
/// Global vehicles never reach this sheet: they belong to the platform and the
/// server answers 403 to any edit, so the list offers none.
class VehicleFormSheet extends ConsumerStatefulWidget {
  const VehicleFormSheet({super.key, this.vehicle});

  /// Null when creating.
  final VehicleMaster? vehicle;

  /// Returns the saved vehicle's name, or null when nothing was saved.
  ///
  /// A name rather than a bool so the **caller** can raise the toast: this
  /// sheet's context is already deactivated the moment it is popped.
  static Future<String?> show(BuildContext context, {VehicleMaster? vehicle}) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: VehicleFormSheet(vehicle: vehicle),
      ),
    );
  }

  @override
  ConsumerState<VehicleFormSheet> createState() => _VehicleFormSheetState();
}

class _VehicleFormSheetState extends ConsumerState<VehicleFormSheet> {
  /// The types already in use on this backend's seed data. Free text on the
  /// wire, so the field stays editable — these are a shortcut, not a whitelist.
  static const _types = ['Sedan', 'SUV', 'Tempo Traveller', 'Bus', 'Luxury'];

  late final _name = TextEditingController(text: widget.vehicle?.name ?? '');
  late final _type = TextEditingController(text: widget.vehicle?.type ?? '');
  late final _capacity = TextEditingController(
    text: widget.vehicle?.capacity?.toString() ?? '',
  );
  late final _description =
      TextEditingController(text: widget.vehicle?.description ?? '');

  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.vehicle != null;

  @override
  void dispose() {
    _name.dispose();
    _type.dispose();
    _capacity.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    final type = _type.text.trim();

    // Both are @NotBlank on the server; catching them here reads better than
    // the generic 400.
    if (name.isEmpty) {
      setState(() => _error = 'Enter the vehicle name.');
      return;
    }
    if (type.isEmpty) {
      setState(() => _error = 'Enter the vehicle type.');
      return;
    }

    final capacityText = _capacity.text.trim();
    final capacity = capacityText.isEmpty ? null : int.tryParse(capacityText);
    // The server's @Min(1) would reject it; say so before the round trip.
    if (capacityText.isNotEmpty && (capacity == null || capacity < 1)) {
      setState(() => _error = 'Seats must be a whole number of at least 1.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final api = ref.read(mastersApiProvider);
    try {
      if (_isEdit) {
        await api.updateVehicle(
          widget.vehicle!.publicId,
          name: name,
          type: type,
          capacity: capacity,
          description: _description.text,
        );
      } else {
        await api.createVehicle(
          name: name,
          type: type,
          capacity: capacity,
          description: _description.text,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(name);
    } on Failure catch (f) {
      // A 403 lands here too — writing needs PLATFORM_ADMIN or MASTER_MANAGE,
      // and the app holds no copy of the user's authorities to check first.
      if (mounted) setState(() => _error = f.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: _isEdit ? 'Edit vehicle' : 'Add vehicle',
      subtitle: 'Saved to your agency’s vehicle master, ready to pick when you '
          'build a quotation.',
      error: _error,
      busy: _busy,
      submitLabel: _isEdit ? 'Save changes' : 'Add vehicle',
      onSubmit: _submit,
      children: [
        SheetField(
          label: 'Vehicle name',
          controller: _name,
          enabled: !_busy,
          hint: 'e.g. Toyota Innova Crysta',
          textCapitalization: TextCapitalization.words,
          maxLength: 150,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Type',
          controller: _type,
          enabled: !_busy,
          hint: 'Sedan, SUV, Tempo Traveller…',
          textCapitalization: TextCapitalization.words,
          maxLength: 80,
        ),
        const SizedBox(height: AppSpacing.x8),
        Wrap(
          spacing: AppSpacing.x8,
          runSpacing: AppSpacing.x8,
          children: [
            for (final type in _types)
              SheetChip(
                label: type,
                active: _type.text.trim().toLowerCase() == type.toLowerCase(),
                onTap: _busy
                    ? null
                    : () => setState(() {
                          _type.text = type;
                          _type.selection =
                              TextSelection.collapsed(offset: type.length);
                        }),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Seats',
          controller: _capacity,
          enabled: !_busy,
          hint: 'Passenger capacity',
          keyboardType: TextInputType.number,
          maxLength: 3,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Notes',
          controller: _description,
          enabled: !_busy,
          hint: 'AC, luggage space, driver included…',
          maxLines: 2,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}
