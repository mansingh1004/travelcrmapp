import 'package:dio/dio.dart';

import '../dto/booking_dto.dart';
import '../dto/envelopes.dart';
import '../remote/failure_mapper.dart';

/// `BookingController` — `/api/bookings`.
class BookingApi {
  const BookingApi(this._dio);

  final Dio _dio;

  /// `GET /api/bookings` — paged. This endpoint takes **no filter params**;
  /// filtering lives on `/api/bookings/filter`, which is unpaged, so the two
  /// cannot be combined. The app pages the plain list and applies its status
  /// tab through [filterBookings] when a facet is set.
  Future<PageEnvelope<BookingDto>> getBookings({
    int page = 0,
    int size = 20,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/bookings',
        queryParameters: {
          'page': page,
          'size': size,
          'sortBy': sortBy,
          'sortDir': sortDir,
        },
      );
      return PageEnvelope.from<BookingDto>(response.data, BookingDto.fromJson);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/bookings/filter` — **unpaged**; the server returns every match.
  Future<List<BookingDto>> filterBookings({
    String? status,
    String? paymentStatus,
    DateTime? fromDate,
    DateTime? toDate,
    num? minAmount,
    num? maxAmount,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/bookings/filter',
        queryParameters: <String, dynamic>{
          'status': ?status,
          'paymentStatus': ?paymentStatus,
          if (fromDate != null) 'fromDate': _date(fromDate),
          if (toDate != null) 'toDate': _date(toDate),
          'minAmount': ?minAmount,
          'maxAmount': ?maxAmount,
        },
      );
      return _listOf(response.data);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/bookings/search?query=` — unpaged.
  Future<List<BookingDto>> searchBookings(String query) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/bookings/search',
        queryParameters: {'query': query.trim()},
      );
      return _listOf(response.data);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/bookings/{publicId}`.
  Future<BookingDto> getBooking(String publicId) async {
    try {
      final response = await _dio.get<dynamic>('/api/bookings/$publicId');
      final envelope = ApiEnvelope.from<BookingDto>(
        response.data,
        (data) => BookingDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/bookings/{publicId}/services` — the service rows whose
  /// confirmation state drives ops readiness.
  Future<List<BookingServiceDto>> getServices(String publicId) async {
    try {
      final response = await _dio.get<dynamic>('/api/bookings/$publicId/services');
      final envelope = ApiEnvelope.from<List<BookingServiceDto>>(
        response.data,
        (data) => (data! as List)
            .whereType<Map<String, dynamic>>()
            .map(BookingServiceDto.fromJson)
            .toList(growable: false),
      );
      return envelope.data ?? const [];
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `PATCH /api/bookings/{publicId}/status`.
  Future<BookingDto> changeStatus(String publicId, String statusWire) async {
    try {
      final response = await _dio.patch<dynamic>(
        '/api/bookings/$publicId/status',
        data: {'status': statusWire},
      );
      final envelope = ApiEnvelope.from<BookingDto>(
        response.data,
        (data) => BookingDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/bookings/stats` — CRM_FULL only.
  Future<BookingStatsDto> getStats() async {
    try {
      final response = await _dio.get<dynamic>('/api/bookings/stats');
      final envelope = ApiEnvelope.from<BookingStatsDto>(
        response.data,
        (data) => BookingStatsDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// Both `ApiResponse<List<T>>` and a bare array are accepted, because the
  /// unpaged endpoints in this controller are not consistent about the wrapper.
  static List<BookingDto> _listOf(Object? body) {
    if (body is List) {
      return body
          .whereType<Map<String, dynamic>>()
          .map(BookingDto.fromJson)
          .toList(growable: false);
    }
    final envelope = ApiEnvelope.from<List<BookingDto>>(
      body,
      (data) => (data! as List)
          .whereType<Map<String, dynamic>>()
          .map(BookingDto.fromJson)
          .toList(growable: false),
    );
    return envelope.data ?? const [];
  }

  // ── Lead → booking ─────────────────────────────────────────────────────
  //
  // A booking is made from its lead, not from a quotation: the backend's own
  // note says "Lead → Booking conversion lives on the lead-centric path". The
  // quotation rides along as `quotationPublicId`, which links it and pins the
  // cancellation policy the customer was quoted under.

  /// `POST /api/leads/{leadPublicId}/convert-to-booking`.
  ///
  /// The `Idempotency-Key` header is **required** — without it the server
  /// answers 400 — and it is what makes a double tap safe: the same key with
  /// the same body replays the booking already created instead of making a
  /// second one.
  ///
  /// Refusals worth expecting: 409 when the lead already has an active booking
  /// (the message names it), and 400 when the lead has no phone — the customer
  /// is resolved by phone, so there is nothing to match on.
  Future<BookingDto> convertLeadToBooking({
    required String leadPublicId,
    required String idempotencyKey,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/leads/$leadPublicId/convert-to-booking',
        data: body,
        options: Options(headers: {'Idempotency-Key': idempotencyKey}),
      );
      final envelope = ApiEnvelope.from<BookingDto>(
        response.data,
        (data) => BookingDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/bookings/preview` — the money a create would stamp.
  ///
  /// GST, TCS, the total and the net profit are the server's, computed under
  /// this tenant's accounting settings. The controller says why in as many
  /// words: it exists "so the browser never computes tax itself". Nothing here
  /// derives tax; the screen only displays what comes back.
  Future<BookingFinancials> previewFinancials({
    required double customerAmount,
    double? vendorCost,
    double? paidAmount,
    bool? applyGst,
    bool? gstInclusive,
    bool? applyTcs,
    bool? overseasTourPackage,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/bookings/preview',
        data: <String, dynamic>{
          'customerAmount': customerAmount,
          'vendorCost': ?vendorCost,
          'paidAmount': ?paidAmount,
          'applyGst': ?applyGst,
          'gstInclusive': ?gstInclusive,
          'applyTcs': ?applyTcs,
          'overseasTourPackage': ?overseasTourPackage,
        },
      );
      final envelope = ApiEnvelope.from<BookingFinancials>(
        response.data,
        (data) => BookingFinancials.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}

/// What `POST /api/bookings/preview` says a booking would cost.
///
/// Every figure here is the server's. None of it is recomputed on the device —
/// GST and TCS depend on the tenant's accounting settings, which this app does
/// not hold and must never guess at.
class BookingFinancials {
  const BookingFinancials({
    this.customerAmount,
    this.gst,
    this.tcs,
    this.totalPayable,
    this.commissionAmount,
    this.netProfit,
    this.pendingAmount,
    this.paymentStatus,
  });

  factory BookingFinancials.fromJson(Map<String, dynamic> json) =>
      BookingFinancials(
        customerAmount: (json['customerAmount'] as num?)?.toDouble(),
        gst: (json['gst'] as num?)?.toDouble(),
        tcs: (json['tcs'] as num?)?.toDouble(),
        totalPayable: (json['totalPayable'] as num?)?.toDouble(),
        commissionAmount: (json['commissionAmount'] as num?)?.toDouble(),
        netProfit: (json['netProfit'] as num?)?.toDouble(),
        pendingAmount: (json['pendingAmount'] as num?)?.toDouble(),
        paymentStatus: json['paymentStatus'] as String?,
      );

  final double? customerAmount;
  final double? gst;
  final double? tcs;
  final double? totalPayable;
  final double? commissionAmount;

  /// Shown to the agent, never to the customer.
  final double? netProfit;

  final double? pendingAmount;
  final String? paymentStatus;
}
