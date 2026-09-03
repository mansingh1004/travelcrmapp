import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/formatters/app_date.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/booking.dart';
import '../../../masters/presentation/widgets/form_fields.dart';

/// Edit the three things about a booking that change on a phone.
///
/// `PUT /api/bookings/{publicId}` accepts twenty-three fields — vendor, the
/// three tax overrides, six commission fields, the trip snapshot, the assigned
/// user. Those belong on the desktop console. A phone changes a travel date
/// that moved and money that was agreed, and nothing else.
///
/// **Only what was actually edited is sent.** Every field on the request is
/// optional and null means *leave it alone*, which is exactly why the DTO also
/// carries `clearVendor`, `clearTaxOverrides` and `clearCommission`. Sending an
/// untouched field back would be harmless for these three, but sending all
/// twenty-three would not: a null commission block would read as "unchanged"
/// while a zero would rewrite it.
class BookingEditSheet extends ConsumerStatefulWidget {
  const BookingEditSheet({super.key, required this.booking});

  final Booking booking;

  /// Returns true when something was saved.
  static Future<bool> show(BuildContext context, {required Booking booking}) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BookingEditSheet(booking: booking),
      ),
    );
    return saved ?? false;
  }

  @override
  ConsumerState<BookingEditSheet> createState() => _BookingEditSheetState();
}

class _BookingEditSheetState extends ConsumerState<BookingEditSheet> {
  late final _amount = TextEditingController(
    text: widget.booking.customerAmount > 0
        ? widget.booking.customerAmount.toStringAsFixed(0)
        : '',
  );
  late final _paid = TextEditingController(
    text: widget.booking.paidAmount > 0
        ? widget.booking.paidAmount.toStringAsFixed(0)
        : '',
  );

  late DateTime? _travelDate = widget.booking.travelDate;

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _paid.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _travelDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) setState(() => _travelDate = picked);
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amount.text.trim().replaceAll(',', ''));
    if (_amount.text.trim().isNotEmpty && amount == null) {
      setState(() => _error = 'The amount must be a number.');
      return;
    }
    final paid = double.tryParse(_paid.text.trim().replaceAll(',', ''));
    if (_paid.text.trim().isNotEmpty && paid == null) {
      setState(() => _error = 'The paid amount must be a number.');
      return;
    }

    final body = buildBookingUpdate(
      travelDate: _travelDate,
      originalTravelDate: widget.booking.travelDate,
      customerAmount: amount,
      originalCustomerAmount: widget.booking.customerAmount,
      paidAmount: paid,
      originalPaidAmount: widget.booking.paidAmount,
    );
    if (body.isEmpty) {
      Navigator.of(context).pop(false);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(bookingApiProvider)
          .updateBooking(widget.booking.id, body);
      if (mounted) Navigator.of(context).pop(true);
    } on Failure catch (f) {
      if (mounted) setState(() => _error = f.message);
    } catch (e) {
      // Not a Failure — a parse error out of the reply, say. The booking may
      // already have been updated, so say so rather than implying nothing
      // happened.
      if (mounted) {
        setState(() => _error =
            'The change may have been saved, but the reply could not be read. '
            'Reopen the booking to check.\n\n$e');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Edit booking',
      subtitle: 'Vendor, tax and commission are set on the desktop console. '
          'Tax is recalculated by the server when the amount changes.',
      error: _error,
      busy: _busy,
      submitLabel: 'Save changes',
      onSubmit: _submit,
      children: [
        Text('Travel date', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        InkWell(
          onTap: _busy ? null : _pickDate,
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
                Text(
                  _travelDate == null ? 'Not set' : AppDate.display(_travelDate),
                  style: _travelDate == null
                      ? AppType.fieldValue.copyWith(color: AppColors.faint)
                      : AppType.fieldValue,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Customer amount',
          controller: _amount,
          enabled: !_busy,
          hint: '₹',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          maxLength: 12,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Paid so far',
          controller: _paid,
          enabled: !_busy,
          hint: '₹',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          maxLength: 12,
        ),
      ],
    );
  }
}

/// The body for `PUT /api/bookings/{id}` — only the fields that changed.
///
/// Anything the agent left alone is left out, because on this endpoint an
/// absent field means "unchanged". Sending everything back would work for these
/// three but sets a habit that breaks on the fields with `clear*` companions.
Map<String, dynamic> buildBookingUpdate({
  DateTime? travelDate,
  DateTime? originalTravelDate,
  double? customerAmount,
  double? originalCustomerAmount,
  double? paidAmount,
  double? originalPaidAmount,
}) {
  final body = <String, dynamic>{};

  if (travelDate != null && !_sameDay(travelDate, originalTravelDate)) {
    body['travelDate'] = '${travelDate.year.toString().padLeft(4, '0')}-'
        '${travelDate.month.toString().padLeft(2, '0')}-'
        '${travelDate.day.toString().padLeft(2, '0')}';
  }
  if (customerAmount != null && customerAmount != originalCustomerAmount) {
    body['customerAmount'] = customerAmount;
  }
  if (paidAmount != null && paidAmount != originalPaidAmount) {
    body['paidAmount'] = paidAmount;
  }
  return body;
}

bool _sameDay(DateTime a, DateTime? b) =>
    b != null && a.year == b.year && a.month == b.month && a.day == b.day;
