import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/formatters/app_date.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/app_toast.dart';
import '../../providers/lead_detail_provider.dart';

/// Log a follow-up — `POST /api/leads/{publicId}/logs`.
///
/// The outcome chips are a client-side convenience: the endpoint takes a single
/// free-text `comment` (5–2000 chars), so a chip seeds the comment and the
/// agent can edit it. Ticking "Set a reminder" sends `createReminder: true`,
/// which the server rejects without a `followUpDate` — so the date field
/// becomes required and is validated before sending.
class LogFollowUpSheet extends ConsumerStatefulWidget {
  const LogFollowUpSheet({super.key, required this.leadId});

  final String leadId;

  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required String leadId,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
        builder: (_) => Padding(
          // Lift the sheet above the keyboard.
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: LogFollowUpSheet(leadId: leadId),
        ),
      );

  @override
  ConsumerState<LogFollowUpSheet> createState() => _LogFollowUpSheetState();
}

class _LogFollowUpSheetState extends ConsumerState<LogFollowUpSheet> {
  static const _outcomes = <String>[
    'Interested',
    'Call back later',
    'Not reachable',
    'Wants revised quote',
    'Not interested',
  ];

  final _comment = TextEditingController();

  String? _outcome;
  bool _createReminder = true;
  DateTime? _followUpDate = DateTime.now().add(const Duration(days: 1));
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _pickOutcome(String outcome) {
    setState(() {
      _outcome = outcome;
      // Seed the comment only while the agent has not written their own.
      if (_comment.text.isEmpty || _outcomes.contains(_comment.text)) {
        _comment.text = outcome;
      }
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _followUpDate ?? now.add(const Duration(days: 1)),
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _followUpDate = picked);
  }

  Future<void> _submit() async {
    final comment = _comment.text.trim();

    // Mirror the server's own constraints so a round-trip is not spent on a
    // rejection the client can see coming.
    if (comment.length < 5) {
      setState(() => _error = 'Add a note of at least 5 characters.');
      return;
    }
    if (_createReminder && _followUpDate == null) {
      setState(() => _error = 'Pick a follow-up date, or turn the reminder off.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await ref.read(leadActionsProvider).logFollowUp(
            widget.leadId,
            comment: comment,
            createReminder: _createReminder,
            followUpDate: _createReminder ? _followUpDate : null,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      AppToast.show(
        context,
        title: 'Follow-up logged',
        message: _createReminder && _followUpDate != null
            ? 'Reminder set for ${AppDate.display(_followUpDate)}.'
            : 'Added to the lead history.',
      );
    } on Failure catch (f) {
      if (mounted) setState(() => _error = f.message);
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
              Text('Log follow-up', style: AppType.h2),
              const SizedBox(height: AppSpacing.x14),
              Text('Outcome', style: AppType.overline),
              const SizedBox(height: AppSpacing.x8),
              Wrap(
                spacing: AppSpacing.x8,
                runSpacing: AppSpacing.x8,
                children: [
                  for (final outcome in _outcomes)
                    _Chip(
                      label: outcome,
                      active: _outcome == outcome,
                      onTap: () => _pickOutcome(outcome),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.x16),
              Text('Note', style: AppType.overline),
              const SizedBox(height: AppSpacing.x8),
              TextField(
                controller: _comment,
                enabled: !_busy,
                maxLines: 3,
                maxLength: 2000,
                style: AppType.fieldValue,
                cursorColor: AppColors.primary,
                decoration: const InputDecoration(
                  hintText: 'What happened on this call?',
                  fillColor: AppColors.canvas,
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                value: _createReminder,
                onChanged: _busy ? null : (v) => setState(() => _createReminder = v),
                contentPadding: EdgeInsets.zero,
                title: Text('Set a reminder', style: AppType.fieldValue),
                subtitle: Text(
                  'Creates a follow-up reminder on the lead.',
                  style: AppType.caption,
                ),
              ),
              if (_createReminder)
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
                        const AppIcon(Ic.calendar, size: 17, color: AppColors.muted),
                        const SizedBox(width: AppSpacing.x10),
                        Text(
                          _followUpDate == null
                              ? 'Pick a date'
                              : AppDate.display(_followUpDate),
                          style: AppType.fieldValue,
                        ),
                        const Spacer(),
                        const AppIcon(Ic.chevronRight, size: 16, color: AppColors.faint),
                      ],
                    ),
                  ),
                ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.x12),
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
                  onPressed: _busy ? null : _submit,
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : const Text('Save follow-up'),
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
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
          alignment: Alignment.center,
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
