import 'package:dio/dio.dart';

import '../dto/envelopes.dart';
import '../dto/operations_dto.dart';
import '../remote/failure_mapper.dart';

/// `OperationsController` — `/api/operations`.
class OperationsApi {
  const OperationsApi(this._dio);

  final Dio _dio;

  /// `GET /api/operations/board` — bookings in the window, nearest departure
  /// first. Sort is fixed server-side; only the tab, window and search vary.
  Future<PageEnvelope<OpsBoardRowDto>> getBoard({
    String tab = 'ALL',
    DateTime? from,
    DateTime? to,
    String? search,
    int page = 0,
    int size = 25,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/operations/board',
        queryParameters: <String, dynamic>{
          'tab': tab,
          if (from != null) 'from': _date(from),
          if (to != null) 'to': _date(to),
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
          'page': page,
          'size': size,
        },
      );
      return PageEnvelope.from<OpsBoardRowDto>(response.data, OpsBoardRowDto.fromJson);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/operations/tab-counts` — each count uses the same predicate its
  /// tab's list does, so the badge and the list can never disagree.
  Future<Map<String, int>> getTabCounts({DateTime? from, DateTime? to, String? search}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/operations/tab-counts',
        queryParameters: <String, dynamic>{
          if (from != null) 'from': _date(from),
          if (to != null) 'to': _date(to),
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        },
      );
      final envelope = ApiEnvelope.from<Map<String, int>>(
        response.data,
        (data) => {
          for (final entry in (data! as Map).entries)
            entry.key.toString(): (entry.value as num?)?.toInt() ?? 0,
        },
      );
      return envelope.data ?? const {};
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/operations/summary` — counted over the whole window.
  Future<OpsSummaryDto> getSummary({DateTime? from, DateTime? to, String? search}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/operations/summary',
        queryParameters: <String, dynamic>{
          if (from != null) 'from': _date(from),
          if (to != null) 'to': _date(to),
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        },
      );
      final envelope = ApiEnvelope.from<OpsSummaryDto>(
        response.data,
        (data) => OpsSummaryDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/operations/bookings/{id}/checkpoints`.
  Future<OpsDetailDto> getCheckpoints(String bookingPublicId) async {
    try {
      final response =
          await _dio.get<dynamic>('/api/operations/bookings/$bookingPublicId/checkpoints');
      final envelope = ApiEnvelope.from<OpsDetailDto>(
        response.data,
        (data) => OpsDetailDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `PUT /api/operations/checkpoints/{id}` — a **sparse** patch: only the
  /// fields sent are changed, so omitting a field leaves it alone.
  Future<void> updateCheckpoint(
    String checkpointPublicId, {
    String? status,
    String? vendorName,
    String? referenceNo,
    String? notes,
  }) async {
    try {
      await _dio.put<dynamic>(
        '/api/operations/checkpoints/$checkpointPublicId',
        data: <String, dynamic>{
          'status': ?status,
          'vendorName': ?vendorName,
          'referenceNo': ?referenceNo,
          'notes': ?notes,
        },
      );
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
