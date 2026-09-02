import 'package:flutter/foundation.dart' show immutable, setEquals;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../../../domain/entities/calendar.dart';

/// The month being viewed, and which day is selected inside it.
@immutable
class CalendarView {
  const CalendarView({required this.month, required this.selectedDay});

  /// First of the visible month.
  final DateTime month;

  final DateTime selectedDay;

  CalendarView copyWith({DateTime? month, DateTime? selectedDay}) => CalendarView(
        month: month ?? this.month,
        selectedDay: selectedDay ?? this.selectedDay,
      );
}

final calendarViewProvider =
    NotifierProvider<CalendarViewNotifier, CalendarView>(CalendarViewNotifier.new);

class CalendarViewNotifier extends Notifier<CalendarView> {
  @override
  CalendarView build() {
    final now = DateTime.now();
    return CalendarView(
      month: DateTime(now.year, now.month),
      selectedDay: DateTime(now.year, now.month, now.day),
    );
  }

  void selectDay(DateTime day) =>
      state = state.copyWith(selectedDay: DateTime(day.year, day.month, day.day));

  void nextMonth() => _shift(1);

  void previousMonth() => _shift(-1);

  void today() {
    final now = DateTime.now();
    state = CalendarView(
      month: DateTime(now.year, now.month),
      selectedDay: DateTime(now.year, now.month, now.day),
    );
  }

  void _shift(int months) {
    final next = DateTime(state.month.year, state.month.month + months);
    state = state.copyWith(
      month: next,
      // Keep the selection inside the visible month so the day list is never
      // showing a day the grid cannot highlight.
      selectedDay: DateTime(next.year, next.month, 1),
    );
  }
}

/// How much of the calendar is on screen.
enum CalendarViewMode {
  day('Day'),
  week('Week'),
  month('Month');

  const CalendarViewMode(this.label);

  final String label;
}

final calendarViewModeProvider =
    NotifierProvider<CalendarViewModeNotifier, CalendarViewMode>(
        CalendarViewModeNotifier.new);

class CalendarViewModeNotifier extends Notifier<CalendarViewMode> {
  @override
  CalendarViewMode build() => CalendarViewMode.month;

  void set(CalendarViewMode mode) => state = mode;
}

/// Monday-first, matching the grid's `M T W T F S S` header.
DateTime startOfWeek(DateTime day) =>
    DateTime(day.year, day.month, day.day - (day.weekday - 1));

/// Which sources are shown. Empty means all — matching the server, where an
/// omitted `categories` param returns every source.
final calendarFilterProvider =
    NotifierProvider<CalendarFilterNotifier, Set<CalendarSource>>(
        CalendarFilterNotifier.new);

class CalendarFilterNotifier extends Notifier<Set<CalendarSource>> {
  @override
  Set<CalendarSource> build() => const {};

  void toggle(CalendarSource source) {
    final next = {...state};
    if (!next.remove(source)) next.add(source);
    state = next;
  }

  void clear() => state = const {};
}

/// The window and filter the event list is keyed on.
///
/// Value-equal, so a rebuild that produces an identical query does **not**
/// re-trigger the fetch below.
@immutable
class _EventQuery {
  const _EventQuery(this.from, this.to, this.sources);

  final DateTime from;
  final DateTime to;
  final Set<CalendarSource> sources;

  @override
  bool operator ==(Object other) =>
      other is _EventQuery &&
      other.from == from &&
      other.to == to &&
      setEquals(other.sources, sources);

  @override
  int get hashCode => Object.hash(from, to, Object.hashAllUnordered(sources));
}

/// The fetch window follows the view mode, so a week straddling two months
/// still gets every one of its days — a month-only window would leave the
/// spill-over days silently dotless.
///
/// In month mode the selected *day* deliberately does not affect the window:
/// tapping a date filters events already in hand rather than re-hitting the
/// network.
final _eventQueryProvider = Provider<_EventQuery>((ref) {
  final view = ref.watch(calendarViewProvider);
  final mode = ref.watch(calendarViewModeProvider);
  final sources = ref.watch(calendarFilterProvider);

  final (DateTime from, DateTime to) = switch (mode) {
    CalendarViewMode.month => (
        DateTime(view.month.year, view.month.month),
        // Day 0 of next month is the last day of this one.
        DateTime(view.month.year, view.month.month + 1, 0, 23, 59, 59),
      ),
    CalendarViewMode.week => () {
        final start = startOfWeek(view.selectedDay);
        return (
          start,
          DateTime(start.year, start.month, start.day + 6, 23, 59, 59),
        );
      }(),
    CalendarViewMode.day => (
        DateTime(view.selectedDay.year, view.selectedDay.month, view.selectedDay.day),
        DateTime(
          view.selectedDay.year,
          view.selectedDay.month,
          view.selectedDay.day,
          23,
          59,
          59,
        ),
      ),
  };

  return _EventQuery(from, to, sources);
});

/// Every event in the visible month.
///
/// **Not `autoDispose`.** The loading state renders a continuously-animating
/// skeleton, and an auto-disposing future behind an always-animating widget
/// thrashes: each rebuild can drop and re-add the only listener, disposing the
/// provider and starting the request again, which renders the skeleton again.
/// Keeping it alive for the session costs one cached list and makes returning
/// to the tab instant.
final calendarEventsProvider = FutureProvider<List<CalendarEvent>>((ref) {
  final query = ref.watch(_eventQueryProvider);

  return ref.watch(calendarApiProvider).getEvents(
        from: query.from,
        to: query.to,
        categories: query.sources.isEmpty ? null : query.sources.toList(),
      );
});

/// Headline numbers for the selected day.
final calendarSummaryProvider = FutureProvider<CalendarSummary>((ref) {
  final day = ref.watch(calendarViewProvider).selectedDay;
  return ref.watch(calendarApiProvider).getSummary(date: day);
});

/// Events grouped by local calendar day — what the grid's dots are drawn from.
///
/// A plain function, not a provider: it returns a fresh `Map` each call, and a
/// provider handing a new map identity to a watching widget would rebuild it
/// every time for no gain. Twenty-odd events regroup in microseconds.
Map<DateTime, List<CalendarEvent>> groupByDay(List<CalendarEvent> events) {
  final map = <DateTime, List<CalendarEvent>>{};
  for (final event in events) {
    final day = event.day;
    if (day == null) continue;
    map.putIfAbsent(day, () => []).add(event);
  }
  return map;
}
