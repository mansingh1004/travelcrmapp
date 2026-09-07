import 'dart:typed_data';

import 'package:crmapp/features/reminders/api/reminder_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Captures the request Dio would send, and replays a canned response.
class _CapturingAdapter implements HttpClientAdapter {
  _CapturingAdapter(this.body);

  final String body;

  RequestOptions? captured;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured = options;
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

Dio _dio(_CapturingAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://x'))..httpClientAdapter = adapter;

/// One row, trimmed from a live `GET /api/reminders`.
const _row = '{"id":9,"title":"Follow-up: raju",'
    '"description":"Call back later","type":"Follow_up","priority":"Medium",'
    '"status":"OVERDUE","leadPublicId":"fe3f9e63-1de4-4792-a234-e5e45e9ffcd1",'
    '"assignToPublicId":"e1842c0d-43c8-4dd1-83f0-62cd45604c31",'
    '"assignToName":"Demo Admin","leadDisplayCode":null,"leadId":null,'
    '"leadName":"raju","phone":"12323222","assignTo":null,'
    '"dueDate":"2026-09-01T03:30:00Z","snoozedUntil":null,"notes":null,'
    '"createdAt":"2026-08-31T17:15:20.978041"}';

/// Reminders.
///
/// Every rule below was read off the running backend, not off the DTOs.
void main() {
  group('reading the list', () {
    test('parses the bare array this controller actually returns', () async {
      // `ResponseEntity<List<ReminderResponseDto>>` — no ApiResponse wrapper.
      // A live GET opens with `[`, not `{`, so looking for a `data` node here
      // would find nothing and the list would come back silently empty.
      final adapter = _CapturingAdapter('[$_row]');
      final list = await ReminderApi(_dio(adapter)).getReminders();

      expect(adapter.captured!.path, '/api/reminders');
      expect(list, hasLength(1));
      expect(list.single.id, 9);
      expect(list.single.title, 'Follow-up: raju');
      expect(list.single.leadName, 'raju');
    });

    test('still reads an envelope, in case these routes are ever aligned',
        () async {
      final adapter = _CapturingAdapter('{"success":true,"data":[$_row]}');
      final list = await ReminderApi(_dio(adapter)).getReminders();

      expect(list, hasLength(1));
      expect(list.single.id, 9);
    });

    test('a malformed row cannot blank the page', () async {
      final adapter = _CapturingAdapter('[$_row,"garbage",null]');
      final list = await ReminderApi(_dio(adapter)).getReminders();

      expect(list, hasLength(1), reason: 'the good row still comes through');
    });

    test('sends a filter only when one is set', () async {
      final adapter = _CapturingAdapter('[]');
      await ReminderApi(_dio(adapter)).getReminders(status: 'Active');

      final query = adapter.captured!.queryParameters;
      expect(query['status'], 'Active');
      expect(query.containsKey('priority'), isFalse);
      expect(query.containsKey('type'), isFalse);
    });

    test('overdue and due-today are separate endpoints, not local filters',
        () async {
      // `/due-today` measures the day in the TENANT's timezone and `/overdue`
      // treats `Active` and `OVERDUE` alike — neither rule can be reproduced
      // from a list the client already holds.
      final a = _CapturingAdapter('[]');
      await ReminderApi(_dio(a)).getOverdue();
      expect(a.captured!.path, '/api/reminders/overdue');

      final b = _CapturingAdapter('[]');
      await ReminderApi(_dio(b)).getDueToday();
      expect(b.captured!.path, '/api/reminders/due-today');
      expect(
        b.captured!.queryParameters,
        isEmpty,
        reason: 'the client must not send a date it computed itself',
      );
    });
  });

  group('timestamps', () {
    test('converts the Instant due date into local time', () async {
      // `dueDate` is a Java Instant — always UTC with a Z. A reminder set for
      // 09:00 IST comes back as 03:30Z; showing the parsed value unconverted
      // would move it hours earlier, and near midnight onto the wrong day.
      final adapter = _CapturingAdapter('[$_row]');
      final reminder = (await ReminderApi(_dio(adapter)).getReminders()).single;

      expect(reminder.dueDate!.isUtc, isFalse, reason: 'shown in local time');
      expect(
        reminder.dueDate!.toUtc(),
        DateTime.utc(2026, 9, 1, 3, 30),
        reason: 'the same instant, just displayed locally',
      );
    });

    test('leaves the zone-less createdAt alone', () async {
      // Jackson emits a LocalDateTime with no designator, so it is already
      // local — running .toLocal() on it would shift it a second time.
      final adapter = _CapturingAdapter('[$_row]');
      final reminder = (await ReminderApi(_dio(adapter)).getReminders()).single;

      // 978041 µs — Jackson writes microseconds, and Dart keeps them.
      expect(reminder.createdAt, DateTime(2026, 8, 31, 17, 15, 20, 978, 41));
      expect(reminder.createdAt!.isUtc, isFalse);
    });

    test('sends a moment back as a Z-suffixed UTC instant', () {
      final wire = toWireInstant(DateTime.utc(2026, 9, 10, 9, 30));

      expect(wire, '2026-09-10T09:30:00Z');
      expect(wire.endsWith('Z'), isTrue);
      expect(wire.contains('.'), isFalse, reason: 'no millisecond tail');
    });

    test('converts a local moment before sending it', () {
      // Sending the wall-clock reading with a Z on it would book an Indian
      // agency's reminder 5½ hours early.
      final local = DateTime(2026, 9, 10, 15);
      final wire = toWireInstant(local);

      expect(DateTime.parse(wire), local.toUtc());
    });
  });

  group('overdue', () {
    test('counts a scheduler-flipped OVERDUE row', () async {
      final adapter = _CapturingAdapter('[$_row]');
      final reminder = (await ReminderApi(_dio(adapter)).getReminders()).single;

      expect(reminder.isOverdue, isTrue);
      expect(reminder.isOpen, isTrue);
    });

    test('counts an Active row whose time has passed', () {
      // The scheduler flips the stored status on its own clock, so a reminder
      // that came due minutes ago is still `Active`. `OVERDUE_STATUSES` on the
      // server holds both for exactly this reason.
      final reminder = Reminder(
        id: 1,
        title: 'x',
        status: 'Active',
        dueDate: DateTime.now().subtract(const Duration(hours: 2)),
      );

      expect(reminder.isOverdue, isTrue);
    });

    test('never counts one that is already finished', () {
      for (final status in ['Completed', 'Dismissed']) {
        final reminder = Reminder(
          id: 1,
          title: 'x',
          status: status,
          dueDate: DateTime.now().subtract(const Duration(days: 5)),
        );

        expect(reminder.isOverdue, isFalse, reason: '$status is not overdue');
        expect(reminder.isOpen, isFalse);
      }
    });
  });

  group('writing', () {
    test('creates with only what the endpoint validates', () async {
      // `title` is @NotBlank and `dueDate` @NotNull; nothing else is required.
      final adapter = _CapturingAdapter(_row);
      await ReminderApi(_dio(adapter)).createReminder(
        title: '  Call Rahul  ',
        dueDate: DateTime.utc(2026, 9, 10, 9, 30),
        description: '   ',
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.method, 'POST');
      expect(body['title'], 'Call Rahul');
      expect(body['dueDate'], '2026-09-10T09:30:00Z');
      expect(
        body.containsKey('description'),
        isFalse,
        reason: 'a whitespace-only field is omitted, not sent blank',
      );
      expect(
        body.containsKey('status'),
        isFalse,
        reason: 'the server sets Active itself — guessing at it would be wrong',
      );
    });

    test('snoozes to a given moment without touching the due date', () async {
      // Snooze sets status + snoozedUntil only; `dueDate` stays put, so the
      // original commitment survives on the record.
      final adapter = _CapturingAdapter(_row);
      await ReminderApi(_dio(adapter)).snooze(9, DateTime.utc(2026, 9, 12, 5));

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.method, 'PATCH');
      expect(adapter.captured!.path, '/api/reminders/9/snooze');
      expect(body, {'snoozedUntil': '2026-09-12T05:00:00Z'});
    });

    test('completes and dismisses over PATCH with no body', () async {
      final a = _CapturingAdapter(_row);
      await ReminderApi(_dio(a)).markComplete(9);
      expect(a.captured!.method, 'PATCH');
      expect(a.captured!.path, '/api/reminders/9/complete');

      final b = _CapturingAdapter(_row);
      await ReminderApi(_dio(b)).dismiss(9);
      expect(b.captured!.method, 'PATCH');
      expect(b.captured!.path, '/api/reminders/9/dismiss');
    });

    test('reads the updated row back off a bare write response', () async {
      final adapter = _CapturingAdapter(
        '{"id":17,"title":"probe","status":"Completed","type":"Payment"}',
      );
      final updated = await ReminderApi(_dio(adapter)).markComplete(17);

      expect(updated.status, 'Completed');
      expect(updated.isOpen, isFalse);
    });
  });

  group('the enum vocabularies', () {
    test('carry the wire spelling exactly, mixed case and all', () {
      // `parseStatus` is `ReminderStatus.valueOf(value.trim())` — case
      // sensitive — and it swallows the failure, so a wrong case does not
      // error, it silently drops the filter. Live, on the same ten rows:
      // ?status=ACTIVE → 10 rows (no filter), ?status=Active → 0 rows (real).
      // These constants are the only safe values to pass.
      expect(ReminderApi.statuses, contains('Active'));
      expect(ReminderApi.statuses, contains('OVERDUE'));
      expect(
        ReminderApi.statuses,
        isNot(contains('ACTIVE')),
        reason: 'only OVERDUE is screaming-case in this enum',
      );
      expect(ReminderApi.types, contains('Follow_up'));
      expect(ReminderApi.priorities, ['High', 'Medium', 'Low']);
    });

    test('renders a wire type as a label without sending it back', () {
      const reminder = Reminder(id: 1, title: 'x', type: 'First_contact');

      expect(reminder.typeLabel, 'First contact');
      expect(reminder.type, 'First_contact', reason: 'the wire value is intact');
    });
  });
}
