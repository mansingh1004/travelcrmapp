import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/formatters/app_date.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/services/task_api.dart';
import '../../providers/calendar_controller.dart';

/// Add an event to the calendar.
///
/// The calendar is a **merged read-only feed** of seven sources — trips,
/// payments, flights and hotel check-ins all belong to bookings and cannot be
/// created here. Of the two the server lets a user author, a task carries the
/// fields a calendar entry needs (start time, all-day, location, category), so
/// that is what this writes: `POST /api/tasks`.
class AddEventSheet extends ConsumerStatefulWidget {
  const AddEventSheet({super.key, required this.day});

  /// The day the calendar had selected, pre-filled as the event's date.
  final DateTime day;

  /// Returns a line describing the event added, or null when dismissed.
  ///
  /// The caller raises the toast, because this sheet's context is deactivated
  /// the moment it pops — "Looking up a deactivated widget's ancestor is
  /// unsafe". The event was always created; the confirmation was what got lost.
  static Future<String?> show(BuildContext context, {required DateTime day}) =>
      showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
        builder: (_) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddEventSheet(day: day),
        ),
      );

  @override
  ConsumerState<AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends ConsumerState<AddEventSheet> {
  final _title = TextEditingController();
  final _location = TextEditingController();
  final _notes = TextEditingController();

  late DateTime _date = widget.day;
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 0);
  TaskCategory _category = TaskCategory.followUp;
  TaskPriority _priority = TaskPriority.medium;
  bool _allDay = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      setState(() => _error = 'Give the event a title.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    // An all-day event still needs an instant: midnight local, so it lands on
    // the chosen day once the server converts it back.
    final at = _allDay
        ? DateTime(_date.year, _date.month, _date.day)
        : DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

    try {
      await ref.read(taskApiProvider).createTask(
            title: _title.text,
            at: at,
            allDay: _allDay,
            category: _category,
            priority: _priority,
            location: _location.text.trim().isEmpty ? null : _location.text.trim(),
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
          );

      // The calendar re-reads rather than inserting locally: the server decides
      // which day and source the new row belongs to.
      ref
        ..invalidate(calendarEventsProvider)
        ..invalidate(calendarSummaryProvider);

      if (!mounted) return;
      Navigator.of(context).pop(
        '${_title.text.trim()} · ${AppDate.display(_date)}',
      );
    } on Failure catch (f) {
      if (mounted) {
        setState(() => _error = f is PermissionFailure
            ? 'Your role cannot create tasks. Ask an admin for the Task Create permission.'
            : f.message);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x16),
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
              Text('New event', style: AppType.h2),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Saved as a task and shown on your calendar.',
                style: AppType.caption,
              ),
              const SizedBox(height: AppSpacing.x16),
              _Field(
                controller: _title,
                hint: 'What is it? e.g. Call Rahul about Nepal quote',
                enabled: !_busy,
                autofocus: true,
              ),
              const SizedBox(height: AppSpacing.x16),
              Text('TYPE', style: AppType.overline),
              const SizedBox(height: AppSpacing.x8),
              Wrap(
                spacing: AppSpacing.x8,
                runSpacing: AppSpacing.x8,
                children: [
                  for (final category in TaskCategory.values)
                    _Chip(
                      label: category.label,
                      active: _category == category,
                      onTap: () => setState(() => _category = category),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.x16),
              Row(
                children: [
                  Expanded(
                    child: _PickerTile(
                      icon: Ic.calendar,
                      label: AppDate.display(_date),
                      onTap: _busy ? null : _pickDate,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  Expanded(
                    child: _PickerTile(
                      icon: Ic.clock,
                      label: _allDay ? 'All day' : _time.format(context),
                      // A time picker is meaningless once the event is all-day.
                      onTap: (_busy || _allDay) ? null : _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x10),
              InkWell(
                onTap: _busy ? null : () => setState(() => _allDay = !_allDay),
                borderRadius: BorderRadius.circular(AppRadii.tile),
                child: Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(AppRadii.tile),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text('All day', style: AppType.fieldValue)),
                      _Switch(on: _allDay),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              Text('PRIORITY', style: AppType.overline),
              const SizedBox(height: AppSpacing.x8),
              Wrap(
                spacing: AppSpacing.x8,
                children: [
                  for (final priority in TaskPriority.values)
                    _Chip(
                      label: priority.label,
                      active: _priority == priority,
                      onTap: () => setState(() => _priority = priority),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.x12),
              _Field(
                controller: _location,
                hint: 'Location (optional)',
                enabled: !_busy,
                maxLength: 255,
              ),
              const SizedBox(height: AppSpacing.x10),
              _Field(
                controller: _notes,
                hint: 'Notes (optional)',
                enabled: !_busy,
                maxLines: 2,
                maxLength: 5000,
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.x10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppIcon(Ic.alert, size: 16, color: AppColors.danger),
                    const SizedBox(width: AppSpacing.x8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: AppType.bodySm.copyWith(color: AppColors.danger),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.x18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _busy ? null : _save,
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : const Text('Add to calendar'),
                ),
              ),
              const SizedBox(height: AppSpacing.x8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.enabled,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      autofocus: autofocus,
      style: AppType.fieldValue,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: AppColors.canvas,
        counterText: '',
        border: const OutlineInputBorder(
          borderRadius: AppRadii.rTile,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.rTile,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadii.rTile,
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({required this.icon, required this.label, this.onTap});

  final String icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final muted = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.tile),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(AppRadii.tile),
        ),
        child: Row(
          children: [
            AppIcon(icon, size: 16, color: muted ? AppColors.faint : AppColors.muted),
            const SizedBox(width: AppSpacing.x8),
            Expanded(
              child: Text(
                label,
                style: muted
                    ? AppType.fieldValue.copyWith(color: AppColors.faint)
                    : AppType.fieldValue,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        // No `alignment` and no fixed height: a Container with an alignment
        // expands to the incoming max width, and inside a Wrap that is the
        // full row — which turned a row of chips into a stack of buttons.
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x12,
            vertical: AppSpacing.x8,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.canvas,
            borderRadius: BorderRadius.circular(AppRadii.chip),
            border: Border.all(color: active ? AppColors.primary : AppColors.border),
          ),
          child: Text(
            label,
            style: AppType.tab.copyWith(
              color: active ? AppColors.onPrimary : AppColors.body,
            ),
          ),
        ),
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 38,
      height: 22,
      decoration: BoxDecoration(
        color: on ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 160),
        alignment: on ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 18,
          height: 18,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
