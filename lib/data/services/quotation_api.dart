import 'package:dio/dio.dart';

import '../dto/envelopes.dart';
import '../dto/quotation_dto.dart';
import '../remote/failure_mapper.dart';

/// `QuotationController` — `/api/quotations`.
class QuotationApi {
  const QuotationApi(this._dio);

  final Dio _dio;

  /// `GET /api/quotations` — paged, with search and stage applied server-side.
  Future<PageEnvelope<QuotationSummaryDto>> getQuotations({
    int page = 0,
    int size = 20,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    String? search,
    String? stage,
    String? leadId,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/quotations',
        queryParameters: <String, dynamic>{
          'page': page,
          'size': size,
          'sortBy': sortBy,
          'sortDir': sortDir,
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
          'stage': ?stage,
          'leadId': ?leadId,
        },
      );
      return PageEnvelope.from<QuotationSummaryDto>(
        response.data,
        QuotationSummaryDto.fromJson,
      );
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/quotations/{publicId}`.
  Future<QuotationDto> getQuotation(String publicId) async {
    try {
      final response = await _dio.get<dynamic>('/api/quotations/$publicId');
      final envelope = ApiEnvelope.from<QuotationDto>(
        response.data,
        (data) => QuotationDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/quotations/lead/{leadId}` — every quotation for one lead.
  Future<List<QuotationSummaryDto>> getForLead(String leadId) async {
    try {
      final response = await _dio.get<dynamic>('/api/quotations/lead/$leadId');
      final envelope = ApiEnvelope.from<List<QuotationSummaryDto>>(
        response.data,
        (data) => (data! as List)
            .whereType<Map<String, dynamic>>()
            .map(QuotationSummaryDto.fromJson)
            .toList(growable: false),
      );
      return envelope.data ?? const [];
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `PATCH /api/quotations/{publicId}/stage?stage=` — the stage is a **query
  /// param**, not a body, on this endpoint.
  Future<QuotationDto> changeStage(String publicId, String stageWire) async {
    try {
      final response = await _dio.patch<dynamic>(
        '/api/quotations/$publicId/stage',
        queryParameters: {'stage': stageWire},
      );
      final envelope = ApiEnvelope.from<QuotationDto>(
        response.data,
        (data) => QuotationDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/quotations/{publicId}/share-link` — a public URL the customer
  /// can open without signing in.
  Future<String?> getShareLink(String publicId) async {
    try {
      final response = await _dio.get<dynamic>('/api/quotations/$publicId/share-link');
      final data = response.data;
      // The endpoint has been seen returning both a bare string and an
      // enveloped object, so accept either rather than failing on the wrapper.
      if (data is String) return data.trim().isEmpty ? null : data.trim();
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is String) return inner;
        if (inner is Map<String, dynamic>) {
          final url = inner['url'] ?? inner['shareLink'] ?? inner['link'];
          if (url is String) return url;
        }
      }
      return null;
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/quotations/{publicId}/duplicate` → the new draft, 201.
  Future<QuotationDto> duplicate(String publicId) async {
    try {
      final response = await _dio.post<dynamic>('/api/quotations/$publicId/duplicate');
      final envelope = ApiEnvelope.from<QuotationDto>(
        response.data,
        (data) => QuotationDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/quotations/{publicId}/send-whatsapp`.
  Future<void> sendWhatsApp(String publicId) async {
    try {
      await _dio.post<dynamic>('/api/quotations/$publicId/send-whatsapp');
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/quotations/{publicId}/send-email`.
  Future<void> sendEmail(String publicId) async {
    try {
      await _dio.post<dynamic>('/api/quotations/$publicId/send-email');
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }
}
