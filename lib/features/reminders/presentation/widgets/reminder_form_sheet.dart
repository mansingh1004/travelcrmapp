import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/formatters/app_date.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../masters/presentation/widgets/form_fields.dart';
import '../../api/reminder_api.dart';
import 'reference_pickers.dart';

/// Add or edit a reminder.
///
/// `POST /api/reminders` and `PUT /api/reminders/{id}`. Only `title` and
/// `dueDate` are validated server-side; everything else is optional and left
/// out of the request when blank rather than sent empty.
///
/// **Lead and assignee are optional here, unlike on the web console**, which
/// marks both required. That is the console's rule, not the server's: a create
/// carrying neither answers 201. Left alone, the reminder belongs to whoever
/// made it and hangs off no lead — which is exactly what "remind me to call
/// the airline" is, and what an agent typing between calls usually means.
///
/// Both are UUIDs the server resolves against real rows, so each is picked
/// from a list rather than typed — see `reference_pickers.dart`.
class ReminderFormSheet extends ConsumerStatefulWidget {
  const ReminderFormSheet({super.key, this.reminder});

  /// Null when adding.
  final Reminder? reminder;

  /// Returns the saved title, or null when nothing was saved.
  static Future<String?> show(BuildContext context, {Reminder? reminder}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ReminderFormSheet(reminder: reminder),
      ),
    );
  }

  @override
  ConsumerState<ReminderFormSheet> createState() => _ReminderFormSheetState();
}

class _ReminderFormSheetState extends ConsumerState<ReminderFormSheet> {
  late final _title = TextEditingController(text: widget.reminder?.title ?? '');
  late final _description =
      TextEditingController(text: widget.reminder?.description ?? '');
  late final _notes = TextEditingController(text: widget.reminder?.notes ?? '');

  late String? _type = widget.reminder?.type ?? 'Follow_up';
  late String? _priority = widget.reminder?.priority ?? 'Medium';

  /// Defaults to tomorrow morning — the commonest thing an agent means by
  /// "remind me", and far enough out that a half-filled form cannot create
  /// something already overdue.
  late DateTime _due = widget.reminder?.dueDate ?? _tomorrowMorning();

  /// The lead this hangs off, if any.
  ///
  /// Id and label are held together and set together — the id is what the
  /// server resolves, the name is what the agent reads, and letting them
  /// diverge is how a picker ends up sending the wrong row.
  late String? _leadId = widget.reminder?.leadPublicId;
  late String? _leadName = widget.reminder?.leadName;

  /// Whose reminder it is. Null means the server decides — which, on create,
  /// means whoever is signed in.
  String? _assigneeId;
  late String? _assigneeName = widget.reminder?.assignToName;

  /// What the server already had, so an edit sends a reference only when the
  /// agent actually changed it.
  ///
  /// Re-sending the same publicId is not free: `applyReferences` re-resolves
  /// it through the access guard on every save, and would fail outright if the
  /// lead had since been deleted — a save rejected over a field nobody touched.
  late final String? _originalLeadId = widget.reminder?.leadPublicId;

  /// True once the agent picked a lead different from the stored one.
  bool get _leadChanged => _leadId != _originalLeadId;

  bool _busy = false;
  String? _error;

  bool get _isEdit => widget.reminder != null;

