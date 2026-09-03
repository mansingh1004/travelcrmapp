import 'dart:typed_data';

import 'package:crmapp/data/services/booking_api.dart';
import 'package:crmapp/features/bookings/presentation/widgets/booking_edit_sheet.dart';
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

/// Editing, cancelling and deleting a booking — three different operations that
/// the backend keeps deliberately apart.
void main() {
  group('edit', () {
    test('sends only the fields that changed', () {
      // On `UpdateBookingRequestDTO` every field is optional and null means
      // "leave it alone" — which is why the DTO carries `clearVendor`,
      // `clearTaxOverrides` and `clearCommission` for the other meaning.
      final body = buildBookingUpdate(
        travelDate: DateTime(2026, 11, 15),
        originalTravelDate: DateTime(2026, 10, 1),
        customerAmount: 24690,
        originalCustomerAmount: 20000,
        paidAmount: 5000,
        originalPaidAmount: 5000,
      );

      expect(body['travelDate'], '2026-11-15');
      expect(body['customerAmount'], 24690);
      expect(
        body.containsKey('paidAmount'),
        isFalse,
        reason: 'unchanged, so it is not sent',
      );
    });

    test('an untouched form sends nothing at all', () {
      final body = buildBookingUpdate(
        travelDate: DateTime(2026, 10, 1),
        originalTravelDate: DateTime(2026, 10, 1),
        customerAmount: 20000,
        originalCustomerAmount: 20000,
      );

      expect(body, isEmpty);
    });

    test('PUTs to the booking and reads the recomputed totals back', () async {
      // Live: changing the amount to 24,690 came back with totalPayable 27,159
      // — the server re-ran the tax. The client never touches those figures.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"publicId":"b1","customerAmount":24690.00,'
        '"totalPayable":27159.00,"travelDate":"2026-11-15"}}',
      );
      final booking = await BookingApi(_dio(adapter))
          .updateBooking('b1', const {'customerAmount': 24690});

      expect(adapter.captured!.method, 'PUT');
      expect(adapter.captured!.path, '/api/bookings/b1');
      expect(booking.totalPayable, 27159.00);
    });
  });

  group('cancel', () {
    test('always names what happens to the lead', () async {
      // `action` is the request's only @NotNull, and for good reason: the
      // booking row survives either way, but the lead is either reopened or
      // sent to Trash with its quotations.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"publicId":"b1","status":"CANCELLED"}}',
      );
      final booking = await BookingApi(_dio(adapter)).cancelBooking(
        'b1',
        action: 'MOVE_TO_LEAD',
        reason: 'customer changed plans',
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.path, '/api/bookings/b1/cancel');
      expect(body['action'], 'MOVE_TO_LEAD');
      expect(body['reason'], 'customer changed plans');
      expect(booking.status, 'CANCELLED');
    });

    test('omits a blank reason rather than sending an empty string', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"publicId":"b1","status":"CANCELLED"}}',
      );
      await BookingApi(_dio(adapter))
          .cancelBooking('b1', action: 'MOVE_TO_LEAD', reason: '   ');

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(body.containsKey('reason'), isFalse);
    });
  });

  group('delete', () {
    test('is a plain DELETE on the booking', () async {
      // Soft on the server, and refused outright on a CONFIRMED or COMPLETED
      // booking — "Cannot delete a CONFIRMED booking. Cancel it first." The
      // menu therefore hides it rather than letting the agent hit that.
      final adapter = _CapturingAdapter('{"success":true}');
      await BookingApi(_dio(adapter)).deleteBooking('b1');

      expect(adapter.captured!.method, 'DELETE');
      expect(adapter.captured!.path, '/api/bookings/b1');
    });
  });
}
