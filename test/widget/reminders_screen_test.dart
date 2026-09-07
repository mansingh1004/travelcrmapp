import 'dart:async';
import 'dart:typed_data';

import 'package:crmapp/core/di.dart';
import 'package:crmapp/core/formatters/app_date.dart';
import 'package:crmapp/core/theme/app_theme.dart';
import 'package:crmapp/features/reminders/api/booking_reminder_api.dart';
import 'package:crmapp/features/reminders/api/reminder_api.dart';
import 'package:crmapp/features/reminders/presentation/reminders_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Replays a canned body per path, and can hang to pin the loading state.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.bodies, {this.hang = false});

  /// Path suffix → response body.
  final Map<String, String> bodies;
  final bool hang;
  final requested = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requested.add(options.path);
    if (hang) return Completer<ResponseBody>().future;
    final body = bodies[options.path] ?? '[]';
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// An overdue follow-up, as the live server sends it.
String _row({
  int id = 9,
  String title = 'Follow-up: raju',
  String status = 'OVERDUE',
  String priority = 'High',
  String due = '2026-09-01T03:30:00Z',
}) =>
    '{"id":$id,"title":"$title","type":"Follow_up","priority":"$priority",'
    '"status":"$status","leadPublicId":"fe3f9e63-1de4-4792-a234-e5e45e9ffcd1",'
    '"leadName":"raju","phone":"12323222","dueDate":"$due"}';

/// A booking-side row — note `Payment_due`, which the lead module has no
/// equivalent of, and `Completed`, which here can still be reopened.
String _bookingRowWith({String status = 'Completed'}) =>
    '{"id":5,"bookingCode":"BK10005","customerName":"Vikram Singh",'
    '"phone":"+91 98765 10004","destination":"Goa",'
    '"reminderType":"Payment_due","message":"Balance due",'
    '"travelDate":"2026-08-31T06:54:09Z",'
    '"reminderDate":"2026-08-12T06:54:09Z","status":"$status",'
    '"amount":90000.0,"createdAt":"2026-08-07T12:24:09.282866"}';

final _bookingRow = _bookingRowWith();

Widget _app(_Adapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'http://x'))..httpClientAdapter = adapter;

  return ProviderScope(
    overrides: [
      reminderApiProvider.overrideWithValue(ReminderApi(dio)),
      // Both modules go through the same fake transport, so a request either
      // one makes shows up in `adapter.requested` and neither reaches a socket.
      bookingReminderApiProvider.overrideWithValue(BookingReminderApi(dio)),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const RemindersScreen(),
    ),
  );
}

