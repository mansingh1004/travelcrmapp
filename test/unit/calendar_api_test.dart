import 'dart:typed_data';

import 'package:crmapp/features/calendar/api/calendar_api.dart';
import 'package:crmapp/domain/entities/calendar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.body);

  final String body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async =>
      ResponseBody.fromString(
        body,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  void close({bool force = false}) {}
}

CalendarApi _api(String body) => CalendarApi(
      Dio(BaseOptions(baseUrl: 'http://x'))..httpClientAdapter = _StubAdapter(body),
    );

void main() {
  group('CalendarApi.getSummary', () {
    // The live endpoint returns the summary WITHOUT the ApiResponse wrapper,
    // unlike every other call in the module. Both shapes must work.
    const bare = '{"date":"2026-08-31","todaysFollowups":0,"activeTrips":2,'
        '"paymentsDueAmount":351689.75,"paymentsDueCount":14,"flightsToday":0,'
        '"hotelCheckinsToday":0,"newLeadsToday":0,"revenueThisMonth":61800.75,'
        '"paymentDueSummary":{"totalOverdue":111689.75,"overdueCount":12}}';

    test('reads the bare object the server actually sends', () async {
      final summary = await _api(bare).getSummary();

      expect(summary.activeTrips, 2);
      expect(summary.paymentsDueAmount, 351689.75);
      expect(summary.paymentsDueCount, 14);
      expect(summary.revenueThisMonth, 61800.75);
      expect(summary.totalOverdue, 111689.75);
      expect(summary.overdueCount, 12);
    });

    test('still reads an enveloped object, should the server start wrapping it',
        () async {
      final summary = await _api('{"success":true,"data":$bare}').getSummary();

      expect(summary.activeTrips, 2);
      expect(summary.totalOverdue, 111689.75);
    });
  });

  group('CalendarApi.getEvents', () {
    test('reads the bare array the server actually sends', () async {
      // /api/calendar answers with a plain JSON array, NOT the ApiResponse
      // envelope. Assuming the wrapper made every calendar load fail with a
      // parse error, so this is the shape that must keep working.
      final api = _api(
        '[{"id":"TRIP:16ab5c17","source":"TRIP","category":"Confirmed Trips",'
        '"title":"Manali","subtitle":"Arjun Sharma",'
        '"start":"2026-08-02T00:00:00Z","allDay":true,'
        '"referenceType":"BOOKING","referencePublicId":"16ab5c17",'
        '"editable":false}]',
      );

      final event = (await api.getEvents()).single;
      expect(event.source, CalendarSource.trip);
      expect(event.title, 'Manali');
      expect(event.subtitle, 'Arjun Sharma');
      expect(event.allDay, isTrue);
      expect(event.referenceId, '16ab5c17');
    });

    test('converts UTC instants to local time', () async {
      // Calendar is the only module that sends true UTC instants; parsing them
      // as zone-less local time would shift every event.
      final api = _api(
        '{"success":true,"data":[{"id":"TASK:1","source":"TASK",'
        '"title":"Call Rahul","start":"2026-08-31T09:30:00Z",'
        '"allDay":false,"referenceType":"TASK","editable":true}]}',
      );

      final events = await api.getEvents();
      final event = events.single;

      expect(event.source, CalendarSource.task);
      expect(event.title, 'Call Rahul');
      expect(event.start!.isUtc, isFalse);
      expect(
        event.start,
        DateTime.utc(2026, 8, 31, 9, 30).toLocal(),
      );
    });

    test('tolerates an unknown source rather than dropping the row', () async {
      final api = _api(
        '{"success":true,"data":[{"id":"X:1","source":"SOMETHING_NEW",'
        '"title":"Future event"}]}',
      );

      final events = await api.getEvents();
      expect(events.single.source, isNull);
      expect(events.single.title, 'Future event');
    });
  });
}
