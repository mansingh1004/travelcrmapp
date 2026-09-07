import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/formatters/app_date.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../masters/presentation/widgets/form_fields.dart';
import '../../api/reminder_api.dart';

/// Add or edit a reminder.
///
/// `POST /api/reminders` and `PUT /api/reminders/{id}`. Only `title` and
/// `dueDate` are validated server-side; everything else is optional and left
/// out of the request when blank rather than sent empty.
///
/// **Assignee and lead are deliberately absent.** Both are UUIDs the server
/// resolves against real rows, and picking either needs a searchable list this
/// sheet has no room for. A reminder made here belongs to whoever made it,
/// which is what an agent adding one between calls means anyway. Reassignment
/// stays on the desktop console.
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
              notes: _notes.text,
            )
          : await api.createReminder(
              title: title,
              dueDate: _due,
              description: _description.text,
              type: _type,
              priority: _priority,
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
          : 'It will be assigned to you.',
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
  });

  final String icon;
  final String label;
  final VoidCallback? onTap;

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
                style: AppType.fieldValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
