import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../masters/presentation/widgets/form_fields.dart';
import '../../api/vendor_api.dart';

/// Add or edit a vendor — the part of one that belongs on a phone.
///
/// `POST /api/vendors` and `PUT /api/vendors/{id}`. Only three fields are
/// validated — `vendorName`, `vendorType` and `phone` — and only a handful more
/// are offered here.
///
/// **The ledger is deliberately absent.** Bank account, IFSC, UPI, GST, PAN,
/// credit limit, payment terms and opening balance are all on the request DTO
/// and all left out: they are entered once, carefully, on the desktop console,
/// and a wrong IFSC typed on a phone surfaces as a failed payment weeks later.
/// Status is absent too — it has its own route, because blacklisting a supplier
/// is a decision rather than an edit.
class VendorFormSheet extends ConsumerStatefulWidget {
  const VendorFormSheet({super.key, this.vendor});

  /// Null when adding.
  final Vendor? vendor;

  /// Returns the saved name, or null when nothing was saved.
  static Future<String?> show(BuildContext context, {Vendor? vendor}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: VendorFormSheet(vendor: vendor),
      ),
    );
  }

  @override
  ConsumerState<VendorFormSheet> createState() => _VendorFormSheetState();
}

class _VendorFormSheetState extends ConsumerState<VendorFormSheet> {
  late final _name = TextEditingController(text: widget.vendor?.name ?? '');
  late final _phone = TextEditingController(text: widget.vendor?.phone ?? '');
  late final _contact =
      TextEditingController(text: widget.vendor?.contactPerson ?? '');
  late final _city = TextEditingController(text: widget.vendor?.city ?? '');
  late final _state = TextEditingController(text: widget.vendor?.state ?? '');
  late final _email = TextEditingController(text: widget.vendor?.email ?? '');
  late final _whatsapp =
      TextEditingController(text: widget.vendor?.whatsapp ?? '');

  late String? _type = widget.vendor?.type;
  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.vendor != null;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _contact.dispose();
    _city.dispose();
    _state.dispose();
    _email.dispose();
    _whatsapp.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    final type = _type;

    // The three the server rejects the request without.
    if (name.isEmpty) {
      setState(() => _error = 'Enter the vendor name.');
      return;
    }
    if (type == null) {
      setState(() => _error = 'Choose what kind of vendor this is.');
      return;
    }
    if (phone.isEmpty) {
      setState(() => _error = 'Enter a phone number.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final api = ref.read(vendorApiProvider);
    try {
      final saved = _isEdit
          ? await api.updateVendor(
              widget.vendor!.id,
              name: name,
              type: type,
              phone: phone,
              contactPerson: _contact.text,
              city: _city.text,
              state: _state.text,
              email: _email.text,
              whatsapp: _whatsapp.text,
            )
          : await api.createVendor(
              name: name,
              type: type,
              phone: phone,
              contactPerson: _contact.text,
              city: _city.text,
              state: _state.text,
              email: _email.text,
              whatsapp: _whatsapp.text,
            );
      if (mounted) Navigator.of(context).pop(saved.name);
    } on Failure catch (f) {
      // A 403 lands here when the account lacks VENDOR_CREATE or VENDOR_UPDATE
      // — vendors have their own permissions, separate from the masters.
      if (mounted) setState(() => _error = f.message);
    } catch (e) {
      if (mounted) {
        setState(() => _error =
            'The vendor may have been saved, but the reply could not be read. '
            'Reopen the list to check.\n\n$e');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: _isEdit ? 'Edit vendor' : 'Add vendor',
      subtitle: 'Bank details, GST, PAN and credit terms are entered on the '
          'desktop console.',
      error: _error,
      busy: _busy,
      submitLabel: _isEdit ? 'Save changes' : 'Add vendor',
      onSubmit: _submit,
      children: [
        SheetField(
          label: 'Vendor name',
          controller: _name,
          enabled: !_busy,
          hint: 'e.g. Coastal DMC',
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
            // A fixed vocabulary, not free text: the console colours and
            // groups its lists by exactly these four.
            for (final type in VendorApi.types)
              SheetChip(
                label: type,
                active: _type == type,
                onTap: _busy ? null : () => setState(() => _type = type),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Phone',
          controller: _phone,
          enabled: !_busy,
          hint: 'Required',
          keyboardType: TextInputType.phone,
          maxLength: 20,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'WhatsApp',
          controller: _whatsapp,
          enabled: !_busy,
          hint: 'If different from the phone',
          keyboardType: TextInputType.phone,
          maxLength: 20,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Contact person',
          controller: _contact,
          enabled: !_busy,
          hint: 'Who you deal with',
          textCapitalization: TextCapitalization.words,
          maxLength: 100,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Email',
          controller: _email,
          enabled: !_busy,
          keyboardType: TextInputType.emailAddress,
          maxLength: 150,
        ),
        const SizedBox(height: AppSpacing.x14),
        Row(
          children: [
            Expanded(
              child: SheetField(
                label: 'City',
                controller: _city,
                enabled: !_busy,
                textCapitalization: TextCapitalization.words,
                maxLength: 100,
              ),
            ),
            const SizedBox(width: AppSpacing.x10),
            Expanded(
              child: SheetField(
                label: 'State',
                controller: _state,
                enabled: !_busy,
                textCapitalization: TextCapitalization.words,
                maxLength: 100,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
