import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../api/masters_api.dart';
import 'form_fields.dart';
import 'geography_providers.dart';

/// Create or edit one of the tenant's own hotels.
///
/// `POST /api/hotels` and `PUT /api/hotels/{id}`. Only the fields a phone is
/// good for: room types, meal plans, rates and images stay with the desktop
/// console, and the server treats every one of them as optional anyway.
///
/// **Destination is required**, and not because the request DTO says so — it
/// does not. `HotelServiceImpl.resolveCity` refuses to place a hotel with no
/// destination, and the city is resolved *by name* against it and must already
/// exist, so both are chosen from the server's own dropdowns rather than typed.
///
/// Platform-synced hotels never reach this sheet — the server rejects a change
/// to any field below on one, so the list offers no edit for them at all.
class HotelFormSheet extends ConsumerStatefulWidget {
  const HotelFormSheet({super.key, this.hotel});

  /// Null when creating.
  final HotelMaster? hotel;

  /// Returns the saved hotel's name, or null when nothing was saved.
  ///
  /// A name rather than a bool so the **caller** can raise the toast. Doing it
  /// here meant calling `ScaffoldMessenger.of` on this sheet's context right
  /// after popping it, and that context is already deactivated by then —
  /// "Looking up a deactivated widget's ancestor is unsafe".
  static Future<String?> show(BuildContext context, {HotelMaster? hotel}) async {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: HotelFormSheet(hotel: hotel),
      ),
    );
  }

  @override
  ConsumerState<HotelFormSheet> createState() => _HotelFormSheetState();
}

class _HotelFormSheetState extends ConsumerState<HotelFormSheet> {
  late final _name = TextEditingController(text: widget.hotel?.name ?? '');
  late final _phone = TextEditingController(text: widget.hotel?.phone ?? '');
  late final _contact = TextEditingController(text: widget.hotel?.contactPerson ?? '');
  late final _address = TextEditingController(text: widget.hotel?.address ?? '');

  late int? _destinationId = widget.hotel?.destinationId;
  late String? _city = widget.hotel?.city;
  late int? _stars = widget.hotel?.stars;

  /// The photo already stored on the server, if any.
  late String? _imagePath = widget.hotel?.imagePath;

