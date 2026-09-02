import 'dart:typed_data';

import 'package:crmapp/core/di.dart';
import 'package:crmapp/data/services/calendar_api.dart';
import 'package:crmapp/features/calendar/providers/calendar_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records the query the calendar asked for, and answers with an empty feed.
class _SpyAdapter implements HttpClientAdapter {
  final queries = <Map<String, String>>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    queries.add(options.uri.queryParameters);
    return ResponseBody.fromString(
      '[]',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('startOfWeek is Monday-first, matching the grid header', () {
    // 2026-08-31 is a Monday; 2026-09-06 the Sunday that closes its week.
    expect(startOfWeek(DateTime(2026, 8, 31)), DateTime(2026, 8, 31));
    expect(startOfWeek(DateTime(2026, 9, 6)), DateTime(2026, 8, 31));
    expect(startOfWeek(DateTime(2026, 9, 7)), DateTime(2026, 9, 7));
  });

  test('the fetch window follows the view mode', () async {
    final adapter = _SpyAdapter();
    final container = ProviderContainer(
      overrides: [
        calendarApiProvider.overrideWithValue(
          CalendarApi(
            Dio(BaseOptions(baseUrl: 'http://x'))..httpClientAdapter = adapter,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    // Pin the visible month, then pick a Sunday inside it: that day's week
    // straddles two months — exactly the case a month-only window would clip.
    container.read(calendarViewProvider.notifier).selectDay(DateTime(2026, 9, 6));

    // Parsed and compared as instants: the client sends UTC, so a literal
    // string match would only pass in one timezone.
    DateTime sentFrom() => DateTime.parse(adapter.queries.last['from']!);
    DateTime sentTo() => DateTime.parse(adapter.queries.last['to']!);

    final month = container.read(calendarViewProvider).month;

    await container.read(calendarEventsProvider.future);
    expect(sentFrom(), DateTime(month.year, month.month, 1).toUtc());
    expect(sentTo(), DateTime(month.year, month.month + 1, 0, 23, 59, 59).toUtc());

    container.read(calendarViewModeProvider.notifier).set(CalendarViewMode.week);
    await container.read(calendarEventsProvider.future);
    expect(sentFrom(), DateTime(2026, 8, 31).toUtc());
    expect(sentTo(), DateTime(2026, 9, 6, 23, 59, 59).toUtc());

    container.read(calendarViewModeProvider.notifier).set(CalendarViewMode.day);
    await container.read(calendarEventsProvider.future);
    expect(sentFrom(), DateTime(2026, 9, 6).toUtc());
    expect(sentTo(), DateTime(2026, 9, 6, 23, 59, 59).toUtc());
  });
}
