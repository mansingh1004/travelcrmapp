import 'dart:typed_data';

import 'package:crmapp/features/reminders/api/booking_reminder_api.dart';
import 'package:crmapp/features/reminders/api/reminder_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

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

/// One row, trimmed from a live `GET /api/booking-reminders`.
const _row = '{"id":5,"bookingCode":"BK10005",'
    '"customerName":"Vikram Singh","phone":"+91 98765 10004",'
    '"destination":"Destination 5","reminderType":"Travel_date",'
    '"message":"Auto-seeded booking reminder",'
    '"travelDate":"2026-08-31T06:54:09.281838Z",'
    '"reminderDate":"2026-08-12T06:54:09.281838Z","status":"Completed",'
    '"amount":90000.0,"createdAt":"2026-08-07T12:24:09.282866"}';

/// Booking reminders — the second, separate reminder module.
void main() {
  group('reading', () {
    test('parses the bare array, like the other reminder module', () async {
      final adapter = _CapturingAdapter('[$_row]');
      final list = await BookingReminderApi(_dio(adapter)).getAll();

      expect(adapter.captured!.path, '/api/booking-reminders');
      expect(list, hasLength(1));
      expect(list.single.id, 5);
      expect(list.single.bookingCode, 'BK10005');
      expect(list.single.customerName, 'Vikram Singh');
      expect(list.single.amount, 90000.0);
    });

    test('reads the stats object', () async {
      // Live shape on the seeded tenant.
      final adapter = _CapturingAdapter(
        '{"total":5,"pending":0,"sent":0,"completed":5}',
      );
      final stats = await BookingReminderApi(_dio(adapter)).getStats();

      expect(stats.total, 5);
      expect(stats.completed, 5);
      expect(stats.pending, 0);
    });

    test('asks for a booking by its human code, not an id', () async {
      // `GET /booking/{bookingCode}` — `BK10005`, not a UUID and not the
      // numeric row id. The one place in this module keyed on the code.
      final adapter = _CapturingAdapter('[$_row]');
      await BookingReminderApi(_dio(adapter)).getForBooking('BK10005');

      expect(adapter.captured!.path, '/api/booking-reminders/booking/BK10005');
    });

    test('upcoming is keyed on the travel date, and defaults to a week',
        () async {
      // Worth pinning: the repository call is `…TravelDateBetween(now, now +
      // days)`, so "upcoming" is trips departing soon — NOT reminders about to
      // fire. Treating it as the latter would quietly show the wrong list.
      final adapter = _CapturingAdapter('[]');
      await BookingReminderApi(_dio(adapter)).getUpcoming();

      expect(adapter.captured!.path, '/api/booking-reminders/upcoming');
      expect(adapter.captured!.queryParameters['days'], 7);
    });

    test('converts the Instants and leaves createdAt alone', () async {
      final adapter = _CapturingAdapter('[$_row]');
      final row = (await BookingReminderApi(_dio(adapter)).getAll()).single;

      expect(row.reminderDate!.isUtc, isFalse);
      expect(
        row.reminderDate!.toUtc().toIso8601String(),
        startsWith('2026-08-12T06:54:09'),
      );
      expect(row.createdAt!.isUtc, isFalse);
      expect(row.createdAt!.hour, 12, reason: 'no second conversion applied');
    });
  });

  group('the vocabularies are its own', () {
    test('use Payment_due, not the lead module\'s Payment', () {
      // The two modules are separate tables with separate enums, and an
      // unrecognised filter is DROPPED rather than rejected — so borrowing a
      // constant from the other module returns an unfiltered list that looks
      // like it worked.
      expect(BookingReminderApi.types, contains('Payment_due'));
      expect(BookingReminderApi.types, isNot(contains('Payment')));
      expect(BookingReminderApi.types, isNot(contains('Follow_up')));
      expect(ReminderApi.types, contains('Payment'));
      expect(ReminderApi.types, isNot(contains('Payment_due')));
    });

    test('have three statuses and no OVERDUE among them', () {
      expect(BookingReminderApi.statuses, ['Pending', 'Sent', 'Completed']);
      expect(BookingReminderApi.statuses, isNot(contains('OVERDUE')));
      expect(ReminderApi.statuses, contains('OVERDUE'));
    });

    test('prettify a type without changing the wire value', () {
      const row = BookingReminder(id: 1, reminderType: 'Final_payment');

      expect(row.typeLabel, 'Final payment');
      expect(row.reminderType, 'Final_payment');
    });
  });

  group('open and overdue', () {
    test('a completed reminder is neither open nor overdue', () {
      final row = BookingReminder(
        id: 1,
        status: 'Completed',
        reminderDate: DateTime.now().subtract(const Duration(days: 30)),
      );

      expect(row.isOpen, isFalse);
      expect(row.isOverdue, isFalse);
    });

    test('a pending reminder past its date is overdue', () {
      final row = BookingReminder(
        id: 1,
        status: 'Pending',
        reminderDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(row.isOpen, isTrue);
      expect(row.isOverdue, isTrue);
    });

    test('a Sent reminder is still open — sending is not settling', () {
      final row = BookingReminder(
        id: 1,
        status: 'Sent',
        reminderDate: DateTime.now().add(const Duration(days: 1)),
      );

      expect(row.isOpen, isTrue);
      expect(row.isOverdue, isFalse);
    });
  });

  group('writing', () {
    test('quick-creates a payment reminder against the booking publicId',
        () async {
      // The only create this app offers, and the only route in the module
      // that names a permission (REMINDER_CREATE). It takes the booking by
      // UUID here, unlike the reads, which use the booking code.
      final adapter = _CapturingAdapter(_row);
      await BookingReminderApi(_dio(adapter)).createPaymentReminder(
        bookingPublicId: 'd5c1a138-de69-45a5-b17a-f5d280ade02b',
        reminderDate: DateTime.utc(2026, 9, 20, 10),
        amount: 25000,
        message: '  Balance due before departure  ',
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.method, 'POST');
      expect(
        adapter.captured!.path,
        '/api/booking-reminders/quick-create/payment',
      );
      expect(body['bookingPublicId'], 'd5c1a138-de69-45a5-b17a-f5d280ade02b');
      expect(body['reminderDate'], '2026-09-20T10:00:00Z');
      expect(body['amount'], 25000);
      expect(body['message'], 'Balance due before departure');
    });

    test('omits a blank message rather than sending an empty one', () async {
      final adapter = _CapturingAdapter(_row);
      await BookingReminderApi(_dio(adapter)).createPaymentReminder(
        bookingPublicId: 'b1',
        reminderDate: DateTime.utc(2026, 9, 20, 10),
        amount: 25000,
        message: '   ',
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(body.containsKey('message'), isFalse);
    });

    test('completes and reopens over PATCH', () async {
      final a = _CapturingAdapter(_row);
      await BookingReminderApi(_dio(a)).markComplete(5);
      expect(a.captured!.method, 'PATCH');
      expect(a.captured!.path, '/api/booking-reminders/5/complete');

      // No equivalent on the lead side: there, completed is final.
      final b = _CapturingAdapter(_row);
      await BookingReminderApi(_dio(b)).markPending(5);
      expect(b.captured!.method, 'PATCH');
      expect(b.captured!.path, '/api/booking-reminders/5/pending');
    });
  });
}
