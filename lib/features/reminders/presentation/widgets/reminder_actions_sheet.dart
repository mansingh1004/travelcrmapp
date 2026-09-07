import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/formatters/app_date.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/app_toast.dart';
import '../../api/reminder_api.dart';
import 'reminder_form_sheet.dart';
import 'sheet_action.dart';

/// What was done to a reminder, so the caller can raise the toast.
///
/// Raised by the caller rather than inside the sheet: the sheet's context is
/// deactivated the moment it pops, which is what "Looking up a deactivated
/// widget's ancestor" was.
typedef ReminderOutcome = ({String title, String message});

/// What an agent can do to a reminder from a phone.
///
/// Deleting is deliberately absent. `TRAVEL_AGENT` holds every REMINDER_*
/// permission except `_DELETE`, so the button would 403 for the role that uses
/// this app most — and dismissing is the reversible equivalent anyway.
class ReminderActionsSheet extends ConsumerStatefulWidget {
  const ReminderActionsSheet._({required this.reminder});

  final Reminder reminder;

  static Future<ReminderOutcome?> show(
    BuildContext context, {
    required Reminder reminder,
  }) =>
      showModalBottomSheet<ReminderOutcome>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
        builder: (_) => ReminderActionsSheet._(reminder: reminder),
      );

  @override
  ConsumerState<ReminderActionsSheet> createState() =>
      _ReminderActionsSheetState();
}

class _ReminderActionsSheetState extends ConsumerState<ReminderActionsSheet> {
  bool _busy = false;

  Reminder get _reminder => widget.reminder;

  /// Run one action, and close with what to say about it.
  ///
  /// `finally` clears the spinner even when the call throws, so a failed
  /// request leaves the sheet usable rather than stuck.
  Future<void> _run(
    Future<Reminder> Function(ReminderApi api) action, {
    required String title,
    required String message,
  }) async {
    setState(() => _busy = true);
    try {
      await action(ref.read(reminderApiProvider));
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

  Future<void> _snooze() async {
    final until = await _SnoozeSheet.show(context);
    if (until == null || !mounted) return;
    await _run(
      (api) => api.snooze(_reminder.id, until),
      title: 'Snoozed',
      message: 'Back on ${AppDate.dateTime(until)}.',
    );
  }

  /// Open the edit form over this sheet, and close both once it saves.
  ///
  /// Editing needs the same REMINDER_UPDATE the other actions do, so it sits
  /// with them rather than behind a separate route.
  Future<void> _edit() async {
    final saved =
        await ReminderFormSheet.show(context, reminder: _reminder);
    if (saved == null || !mounted) return;
    Navigator.of(context).pop((title: 'Reminder updated', message: saved));
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
    final open = _reminder.isOpen;

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
            Text(_reminder.title, style: AppType.h3),
            const SizedBox(height: AppSpacing.x4),
            Text(
              [
                _reminder.typeLabel,
                if (_reminder.dueDate != null)
                  'Due ${AppDate.dateTime(_reminder.dueDate)}',
              ].join(' · '),
              style: AppType.bodySm,
            ),
            if (_reminder.description != null) ...[
              const SizedBox(height: AppSpacing.x10),
              Text(_reminder.description!, style: AppType.body),
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
                  label: 'Call ${_reminder.leadName ?? 'customer'}',
                  onTap: _call,
                ),
              if (open) ...[
                SheetAction(
                  icon: Ic.checkCircle,
                  label: 'Mark complete',
                  color: AppColors.success,
                  onTap: () => _run(
                    (api) => api.markComplete(_reminder.id),
                    title: 'Reminder completed',
                    message: _reminder.title,
                  ),
                ),
                SheetAction(
                  icon: Ic.clock,
                  label: 'Snooze',
                  onTap: _snooze,
                ),
                SheetAction(
                  icon: Ic.edit,
                  label: 'Edit',
                  onTap: _edit,
                ),
                SheetAction(
                  icon: Ic.close,
                  label: 'Dismiss',
                  color: AppColors.danger,
                  last: true,
                  onTap: () => _run(
                    (api) => api.dismiss(_reminder.id),
                    title: 'Reminder dismissed',
                    message: _reminder.title,
                  ),
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
                  child: Text(
                    'This reminder is already ${_reminder.status?.toLowerCase()}.',
                    style: AppType.bodySm,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}


/// How long to push a reminder out by.
///
/// Presets rather than a date-and-time picker: snoozing is a one-handed action
/// taken between calls, and every option here is a moment an agent would
/// actually pick. The exact instant is computed locally and sent as UTC.
class _SnoozeSheet extends StatelessWidget {
  const _SnoozeSheet();

  static Future<DateTime?> show(BuildContext context) =>
      showModalBottomSheet<DateTime>(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
        builder: (_) => const _SnoozeSheet(),
      );

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 9);
    final options = <(String, DateTime)>[
      ('In 1 hour', now.add(const Duration(hours: 1))),
      ('In 3 hours', now.add(const Duration(hours: 3))),
      ('Tomorrow, 9:00 AM', tomorrow),
      ('Next week', tomorrow.add(const Duration(days: 6))),
    ];

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
            Text('Snooze until', style: AppType.h3),
            const SizedBox(height: AppSpacing.x8),
            for (final (index, (label, moment)) in options.indexed)
              SheetAction(
                icon: Ic.clock,
                label: label,
                last: index == options.length - 1,
                onTap: () => Navigator.of(context).pop(moment),
              ),
          ],
        ),
      ),
    );
  }
}
