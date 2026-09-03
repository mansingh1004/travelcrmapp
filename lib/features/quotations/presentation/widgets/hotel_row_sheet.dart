import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/formatters/app_date.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../masters/api/masters_api.dart';
import '../../../masters/presentation/widgets/form_fields.dart';
import '../../../masters/presentation/widgets/geography_providers.dart';

/// The hotels the tenant can quote, and the room types under one of them.
final quoteHotelsProvider = FutureProvider.autoDispose
    .family<List<DropdownOption>, int?>(
      (ref, destinationId) => ref
          .watch(mastersApiProvider)
          .getQuoteHotels(destinationId: destinationId),
    );

final quoteRoomTypesProvider = FutureProvider.autoDispose
    .family<List<DropdownOption>, int>(
      (ref, hotelId) => ref.watch(mastersApiProvider).getRoomTypes(hotelId),
    );

final quoteMealPlansProvider = FutureProvider.autoDispose
    .family<List<DropdownOption>, int>(
      (ref, hotelId) => ref.watch(mastersApiProvider).getMealPlans(hotelId),
    );

/// One hotel line on a quotation.
///
/// Returns the row as the wire wants it — `QuotationRequestDto.HotelItem`, the
/// same shape the response hands back, so an edited row and an untouched one
/// are indistinguishable on save.
///
/// Only the fields that change the quotation: hotel, city, dates, room type,
/// meal plan, rooms and the per-room price. `bedType`, `occupancy`, `childAges`
/// and the platform-marketplace ids stay on whatever the row already had.
class HotelRowSheet extends ConsumerStatefulWidget {
  const HotelRowSheet({
    super.key,
    this.row,
    this.destinationId,
    this.cities = const [],
  });

  /// The existing line, or null when adding.
  final Map<String, dynamic>? row;

  /// Narrows the hotel list to one destination. Null shows every hotel.
  final int? destinationId;

  /// The cities the trip actually visits, offered instead of free text.
  final List<String> cities;

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    Map<String, dynamic>? row,
    int? destinationId,
    List<String> cities = const [],
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
        child: HotelRowSheet(
          row: row,
          destinationId: destinationId,
          cities: cities,
        ),
      ),
    );
  }

  @override
  ConsumerState<HotelRowSheet> createState() => _HotelRowSheetState();
}

class _HotelRowSheetState extends ConsumerState<HotelRowSheet> {
  late final _name = TextEditingController(text: _string('name'));
  late final _city = TextEditingController(text: _string('city'));
  late final _rooms = TextEditingController(
    text: _number('rooms')?.toString() ?? '1',
  );
  late final _price = TextEditingController(
    text: _number('pricePerRoom')?.toString() ?? '',
  );

