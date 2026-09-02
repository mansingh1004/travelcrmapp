import 'package:dio/dio.dart';

import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../domain/entities/calendar.dart';
import '../../../data/remote/failure_mapper.dart';

/// `CalendarController` — `/api/calendar`.
///
/// Small enough to map inline: the payload is a flat event list with no nested
/// DTOs, so a separate freezed model and mapper would only add indirection.
class CalendarApi {
  const CalendarApi(this._dio);

  final Dio _dio;

  /// `GET /api/calendar` — the merged feed for a window.
  ///
  /// `from`/`to` are **ISO-8601 instants**, not the `yyyy-MM-dd` the rest of
  /// the API uses. Passing a bare date silently yields null on the server and
  /// the window falls back to the current month.
  Future<List<CalendarEvent>> getEvents({
    DateTime? from,
    DateTime? to,
    List<CalendarSource>? categories,
    bool mine = false,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/calendar',
        queryParameters: <String, dynamic>{
          if (from != null) 'from': _instant(from),
          if (to != null) 'to': _instant(to),
          if (categories != null && categories.isNotEmpty)
            'categories': categories.map((c) => c.wire).join(','),
          if (mine) 'mine': true,
        },
      );

      // This module answers **bare**, not enveloped: the events call returns a
      // plain JSON array and the summary a plain object. Both shapes are
      // accepted so the client keeps working either way.
      final body = response.data;
      final rows = switch (body) {
        List<dynamic>() => body,
        Map<String, dynamic>() when body['data'] is List => body['data'] as List,
        _ => throw const ParseFailure(
            cause: 'Calendar events were neither a list nor an enveloped list',
          ),
      };

      return rows
          .whereType<Map<String, dynamic>>()
          .map(_toEvent)
          .toList(growable: false);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/calendar/summary` — headline numbers for one day.
  ///
  /// This endpoint returns the summary **bare**, without the `ApiResponse`
  /// envelope every other endpoint in the module uses, so both shapes are
  /// accepted rather than assuming the wrapper.
  Future<CalendarSummary> getSummary({DateTime? date}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/calendar/summary',
        queryParameters: <String, dynamic>{
          if (date != null) 'date': AppDate.toWire(date),
        },
      );

      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const ParseFailure(cause: 'Calendar summary was not a JSON object');
      }
      final inner = body['data'];
      return _toSummary(inner is Map<String, dynamic> ? inner : body);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static CalendarEvent _toEvent(Map<String, dynamic> json) => CalendarEvent(
        id: json['id'] as String? ?? '',
        source: CalendarSource.tryParse(json['source'] as String?),
        category: _blankToNull(json['category'] as String?),
        title: (json['title'] as String?)?.trim() ?? '',
        subtitle: _blankToNull(json['subtitle'] as String?),
        // These are true UTC instants, so they must be converted to local —
        // the zone-less parsing used elsewhere would shift them.
        start: _instantToLocal(json['start'] as String?),
        end: _instantToLocal(json['end'] as String?),
        allDay: json['allDay'] as bool? ?? false,
        priority: _blankToNull(json['priority'] as String?),
        status: _blankToNull(json['status'] as String?),
        amount: (json['amount'] as num?)?.toDouble(),
        referenceType: _blankToNull(json['referenceType'] as String?),
        referenceId: _blankToNull(json['referencePublicId'] as String?),
        assigneeName: _blankToNull(json['assigneeName'] as String?),
        editable: json['editable'] as bool? ?? false,
      );

  static CalendarSummary _toSummary(Map<String, dynamic> json) {
    final payments = json['paymentDueSummary'];
    final due = payments is Map<String, dynamic> ? payments : const <String, dynamic>{};

    return CalendarSummary(
      date: AppDate.parseDate(json['date'] as String?),
      todaysFollowups: (json['todaysFollowups'] as num?)?.toInt() ?? 0,
      activeTrips: (json['activeTrips'] as num?)?.toInt() ?? 0,
      paymentsDueAmount: (json['paymentsDueAmount'] as num?)?.toDouble() ?? 0,
      paymentsDueCount: (json['paymentsDueCount'] as num?)?.toInt() ?? 0,
      flightsToday: (json['flightsToday'] as num?)?.toInt() ?? 0,
      hotelCheckinsToday: (json['hotelCheckinsToday'] as num?)?.toInt() ?? 0,
      newLeadsToday: (json['newLeadsToday'] as num?)?.toInt() ?? 0,
      revenueThisMonth: (json['revenueThisMonth'] as num?)?.toDouble() ?? 0,
      totalOverdue: (due['totalOverdue'] as num?)?.toDouble(),
      overdueCount: (due['overdueCount'] as num?)?.toInt(),
    );
  }

  static DateTime? _instantToLocal(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }

  static String _instant(DateTime value) => value.toUtc().toIso8601String();

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
