import '../../domain/entities/lead.dart';
import '../../domain/entities/lead_enums.dart';
import '../../domain/repositories/lead_repository.dart';
import '../mappers/lead_mapper.dart';
import '../services/lead_api.dart';

/// Repository over [LeadApi].
///
/// Filtering, sorting and paging are all delegated to the server — the only
/// caching here is the last page (for instant paint on re-entry) and the source
/// catalog (static per session).
class LeadRepositoryImpl implements LeadRepository {
  LeadRepositoryImpl(this._api);

  final LeadApi _api;

  LeadPage? _cached;
  List<LeadSourceOption>? _sources;

  @override
  LeadPage? get cached => _cached;

  @override
  Future<LeadPage> getLeads({
    int page = 0,
    int size = 20,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    LeadFilter filter = LeadFilter.none,
    bool forceRefresh = false,
  }) async {
    final cachedPage = _cached;
    if (!forceRefresh && page == 0 && cachedPage != null && filter.appliedCount == 0) {
      return cachedPage;
    }

    final envelope = await _api.getLeads(
      page: page,
      size: size,
      sortBy: sortBy,
      sortDir: sortDir,
      search: filter.search,
      stage: filter.stage?.wire,
      leadType: filter.type?.wire,
      fromDate: filter.fromDate,
      toDate: filter.toDate,
      activeOnly: filter.activeOnly,
      followUpDueBy: filter.followUpDueBy,
    );

    final result = LeadPage(
      // A row missing its publicId cannot be opened, so drop it rather than
      // render a card that navigates nowhere.
      leads: envelope.content
          .map(LeadMapper.toEntity)
          .where((lead) => lead.id.isNotEmpty)
          .toList(growable: false),
      pageNumber: envelope.pageNumber,
      totalElements: envelope.totalElements,
      hasMore: envelope.hasMore,
    );

    if (page == 0 && filter.appliedCount == 0) _cached = result;
    return result;
  }

  @override
  Future<Lead> getLead(String publicId) async =>
      LeadMapper.toEntity(await _api.getLead(publicId));

  @override
  Future<Lead> createLead(Map<String, dynamic> body) async {
    final lead = LeadMapper.toEntity(await _api.createLead(body));
    _cached = null; // The list is stale now.
    return lead;
  }

  @override
  Future<Lead> updateLead(String publicId, Map<String, dynamic> body) async {
    final lead = LeadMapper.toEntity(await _api.updateLead(publicId, body));
    _cached = null;
    return lead;
  }

  @override
  Future<Lead> changeStage(String publicId, LeadStage stage) async {
    final lead = LeadMapper.toEntity(await _api.changeStage(publicId, stage.wire));
    _cached = null;
    return lead;
  }

  @override
  Future<void> deleteLead(String publicId) async {
    await _api.deleteLead(publicId);
    _cached = null;
  }

  @override
  Future<List<LeadLog>> getLogs(String publicId) async {
    final logs = await _api.getLogs(publicId);
    return logs.map(LeadMapper.toLog).toList(growable: false);
  }

  @override
  Future<LeadLog> addLog(
    String publicId, {
    required String comment,
    bool createReminder = false,
    DateTime? followUpDate,
  }) async {
    final log = await _api.addLog(
      publicId,
      comment: comment,
      createReminder: createReminder,
      followUpDate: followUpDate,
    );
    // A log can move the follow-up date, which the list renders.
    _cached = null;
    return LeadMapper.toLog(log);
  }

  @override
  Future<LeadStats> getStats({DateTime? from, DateTime? to}) async =>
      LeadMapper.toStats(await _api.getStats(from: from, to: to));

  @override
  Future<List<LeadSourceOption>> getSelectableSources() async {
    final cachedSources = _sources;
    if (cachedSources != null) return cachedSources;

    final rows = await _api.getSources();
    final options = rows
        .map(LeadSourceOption.fromJson)
        .where((o) => o.selectable && o.value.isNotEmpty)
        .toList(growable: false);
    _sources = options;
    return options;
  }

  @override
  Future<AssignmentChoice> getAssignmentChoice() async =>
      LeadMapper.toAssignmentChoice(await _api.getAssignmentRecommendation());
}
