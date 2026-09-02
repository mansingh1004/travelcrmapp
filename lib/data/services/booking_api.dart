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

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