void main() {
  testWidgets('opens on Overdue and asks the overdue endpoint for it',
      (tester) async {
    // The tab is not a local filter: `/overdue` applies a rule — Active *and*
    // scheduler-flipped OVERDUE, measured against server time — that the
    // client cannot reproduce from a list it already holds.
    final adapter = _Adapter({'/api/reminders/overdue': '[${_row()}]'});
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(adapter.requested, ['/api/reminders/overdue']);
    expect(find.text('Follow-up: raju'), findsOneWidget);
    expect(find.text('Follow up · raju'), findsOneWidget);
  });

  testWidgets('each tab calls its own endpoint', (tester) async {
    final adapter = _Adapter({
      '/api/reminders/overdue': '[${_row()}]',
      '/api/reminders/due-today': '[${_row(id: 11, title: 'Collect balance')}]',
      '/api/reminders': '[${_row()},${_row(id: 11, title: 'Collect balance')}]',
    });
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();
    expect(find.text('Collect balance'), findsOneWidget);

    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(find.text('Follow-up: raju'), findsOneWidget);
    expect(find.text('Collect balance'), findsOneWidget);

    expect(adapter.requested, [
      '/api/reminders/overdue',
      '/api/reminders/due-today',
      '/api/reminders',
    ]);
  });

  testWidgets('loading state raises no layout exception', (tester) async {
    await tester.pumpWidget(_app(_Adapter(const {}, hang: true)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(tester.takeException(), isNull);
  });

  testWidgets('an empty tab says so in its own words', (tester) async {
    await tester.pumpWidget(_app(_Adapter(const {})));
    await tester.pumpAndSettle();

    expect(find.text('Nothing overdue'), findsOneWidget);

    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing due today'), findsOneWidget);
  });

  testWidgets('tapping a reminder offers the three actions', (tester) async {
    // Delete is deliberately not among them: TRAVEL_AGENT holds every
    // REMINDER_* permission except _DELETE, so the button would 403 for the
    // role that lives in this app.
    final adapter = _Adapter({'/api/reminders/overdue': '[${_row()}]'});
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Follow-up: raju'));
    await tester.pumpAndSettle();

    expect(find.text('Mark complete'), findsOneWidget);
    expect(find.text('Snooze'), findsOneWidget);
    expect(find.text('Dismiss'), findsOneWidget);
    expect(find.text('Call raju'), findsOneWidget);
    expect(find.textContaining('Delete'), findsNothing);
  });

  testWidgets('a finished reminder offers no actions at all', (tester) async {
    final adapter = _Adapter({
      '/api/reminders/overdue': '[${_row(status: 'Completed')}]',
    });
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Follow-up: raju'));
    await tester.pumpAndSettle();

    expect(find.text('Mark complete'), findsNothing);
    expect(find.textContaining('already completed'), findsOneWidget);
  });

  testWidgets('the Bookings tab reads the other module entirely',
      (tester) async {
    // A different backend module behind the same tab bar: separate table,
    // separate endpoints, separate vocabularies. The tab must not be served
    // from a filter on the lead-side list.
    final adapter = _Adapter({
      '/api/reminders/overdue': '[${_row()}]',
      '/api/booking-reminders': '[$_bookingRow]',
    });
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bookings'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(adapter.requested, [
      '/api/reminders/overdue',
      '/api/booking-reminders',
    ]);
    expect(find.text('Vikram Singh'), findsOneWidget);
    expect(find.textContaining('Payment due'), findsOneWidget);
    expect(find.textContaining('BK10005'), findsOneWidget);
  });

  testWidgets('Add is hidden on the Bookings tab', (tester) async {
    // Creating one needs a booking to hang it on, and that flow starts from
    // the booking — an Add here would open a form with nothing to attach to.
    final adapter = _Adapter({
      '/api/reminders/overdue': '[${_row()}]',
      '/api/booking-reminders': '[$_bookingRow]',
    });
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();
    expect(find.text('Add'), findsOneWidget);

    await tester.tap(find.text('Bookings'));
    await tester.pumpAndSettle();
    expect(find.text('Add'), findsNothing);
  });

  testWidgets('a booking reminder offers complete, but never send-now',
      (tester) async {
    // `POST /{id}/send-now` answers 422 "WhatsApp is not configured" until the
    // tenant's provider is set up server-side, so the button would only ever
    // fail. Calling the customer works today and is offered instead.
    final adapter = _Adapter({
      '/api/reminders/overdue': '[${_row()}]',
      '/api/booking-reminders': '[${_bookingRowWith(status: 'Pending')}]',
    });
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bookings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Vikram Singh'));
    await tester.pumpAndSettle();

    expect(find.text('Mark complete'), findsOneWidget);
    expect(find.text('Call Vikram Singh'), findsOneWidget);
    expect(find.textContaining('Send'), findsNothing);
    expect(
      find.text('Snooze'),
      findsNothing,
      reason: 'the date belongs to the trip, so it is not the agent\'s to move',
    );
  });

  testWidgets('a completed booking reminder can be reopened', (tester) async {
    // No equivalent on the lead side, where completed is final.
    final adapter = _Adapter({
      '/api/reminders/overdue': '[${_row()}]',
      '/api/booking-reminders': '[$_bookingRow]',
    });
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bookings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Vikram Singh'));
    await tester.pumpAndSettle();

    expect(find.text('Reopen'), findsOneWidget);
    expect(find.text('Mark complete'), findsNothing);
  });

  group('the due line', () {
    test('names how late a reminder is, without repeating the date', () {
      // `AppDate.relative` falls back to the formatted date once something is
      // older than yesterday, so the first cut of this printed
      // "01 Sep 2026, 9:00 AM · 01 Sep 2026" — the same date twice, on exactly
      // the rows this screen exists to show. Seen on the emulator against live
      // data before it was changed.
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      final label = dueLabel(threeDaysAgo, overdue: true);

      expect(label, endsWith(' · 3 days late'));
      final date = AppDate.display(threeDaysAgo);
      expect(
        date.allMatches(label).length,
        1,
        reason: 'the date appears once, not twice',
      );
    });

    test('says Yesterday rather than "1 days late"', () {
      final label = dueLabel(
        DateTime.now().subtract(const Duration(days: 1)),
        overdue: true,
      );

      expect(label, endsWith(' · Yesterday'));
    });

    test('adds nothing at all when the reminder is not late', () {
      final soon = DateTime.now().add(const Duration(days: 2));

      expect(dueLabel(soon, overdue: false), AppDate.dateTime(soon));
    });
  });

  testWidgets('snoozing offers moments, not a date picker', (tester) async {
    // Snoozing is a one-handed action taken between calls; a full
    // date-and-time picker is the wrong instrument for it.
    final adapter = _Adapter({'/api/reminders/overdue': '[${_row()}]'});
    await tester.pumpWidget(_app(adapter));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Follow-up: raju'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Snooze'));
    await tester.pumpAndSettle();

    expect(find.text('Snooze until'), findsOneWidget);
    expect(find.text('In 1 hour'), findsOneWidget);
    expect(find.text('Tomorrow, 9:00 AM'), findsOneWidget);
    expect(find.byType(CalendarDatePicker), findsNothing);
  });
}
