import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../masters/api/masters_api.dart';
import '../../../masters/presentation/widgets/form_fields.dart';
import '../../../masters/presentation/widgets/geography_providers.dart';

/// The sightseeing a quotation can draw on, narrowed to one destination.
final quoteSightseeingsProvider = FutureProvider.autoDispose
    .family<List<DropdownOption>, int?>(
      (ref, destinationId) => ref
          .watch(mastersApiProvider)
          .getQuoteSightseeings(destinationId: destinationId),
    );

/// What one activity, and its day's pricing, came back as.
class SightseeingEntry {
  const SightseeingEntry({
    required this.activity,
    required this.pricePerPax,
    required this.pax,
  });

  /// A `QuotationRequestDto.Activity` map.
  final Map<String, dynamic> activity;

  /// Priced on the **day**, not the activity — the wire has no per-activity
  /// price, so this is what the day carries once this one is added to it.
  final double? pricePerPax;
  final int? pax;
}

/// Add one sightseeing activity to a day of the itinerary.
///
/// The wire shape is two levels deep — `sightseeing.days[].activities[]` — so
/// this sheet edits an activity **and** the day's price per head, because that
/// is where the money sits. There is no per-activity price on the wire.
class SightseeingActivitySheet extends ConsumerStatefulWidget {
  const SightseeingActivitySheet({
    super.key,
    required this.dayNumber,
    this.destinationId,
    this.activity,
    this.pricePerPax,
    this.pax,
  });

  final int dayNumber;

  /// Narrows the master list. Null shows every sightseeing the tenant has.
  final int? destinationId;

  /// The existing activity, or null when adding.
  final Map<String, dynamic>? activity;

  final double? pricePerPax;
  final int? pax;

  static Future<SightseeingEntry?> show(
    BuildContext context, {
    required int dayNumber,
    int? destinationId,
    Map<String, dynamic>? activity,
    double? pricePerPax,
    int? pax,
  }) {
    return showModalBottomSheet<SightseeingEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SightseeingActivitySheet(
          dayNumber: dayNumber,
          destinationId: destinationId,
          activity: activity,
          pricePerPax: pricePerPax,
          pax: pax,
        ),
      ),
    );
  }

  @override
  ConsumerState<SightseeingActivitySheet> createState() =>
      _SightseeingActivitySheetState();
}

class _SightseeingActivitySheetState
    extends ConsumerState<SightseeingActivitySheet> {
  late final _attraction = TextEditingController(
    text: _string('attraction') ?? '',
  );
  late final _description = TextEditingController(
    text: _string('description') ?? '',
  );
  late final _price = TextEditingController(
    text: widget.pricePerPax?.toString() ?? '',
  );
  late final _pax = TextEditingController(text: widget.pax?.toString() ?? '');

  late TimeOfDay? _startTime = _parseTime(_string('startTime'));
  String? _error;

  String? _string(String key) {
    final value = widget.activity?[key];
    return value is String && value.isNotEmpty ? value : null;
  }

  /// `HH:mm` off the wire; anything else is treated as unset rather than
  /// guessed at.
  static TimeOfDay? _parseTime(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String? _wireTime(TimeOfDay? time) => time == null
      ? null
      : '${time.hour.toString().padLeft(2, '0')}:'
            '${time.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _attraction.dispose();
    _description.dispose();
    _price.dispose();
    _pax.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  void _submit() {
    final attraction = _attraction.text.trim();
    if (attraction.isEmpty) {
      setState(() => _error = 'Choose or name the sightseeing.');
      return;
    }
    final price = double.tryParse(_price.text.trim().replaceAll(',', ''));
    if (_price.text.trim().isNotEmpty && price == null) {
      setState(() => _error = 'The price must be a number.');
      return;
    }

    final activity = <String, dynamic>{...?widget.activity};
    activity['attraction'] = attraction;
    activity['startTime'] = _wireTime(_startTime);
    activity['description'] = _description.text.trim().isEmpty
        ? null
        : _description.text.trim();

    Navigator.of(context).pop(
      SightseeingEntry(
        activity: activity,
        pricePerPax: price,
        pax: int.tryParse(_pax.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = ref.watch(quoteSightseeingsProvider(widget.destinationId));

    return SheetScaffold(
      title: widget.activity == null
          ? 'Add to day ${widget.dayNumber}'
          : 'Edit day ${widget.dayNumber}',
      subtitle:
          'Sightseeing is priced per head for the whole day, so the price '
          'below covers everything on this day.',
      error: _error,
      busy: false,
      submitLabel: widget.activity == null ? 'Add to day' : 'Save',
      onSubmit: _submit,
      children: [
        SheetPicker<String>(
          label: 'From your sightseeing',
          hint: 'Pick a sightseeing',
          enabled: true,
          value: _attraction.text.trim().isEmpty
              ? null
              : _attraction.text.trim(),
          options: asyncOptions(options),
          optionValue: (o) => o.label,
          onChanged: (value) => setState(() => _attraction.text = value ?? ''),
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Attraction',
          controller: _attraction,
          enabled: true,
          hint: 'Or type it',
          textCapitalization: TextCapitalization.words,
          maxLength: 200,
        ),
        const SizedBox(height: AppSpacing.x14),
        Text('Start time', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        InkWell(
          onTap: _pickTime,
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
                const AppIcon(Ic.clock, size: 15, color: AppColors.muted),
                const SizedBox(width: AppSpacing.x8),
                Text(
                  _startTime == null ? 'Not set' : _startTime!.format(context),
                  style: _startTime == null
                      ? AppType.fieldValue.copyWith(color: AppColors.faint)
                      : AppType.fieldValue,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Notes',
          controller: _description,
          enabled: true,
          hint: 'Tickets, transfers, what is included…',
          maxLines: 2,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSpacing.x16),
        const Divider(height: 1),
        const SizedBox(height: AppSpacing.x14),
        Text('Day ${widget.dayNumber} pricing', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        Row(
          children: [
            Expanded(
              child: SheetField(
                label: 'Per head',
                controller: _price,
                enabled: true,
                hint: '₹',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                maxLength: 10,
              ),
            ),
            const SizedBox(width: AppSpacing.x10),
            Expanded(
              child: SheetField(
                label: 'Heads',
                controller: _pax,
                enabled: true,
                hint: 'From the lead',
                keyboardType: TextInputType.number,
                maxLength: 3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
