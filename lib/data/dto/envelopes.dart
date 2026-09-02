import '../../core/errors/failure.dart';

/// The running backend's two JSON envelopes.
///
/// Hand-written rather than generated: they are generic wrappers, and
/// `json_serializable`'s `genericArgumentFactories` buys nothing here beyond
/// indirection. The third response shape — a bare DTO (e.g. login) — is handled
/// at the call site.

/// `common.dto.ApiResponse<T>` — `{success, message, data, errors, statusCode,
/// timestamp}`. `@JsonInclude(NON_NULL)` means `data` and `errors` are absent
/// rather than null when empty.
class ApiEnvelope<T> {
  const ApiEnvelope({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.timestamp,
  });

  final bool success;
  final String? message;
  final T? data;
  final Object? errors;
  final String? timestamp;

  /// [parse] converts the raw `data` node. Throws [ParseFailure] if the body is
  /// not the documented object shape.
  static ApiEnvelope<T> from<T>(Object? body, T Function(Object? data) parse) {
    if (body is! Map<String, dynamic>) {
      throw const ParseFailure(cause: 'Response body was not a JSON object');
    }
    return ApiEnvelope<T>(
      success: body['success'] as bool? ?? false,
      message: body['message'] as String?,
      data: body.containsKey('data') && body['data'] != null ? parse(body['data']) : null,
      errors: body['errors'],
      timestamp: body['timestamp'] as String?,
    );
  }

  /// The `data` node, or a [ParseFailure] if the server said success with no
  /// payload where one was required.
  T requireData() {
    final value = data;
    if (value == null) {
      throw ParseFailure(cause: message ?? 'Response contained no data');
    }
    return value;
  }
}

/// `common.dto.PagedApiResponse<T>` — the running backend's list envelope.
///
/// Shape (extraction `api_common-search-trash.json`):
/// `{ success, message, data: [T]  ← FLAT list, pagination: { page, size,
///   totalElements, totalPages, first, last, hasNext, hasPrevious, sortBy,
///   sortDir }, timestamp }`.
class PageEnvelope<T> {
  const PageEnvelope({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.isFirst,
    required this.isLast,
    required this.hasNext,
  });

  final List<T> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool isFirst;
  final bool isLast;
  final bool hasNext;

  bool get isEmpty => content.isEmpty;

  /// True when another page can be requested.
  bool get hasMore => hasNext;

  /// Zero-based index of the next page, or null when this is the last one.
  int? get nextPage => hasNext ? pageNumber + 1 : null;

  static PageEnvelope<T> from<T>(Object? body, T Function(Map<String, dynamic> item) parse) {
    if (body is! Map<String, dynamic>) {
      throw const ParseFailure(cause: 'Paged body was not a JSON object');
    }

    final items = <T>[];
    final rawData = body['data'];
    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map<String, dynamic>) {
          items.add(parse(item));
        }
      }
    }

    final pagination = body['pagination'];
    final meta = pagination is Map<String, dynamic> ? pagination : const <String, dynamic>{};
    final number = meta['page'] as int? ?? 0;
    final totalPages = meta['totalPages'] as int? ?? 1;
    final isLast = meta['last'] as bool? ?? number >= totalPages - 1;

    return PageEnvelope<T>(
      content: items,
      pageNumber: number,
      pageSize: meta['size'] as int? ?? items.length,
      totalElements: meta['totalElements'] as int? ?? items.length,
      totalPages: totalPages,
      isFirst: meta['first'] as bool? ?? number == 0,
      isLast: isLast,
      hasNext: meta['hasNext'] as bool? ?? !isLast,
    );
  }

  PageEnvelope<R> map<R>(R Function(T item) transform) => PageEnvelope<R>(
        content: content.map(transform).toList(growable: false),
        pageNumber: pageNumber,
        pageSize: pageSize,
        totalElements: totalElements,
        totalPages: totalPages,
        isFirst: isFirst,
        isLast: isLast,
        hasNext: hasNext,
      );
}