  static DateTime _tomorrowMorning() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1, 10);
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _due,
      // Backdating is allowed: a reminder recorded after the fact is a real
      // thing, and the scheduler simply flips it to OVERDUE on the next tick.
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    setState(() {
      _due = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _due.hour,
        _due.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_due),
    );
    if (picked == null) return;
    setState(() {
      _due = DateTime(
        _due.year,
        _due.month,
        _due.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  Future<void> _submit() async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Give the reminder a title.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final api = ref.read(reminderApiProvider);
    try {
      final saved = _isEdit
          ? await api.updateReminder(
              widget.reminder!.id,
              title: title,
              dueDate: _due,
              description: _description.text,
              type: _type,
              priority: _priority,
              // Only what the picker actually changed. `_assigneeId` starts
              // null on an edit even when a name is shown, so an untouched
              // assignee is left alone rather than re-sent.
              leadPublicId: _leadChanged ? _leadId : null,
              assignToPublicId: _assigneeId,
              notes: _notes.text,
            )
          : await api.createReminder(
              title: title,
              dueDate: _due,
              description: _description.text,
              type: _type,
              priority: _priority,
              leadPublicId: _leadId,
              assignToPublicId: _assigneeId,
              notes: _notes.text,
            );
      if (mounted) Navigator.of(context).pop(saved.title);
    } on Failure catch (f) {
      // A 403 lands here without REMINDER_CREATE or REMINDER_UPDATE.
      if (mounted) setState(() => _error = f.message);
    } catch (e) {
      if (mounted) {
        setState(() => _error =
            'The reminder may have been saved, but the reply could not be '
            'read. Reopen the list to check.\n\n$e');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: _isEdit ? 'Edit reminder' : 'New reminder',
      subtitle: _isEdit
          // Worth saying, because it is not obvious and it is what the agent
          // usually wants: moving the date is how an overdue reminder is
          // brought back to life.
          ? 'Changing the date revives an overdue reminder and re-arms it.'
          : 'Only a title and a due date are required.',
      error: _error,
      busy: _busy,
      submitLabel: _isEdit ? 'Save changes' : 'Add reminder',
      onSubmit: _submit,
      children: [
        SheetField(
          label: 'Title',
          controller: _title,
          enabled: !_busy,
          hint: 'e.g. Call Rahul about the Goa balance',
          textCapitalization: TextCapitalization.sentences,
          maxLength: 255,
        ),
        const SizedBox(height: AppSpacing.x14),
        Text('Due', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _PickerTile(
                icon: Ic.calendar,
                label: AppDate.display(_due),
                onTap: _busy ? null : _pickDate,
              ),
            ),
            const SizedBox(width: AppSpacing.x8),
            Expanded(
              flex: 2,
              // The server stores an Instant, not a date — a reminder without
              // a time of day would silently land at midnight.
              child: _PickerTile(
                icon: Ic.clock,
                label: AppDate.time(_due),
                onTap: _busy ? null : _pickTime,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x14),
        // Both optional, unlike the web console, which makes them mandatory.
        // The server does not: a create with neither answers 201.
        Text('Lead', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        _PickerTile(
          icon: Ic.user,
          label: _leadName ?? 'Not linked to a lead',
          muted: _leadName == null,
          // Clearing only ever undoes a pick made in this sheet. A lead the
          // server already stored cannot be removed at all: `applyReferences`
          // is a "no-op for null publicIds, so partial updates leave existing
          // references untouched" — so offering Clear there would be a button
          // that appears to work and silently does nothing.
          onClear: _leadChanged && _leadId != null
              ? () => setState(() {
                    _leadId = _originalLeadId;
                    _leadName = widget.reminder?.leadName;
                  })
              : null,
          onTap: _busy
              ? null
              : () async {
                  final picked = await LeadPickerSheet.show(context);
                  if (picked == null || !mounted) return;
                  setState(() {
                    _leadId = picked.id;
                    _leadName = picked.name;
                  });
                },
        ),
        const SizedBox(height: AppSpacing.x14),
        Text('Assign to', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        _PickerTile(
          icon: Ic.users,
          label: _assigneeName ?? 'Me',
          muted: _assigneeName == null,
          onClear: _assigneeId == null
              ? null
              : () => setState(() {
                    _assigneeId = null;
                    _assigneeName = widget.reminder?.assignToName;
                  }),
          onTap: _busy
              ? null
              : () async {
                  final picked = await AssigneePickerSheet.show(context);
                  if (picked == null || !mounted) return;
                  setState(() {
                    _assigneeId = picked.id;
                    _assigneeName = picked.name;
                  });
                },
        ),
        const SizedBox(height: AppSpacing.x14),
        Text('Type', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        Wrap(
          spacing: AppSpacing.x8,
          runSpacing: AppSpacing.x8,
          children: [
            for (final type in ReminderApi.types)
              SheetChip(
                // Shown prettified, sent verbatim: the underscore is part of
                // the enum and a mangled value is dropped without an error.
                label: reminderTypeLabel(type),
                active: _type == type,
                onTap: _busy ? null : () => setState(() => _type = type),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x14),
        Text('Priority', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        Wrap(
          spacing: AppSpacing.x8,
          runSpacing: AppSpacing.x8,
          children: [
            for (final priority in ReminderApi.priorities)
              SheetChip(
                label: priority,
                active: _priority == priority,
                onTap:
                    _busy ? null : () => setState(() => _priority = priority),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Description',
          controller: _description,
          enabled: !_busy,
          hint: 'What needs doing',
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Notes',
          controller: _notes,
          enabled: !_busy,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
        ),
      ],
    );
  }
}

/// A tap target that reads like a field but opens a picker.
class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.muted = false,
    this.onClear,
  });

  final String icon;
  final String label;
  final VoidCallback? onTap;

  /// Greys the label when it is a stand-in ("Not linked to a lead") rather
  /// than a real value, so an empty optional field does not read as filled.
  final bool muted;

  /// Shown only when there is something to clear. Both these references are
  /// optional, and an agent who linked the wrong lead needs a way back to
  /// none — not just a way to swap it for another wrong one.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.rTile,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: AppRadii.rTile,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            AppIcon(icon, size: 16, color: AppColors.faint),
            const SizedBox(width: AppSpacing.x8),
            Expanded(
              child: Text(
                label,
                style: muted
                    ? AppType.fieldValue.copyWith(color: AppColors.faint)
                    : AppType.fieldValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onClear != null)
              IconButton(
                onPressed: onClear,
                icon: const AppIcon(Ic.close, size: 14, color: AppColors.muted),
                tooltip: 'Clear',
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
          ],
        ),
      ),
    );
  }
}
