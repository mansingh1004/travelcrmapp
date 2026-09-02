import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/theme/app_theme.dart';
import '../../api/masters_api.dart';
import 'form_fields.dart';
import 'geography_providers.dart';

/// Create or edit one of the tenant's own destinations.
///
/// `POST /api/destinations` and `PUT /api/destinations/{id}`.
///
/// **The country is required on create**, though the request DTO does not say
/// so: `createFlat` throws 400 "Either countryId or country name is required".
/// It cannot be changed afterwards — `UpdateDestinationRequest` has no country
/// field at all — so the picker is hidden when editing.
///
/// The five policy fields (`inclusions`, `exclusions`, `paymentPolicies`,
/// `cancellationPolicies`, `bookingTerms`) are rich text written on the desktop
/// console, and are left alone here.
class DestinationFormSheet extends ConsumerStatefulWidget {
  const DestinationFormSheet({super.key, this.destination});

  /// Null when creating.
  final DestinationMaster? destination;

  /// Returns the saved name, or null when nothing was saved. A name rather
  /// than a bool so the caller raises the toast with a context that is alive.
  static Future<String?> show(
    BuildContext context, {
    DestinationMaster? destination,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DestinationFormSheet(destination: destination),
      ),
    );
  }

  @override
  ConsumerState<DestinationFormSheet> createState() =>
      _DestinationFormSheetState();
}

class _DestinationFormSheetState extends ConsumerState<DestinationFormSheet> {
  static const _types = ['Domestic', 'International'];

  late final _name = TextEditingController(text: widget.destination?.name ?? '');
  late final _description =
      TextEditingController(text: widget.destination?.description ?? '');

  late int? _countryId = widget.destination?.countryId;
  late String? _type = widget.destination?.type;
  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.destination != null;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Enter the destination name.');
      return;
    }
    final countryId = _countryId;
    if (!_isEdit && countryId == null) {
      setState(() => _error = 'Choose a country.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final api = ref.read(mastersApiProvider);
    try {
      if (_isEdit) {
        await api.updateDestination(
          widget.destination!.id,
          name: name,
          type: _type,
          description: _description.text,
        );
      } else {
        await api.createDestination(
          name: name,
          countryId: countryId!,
          type: _type,
          description: _description.text,
        );
      }
      if (!mounted) return;
      // A destination the hotel and sightseeing forms have already cached would
      // otherwise not show the new entry until the app restarts.
      ref.invalidate(destinationsProvider);
      Navigator.of(context).pop(name);
    } on Failure catch (f) {
      // A duplicate name for this tenant arrives as a 409 with the server's own
      // wording; a global destination cannot be edited and answers 404.
      if (mounted) setState(() => _error = f.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: _isEdit ? 'Edit destination' : 'Add destination',
      subtitle: 'Hotels and sightseeing sit under a destination, so this comes '
          'first.',
      error: _error,
      busy: _busy,
      submitLabel: _isEdit ? 'Save changes' : 'Add destination',
      onSubmit: _submit,
      children: [
        SheetField(
          label: 'Destination name',
          controller: _name,
          enabled: !_busy,
          hint: 'e.g. Rajasthan',
          textCapitalization: TextCapitalization.words,
          maxLength: 150,
        ),
        const SizedBox(height: AppSpacing.x14),
        if (!_isEdit) ...[
          SheetPicker<int>(
            label: 'Country',
            hint: 'Choose a country',
            enabled: !_busy,
            value: _countryId,
            options: asyncOptions(ref.watch(countriesProvider)),
            optionValue: (o) => o.value,
            onChanged: (value) => setState(() => _countryId = value),
          ),
          const SizedBox(height: AppSpacing.x14),
        ] else ...[
          // Shown, not editable: the update endpoint carries no country.
          Text('Country', style: AppType.overline),
          const SizedBox(height: AppSpacing.x8),
          Text(
            widget.destination?.countryName ?? '—',
            style: AppType.fieldValue.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: AppSpacing.x14),
        ],
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
                onTap: _busy
                    ? null
                    : () => setState(() => _type = _type == type ? null : type),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Description',
          controller: _description,
          enabled: !_busy,
          hint: 'What this destination is known for',
          maxLines: 3,
          maxLength: 1000,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}
