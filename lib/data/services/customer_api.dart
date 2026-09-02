import 'package:dio/dio.dart';

import '../dto/customer_dto.dart';
import '../dto/envelopes.dart';
import '../remote/failure_mapper.dart';

/// `CustomerController` — `/api/customers`.
class CustomerApi {
  const CustomerApi(this._dio);

  final Dio _dio;

  /// `GET /api/customers` — paged, searched and filtered server-side.
  /// Default page size is 25 on the server; the app passes its own.
  Future<PageEnvelope<CustomerDto>> getCustomers({
    int page = 0,
    int size = 20,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    String? q,
    String? status,
    String? type,
    String? tier,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/customers',
        queryParameters: <String, dynamic>{
          'page': page,
          'size': size,
          'sortBy': sortBy,
          'sortDir': sortDir,
          if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
          'status': ?status,
          'type': ?type,
          'tier': ?tier,
        },
      );
      return PageEnvelope.from<CustomerDto>(response.data, CustomerDto.fromJson);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/customers/{publicId}`.
  Future<CustomerDto> getCustomer(String publicId) async {
    try {
      final response = await _dio.get<dynamic>('/api/customers/$publicId');
      final envelope = ApiEnvelope.from<CustomerDto>(
        response.data,
        (data) => CustomerDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/customers/{publicId}/summary` — the 360 header. This is the
  /// detail page's only eager call; the tabs load on demand.
  Future<CustomerSummaryDto> getSummary(String publicId) async {
    try {
      final response = await _dio.get<dynamic>('/api/customers/$publicId/summary');
      final envelope = ApiEnvelope.from<CustomerSummaryDto>(
        response.data,
        (data) => CustomerSummaryDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/customers/stats` — requires CRM_FULL, so a sub-agent gets 403.
  /// Callers treat that as "hide the tiles", not as an error.
  Future<CustomerStatsDto> getStats() async {
    try {
      final response = await _dio.get<dynamic>('/api/customers/stats');
      final envelope = ApiEnvelope.from<CustomerStatsDto>(
        response.data,
        (data) => CustomerStatsDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }
}
