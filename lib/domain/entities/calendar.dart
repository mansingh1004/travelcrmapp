import 'package:flutter/foundation.dart';

/// Where a calendar row came from. The server merges seven sources into one
/// feed, which is what the screen's legend shows.
enum CalendarSource {
  task('TASK', 'Task'),
  reminder('REMINDER', 'Follow-up'),
  trip('TRIP', 'Travel'),
  paymentDue('PAYMENT_DUE', 'Payment'),
  flight('FLIGHT', 'Flight'),
  hotelCheckin('HOTEL_CHECKIN', 'Hotel'),
  visa('VISA', 'Visa');

  const CalendarSource(this.wire, this.label);

  final String wire;
  final String label;

  static CalendarSource? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    final key = value.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
    for (final source in CalendarSource.values) {
      final w = source.wire.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
      if (w == key) return source;
    }
    return null;
  }
}

/// One row of `GET /api/calendar`.
///
/// Times arrive as UTC instants — unlike the rest of the API, which sends
/// zone-less local times — so they are converted to local for display.
@immutable
class CalendarEvent {
  const CalendarEvent({
    required this.id,
    this.source,
    this.category,
    required this.title,
    this.subtitle,
    this.start,
    this.end,
    this.allDay = false,
    this.priority,
    this.status,
    this.amount,
    this.referenceType,
    this.referenceId,
    this.assigneeName,
    this.editable = false,
  });

  /// Composite key, e.g. `TASK:<uuid>` — unique across sources.
  final String id;

  final CalendarSource? source;

  /// The server's own legend label.
  final String? category;

  final String title;
  final String? subtitle;

  final DateTime? start;
  final DateTime? end;
  final bool allDay;

  final String? priority;
  final String? status;

  /// Only present on payment-due rows.
  final double? amount;

  /// TASK / REMINDER / BOOKING — what [referenceId] points at.
  final String? referenceType;
  final String? referenceId;

  final String? assigneeName;

  /// True only for task and reminder rows; booking-derived rows are read-only.
  final bool editable;

  /// The calendar day this event belongs to, in local time.
  DateTime? get day {
    final s = start;
    return s == null ? null : DateTime(s.year, s.month, s.day);
  }
}

/// `GET /api/calendar/summary` — the day's headline numbers.
@immutable
class CalendarSummary {
  const CalendarSummary({
    this.date,
    required this.todaysFollowups,
    required this.activeTrips,
    required this.paymentsDueAmount,
    required this.paymentsDueCount,
    required this.flightsToday,
    required this.hotelCheckinsToday,
    required this.newLeadsToday,
    required this.revenueThisMonth,
    this.totalOverdue,
    this.overdueCount,
  });

  final DateTime? date;
  final int todaysFollowups;
  final int activeTrips;
  final double paymentsDueAmount;
  final int paymentsDueCount;
  final int flightsToday;
  final int hotelCheckinsToday;
  final int newLeadsToday;
  final double revenueThisMonth;

  /// Payments already past their due date, reported separately from today's.
  final double? totalOverdue;
  final int? overdueCount;
}
