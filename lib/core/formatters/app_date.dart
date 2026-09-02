import 'package:intl/intl.dart';

/// Date and time formatting: `dd MMM yyyy` and 12-hour clock, per the spec.
///
/// The backend serialises `LocalDate` as `yyyy-MM-dd` and `LocalDateTime` as
/// ISO-8601 **without a timezone** (`API_CONTRACT.md` §5), so timestamps are
/// parsed as local wall-clock time, never shifted as if they were UTC.
abstract final class AppDate {
  static final _display = DateFormat('dd MMM yyyy');
  static final _displayShort = DateFormat('dd MMM');
  static final _dayMonth = DateFormat('EEE, dd MMM');
  static final _time12 = DateFormat('h:mm a');
  static final _wire = DateFormat('yyyy-MM-dd');
  static final _monthYear = DateFormat('MMMM yyyy');

  /// `2026-09-12` → `12 Sep 2026`
  static String display(DateTime? d) => d == null ? '—' : _display.format(d);

  /// `12 Sep`
  static String displayShort(DateTime? d) => d == null ? '—' : _displayShort.format(d);

  /// `Fri, 12 Sep`
  static String dayMonth(DateTime? d) => d == null ? '—' : _dayMonth.format(d);

  /// `11:30 AM`
  static String time(DateTime? d) => d == null ? '—' : _time12.format(d);

  /// `12 Sep 2026, 11:30 AM`
  static String dateTime(DateTime? d) => d == null ? '—' : '${_display.format(d)}, ${_time12.format(d)}';

  /// `September 2026`
  static String monthYear(DateTime d) => _monthYear.format(d);

  /// Serialise for the backend's `@JsonFormat(pattern = "yyyy-MM-dd")` fields.
  static String toWire(DateTime d) => _wire.format(d);

  /// Parse a backend `yyyy-MM-dd` date. Returns null on anything unparseable
  /// rather than throwing, so one bad row cannot blank a whole list.
  static DateTime? parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// Parse a backend `LocalDateTime`. Jackson emits no zone designator, so
  /// `DateTime.tryParse` already yields local time — no conversion applied.
  static DateTime? parseDateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// `12–18 Sep` / `28 Sep – 3 Oct`, the prototype's travel-window style.
  static String range(DateTime? from, DateTime? to) {
    if (from == null && to == null) return '—';
    if (to == null) return display(from);
    if (from == null) return display(to);
    if (from.year == to.year && from.month == to.month) {
      return '${from.day}–${_displayShort.format(to)}';
    }
    return '${_displayShort.format(from)} – ${_displayShort.format(to)}';
  }

  /// Whole days from today, negative when in the past.
  static int daysFromToday(DateTime d) {
    final now = DateTime.now();
    return DateTime(d.year, d.month, d.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  /// `Today` / `Tomorrow` / `Yesterday`, else `12 Sep 2026`.
  static String relative(DateTime? d) {
    if (d == null) return '—';
    return switch (daysFromToday(d)) {
      0 => 'Today',
      1 => 'Tomorrow',
      -1 => 'Yesterday',
      _ => display(d),
    };
  }
}
