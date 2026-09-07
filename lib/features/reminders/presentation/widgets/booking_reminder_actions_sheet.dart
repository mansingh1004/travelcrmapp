import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/formatters/app_date.dart';
import '../../../../core/formatters/inr.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/app_toast.dart';
import '../../api/booking_reminder_api.dart';
import 'reminder_actions_sheet.dart' show ReminderOutcome;
import 'sheet_action.dart';

/// What an agent can do to a booking reminder from a phone.
///
/// Fewer actions than the lead-side sheet, and on purpose. There is no snooze
/// in this module — the reminder is pinned to a trip's dates, and pushing it
/// out would say the trip moved. What is offered is the pair the backend
/// actually supports: mark it done, or put it back.
///
/// **Send now is absent.** `POST /{id}/send-now` goes out over WhatsApp and
/// answers 422 "WhatsApp is not configured. Set it up in Settings → WhatsApp
/// first." until the tenant's provider is configured server-side — confirmed
/// live against a reminder that does carry a phone number. Calling the
/// customer is offered instead, which works today.
class BookingReminderActionsSheet extends ConsumerStatefulWidget {
  const BookingReminderActionsSheet._({required this.reminder});

  final BookingReminder reminder;

  static Future<ReminderOutcome?> show(
    BuildContext context, {
    required BookingReminder reminder,
  }) =>
      showModalBottomSheet<ReminderOutcome>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
        builder: (_) => BookingReminderActionsSheet._(reminder: reminder),
      );

  @override
  ConsumerState<BookingReminderActionsSheet> createState() =>
      _BookingReminderActionsSheetState();
}

class _BookingReminderActionsSheetState
    extends ConsumerState<BookingReminderActionsSheet> {
  bool _busy = false;

  BookingReminder get _reminder => widget.reminder;

  Future<void> _run(
    Future<BookingReminder> Function(BookingReminderApi api) action, {
    required String title,
    required String message,
  }) async {
    setState(() => _busy = true);
    try {
      await action(ref.read(bookingReminderApiProvider));
      if (mounted) {
        Navigator.of(context).pop((title: title, message: message));
      }
    } on Failure catch (f) {
      if (mounted) {
        setState(() => _busy = false);
        AppToast.error(context, 'Could not update the reminder', f.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        AppToast.error(context, 'Could not update the reminder', '$e');
      }
    }
  }

  Future<void> _call() async {
    final phone = _reminder.phone;
    if (phone == null) return;
    final ok = await launchUrl(
      Uri.parse('tel:$phone'),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && mounted) {
      AppToast.error(context, 'Could not open', 'No app available to handle that.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = _reminder.amount;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x16,
          AppSpacing.x12,
          AppSpacing.x16,
          AppSpacing.x16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x16),
            Text(_reminder.customerName ?? 'Unnamed booking', style: AppType.h3),
            const SizedBox(height: AppSpacing.x4),
            Text(
              [
                _reminder.typeLabel,
                if (_reminder.bookingCode != null) _reminder.bookingCode!,
                if (_reminder.reminderDate != null)
                  'Due ${AppDate.dateTime(_reminder.reminderDate)}',
              ].join(' · '),
              style: AppType.bodySm,
            ),
            if (amount != null && amount > 0) ...[
              const SizedBox(height: AppSpacing.x10),
              Text(
                Inr.format(amount),
                style: AppType.monoStrong.copyWith(color: AppColors.ink),
              ),
            ],
            if (_reminder.message != null) ...[
              const SizedBox(height: AppSpacing.x10),
              Text(_reminder.message!, style: AppType.body),
            ],
            if (_reminder.travelDate != null) ...[
              const SizedBox(height: AppSpacing.x6),
              Text(
                'Travels ${AppDate.display(_reminder.travelDate)}',
                style: AppType.caption,
              ),
            ],
            const SizedBox(height: AppSpacing.x16),
            if (_busy)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.x20),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else ...[
              if (_reminder.phone != null)
                SheetAction(
                  icon: Ic.phone,
                  label: 'Call ${_reminder.customerName ?? 'customer'}',
                  onTap: _call,
                ),
              if (_reminder.isOpen)
                SheetAction(
                  icon: Ic.checkCircle,
                  label: 'Mark complete',
                  color: AppColors.success,
                  last: true,
                  onTap: () => _run(
                    (api) => api.markComplete(_reminder.id),
                    title: 'Reminder completed',
                    message: _reminder.customerName ?? 'Booking reminder',
                  ),
                )
              else
                // The lead-side module has no equivalent — there, done is
                // final. Here a reminder closed by mistake can be reopened.
                SheetAction(
                  icon: Ic.refresh,
                  label: 'Reopen',
                  last: true,
                  onTap: () => _run(
                    (api) => api.markPending(_reminder.id),
                    title: 'Reminder reopened',
                    message: _reminder.customerName ?? 'Booking reminder',
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

