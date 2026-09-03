import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/booking.dart';
import '../../../masters/presentation/widgets/form_fields.dart';

/// Cancel a booking, and say what happens to the lead behind it.
///
/// `POST /api/bookings/{publicId}/cancel`. The booking row is **always kept**
/// with status `CANCELLED` — the backend keeps it "for audit/financial history
/// regardless of choice" — so nothing here destroys the record.
///
/// What the agent is really choosing is the lead's fate, which is why `action`
/// is the request's only `@NotNull` and has no default:
///
/// * `MOVE_TO_LEAD` — the lead reopens (stage → REOPENED) and can be sold again
/// * `PERMANENT_DELETE_LEAD` — the lead goes to Trash with its quotations, and
///   needs `LEAD_PERMANENT_DELETE`
///
/// The cancellation charge is not asked for. The server computes it from the
/// policy pinned on the booking — the one the customer was quoted under — and
/// the override fields belong with whoever reconciles the money.
class BookingCancelSheet extends ConsumerStatefulWidget {
  const BookingCancelSheet({super.key, required this.booking});

  final Booking booking;

  /// Returns true when the booking was cancelled.
  static Future<bool> show(BuildContext context, {required Booking booking}) async {
    final done = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BookingCancelSheet(booking: booking),
      ),
    );
    return done ?? false;
  }

  @override
  ConsumerState<BookingCancelSheet> createState() => _BookingCancelSheetState();
}

class _BookingCancelSheetState extends ConsumerState<BookingCancelSheet> {
  final _reason = TextEditingController();

  /// Reopening the lead is the ordinary case, so it starts selected — but the
  /// other one is destructive enough that it must be chosen, never defaulted.
  String _action = 'MOVE_TO_LEAD';

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(bookingApiProvider).cancelBooking(
            widget.booking.id,
            action: _action,
            reason: _reason.text,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on Failure catch (f) {
      // A 403 lands here when the agent lacks LEAD_PERMANENT_DELETE for the
      // second option; the server's wording says so plainly.
      if (mounted) setState(() => _error = f.message);
    } catch (e) {
      if (mounted) {
        setState(() => _error =
            'The booking may have been cancelled, but the reply could not be '
            'read. Reopen it to check.\n\n$e');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Cancel ${widget.booking.code ?? 'booking'}',
      subtitle: 'The booking is kept as Cancelled for your records. Choose what '
          'should happen to the lead it came from.',
      error: _error,
      busy: _busy,
      submitLabel: 'Cancel booking',
      onSubmit: _submit,
      children: [
        Text('The lead', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        _ActionChoice(
          label: 'Reopen the lead',
          note: 'Goes back to Reopened so you can sell it again.',
          selected: _action == 'MOVE_TO_LEAD',
          onTap: _busy ? null : () => setState(() => _action = 'MOVE_TO_LEAD'),
        ),
        const SizedBox(height: AppSpacing.x8),
        _ActionChoice(
          label: 'Send the lead to Trash',
          note: 'Its quotations go with it. Recoverable for 30 days, and needs '
              'permission your account may not have.',
          danger: true,
          selected: _action == 'PERMANENT_DELETE_LEAD',
          onTap: _busy
              ? null
              : () => setState(() => _action = 'PERMANENT_DELETE_LEAD'),
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Reason',
          controller: _reason,
          enabled: !_busy,
          hint: 'Why the customer cancelled',
          maxLines: 2,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}

class _ActionChoice extends StatelessWidget {
  const _ActionChoice({
    required this.label,
    required this.note,
    required this.selected,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final String note;
  final bool selected;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final accent = danger ? AppColors.danger : AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.tile),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.x12),
        decoration: BoxDecoration(
          color: selected ? AppColors.canvas : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          border: Border.all(color: selected ? accent : AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: selected ? accent : AppColors.faint,
            ),
            const SizedBox(width: AppSpacing.x10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppType.body.copyWith(
                      color: danger && selected ? AppColors.danger : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(note, style: AppType.captionSm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
