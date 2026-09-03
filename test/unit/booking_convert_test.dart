import 'dart:typed_data';

import 'package:crmapp/data/services/booking_api.dart';
import 'package:crmapp/features/bookings/presentation/booking_convert_screen.dart';
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

/// Turning a lead into a booking.
///
/// The shapes below are trimmed from live responses, and the rules they guard
/// were all learned from the running backend rather than from the DTOs.
void main() {
  group('conversion request', () {
    test('goes to the lead-centric route and carries the idempotency key',
        () async {
      // Without the header the server answers 400 outright:
      // "Idempotency-Key header is required when converting a lead to a
      // booking." With it, a repeat of the same request replays the booking
      // that already exists instead of making a second one — verified live.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"publicId":"b1","bookingCode":"BKG-26-0016",'
        '"status":"PENDING","paidAmount":10000}}',
      );
      final booking = await BookingApi(_dio(adapter)).convertLeadToBooking(
        leadPublicId: 'lead-1',
        idempotencyKey: 'key-1',
        body: const {'customerName': 'rahul'},
      );

      expect(adapter.captured!.method, 'POST');
      expect(adapter.captured!.path, '/api/leads/lead-1/convert-to-booking');
      expect(adapter.captured!.headers['Idempotency-Key'], 'key-1');
      expect(booking.publicId, 'b1');
    });

    test('parses a reply carrying the trip snapshot the conversion builds',
        () async {
      // `tripSnapshot` is a **TripSnapshotResponse object**, not a string, and
      // conversion is the path that fills it — `attachTripSnapshot(
      // buildTripSnapshotFromLead(lead))`. Reading it into a `String?` threw a
      // TypeError after the booking had already been created, which showed up
      // as a spinner that never stopped.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"publicId":"b1","bookingCode":"BKG-26-0016",'
        '"status":"PENDING","tripSnapshot":{"packageType":"Family",'
        '"itinerary":[{"destination":"mumbai","city":"gateway","nights":2},'
        '{"destination":"mumbai","city":"Juhu","nights":2}]}}}',
      );

      final booking = await BookingApi(_dio(adapter)).convertLeadToBooking(
        leadPublicId: 'lead-1',
        idempotencyKey: 'key-1',
        body: const {'customerName': 'rahul'},
      );

      expect(booking.publicId, 'b1');
      expect(
        booking.tripSnapshot,
        'gateway → Juhu',
        reason: 'the legs become the one line the booking screen shows',
      );
    });

    test('still accepts a plain string trip snapshot', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"publicId":"b1","tripSnapshot":"Goa, 3N"}}',
      );
      final booking = await BookingApi(_dio(adapter)).convertLeadToBooking(
        leadPublicId: 'lead-1',
        idempotencyKey: 'key-1',
        body: const {},
      );

      expect(booking.tripSnapshot, 'Goa, 3N');
    });

    test('sends only what the endpoint validates, plus the quotation', () {
      final body = buildConversionBody(
        customerName: '  rahul  ',
        destination: '  mumbai  ',
        travelDate: DateTime(2026, 10, 1),
        quotationId: 'q1',
        customerAmount: 50000,
        paidAmount: 10000,
      );

      expect(body['customerName'], 'rahul');
      expect(body['destination'], 'mumbai');
      expect(body['travelDate'], '2026-10-01');
      expect(body['quotationPublicId'], 'q1');
      expect(body['customerAmount'], 50000);
      expect(body['paidAmount'], 10000);
    });

    test('never sends the phone or email', () {
      // The customer is resolved from the **lead's** phone, which is the
      // per-tenant natural key. Sending a different one risks a second
      // customer row for the same person.
      final body = buildConversionBody(
        customerName: 'rahul',
        destination: 'mumbai',
        travelDate: DateTime(2026, 10, 1),
      );

      expect(body.containsKey('customerPhone'), isFalse);
      expect(body.containsKey('customerEmail'), isFalse);
    });

    test('omits a tax flag left on Default, and sends one that was changed', () {
      // Null means "inherit the tenant's accounting settings" to
      // `BookingTaxCalculator`. Sending `false` instead would switch the tax
      // off for a tenant who has it on centrally — the backend's own reason for
      // making these `Boolean` rather than `boolean`.
      final untouched = buildConversionBody(
        customerName: 'rahul',
        destination: 'mumbai',
        travelDate: DateTime(2026, 10, 1),
      );
      expect(untouched.containsKey('applyGst'), isFalse);
      expect(untouched.containsKey('gstInclusive'), isFalse);
      expect(untouched.containsKey('applyTcs'), isFalse);

      final overridden = buildConversionBody(
        customerName: 'rahul',
        destination: 'mumbai',
        travelDate: DateTime(2026, 10, 1),
        applyGst: false,
        applyTcs: true,
      );
      expect(overridden['applyGst'], isFalse, reason: 'off, not inherited');
      expect(overridden['applyTcs'], isTrue);
      expect(overridden.containsKey('gstInclusive'), isFalse);
    });

    test('omits money that was left blank', () {
      // `customerAmount` is optional on purpose: the backend notes that "a
      // booking is routinely taken before the money is settled".
      final body = buildConversionBody(
        customerName: 'rahul',
        destination: 'mumbai',
        travelDate: DateTime(2026, 10, 1),
      );

      expect(body.keys.toList(), ['customerName', 'destination', 'travelDate']);
    });
  });

  group('financial preview', () {
    test('reads the tax the server worked out, and computes none of it',
        () async {
      // Live: 50,000 → GST 2,500 + TCS 2,500 → 55,000 payable, 45,000 pending
      // after 10,000 paid. The rates come from the tenant's accounting
      // settings, which this app never sees.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"customerAmount":50000.00,"gst":2500.00,'
        '"tcs":2500.00,"totalPayable":55000.00,"pendingAmount":45000.00,'
        '"paymentStatus":"PARTIAL"}}',
      );
      final financials = await BookingApi(_dio(adapter)).previewFinancials(
        customerAmount: 50000,
        paidAmount: 10000,
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.path, '/api/bookings/preview');
      expect(body['customerAmount'], 50000);
      expect(body['paidAmount'], 10000);
      expect(
        body.containsKey('applyGst'),
        isFalse,
        reason: 'an untouched toggle is omitted, not guessed at',
      );

      expect(financials.gst, 2500.00);
      expect(financials.tcs, 2500.00);
      expect(financials.totalPayable, 55000.00);
      expect(financials.pendingAmount, 45000.00);
      expect(financials.paymentStatus, 'PARTIAL');
    });

    test('reads the derived base back under inclusive pricing', () async {
      // Live, with `gstInclusive: true` on ₹50,000: the server treats it as the
      // gross and derives ₹47,619.05 out of it. Showing the typed number as the
      // taxable value would disagree with the row the booking actually stores.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"customerAmount":47619.05,"gst":2380.95,'
        '"tcs":2380.95,"totalPayable":52380.95}}',
      );
      final financials = await BookingApi(_dio(adapter)).previewFinancials(
        customerAmount: 50000,
        gstInclusive: true,
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(body['gstInclusive'], isTrue);
      expect(
        financials.customerAmount,
        47619.05,
        reason: 'the base is the server\'s, not the number that was typed',
      );
    });
  });
}
