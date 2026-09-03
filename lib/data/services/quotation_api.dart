import 'package:dio/dio.dart';

import '../../core/errors/failure.dart';
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

  // ── Editing a draft's services ─────────────────────────────────────────
  //
  // `PUT /api/quotations/{publicId}` takes the **whole** document:
  // `quotationMapper.applyRequest` re-maps every section, so anything left out
  // of the body is wiped. There is no partial update. The editor therefore
  // reads the quotation as raw JSON, changes only the rows it owns, and sends
  // the rest back untouched.
  //
  // That round trip is safe because `QuotationResponseDto`'s section items are
  // field-for-field identical to `QuotationRequestDto`'s — same names, same
  // nesting — so a row that came out goes back in unchanged.

  /// `GET /api/quotations/{publicId}`, as the raw `data` map.
  ///
  /// Deliberately not the typed DTO: the editor has to hand back sections it
  /// does not understand (flights, cruises, add-ons) exactly as they arrived,
  /// and a typed model would quietly drop every field it has no place for.
  Future<Map<String, dynamic>> getQuotationRaw(String publicId) async {
    try {
      final response = await _dio.get<dynamic>('/api/quotations/$publicId');
      final body = response.data;
      if (body is! Map<String, dynamic> || body['data'] is! Map) {
        throw const ParseFailure(cause: 'Quotation response had no data object');
      }
      return Map<String, dynamic>.from(body['data'] as Map);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `PUT /api/quotations/{publicId}` with a body built by [editableDocument].
  Future<void> updateQuotationRaw(
    String publicId,
    Map<String, dynamic> body,
  ) async {
    try {
      await _dio.put<dynamic>('/api/quotations/$publicId', data: body);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// Narrows a fetched quotation to the keys `QuotationRequestDto` accepts.
  ///
  /// An allowlist rather than a blocklist: the response also carries computed
  /// and read-only fields — `totals`, `customer`, `quoteNo`, `nights`, `days`,
  /// `rooms`, `allowedServices`, `pdfUrl`, `createdBy`, timestamps — and
  /// sending those back is at best ignored and at worst confusing to read in a
  /// request log.
  ///
  /// `pricing` is kept and `totals` dropped on purpose: the client states the
  /// discount, tax and markup it wants, and the server computes every total
  /// from them. Money is never calculated here.
  static Map<String, dynamic> editableDocument(Map<String, dynamic> raw) {
    const keys = [
      'leadId',
      'destinationId',
      'title',
      'quotationStage',
      'templateStyle',
      'includeSignature',
      'includeStamp',
      'coverImageUrl',
      'notes',
      'flight',
      'hotel',
      'sightseeing',
      'cruise',
      'vehicle',
      'addons',
      'inclusions',
      'exclusions',
      'paymentPolicies',
      'cancellationPolicies',
      'bookingTerms',
      'pricing',
    ];
    return <String, dynamic>{
      for (final key in keys)
        if (raw.containsKey(key) && raw[key] != null) key: raw[key],
    };
  }

  // ── Starting a quotation from a lead ───────────────────────────────────
  //
  // The desktop console's `/createquotation?leadId=…` opens a builder with the
  // lead's people, dates and destination already in it. On the server that
  // pre-fill is not the client's work at all: `linkLeadAndSnapshot` copies the
  // customer, pax, travel date, destination and the lead's chosen services onto
  // whatever quotation is created for that lead, and applying a template fills
  // the sections and the pricing on top.

  /// `POST /api/quotation-templates/match` — the package templates that fit
  /// this lead, ranked. `leadId` is the only required field.
  Future<List<TemplateMatchDto>> matchTemplates(String leadId, {int limit = 10}) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/quotation-templates/match',
        data: <String, dynamic>{'leadId': leadId, 'limit': limit},
      );
      final envelope = ApiEnvelope.from<List<TemplateMatchDto>>(
        response.data,
        (data) => (data as List? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(TemplateMatchDto.fromJson)
            .toList(growable: false),
      );
      return envelope.data ?? const [];
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/quotation-templates/{publicId}/apply` — creates a **filled**
  /// draft for the lead and returns it.
  ///
  /// The controller's own note: *"Returns the freshly created DRAFT quotation;
  /// the client navigates straight into its builder."* Verified live: the draft
  /// comes back with the lead's customer block, the template's hotel and
  /// sightseeing rows, inclusions, exclusions and a computed grand total.
  Future<QuotationDto> applyTemplate(
    String templatePublicId, {
    required String leadId,
    String? title,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/quotation-templates/$templatePublicId/apply',
        data: <String, dynamic>{
          'leadId': leadId,
          if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
        },
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

  /// `POST /api/quotations` with a body the caller built — the whole document
  /// in one call, sections and all.
  ///
  /// The server still does the pre-fill: `linkLeadAndSnapshot` copies the
  /// customer, pax, travel date and destination off the lead, so the body only
  /// carries what the agent chose.
  Future<QuotationDto> createQuotationRaw(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post<dynamic>('/api/quotations', data: body);
      final envelope = ApiEnvelope.from<QuotationDto>(
        response.data,
        (data) => QuotationDto.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/quotations` with nothing but the lead — an empty draft that
  /// still carries the lead's snapshot.
  ///
  /// A zero-value quotation is accepted: `assertQuotationHasValue` is gated on
  /// `app.quotation.require-positive-total`, which is off, precisely so a quote
  /// can be parked while rates are still being collected.
  Future<QuotationDto> createForLead({
    required String leadId,
    String? title,
    int? destinationId,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/quotations',
        data: <String, dynamic>{
          'leadId': leadId,
          if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
          'destinationId': ?destinationId,
        },
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
}

/// One ranked template from `/api/quotation-templates/match`.
class TemplateMatchDto {
  const TemplateMatchDto({
    required this.id,
    required this.name,
    required this.matchPercentage,
    this.description,
    this.coverImageUrl,
    this.durationNights,
    this.durationDays,
    this.hotelTier,
    this.basePrice,
    this.cities = const [],
    this.belowThreshold = false,
  });

  factory TemplateMatchDto.fromJson(Map<String, dynamic> json) => TemplateMatchDto(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? 'Template',
        matchPercentage: (json['matchPercentage'] as num?)?.toInt() ?? 0,
        description: json['description'] as String?,
        coverImageUrl: json['coverImageUrl'] as String?,
        durationNights: (json['durationNights'] as num?)?.toInt(),
        durationDays: (json['durationDays'] as num?)?.toInt(),
        hotelTier: (json['hotelTier'] as num?)?.toInt(),
        basePrice: json['basePrice'] as num?,
        cities: (json['cities'] as List? ?? const [])
            .map((c) => c.toString())
            .toList(growable: false),
        belowThreshold: json['belowThreshold'] as bool? ?? false,
      );

  final String id;
  final String name;

  /// How well the template fits the lead, 0–100, as the server scored it.
  final int matchPercentage;

  final String? description;
  final String? coverImageUrl;
  final int? durationNights;
  final int? durationDays;

  /// Star tier the template is priced at.
  final int? hotelTier;

  final num? basePrice;
  final List<String> cities;

  /// The server scored this below its own match threshold — shown, but flagged.
  final bool belowThreshold;
}
