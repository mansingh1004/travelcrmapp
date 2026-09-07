import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../router/routes.dart';
import '../../../router/safe_pop.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../api/booking_reminder_api.dart';
import '../api/reminder_api.dart';
import 'widgets/booking_reminder_actions_sheet.dart';
import 'widgets/reminder_actions_sheet.dart';
import 'widgets/reminder_form_sheet.dart';

/// Which slice of the list is on screen.
///
/// The first three are the lead-side reminder module. [bookings] is a
/// **different backend module** — separate table, separate vocabularies — put
/// behind the same tab bar because to an agent they are the same job: things
/// owed, in one place. The code keeps them apart; only the screen joins them.
enum ReminderTab {
  overdue('Overdue'),
  today('Today'),
  all('All'),
  bookings('Bookings');

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
///
/// Keyed on the tab rather than reading it, so selecting Bookings does not
/// instantiate a lead-side request at all.
///
/// Watching `reminderTabProvider` from inside here looked equivalent and was
/// not: switching to Bookings re-evaluated this provider before it was
/// disposed, firing a `GET /api/reminders` nobody rendered. Caught by the tab
/// test, which asserts the exact list of requests made.
final remindersProvider =
    FutureProvider.autoDispose.family<List<Reminder>, ReminderTab>(
  (ref, tab) async {
    final api = ref.watch(reminderApiProvider);
    return switch (tab) {
      ReminderTab.overdue => api.getOverdue(),
      ReminderTab.today => api.getDueToday(),
      ReminderTab.all => api.getReminders(),
      ReminderTab.bookings =>
        throw StateError('the Bookings tab reads bookingRemindersProvider'),
    };
  },
);

/// Booking-side reminders — payments and documents owed on a trip.
final bookingRemindersProvider =
    FutureProvider.autoDispose<List<BookingReminder>>(
  (ref) => ref.watch(bookingReminderApiProvider).getAll(),
);

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

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Reminders', style: AppType.h2),
        actions: [
          // Only on the lead-side tabs. Creating a booking reminder needs a
          // booking to hang it on, and that flow starts from the booking.
          if (tab != ReminderTab.bookings)
            TextButton.icon(
              onPressed: () => _add(context, ref),
              icon: const AppIcon(Ic.plus, size: 16, color: AppColors.primary),
              label: const Text('Add'),
            ),
        ],
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
            child: tab == ReminderTab.bookings
                ? _bookingList(context, ref)
                : _reminderList(context, ref, tab),
          ),
        ],
      ),
    );
  }

  /// The lead-side list — Overdue, Today or All.
  Widget _reminderList(BuildContext context, WidgetRef ref, ReminderTab tab) {
    return switch (ref.watch(remindersProvider(tab))) {
      AsyncLoading() => const SkeletonList(),
      AsyncError(:final error) => ErrorStateView(
          failure: asFailure(error),
          onRetry: () => ref.invalidate(remindersProvider(tab)),
        ),
      AsyncData(:final value) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => ref.invalidate(remindersProvider(tab)),
          child: value.isEmpty
              ? _Empty(
                  title: switch (tab) {
                    ReminderTab.overdue => 'Nothing overdue',
                    ReminderTab.today => 'Nothing due today',
                    _ => 'No reminders yet',
                  },
                  message: switch (tab) {
                    ReminderTab.overdue => 'Every reminder is on schedule.',
                    ReminderTab.today => 'Your day is clear so far.',
                    _ => 'Logging a follow-up on a lead raises one.',
                  },
                )
              : _List(
                  itemCount: value.length,
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
    };
  }

  /// The booking-side list — a different module behind the same tab bar.
  Widget _bookingList(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(bookingRemindersProvider)) {
      AsyncLoading() => const SkeletonList(),
      AsyncError(:final error) => ErrorStateView(
          failure: asFailure(error),
          onRetry: () => ref.invalidate(bookingRemindersProvider),
        ),
      AsyncData(:final value) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => ref.invalidate(bookingRemindersProvider),
          child: value.isEmpty
              ? const _Empty(
                  title: 'No booking reminders',
                  message: 'Payment and document reminders on a trip show '
                      'up here.',
                )
              : _List(
                  itemCount: value.length,
                  itemBuilder: (context, index) => _BookingReminderRow(
                    reminder: value[index],
                    onTap: () => _actOnBooking(context, ref, value[index]),
                  ),
                ),
        ),
    };
  }

  /// Add one by hand.
  ///
  /// Most reminders arrive on their own, but an agent on a call needs to be
  /// able to write one down without going back to a desk.
  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final saved = await ReminderFormSheet.show(context);
    if (saved == null) return;
    // The whole family: a new reminder can land in any of the three tabs.
    ref.invalidate(remindersProvider);
    if (context.mounted) {
      AppToast.success(context, 'Reminder added', saved);
    }
  }

  /// Same shape as [_act], against the other module's endpoints.
  Future<void> _actOnBooking(
    BuildContext context,
    WidgetRef ref,
    BookingReminder reminder,
  ) async {
    final outcome =
        await BookingReminderActionsSheet.show(context, reminder: reminder);
    if (outcome == null) return;
    ref.invalidate(bookingRemindersProvider);
    if (context.mounted) {
      AppToast.success(context, outcome.title, outcome.message);
    }
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
    // Completing, snoozing or rescheduling moves a row between tabs, so all
    // three are stale, not just the one being looked at.
    ref.invalidate(remindersProvider);
    if (context.mounted) {
      AppToast.success(context, outcome.title, outcome.message);
    }
  }
}

/// The list chrome both tabs share — same padding, same separators.
class _List extends StatelessWidget {
  const _List({required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        0,
        AppSpacing.gutter,
        AppSpacing.x24,
      ),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x12),
      itemBuilder: itemBuilder,
    );
  }
}

/// An empty tab, inside a scrollable so pull-to-refresh still works.
class _Empty extends StatelessWidget {
  const _Empty({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 360,
          child: EmptyStateView(icon: Ic.bell, title: title, message: message),
        ),
      ],
    );
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

/// One booking-side reminder: what is owed, on which trip, and when.
class _BookingReminderRow extends StatelessWidget {
  const _BookingReminderRow({required this.reminder, required this.onTap});

  final BookingReminder reminder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final overdue = reminder.isOverdue;
    final due = reminder.reminderDate;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.customerName ?? 'Unnamed booking',
                      style: AppType.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      [
                        reminder.typeLabel,
                        if (reminder.bookingCode != null) reminder.bookingCode!,
                        if (reminder.destination != null)
                          reminder.destination!,
                      ].join(' · '),
                      style: AppType.bodySm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (reminder.status != null)
                _Chip(
                  label: reminder.status!,
                  fg: switch (reminder.status) {
                    'Completed' => AppColors.success,
                    'Sent' => AppColors.primary,
                    _ => AppColors.warn,
                  },
                  bg: switch (reminder.status) {
                    'Completed' => AppColors.successBg,
                    'Sent' => AppColors.primaryTint,
                    _ => AppColors.warnBg,
                  },
                ),
            ],
          ),
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
                  due == null ? '—' : dueLabel(due, overdue: overdue),
                  style: AppType.caption.copyWith(
                    fontSize: 11,
                    color: overdue ? AppColors.danger : AppColors.muted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (reminder.amount != null && reminder.amount! > 0)
                Text(
                  Inr.format(reminder.amount!),
                  style: AppType.monoStrong.copyWith(
                    fontSize: 13,
                    color: overdue ? AppColors.danger : AppColors.ink,
                  ),
                ),
            ],
          ),
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
