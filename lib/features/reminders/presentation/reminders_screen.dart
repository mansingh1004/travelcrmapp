import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../router/routes.dart';
import '../../../router/safe_pop.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../api/reminder_api.dart';
import 'widgets/reminder_actions_sheet.dart';

/// Which slice of the list is on screen.
enum ReminderTab {
  overdue('Overdue'),
  today('Today'),
  all('All');

  const ReminderTab(this.label);

  final String label;
}

final reminderTabProvider = NotifierProvider<ReminderTabNotifier, ReminderTab>(
  ReminderTabNotifier.new,
);

class ReminderTabNotifier extends Notifier<ReminderTab> {
  @override
  ReminderTab build() => ReminderTab.overdue;

  void select(ReminderTab tab) => state = tab;
}

/// The list for the selected tab.
///
/// Each tab is a different endpoint rather than one list filtered locally:
/// `/overdue` and `/due-today` apply rules the client cannot reproduce — the
/// due-today window is measured in the **tenant's** timezone, and "overdue"
/// covers both `Active` and the scheduler-flipped `OVERDUE`.
final remindersProvider =
    FutureProvider.autoDispose<List<Reminder>>((ref) async {
  final api = ref.watch(reminderApiProvider);
  return switch (ref.watch(reminderTabProvider)) {
    ReminderTab.overdue => api.getOverdue(),
    ReminderTab.today => api.getDueToday(),
    ReminderTab.all => api.getReminders(),
  };
});

/// Reminders — what is owed today, and what is already late.
///
/// Reminders arrive here rather than being made here: logging a follow-up on a
/// lead raises one, and `ReminderScheduler` flips it to `OVERDUE` when its time
/// passes. So this screen is built for working a list down — complete, snooze,
/// dismiss, or call the customer — which is what an agent away from a desk
/// actually does with them.
class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(reminderTabProvider);
    final async = ref.watch(remindersProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Reminders', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: Row(
              children: [
                for (final option in ReminderTab.values) ...[
                  _Tab(
                    label: option.label,
                    active: option == tab,
                    onTap: () =>
                        ref.read(reminderTabProvider.notifier).select(option),
                  ),
                  if (option != ReminderTab.values.last)
                    const SizedBox(width: AppSpacing.x8),
                ],
              ],
            ),
          ),
          Expanded(
            child: switch (async) {
              AsyncLoading() => const SkeletonList(),
              AsyncError(:final error) => ErrorStateView(
                  failure: asFailure(error),
                  onRetry: () => ref.invalidate(remindersProvider),
                ),
              AsyncData(:final value) => RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => ref.invalidate(remindersProvider),
                  child: value.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(
                              height: 360,
                              child: EmptyStateView(
                                icon: Ic.bell,
                                title: switch (tab) {
                                  ReminderTab.overdue => 'Nothing overdue',
                                  ReminderTab.today => 'Nothing due today',
                                  ReminderTab.all => 'No reminders yet',
                                },
                                message: switch (tab) {
                                  ReminderTab.overdue =>
                                    'Every reminder is on schedule.',
                                  ReminderTab.today =>
                                    'Your day is clear so far.',
                                  ReminderTab.all =>
                                    'Logging a follow-up on a lead raises one.',
                                },
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.gutter,
                            0,
                            AppSpacing.gutter,
                            AppSpacing.x24,
                          ),
                          itemCount: value.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.x12),
                          itemBuilder: (context, index) => _ReminderRow(
                            reminder: value[index],
                            onTap: () => _act(context, ref, value[index]),
                            onOpenLead: () {
                              final leadId = value[index].leadPublicId;
                              if (leadId != null) {
                                context.push(Routes.leadDetailFor(leadId));
                              }
                            },
                          ),
                        ),
                ),
            },
          ),
        ],
      ),
    );
  }

  /// Open the actions sheet, then refresh and report what happened.
  ///
  /// The toast is raised here rather than inside the sheet, whose context is
  /// deactivated the moment it pops.
  Future<void> _act(
    BuildContext context,
    WidgetRef ref,
    Reminder reminder,
  ) async {
    final outcome = await ReminderActionsSheet.show(context, reminder: reminder);
    if (outcome == null) return;
    ref.invalidate(remindersProvider);
    if (context.mounted) {
      AppToast.success(context, outcome.title, outcome.message);
    }
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: active,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          child: Container(
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.chip),
              border: Border.all(
                color: active ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Text(
              label,
              style: AppType.tab.copyWith(
                color: active ? AppColors.onPrimary : AppColors.body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.reminder,
    required this.onTap,
    required this.onOpenLead,
  });

  final Reminder reminder;
  final VoidCallback onTap;
  final VoidCallback onOpenLead;

  @override
  Widget build(BuildContext context) {
    final overdue = reminder.isOverdue;
    final due = reminder.dueDate;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PriorityDot(priority: reminder.priority),
              const SizedBox(width: AppSpacing.x10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: AppType.h3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      [
                        reminder.typeLabel,
                        if (reminder.leadName != null) reminder.leadName!,
                      ].join(' · '),
                      style: AppType.bodySm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!reminder.isOpen)
                _Chip(
                  label: reminder.status == 'Completed' ? 'Done' : 'Dismissed',
                  fg: AppColors.muted,
                  bg: AppColors.slateBg,
                )
              else if (reminder.status == 'Snoozed')
                _Chip(
                  label: 'Snoozed',
                  fg: AppColors.warn,
                  bg: AppColors.warnBg,
                ),
            ],
          ),
          if (due != null) ...[
            const SizedBox(height: AppSpacing.x12),
            Row(
              children: [
                AppIcon(
                  Ic.clock,
                  size: 14,
                  color: overdue ? AppColors.danger : AppColors.faint,
                ),
                const SizedBox(width: AppSpacing.x6),
                Expanded(
                  child: Text(
                    dueLabel(due, overdue: overdue),
                    style: AppType.caption.copyWith(
                      fontSize: 11,
                      color: overdue ? AppColors.danger : AppColors.muted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (reminder.leadPublicId != null)
                  TextButton(
                    onPressed: onOpenLead,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Open lead'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// `01 Sep 2026, 9:00 AM · 6 days late`.
///
/// The lateness is spelled out rather than run through `AppDate.relative`,
/// which falls back to the formatted date once something is older than
/// yesterday — that printed the same date twice on exactly the rows this
/// screen exists to show.
String dueLabel(DateTime due, {required bool overdue}) {
  final when = AppDate.dateTime(due);
  if (!overdue) return when;
  final days = -AppDate.daysFromToday(due);
  final late = switch (days) {
    <= 0 => 'Overdue',
    1 => 'Yesterday',
    _ => '$days days late',
  };
  return '$when · $late';
}

/// Priority as a colour, not a word — it sits beside the title where a word
/// would crowd it out on a narrow phone.
class _PriorityDot extends StatelessWidget {
  const _PriorityDot({required this.priority});

  final String? priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      'High' => AppColors.danger,
      'Medium' => AppColors.warn,
      'Low' => AppColors.success,
      _ => AppColors.border,
    };
    return Semantics(
      label: priority == null ? null : '$priority priority',
      child: Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(top: AppSpacing.x6),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.fg, required this.bg});

  final String label;
  final Color fg;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x8,
          vertical: 3,
        ),
        child: Text(label, style: AppType.chip.copyWith(color: fg)),
      ),
    );
  }
}
