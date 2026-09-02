import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/calendar.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/state_views.dart';
import '../providers/calendar_controller.dart';
import 'widgets/add_event_sheet.dart';

/// Monday-first, matching [startOfWeek].
const _weekdayInitials = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

/// Calendar — month grid with per-day dots, a source legend, and the selected
/// day's events.
///
/// One feed, seven sources. Task and reminder rows are editable server-side;
/// booking-derived rows (trips, payments, flights) are read-only and open the
/// record they came from instead.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(calendarViewProvider);
    final mode = ref.watch(calendarViewModeProvider);
    final async = ref.watch(calendarEventsProvider);
    final events = async.value ?? const <CalendarEvent>[];

    // Group here rather than in a provider: the map is cheap to build and a
    // provider would hand the widget a new identity on every rebuild.
    final byDay = groupByDay(events);
    final selected = byDay[view.selectedDay] ?? const <CalendarEvent>[];

    return Column(
      children: [
        _MonthBar(
          month: view.month,
          mode: mode,
          eventCount: events.length,
          onPrevious: () => ref.read(calendarViewProvider.notifier).previousMonth(),
          onNext: () => ref.read(calendarViewProvider.notifier).nextMonth(),
          onToday: () => ref.read(calendarViewProvider.notifier).today(),
          onMode: (m) => ref.read(calendarViewModeProvider.notifier).set(m),
        ),
        _Legend(
          active: ref.watch(calendarFilterProvider),
          onToggle: (s) => ref.read(calendarFilterProvider.notifier).toggle(s),
        ),
        Expanded(
          child: switch (async) {
            // Skeleton only on the very first load. A refetch — changing month
            // or toggling a source — keeps the current events on screen, so the
            // grid does not blink back to placeholders on every tap.
            AsyncLoading() when !async.hasValue => const SkeletonList(),
            AsyncError(:final error) when !async.hasValue => ErrorStateView(
                failure: asFailure(error),
                onRetry: () => ref.invalidate(calendarEventsProvider),
              ),
            _ => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  ref
                    ..invalidate(calendarEventsProvider)
                    ..invalidate(calendarSummaryProvider);
                },
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  children: [
                    _SummaryStrip(day: view.selectedDay),
                    const SizedBox(height: AppSpacing.x12),
                    if (mode == CalendarViewMode.month)
                      _MonthGrid(
                        month: view.month,
                        selectedDay: view.selectedDay,
                        byDay: byDay,
                        onSelect: (d) =>
                            ref.read(calendarViewProvider.notifier).selectDay(d),
                      ),
                    if (mode == CalendarViewMode.week)
                      _WeekStrip(
                        selectedDay: view.selectedDay,
                        byDay: byDay,
                        onSelect: (d) =>
                            ref.read(calendarViewProvider.notifier).selectDay(d),
                      ),
                    if (mode != CalendarViewMode.day)
                      const SizedBox(height: AppSpacing.x16),
                    Row(
                      children: [
                        Text(_dayHeading(view.selectedDay), style: AppType.h2),
                        const Spacer(),
                        _AddEventButton(day: view.selectedDay),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x10),
                    if (selected.isEmpty)
                      _DayEmpty(day: view.selectedDay)
                    else
                      for (final event in _sorted(selected))
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.x10),
                          child: _EventCard(
                            event: event,
                            onTap: () => _open(context, event),
                          ),
                        ),
                    const SizedBox(height: AppSpacing.x24),
                  ],
                ),
              ),
          },
        ),
      ],
    );
  }

  /// `Today` reads better than the date when it is in fact today.
  static String _dayHeading(DateTime day) {
    final now = DateTime.now();
    final isToday = day.year == now.year && day.month == now.month && day.day == now.day;
    return isToday ? 'Today · ${AppDate.dayMonth(day)}' : AppDate.dayMonth(day);
  }

  /// All-day rows first, then by start time — an all-day item has no useful
  /// time to sort against.
  List<CalendarEvent> _sorted(List<CalendarEvent> events) {
    final sorted = [...events];
    sorted.sort((a, b) {
      if (a.allDay != b.allDay) return a.allDay ? -1 : 1;
      final at = a.start;
      final bt = b.start;
      if (at == null || bt == null) return 0;
      return at.compareTo(bt);
    });
    return sorted;
  }

  void _open(BuildContext context, CalendarEvent event) {
    final id = event.referenceId;
    if (id == null) return;
    switch (event.referenceType) {
      case 'BOOKING':
        context.push(Routes.bookingDetailFor(id));
      case 'LEAD':
        context.push(Routes.leadDetailFor(id));
      default:
        // Tasks and reminders have no screen of their own yet.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${event.source?.label ?? 'This'} has no screen yet.')),
        );
    }
  }
}

