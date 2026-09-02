import 'package:dio/dio.dart';

import '../dto/envelopes.dart';
import '../remote/failure_mapper.dart';

/// One hit from `GET /api/search` — the global Cmd-K style record search.
class SearchHit {
  const SearchHit({
    required this.type,
    required this.publicId,
    required this.title,
    this.subtitle,
    this.status,
  });

  /// LEAD · CUSTOMER · BOOKING · QUOTATION · VENDOR · INVOICE
  final String type;
  final String publicId;
  final String title;
  final String? subtitle;
  final String? status;

  String get typeLabel => switch (type) {
        'LEAD' => 'Lead',
        'CUSTOMER' => 'Customer',
        'BOOKING' => 'Booking',
        'QUOTATION' => 'Quotation',
        'VENDOR' => 'Vendor',
        'INVOICE' => 'Invoice',
        _ => type,
      };

  static SearchHit fromJson(Map<String, dynamic> json) => SearchHit(
        type: json['type'] as String? ?? '',
        publicId: json['publicId'] as String? ?? '',
        title: json['title'] as String? ?? '',
        subtitle: json['subtitle'] as String?,
        status: json['status'] as String?,
      );
}

/// `SearchController` — one endpoint, searching every record type the caller
/// has read permission for.
class SearchApi {
  const SearchApi(this._dio);

  final Dio _dio;

  /// `GET /api/search?q=&limit=`.
  ///
  /// Always 200 with a list: a query under two characters comes back empty
  /// rather than as an error, and a caller lacking every read permission gets
  /// an empty list, never a 403. `limit` is clamped to 25 server-side.
  Future<List<SearchHit>> search(String query, {int limit = 20}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/search',
        queryParameters: {'q': query.trim(), 'limit': limit},
      );

      final envelope = ApiEnvelope.from<List<SearchHit>>(
        response.data,
        (data) {
          final results = (data! as Map<String, dynamic>)['results'];
          if (results is! List) return const <SearchHit>[];
          return results
              .whereType<Map<String, dynamic>>()
              .map(SearchHit.fromJson)
              .toList(growable: false);
        },
      );
      return envelope.data ?? const [];
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }
}
