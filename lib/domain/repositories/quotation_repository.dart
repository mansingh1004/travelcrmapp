import '../entities/quotation.dart';
import '../entities/quotation_enums.dart';

class QuotationFilter {
  const QuotationFilter({this.search, this.stage});

  final String? search;
  final QuotationStage? stage;

  static const none = QuotationFilter();

  int get appliedCount =>
      [search?.trim().isNotEmpty ?? false, stage != null].where((a) => a).length;

  QuotationFilter copyWith({Object? search = _unset, Object? stage = _unset}) =>
      QuotationFilter(
        search: search == _unset ? this.search : search as String?,
        stage: stage == _unset ? this.stage : stage as QuotationStage?,
      );

  static const _unset = Object();
}

class QuotationPage {
  const QuotationPage({
    required this.quotations,
    required this.pageNumber,
    required this.totalElements,
    required this.hasMore,
  });

  final List<QuotationSummary> quotations;
  final int pageNumber;
  final int totalElements;
  final bool hasMore;

  static const empty =
      QuotationPage(quotations: [], pageNumber: 0, totalElements: 0, hasMore: false);
}

abstract interface class QuotationRepository {
  Future<QuotationPage> getQuotations({
    int page,
    int size,
    String sortBy,
    String sortDir,
    QuotationFilter filter,
  });

  Future<Quotation> getQuotation(String publicId);

  /// Every quotation raised for one lead — shown on the lead detail screen.
  Future<List<QuotationSummary>> getForLead(String leadId);

  Future<Quotation> changeStage(String publicId, QuotationStage stage);

  /// A public URL the customer can open without signing in. Null when the
  /// server has none for this quotation.
  Future<String?> getShareLink(String publicId);

  /// Copies the quotation into a fresh **draft** and returns it —
  /// `POST /api/quotations/{publicId}/duplicate`.
  ///
  /// Wired but **not surfaced**: on the current backend build the server-side
  /// copy trips a database constraint and answers 409 for every quotation, so
  /// the quotations list does not show a Duplicate button that could only fail.
  Future<Quotation> duplicate(String publicId);

  Future<void> sendWhatsApp(String publicId);

  Future<void> sendEmail(String publicId);
}