class _MonthBar extends StatelessWidget {
  const _MonthBar({
    required this.month,
    required this.mode,
    required this.eventCount,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    required this.onMode,
  });

  final DateTime month;
  final CalendarViewMode mode;
  final int eventCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final ValueChanged<CalendarViewMode> onMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x8,
        AppSpacing.x8,
        AppSpacing.gutter,
        AppSpacing.x10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onPrevious,
                icon: const AppIcon(Ic.back, size: 18, color: AppColors.body),
                tooltip: 'Previous month',
              ),
              Expanded(
                child: Text(
                  AppDate.monthYear(month),
                  style: AppType.h2,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: onNext,
                icon: Transform.flip(
                  flipX: true,
                  child: const AppIcon(Ic.back, size: 18, color: AppColors.body),
                ),
                tooltip: 'Next month',
              ),
              TextButton(onPressed: onToday, child: const Text('Today')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.x8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    // The count describes the window actually fetched, which
                    // follows the view mode — saying "this month" in week view
                    // would be a lie.
                    '$eventCount event${eventCount == 1 ? '' : 's'} '
                    '${switch (mode) {
                      CalendarViewMode.month => 'this month',
                      CalendarViewMode.week => 'this week',
                      CalendarViewMode.day => 'on this day',
                    }}',
                    style: AppType.caption,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _ModeToggle(mode: mode, onMode: onMode),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Day / Week / Month — a segmented control, not three separate chips, because
