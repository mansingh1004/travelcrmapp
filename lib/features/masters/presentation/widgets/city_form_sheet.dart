import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/theme/app_theme.dart';
import '../../api/masters_api.dart';
import 'form_fields.dart';
import 'geography_providers.dart';

/// Create or edit a city under one destination.
///
/// Create goes through the nested route,
/// `POST /api/v1/destinations/{destinationId}/cities`, so a city can never be
/// saved without its destination. Edit uses the flat `PUT /api/cities/{id}`
/// and sends the destination back in the body.
///
/// This is the only way a city gets into the system from the app: the hotel and
/// sightseeing endpoints resolve a city by name and refuse to create one.
class CityFormSheet extends ConsumerStatefulWidget {
  const CityFormSheet({
    super.key,
    required this.destinationId,
    required this.destinationName,
    this.city,
  });

  final int destinationId;
  final String destinationName;

  /// Null when creating.
  final CityMaster? city;

  /// Returns the saved name, or null when nothing was saved.
  static Future<String?> show(
    BuildContext context, {
    required int destinationId,
    required String destinationName,
    CityMaster? city,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: CityFormSheet(
          destinationId: destinationId,
          destinationName: destinationName,
          city: city,
        ),
      ),
    );
  }

  @override
  ConsumerState<CityFormSheet> createState() => _CityFormSheetState();
}

class _CityFormSheetState extends ConsumerState<CityFormSheet> {
  late final _name = TextEditingController(text: widget.city?.name ?? '');
  late final _state = TextEditingController(text: widget.city?.state ?? '');

  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.city != null;

  @override
  void dispose() {
    _name.dispose();
    _state.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Enter the city name.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final api = ref.read(mastersApiProvider);
    try {
      if (_isEdit) {
        await api.updateCity(
          widget.city!.id,
          name: name,
          destinationId: widget.destinationId,
          state: _state.text,
        );
      } else {
        await api.createCity(
          widget.destinationId,
          name: name,
          state: _state.text,
        );
      }
      if (!mounted) return;
      // The hotel and sightseeing forms cache this destination's cities.
      ref.invalidate(citiesProvider(widget.destinationId));
      Navigator.of(context).pop(name);
    } on Failure catch (f) {
      if (mounted) setState(() => _error = f.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: _isEdit ? 'Edit city' : 'Add city',
      subtitle: 'Under ${widget.destinationName}. Hotels and sightseeing can '
          'only use a city that already exists here.',
      error: _error,
      busy: _busy,
      submitLabel: _isEdit ? 'Save changes' : 'Add city',
      onSubmit: _submit,
      children: [
        SheetField(
          label: 'City name',
          controller: _name,
          enabled: !_busy,
          hint: 'e.g. Udaipur',
          textCapitalization: TextCapitalization.words,
          maxLength: 150,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'State',
          controller: _state,
          enabled: !_busy,
          hint: 'e.g. Rajasthan',
          textCapitalization: TextCapitalization.words,
          maxLength: 100,
        ),
      ],
    );
  }
}