  int? _hotelId;
  late String? _roomType = _string('roomType');
  late String? _mealPlan = _string('mealPlan');
  late DateTime? _checkIn = AppDate.parseDate(_string('checkIn'));
  late DateTime? _checkOut = AppDate.parseDate(_string('checkOut'));

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
    _name.dispose();
    _city.dispose();
    _rooms.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool checkIn}) async {
    final now = DateTime.now();
    final initial = (checkIn ? _checkIn : _checkOut) ?? _checkIn ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked == null) return;
    setState(() {
      if (checkIn) {
        _checkIn = picked;
        // Keep the stay valid rather than letting the server reject it.
        if (_checkOut != null && !_checkOut!.isAfter(picked)) _checkOut = null;
      } else {
        _checkOut = picked;
      }
    });
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Choose or name the hotel.');
      return;
    }
    if (_checkIn != null &&
        _checkOut != null &&
        !_checkOut!.isAfter(_checkIn!)) {
      setState(() => _error = 'Check-out must be after check-in.');
      return;
    }
    final price = double.tryParse(_price.text.trim().replaceAll(',', ''));
    if (_price.text.trim().isNotEmpty && price == null) {
      setState(() => _error = 'The price must be a number.');
      return;
    }

    // Start from the row that came in, so fields with no editor here — bed
    // type, occupancy, child ages, the marketplace ids — are preserved.
    final row = <String, dynamic>{...?widget.row};
    row['name'] = name;
    row['city'] = _city.text.trim().isEmpty ? null : _city.text.trim();
    row['checkIn'] = _wire(_checkIn);
    row['checkOut'] = _wire(_checkOut);
    row['roomType'] = _roomType;
    row['mealPlan'] = _mealPlan;
    row['rooms'] = int.tryParse(_rooms.text.trim()) ?? 1;
    row['pricePerRoom'] = price;
    Navigator.of(context).pop(row);
  }

  /// `yyyy-MM-dd`, which is what the section carries on the wire.
  static String? _wire(DateTime? date) => date == null
      ? null
      : '${date.year.toString().padLeft(4, '0')}-'
            '${date.month.toString().padLeft(2, '0')}-'
            '${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final hotels = ref.watch(quoteHotelsProvider(widget.destinationId));

    return SheetScaffold(
      title: widget.row == null ? 'Add hotel' : 'Edit hotel',
      subtitle:
          'The line is stored on the quotation, not in your masters — '
          'picking one only fills the fields.',
      error: _error,
      busy: false,
      submitLabel: widget.row == null ? 'Add line' : 'Save line',
      onSubmit: _submit,
      children: [
        SheetPicker<int>(
          label: 'From your hotels',
          hint: 'Pick a hotel',
          enabled: true,
          value: _hotelId,
          options: asyncOptions(hotels),
          optionValue: (o) => o.value,
          onChanged: (value) => setState(() {
            _hotelId = value;
            final picked = hotels.value?.where((o) => o.value == value);
            if (picked != null && picked.isNotEmpty) {
              _name.text = picked.first.label;
            }
            // Room types and meal plans belong to a hotel; the old ones would
            // not exist under the new one.
            _roomType = null;
            _mealPlan = null;
          }),
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Hotel name',
          controller: _name,
          enabled: true,
          hint: 'Or type it',
          textCapitalization: TextCapitalization.words,
          maxLength: 200,
        ),
        const SizedBox(height: AppSpacing.x14),
        // The trip's own stops when they are known, free text otherwise: the
        // city is a label on the quotation, not a foreign key, so anything the
        // agent types is valid.
        if (widget.cities.isEmpty)
          SheetField(
            label: 'City',
            controller: _city,
            enabled: true,
            hint: 'Shown on the quotation',
            textCapitalization: TextCapitalization.words,
            maxLength: 100,
          )
        else
          SheetPicker<String>(
            label: 'City',
            hint: 'Which stop this stay is for',
            enabled: true,
            value: _city.text.trim().isEmpty ? null : _city.text.trim(),
            options: AsyncValueLike(
              options: [
                for (final city in widget.cities)
                  DropdownOption(value: 0, label: city),
              ],
            ),
            optionValue: (o) => o.label,
            onChanged: (value) => setState(() => _city.text = value ?? ''),
          ),
        const SizedBox(height: AppSpacing.x14),
        Row(
          children: [
            Expanded(
              child: _DateField(
                label: 'Check-in',
                value: _checkIn,
                onTap: () => _pickDate(checkIn: true),
              ),
            ),
            const SizedBox(width: AppSpacing.x10),
            Expanded(
              child: _DateField(
                label: 'Check-out',
                value: _checkOut,
                onTap: () => _pickDate(checkIn: false),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetPicker<String>(
          label: 'Room type',
          hint: _hotelId == null ? 'Pick a hotel first' : 'Choose a room type',
          enabled: _hotelId != null,
          value: _roomType,
          options: _hotelId == null
              ? const AsyncValueLike()
              : asyncOptions(ref.watch(quoteRoomTypesProvider(_hotelId!))),
          optionValue: (o) => o.label,
          onChanged: (value) => setState(() => _roomType = value),
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetPicker<String>(
          label: 'Meal plan',
          hint: _hotelId == null ? 'Pick a hotel first' : 'Choose a meal plan',
          enabled: _hotelId != null,
          value: _mealPlan,
          options: _hotelId == null
              ? const AsyncValueLike()
              : asyncOptions(ref.watch(quoteMealPlansProvider(_hotelId!))),
          optionValue: (o) => o.label,
          onChanged: (value) => setState(() => _mealPlan = value),
        ),
        const SizedBox(height: AppSpacing.x14),
        Row(
          children: [
            Expanded(
              child: SheetField(
                label: 'Rooms',
                controller: _rooms,
                enabled: true,
                keyboardType: TextInputType.number,
                maxLength: 3,
              ),
            ),
            const SizedBox(width: AppSpacing.x10),
            Expanded(
              child: SheetField(
                label: 'Price per room',
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

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(AppRadii.tile),
            ),
            child: Row(
              children: [
                const AppIcon(Ic.calendar, size: 15, color: AppColors.muted),
                const SizedBox(width: AppSpacing.x8),
                Expanded(
                  child: Text(
                    value == null ? 'Not set' : AppDate.display(value),
                    style: value == null
                        ? AppType.fieldValue.copyWith(color: AppColors.faint)
                        : AppType.fieldValue,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