/// the choices are mutually exclusive.
class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onMode});

  final CalendarViewMode mode;
  final ValueChanged<CalendarViewMode> onMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final value in CalendarViewMode.values)
            Semantics(
              button: true,
              selected: value == mode,
              child: InkWell(
                onTap: () => onMode(value),
                borderRadius: BorderRadius.circular(AppRadii.chip),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: value == mode ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadii.chip),
                  ),
                  child: Text(
                    value.label,
                    style: AppType.tab.copyWith(
                      fontSize: 11.5,
                      color: value == mode ? AppColors.onPrimary : AppColors.body,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The day's headline numbers from `GET /api/calendar/summary`.
///
/// Every figure is counted server-side for the selected date. Revenue is the
/// one month-scoped number, so it says so rather than sitting unlabelled
/// beside the day counts.
class _SummaryStrip extends ConsumerWidget {
  const _SummaryStrip({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(calendarSummaryProvider).value;
    // Absent until the first read lands, and absent for a role without
    // CRM_FULL — either way the strip is simply not drawn rather than shown
    // as a row of zeroes.
    if (summary == null) return const SizedBox.shrink();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Stat(
                label: 'Follow-ups',
                value: '${summary.todaysFollowups}',
                color: AppColors.primary,
              ),
              _Stat(
                label: 'Trips',
                value: '${summary.activeTrips}',
                color: AppColors.success,
              ),
              _Stat(
                label: 'Due',
                value: Inr.compact(summary.paymentsDueAmount),
                caption: '${summary.paymentsDueCount} invoice'
                    '${summary.paymentsDueCount == 1 ? '' : 's'}',
                color: AppColors.warn,
              ),
              if ((summary.overdueCount ?? 0) > 0)
                _Stat(
                  label: 'Overdue',
                  value: Inr.compact(summary.totalOverdue),
                  caption: '${summary.overdueCount}',
                  color: AppColors.danger,
                ),
            ],
          ),
          if (summary.revenueThisMonth > 0) ...[
            const SizedBox(height: AppSpacing.x10),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.x8),
            Row(
              children: [
                const AppIcon(Ic.trend, size: 14, color: AppColors.success),
                const SizedBox(width: AppSpacing.x8),
                Text('Revenue this month', style: AppType.caption),
                const Spacer(),
                Text(
                  Inr.format(summary.revenueThisMonth),
                  style: AppType.monoSm.copyWith(color: AppColors.ink),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.color,
    this.caption,
  });

  final String label;
  final String value;
  final String? caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppType.monoStrong.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            label,
            style: AppType.caption.copyWith(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (caption != null)
            Text(
              caption!,
              style: AppType.caption.copyWith(fontSize: 10, color: AppColors.faint),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

/// The seven days around the selection, for week view.
class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.selectedDay,
    required this.byDay,
    required this.onSelect,
  });

  final DateTime selectedDay;
  final Map<DateTime, List<CalendarEvent>> byDay;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final start = startOfWeek(selectedDay);
    final today = DateTime.now();

    return Row(
      children: [
        for (var i = 0; i < 7; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.x6),
          Builder(
            builder: (context) {
              final day = DateTime(start.year, start.month, start.day + i);
              final events = byDay[day] ?? const <CalendarEvent>[];
              final isSelected = day == selectedDay;
              final isToday = day.year == today.year &&
                  day.month == today.month &&
                  day.day == today.day;

              return Expanded(
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  label: '${AppDate.dayMonth(day)}, ${events.length} events',
                  child: InkWell(
                    onTap: () => onSelect(day),
                    borderRadius: BorderRadius.circular(AppRadii.card),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _weekdayInitials[i],
                            style: AppType.caption.copyWith(
                              fontSize: 10,
                              color: isSelected
                                  ? AppColors.onPrimary.withValues(alpha: 0.75)
                                  : AppColors.faint,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          Text(
                            '${day.day}',
                            style: AppType.monoStrong.copyWith(
                              color: isSelected
                                  ? AppColors.onPrimary
                                  : isToday
                                      ? AppColors.primary
                                      : AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x6),
                          SizedBox(
                            height: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (final source in _sourcesOf(events))
                                  Container(
                                    width: 4,
                                    height: 4,
                                    margin: const EdgeInsets.symmetric(horizontal: 1),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.onPrimary
                                          : StatusColors.calendarSource(source)
                                              .foreground,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

/// One dot per distinct source, capped at three.
List<CalendarSource> _sourcesOf(List<CalendarEvent> events) => <CalendarSource>{
      for (final e in events)
        if (e.source != null) e.source!,
    }.take(3).toList();

class _AddEventButton extends StatelessWidget {
  const _AddEventButton({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => AddEventSheet.show(context, day: day),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x12,
          vertical: AppSpacing.x8,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppIcon(Ic.plus, size: 15, color: AppColors.onPrimary),
          const SizedBox(width: AppSpacing.x6),
          Text(
            'Event',
            style: AppType.tab.copyWith(color: AppColors.onPrimary),
          ),
        ],
      ),
    );
  }
}

class _DayEmpty extends StatelessWidget {
  const _DayEmpty({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x16,
        vertical: AppSpacing.x24,
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            child: const AppIcon(Ic.calendar, size: 24, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.x12),
          Text('Nothing scheduled', style: AppType.h3),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'No follow-ups, payments or departures on this day.',
            style: AppType.bodySm,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x14),
          OutlinedButton(
            onPressed: () => AddEventSheet.show(context, day: day),
            child: const Text('Add event'),
          ),
        ],
      ),
    );
  }
}

/// Source filter chips, doubling as the dot-colour legend.
class _Legend extends StatelessWidget {
  const _Legend({required this.active, required this.onToggle});

  final Set<CalendarSource> active;
  final ValueChanged<CalendarSource> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          0,
          AppSpacing.gutter,
          AppSpacing.x12,
        ),
        child: Row(
          children: [
            for (final source in CalendarSource.values) ...[
              if (source != CalendarSource.values.first)
                const SizedBox(width: AppSpacing.x8),
              _LegendChip(
                source: source,
                // With nothing selected the server returns everything, so every
                // chip reads as on rather than off.
                active: active.isEmpty || active.contains(source),
                onTap: () => onToggle(source),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.source,
    required this.active,
    required this.onTap,
  });

  final CalendarSource source;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = StatusColors.calendarSource(source);

    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x10),
          decoration: BoxDecoration(
            color: active ? palette.background : AppColors.canvas,
            borderRadius: BorderRadius.circular(AppRadii.chip),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? palette.foreground : AppColors.border,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.x6),
              Text(
                source.label,
                style: AppType.chip.copyWith(
                  color: active ? palette.foreground : AppColors.faint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The month grid. Each day shows up to three dots, one per distinct source.
class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.selectedDay,
    required this.byDay,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime selectedDay;
  final Map<DateTime, List<CalendarEvent>> byDay;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Monday-first: DateTime.weekday is 1..7 with Monday == 1.
    final leading = first.weekday - 1;
    final today = DateTime.now();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.x12),
      child: Column(
        children: [
          Row(
            children: [
              for (final label in _weekdayInitials)
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: AppType.caption.copyWith(fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.82,
            ),
            itemCount: leading + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leading) return const SizedBox.shrink();

              final dayNumber = index - leading + 1;
              final day = DateTime(month.year, month.month, dayNumber);
              final events = byDay[day] ?? const <CalendarEvent>[];
              final isSelected = day == selectedDay;
              final isToday = day.year == today.year &&
                  day.month == today.month &&
                  day.day == today.day;

              return _DayCell(
                day: dayNumber,
                events: events,
                selected: isSelected,
                isToday: isToday,
                onTap: () => onSelect(day),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.events,
    required this.selected,
    required this.isToday,
    required this.onTap,
  });

  final int day;
  final List<CalendarEvent> events;
  final bool selected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // One dot per distinct source, capped at three — a day with ten events
    // should read as busy, not as a solid bar.
    final sources = <CalendarSource>{
      for (final e in events)
        if (e.source != null) e.source!,
    }.take(3).toList();

    return Semantics(
      button: true,
      selected: selected,
      label: '$day, ${events.length} event${events.length == 1 ? '' : 's'}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : isToday
                        ? AppColors.primaryTint
                        : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$day',
                style: AppType.monoSm.copyWith(
                  color: selected
                      ? AppColors.onPrimary
                      : isToday
                          ? AppColors.primary
                          : AppColors.ink,
                  fontWeight: isToday || selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              height: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final source in sources)
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: StatusColors.calendarSource(source).foreground,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onTap});

  final CalendarEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = event.source == null
        ? StatusColors.neutral
        : StatusColors.calendarSource(event.source!);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: palette.foreground,
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
          ),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title.isEmpty ? 'Untitled' : event.title,
                  style: AppType.h3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (event.subtitle != null) ...[
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    event.subtitle!,
                    style: AppType.bodySm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.x8),
                Wrap(
                  spacing: AppSpacing.x10,
                  runSpacing: AppSpacing.x6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      _when(event),
                      style: AppType.monoSm.copyWith(color: palette.foreground),
                    ),
                    _TypeChip(
                      // The server's own label wins when it sends one; the
                      // enum's is the fallback for rows it does not label.
                      label: event.category ?? event.source?.label ?? 'Event',
                      palette: palette,
                    ),
                    if (event.amount != null)
                      Text(Inr.format(event.amount), style: AppType.monoSm),
                    if (event.assigneeName != null)
                      Text(event.assigneeName!, style: AppType.caption),
                  ],
                ),
              ],
            ),
          ),
          const AppIcon(Ic.chevronRight, size: 16, color: AppColors.faint),
        ],
      ),
    );
  }
}

/// `10:30 AM · 45m`, or just the start when the row has no end.
///
/// The duration is only shown when it is genuinely known: a row whose end
/// equals its start carries no duration, and printing `0m` there would read as
/// a zero-length meeting rather than as "unspecified".
String _when(CalendarEvent event) {
  if (event.allDay) return 'All day';

  final start = event.start;
  if (start == null) return '—';

  final end = event.end;
  final minutes = end == null ? 0 : end.difference(start).inMinutes;
  if (minutes <= 0) return AppDate.time(start);

  return '${AppDate.time(start)} · ${_duration(minutes)}';
}

String _duration(int minutes) {
  if (minutes < 60) return '${minutes}m';
  final hours = minutes ~/ 60;
  final rest = minutes % 60;
  // Past a day the hour count stops being readable — a five-night trip should
  // say `5d`, not `120h`.
  if (hours >= 24) {
    final days = hours ~/ 24;
    final spareHours = hours % 24;
    return spareHours == 0 ? '${days}d' : '${days}d ${spareHours}h';
  }
  return rest == 0 ? '${hours}h' : '${hours}h ${rest}m';
}

/// The event's kind, tinted to match its source dot.
class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label, required this.palette});

  final String label;
  final StatusPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x8, vertical: 2),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppType.caption.copyWith(
          fontSize: 9.5,
          letterSpacing: 0.5,
          fontWeight: FontWeight.w700,
          color: palette.foreground,
        ),
      ),
    );
  }
}
