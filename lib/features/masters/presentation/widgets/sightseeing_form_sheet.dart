import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/theme/app_theme.dart';
import '../../api/masters_api.dart';
import 'form_fields.dart';
import 'geography_providers.dart';

/// Create or edit one of the tenant's own sightseeing entries.
///
/// `POST /api/sightseeings` and `PUT /api/sightseeings/{id}`.
///
/// **Destination and city are both required**, and not because the request DTO
/// says so — only `title` is `@NotBlank`. `resolveCityByName` throws 400 when
/// either is missing, and 404 when the pair does not exist for this tenant, so
/// both are chosen from the server's own dropdowns rather than typed.
class SightseeingFormSheet extends ConsumerStatefulWidget {
  const SightseeingFormSheet({super.key, this.entry});

  /// Null when creating.
  final SightseeingMaster? entry;

  /// Returns the saved entry's title, or null when nothing was saved.
  ///
  /// A title rather than a bool so the **caller** can raise the toast: this
  /// sheet's context is already deactivated the moment it is popped.
  static Future<String?> show(
    BuildContext context, {
    SightseeingMaster? entry,
  }) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SightseeingFormSheet(entry: entry),
      ),
    );
  }

  @override
  ConsumerState<SightseeingFormSheet> createState() =>
      _SightseeingFormSheetState();
}

class _SightseeingFormSheetState extends ConsumerState<SightseeingFormSheet> {
  late final _title = TextEditingController(text: widget.entry?.title ?? '');
  late final _hours = TextEditingController(
    text: widget.entry?.estimatedHours?.toString() ?? '',
  );
  late final _description =
      TextEditingController(text: widget.entry?.description ?? '');

  /// Held as ids so the city list can be scoped, but sent as names.
  int? _destinationId;
  late String? _destinationName = widget.entry?.destination;
  late String? _city = widget.entry?.city;

  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.entry != null;

  @override
  void dispose() {
    _title.dispose();
    _hours.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Enter a title.');
      return;
    }
    final destination = _destinationName;
    final city = _city;
    if (destination == null || city == null) {
      setState(() => _error = 'Choose a destination and a city.');
      return;
    }

    final hoursText = _hours.text.trim();
    final hours = hoursText.isEmpty ? null : double.tryParse(hoursText);
    if (hoursText.isNotEmpty && hours == null) {
      setState(() => _error = 'Hours must be a number, like 2 or 3.5.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final api = ref.read(mastersApiProvider);
    try {
      if (_isEdit) {
        await api.updateSightseeing(
          widget.entry!.id,
          title: title,
          destination: destination,
          city: city,
          estimatedHours: hours,
          description: _description.text,
        );
      } else {
        await api.createSightseeing(
          title: title,
          destination: destination,
          city: city,
          estimatedHours: hours,
          description: _description.text,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(title);
    } on Failure catch (f) {
      if (mounted) setState(() => _error = f.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final destinations = ref.watch(destinationsProvider);

    return SheetScaffold(
      title: _isEdit ? 'Edit sightseeing' : 'Add sightseeing',
      subtitle: 'Saved to your agency’s sightseeing master, ready to drop into '
          'a day plan.',
      error: _error,
      busy: _busy,
      submitLabel: _isEdit ? 'Save changes' : 'Add sightseeing',
      onSubmit: _submit,
      children: [
        SheetField(
          label: 'Title',
          controller: _title,
          enabled: !_busy,
          hint: 'e.g. Amber Fort with elephant ride',
          textCapitalization: TextCapitalization.sentences,
          maxLength: 200,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetPicker<int>(
          label: 'Destination',
          hint: 'Choose a destination',
          enabled: !_busy,
          value: _destinationId,
          options: asyncOptions(destinations),
          optionValue: (o) => o.value,
          fallbackLabel: _destinationName,
          onChanged: (value) => setState(() {
            _destinationId = value;
            _destinationName = destinations.value
                ?.where((o) => o.value == value)
                .map((o) => o.label)
                .firstOrNull;
            // The city list is per destination, and a city from the old one
            // would not resolve under the new.
            _city = null;
          }),
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetPicker<String>(
          label: 'City',
          hint: _destinationId == null
              ? 'Choose a destination first'
              : 'Choose a city',
          enabled: !_busy && _destinationId != null,
          value: _city,
          options: _destinationId == null
              ? const AsyncValueLike()
              : asyncOptions(ref.watch(citiesProvider(_destinationId!))),
          optionValue: (o) => o.label,
          onChanged: (value) => setState(() => _city = value),
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Estimated hours',
          controller: _hours,
          enabled: !_busy,
          hint: 'e.g. 3',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          maxLength: 5,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Notes',
          controller: _description,
          enabled: !_busy,
          hint: 'Tickets, timings, what is included…',
          maxLines: 2,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}
