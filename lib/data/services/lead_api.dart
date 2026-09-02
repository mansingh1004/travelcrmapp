import 'package:dio/dio.dart';

import '../dto/envelopes.dart';
import '../dto/lead_dto.dart';
import '../remote/failure_mapper.dart';

/// The running backend's lead endpoints (`/api/leads`, `LeadController` +
/// `LeadMetaController` + `LeadAssignmentController`).
///
/// Unlike the stale snapshot this app first targeted, filtering, search,
/// paging, update, stage-change, delete and activity logs are all real here.
class LeadApi {
  const LeadApi(this._dio);

  final Dio _dio;

  /// `sortBy` is validated against `LEAD_SORT_WHITELIST` server-side; anything
  /// else is rejected. These are the whitelist entries worth offering.
  static const sortableFields = <String, String>{
    'createdAt': 'Recently added',
    'followUpDate': 'Follow-up date',
    'travelDate': 'Travel date',
    'budget': 'Budget',
    'customerName': 'Customer name',
    'leadCode': 'Lead code',
    'leadStage': 'Stage',
  };

  /// `GET /api/leads` — paged and filtered **in the database**.
  ///
  /// Pass [stage] as a display name ("New Lead"); never pass "Active" — use
  /// [activeOnly] instead, which the server implements as the complement of
  /// the terminal stages.
  Future<PageEnvelope<LeadDto>> getLeads({
    int page = 0,
    int size = 20,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    String? search,
    String? stage,
    String? leadType,
    DateTime? fromDate,
    DateTime? toDate,
    bool? activeOnly,
    DateTime? followUpDueBy,
  }) async {
    assert(sortableFields.containsKey(sortBy), 'Unsortable field "$sortBy" is rejected server-side');
    try {
      final response = await _dio.get<dynamic>(
        '/api/leads',
        queryParameters: <String, dynamic>{
          'page': page,
          'size': size,
          'sortBy': sortBy,
          'sortDir': sortDir,
          if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
          'stage': ?stage,
          'leadType': ?leadType,
          if (fromDate != null) 'fromDate': _date(fromDate),
          if (toDate != null) 'toDate': _date(toDate),
          'activeOnly': ?activeOnly,
          if (followUpDueBy != null) 'followUpDueBy': _date(followUpDueBy),
        },
      );
      return PageEnvelope.from<LeadDto>(response.data, LeadDto.fromJson);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/leads/{publicId}`.
  Future<LeadDto> getLead(String publicId) => _one('/api/leads/$publicId');

  /// `POST /api/leads` → 201.
  Future<LeadDto> createLead(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post<dynamic>('/api/leads', data: body);
      return _unwrapLead(response.data);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `PUT /api/leads/{publicId}` — same body as create.
  Future<LeadDto> updateLead(String publicId, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put<dynamic>('/api/leads/$publicId', data: body);
      return _unwrapLead(response.data);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `PATCH /api/leads/{publicId}/stage` — the stage-change sheet.
  Future<LeadDto> changeStage(String publicId, String stageWire) async {
    try {
      final response = await _dio.patch<dynamic>(
        '/api/leads/$publicId/stage',
        data: {'leadStage': stageWire},
      );
      return _unwrapLead(response.data);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `DELETE /api/leads/{publicId}` — soft delete.
  Future<void> deleteLead(String publicId) async {
    try {
      await _dio.delete<dynamic>('/api/leads/$publicId');
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/leads/{publicId}/logs` — the follow-up timeline, newest first.
  Future<List<LeadLogDto>> getLogs(String publicId) async {
    try {
      final response = await _dio.get<dynamic>('/api/leads/$publicId/logs');
      final envelope = ApiEnvelope.from<List<LeadLogDto>>(
        response.data,
        (data) => (data! as List)
            .whereType<Map<String, dynamic>>()
            .map(LeadLogDto.fromJson)
            .toList(growable: false),
      );
      return envelope.data ?? const [];
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/leads/{publicId}/logs` — log a follow-up, optionally creating
  /// a reminder. `followUpDate` is required when [createReminder] is true.
  Future<LeadLogDto> addLog(
    String publicId, {
    required String comment,
    bool createReminder = false,
    DateTime? followUpDate,
  }) async {
    assert(!createReminder || followUpDate != null,
        'followUpDate is required when createReminder is true');
    try {
      final response = await _dio.post<dynamic>(
        '/api/leads/$publicId/logs',
        data: <String, dynamic>{
          'comment': comment.trim(),
          'createReminder': createReminder,
          if (followUpDate != null) 'followUpDate': _date(followUpDate),
        },
      );
      final envelope = ApiEnvelope.from<LeadLogDto>(
        response.data,
        (data) => LeadLogDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/leads/stats/summary` — dashboard roll-up for a period
  /// (omit both dates for the tenant's current calendar month).
  Future<LeadStatsSummaryDto> getStats({DateTime? from, DateTime? to}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/leads/stats/summary',
        queryParameters: <String, dynamic>{
          if (from != null) 'from': _date(from),
          if (to != null) 'to': _date(to),
        },
      );
      final envelope = ApiEnvelope.from<LeadStatsSummaryDto>(
        response.data,
        (data) => LeadStatsSummaryDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/leads/meta/sources` — the full source catalog for pickers.
  Future<List<Map<String, dynamic>>> getSources() async {
    try {
      final response = await _dio.get<dynamic>('/api/leads/meta/sources');
      final envelope = ApiEnvelope.from<List<Map<String, dynamic>>>(
        response.data,
        (data) => (data! as List).whereType<Map<String, dynamic>>().toList(growable: false),
      );
      return envelope.data ?? const [];
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/leads/assignment/recommendation` — who should own a new lead.
  Future<AssignmentRecommendationDto> getAssignmentRecommendation() async {
    try {
      final response = await _dio.get<dynamic>('/api/leads/assignment/recommendation');
      final envelope = ApiEnvelope.from<AssignmentRecommendationDto>(
        response.data,
        (data) => AssignmentRecommendationDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<LeadDto> _one(String path) async {
    try {
      final response = await _dio.get<dynamic>(path);
      return _unwrapLead(response.data);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static LeadDto _unwrapLead(Object? body) {
    final envelope = ApiEnvelope.from<LeadDto>(
      body,
      (data) => LeadDto.fromJson(data! as Map<String, dynamic>),
    );
    return envelope.requireData();
  }

  /// `yyyy-MM-dd`, the ISO date format every date query param expects.
  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}