  /// A photo chosen on this device but **not yet uploaded**.
  ///
  /// The upload only happens on save. The server charges every uploaded byte
  /// to the tenant's storage quota and never deletes a replaced image, so a
  /// cancelled form must not cost anything.
  XFile? _picked;

  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.hotel != null;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _contact.dispose();
    _address.dispose();
    super.dispose();
  }

  /// Picks a photo and downscales it on the way in.
  ///
  /// `maxWidth`/`imageQuality` are the picker's own, so no extra package: a
  /// phone's 6 MB shot arrives around 300 KB. Without that, every hotel would
  /// spend megabytes of a quota nothing ever reclaims — and the server caps a
  /// request at 11 MB anyway.
  Future<void> _pick(ImageSource source) async {
    final XFile? file;
    try {
      file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 80,
      );
    } on Exception catch (e) {
      // A denied permission or a missing camera arrives as a PlatformException.
      if (mounted) setState(() => _error = 'Could not open the photo: $e');
      return;
    }
    if (file != null && mounted) {
      setState(() {
        _picked = file;
        _error = null;
      });
    }
  }

  /// Offers camera and gallery, and a way to drop the photo again.
  Future<void> _choosePhoto() async {
    final hasPhoto = _picked != null || _imagePath != null;
    final source = await showModalBottomSheet<Object>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const AppIcon(Ic.camera, size: 20, color: AppColors.body),
              title: Text('Take a photo', style: AppType.body),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const AppIcon(Ic.file, size: 20, color: AppColors.body),
              title: Text('Choose from gallery', style: AppType.body),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
            if (hasPhoto)
              ListTile(
                leading: const AppIcon(Ic.trash, size: 20, color: AppColors.danger),
                title: Text(
                  'Remove photo',
                  style: AppType.body.copyWith(color: AppColors.danger),
                ),
                // Only unlinks it here. The stored file stays on the server —
                // nothing in the backend deletes a hotel image.
                onTap: () => Navigator.of(sheetContext).pop('remove'),
              ),
          ],
        ),
      ),
    );

    if (source is ImageSource) {
      await _pick(source);
    } else if (source == 'remove' && mounted) {
      setState(() {
        _picked = null;
        _imagePath = null;
      });
    }
  }

  Future<void> _submit() async {
    final name = _name.text.trim();

    // `name` is the server's only @NotBlank field; catching it here saves a
    // round trip and reads better than the generic 400.
    if (name.isEmpty) {
      setState(() => _error = 'Enter the hotel name.');
      return;
    }
    final destinationId = _destinationId;
    if (destinationId == null) {
      setState(() => _error = 'Choose a destination.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final api = ref.read(mastersApiProvider);
    try {
      // Upload only now, with the save already committed to: a form the user
      // backs out of costs the tenant nothing.
      var imagePath = _imagePath;
      if (_picked != null) {
        imagePath = await api.uploadHotelImage(_picked!.path);
      }

      if (_isEdit) {
        await api.updateHotel(
          widget.hotel!.id,
          name: name,
          destinationId: destinationId,
          city: _city,
          stars: _stars,
          address: _address.text,
          contactPerson: _contact.text,
          phone: _phone.text,
          imagePath: imagePath,
        );
      } else {
        await api.createHotel(
          name: name,
          destinationId: destinationId,
          city: _city,
          stars: _stars,
          address: _address.text,
          contactPerson: _contact.text,
          phone: _phone.text,
          imagePath: imagePath,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(name);
    } on Failure catch (f) {
      // A 403 lands here too: only PLATFORM_ADMIN and MASTER_MANAGE may write,
      // and the app has no copy of the signed-in user's authorities to check
      // against, so the server's own message is what the user sees.
      if (mounted) setState(() => _error = f.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final destinations = ref.watch(destinationsProvider);

    return SheetScaffold(
      title: _isEdit ? 'Edit hotel' : 'Add hotel',
      subtitle: 'Saved to your agency’s hotel master. Room types and rates are '
          'set on the desktop console.',
      error: _error,
      busy: _busy,
      submitLabel: _isEdit ? 'Save changes' : 'Add hotel',
      onSubmit: _submit,
      children: [
        Text('Photo', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        _PhotoTile(
          picked: _picked,
          imagePath: _imagePath,
          onTap: _busy ? null : _choosePhoto,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Hotel name',
          controller: _name,
          enabled: !_busy,
          hint: 'e.g. Taj Lake Palace',
          textCapitalization: TextCapitalization.words,
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
          fallbackLabel: widget.hotel?.destinationName,
          onChanged: (value) => setState(() {
            _destinationId = value;
            // The city list is per destination, and a city name from the old
            // one would be rejected against the new.
            _city = null;
          }),
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetPicker<String>(
          label: 'City',
          hint: _destinationId == null
              ? 'Choose a destination first'
              : 'Choose a city (optional)',
          enabled: !_busy && _destinationId != null,
          value: _city,
          options: _destinationId == null
              ? const AsyncValueLike()
              : asyncOptions(ref.watch(citiesProvider(_destinationId!))),
          optionValue: (o) => o.label,
          onChanged: (value) => setState(() => _city = value),
        ),
        const SizedBox(height: AppSpacing.x14),
        Text('Category', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        Wrap(
          spacing: AppSpacing.x8,
          runSpacing: AppSpacing.x8,
          children: [
            for (final stars in const [3, 4, 5])
              SheetChip(
                label: '$stars★',
                active: _stars == stars,
                onTap: _busy
                    ? null
                    : () => setState(
                          () => _stars = _stars == stars ? null : stars,
                        ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Phone',
          controller: _phone,
          enabled: !_busy,
          hint: 'Reservations number',
          keyboardType: TextInputType.phone,
          maxLength: 20,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Contact person',
          controller: _contact,
          enabled: !_busy,
          hint: 'Sales manager, front office…',
          textCapitalization: TextCapitalization.words,
          maxLength: 100,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Address',
          controller: _address,
          enabled: !_busy,
          hint: 'Street, area, landmark',
          maxLines: 2,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}

/// The photo slot: a local pick if there is one, otherwise the stored image,
/// otherwise an empty prompt.
///
/// A local pick wins over the stored URL because it is what will be saved.
class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.picked, required this.imagePath, this.onTap});

  final XFile? picked;
  final String? imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = picked != null || imagePath != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.tile),
      child: Container(
        height: 140,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(color: AppColors.border),
        ),
        child: hasPhoto
            ? Stack(
                fit: StackFit.expand,
                children: [
                  if (picked != null)
                    Image.file(File(picked!.path), fit: BoxFit.cover)
                  else
                    Image.network(
                      imagePath!,
                      fit: BoxFit.cover,
                      // The stored URL can 404 or the phone can be offline;
                      // a broken image should not blank the form.
                      errorBuilder: (_, _, _) => const Center(
                        child: AppIcon(Ic.alert, size: 20, color: AppColors.faint),
                      ),
                    ),
                  Positioned(
                    right: AppSpacing.x8,
                    bottom: AppSpacing.x8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.x12,
                          vertical: AppSpacing.x6,
                        ),
                        child: Text('Change', style: AppType.chip),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppIcon(Ic.camera, size: 22, color: AppColors.faint),
                  const SizedBox(height: AppSpacing.x8),
                  Text('Add a photo', style: AppType.bodySm),
                ],
              ),
      ),
    );
  }
}
