import '../../domain/entities/quotation.dart';
import '../../domain/entities/quotation_enums.dart';
import '../../domain/repositories/quotation_repository.dart';
import '../mappers/quotation_mapper.dart';
import '../services/quotation_api.dart';

class QuotationRepositoryImpl implements QuotationRepository {
  const QuotationRepositoryImpl(this._api);

  final QuotationApi _api;

  @override
  Future<QuotationPage> getQuotations({
    int page = 0,
    int size = 20,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    QuotationFilter filter = QuotationFilter.none,
  }) async {
    final envelope = await _api.getQuotations(
      page: page,
      size: size,
      sortBy: sortBy,
      sortDir: sortDir,
      search: filter.search,
      stage: filter.stage?.wire,
    );

    return QuotationPage(
      quotations: envelope.content
          .map(QuotationMapper.toSummary)
          .where((q) => q.id.isNotEmpty)
          .toList(growable: false),
      pageNumber: envelope.pageNumber,
      totalElements: envelope.totalElements,
      hasMore: envelope.hasMore,
    );
  }

  @override
  Future<Quotation> getQuotation(String publicId) async =>
      QuotationMapper.toEntity(await _api.getQuotation(publicId));

  @override
  Future<List<QuotationSummary>> getForLead(String leadId) async {
    final rows = await _api.getForLead(leadId);
    return rows
        .map(QuotationMapper.toSummary)
        .where((q) => q.id.isNotEmpty)
        .toList(growable: false);
  }

  @override
  Future<Quotation> changeStage(String publicId, QuotationStage stage) async =>
      QuotationMapper.toEntity(await _api.changeStage(publicId, stage.wire));

  @override
  Future<String?> getShareLink(String publicId) => _api.getShareLink(publicId);

  @override
  Future<Quotation> duplicate(String publicId) async =>
      QuotationMapper.toEntity(await _api.duplicate(publicId));

  @override
  Future<void> sendWhatsApp(String publicId) => _api.sendWhatsApp(publicId);

  @override
  Future<void> sendEmail(String publicId) => _api.sendEmail(publicId);
}
