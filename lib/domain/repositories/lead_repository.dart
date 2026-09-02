import '../entities/lead.dart';
import '../entities/lead_enums.dart';

/// Filters the server applies **in the database** on `GET /api/leads`.
class LeadFilter {
  const LeadFilter({
    this.search,
    this.stage,
    this.type,
    this.fromDate,
    this.toDate,
    this.activeOnly,
    this.followUpDueBy,
  });

  final String? search;
  final LeadStage? stage;
  final LeadType? type;
  final DateTime? fromDate;
  final DateTime? toDate;

  /// Non-terminal stages only. Mutually exclusive with [stage] in practice —
  /// the server has no "Active" stage value.
  final bool? activeOnly;

  /// Work-queue predicate: leads whose follow-up is due on or before this day.
  final DateTime? followUpDueBy;

  static const none = LeadFilter();

  /// How many facets are set — drives the filter sheet's badge count.
  int get appliedCount => [
        search?.trim().isNotEmpty ?? false,
        stage != null,
        type != null,
        fromDate != null || toDate != null,
        activeOnly ?? false,
        followUpDueBy != null,
      ].where((applied) => applied).length;

  LeadFilter copyWith({
    Object? search = _unset,
    Object? stage = _unset,
    Object? type = _unset,
    Object? fromDate = _unset,
    Object? toDate = _unset,
    Object? activeOnly = _unset,
    Object? followUpDueBy = _unset,
  }) =>
      LeadFilter(
        search: search == _unset ? this.search : search as String?,
        stage: stage == _unset ? this.stage : stage as LeadStage?,
        type: type == _unset ? this.type : type as LeadType?,
        fromDate: fromDate == _unset ? this.fromDate : fromDate as DateTime?,
        toDate: toDate == _unset ? this.toDate : toDate as DateTime?,
        activeOnly: activeOnly == _unset ? this.activeOnly : activeOnly as bool?,
        followUpDueBy:
            followUpDueBy == _unset ? this.followUpDueBy : followUpDueBy as DateTime?,
      );

  static const _unset = Object();
}

/// One page of leads plus the paging state the list needs.
class LeadPage {
  const LeadPage({
    required this.leads,
    required this.pageNumber,
    required this.totalElements,
    required this.hasMore,
  });

  final List<Lead> leads;
  final int pageNumber;
  final int totalElements;
  final bool hasMore;

  static const empty = LeadPage(leads: [], pageNumber: 0, totalElements: 0, hasMore: false);
}

/// Lead operations against the running backend.
abstract interface class LeadRepository {
  /// `GET /api/leads` — server-side filtered, sorted and paged.
  /// [sortBy] must be one of `LeadApi.sortableFields`.
  Future<LeadPage> getLeads({
    int page,
    int size,
    String sortBy,
    String sortDir,
    LeadFilter filter,
    bool forceRefresh,
  });

  /// `GET /api/leads/{publicId}`.
  Future<Lead> getLead(String publicId);

  /// `POST /api/leads`.
  Future<Lead> createLead(Map<String, dynamic> body);

  /// `PUT /api/leads/{publicId}`.
  Future<Lead> updateLead(String publicId, Map<String, dynamic> body);

  /// `PATCH /api/leads/{publicId}/stage`.
  Future<Lead> changeStage(String publicId, LeadStage stage);

  /// `DELETE /api/leads/{publicId}` — soft delete.
  Future<void> deleteLead(String publicId);

  /// `GET /api/leads/{publicId}/logs`.
  Future<List<LeadLog>> getLogs(String publicId);

  /// `POST /api/leads/{publicId}/logs`.
  Future<LeadLog> addLog(
    String publicId, {
    required String comment,
    bool createReminder,
    DateTime? followUpDate,
  });

  /// `GET /api/leads/stats/summary`.
  Future<LeadStats> getStats({DateTime? from, DateTime? to});

  /// `GET /api/leads/meta/sources` — pickable sources only, cached per session.
  Future<List<LeadSourceOption>> getSelectableSources();

  /// `GET /api/leads/assignment/recommendation`.
  Future<AssignmentChoice> getAssignmentChoice();

  /// The most recent page held in memory, for instant paint on re-entry.
  LeadPage? get cached;
}
