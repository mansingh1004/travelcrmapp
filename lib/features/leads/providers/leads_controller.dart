import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/di.dart';
import '../../../domain/entities/lead.dart';
import '../../../domain/entities/lead_enums.dart';
import '../../../domain/repositories/lead_repository.dart';

/// Sort options the list offers. Every field here is in the server's
/// `LEAD_SORT_WHITELIST`; anything else is rejected.
enum LeadSort {
  recent('createdAt', 'desc', 'Recently added'),
  oldest('createdAt', 'asc', 'Oldest first'),
  followUp('followUpDate', 'asc', 'Follow-up date'),
  travelDate('travelDate', 'asc', 'Travel date'),
  budgetHigh('budget', 'desc', 'Budget (high first)'),
  nameAsc('customerName', 'asc', 'Name (A–Z)'),
  stage('leadStage', 'asc', 'Stage');

  const LeadSort(this.field, this.direction, this.label);

  final String field;
  final String direction;
  final String label;
}

/// The list's full state: the loaded rows plus paging bookkeeping.
@immutable
class LeadsState {
  const LeadsState({
    this.leads = const [],
    this.totalElements = 0,
    this.pageNumber = 0,
    this.hasMore = false,
    this.loadingMore = false,
  });

  final List<Lead> leads;

  /// Total matching the current filter **on the server**, not just loaded.
  final int totalElements;
  final int pageNumber;
  final bool hasMore;
  final bool loadingMore;

  LeadsState copyWith({
    List<Lead>? leads,
    int? totalElements,
    int? pageNumber,
    bool? hasMore,
    bool? loadingMore,
  }) =>
      LeadsState(
        leads: leads ?? this.leads,
        totalElements: totalElements ?? this.totalElements,
        pageNumber: pageNumber ?? this.pageNumber,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

/// Current sort. Changing it re-fetches.
final leadSortProvider = NotifierProvider<LeadSortNotifier, LeadSort>(LeadSortNotifier.new);

class LeadSortNotifier extends Notifier<LeadSort> {
  @override
  LeadSort build() => LeadSort.recent;

  void set(LeadSort sort) => state = sort;
}

/// Current filters. Applied **server-side**, so changing them re-fetches.
final leadFilterProvider =
    NotifierProvider<LeadFilterNotifier, LeadFilter>(LeadFilterNotifier.new);

class LeadFilterNotifier extends Notifier<LeadFilter> {
  Timer? _debounce;

  @override
  LeadFilter build() {
    ref.onDispose(() => _debounce?.cancel());
    return LeadFilter.none;
  }

  void set(LeadFilter filter) => state = filter;

  /// Debounced so typing does not fire a request per keystroke.
  void setQuery(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      state = state.copyWith(search: query.trim().isEmpty ? null : query.trim());
    });
  }

  /// Tab selection. `null` is the "All" tab.
  void setStage(LeadStage? stage) => state = state.copyWith(stage: stage);

  void clear() => state = LeadFilter(search: state.search);
}

/// Per-stage counts for the tab badges — from `GET /api/leads/stats/summary`,
/// so they are **global totals**, not per-page.
final leadStageCountsProvider = FutureProvider.autoDispose<Map<LeadStage, int>>((ref) async {
  final stats = await ref.watch(leadRepositoryProvider).getStats();
  return stats.byStage;
});

/// Sources that may be picked in the create wizard.
final leadSourcesProvider = FutureProvider<List<LeadSourceOption>>(
  (ref) => ref.watch(leadRepositoryProvider).getSelectableSources(),
);

/// Who a new lead may be assigned to, plus the server's recommendation.
final assignmentChoiceProvider = FutureProvider.autoDispose<AssignmentChoice>(
  (ref) => ref.watch(leadRepositoryProvider).getAssignmentChoice(),
);

final leadsControllerProvider =
    AsyncNotifierProvider<LeadsController, LeadsState>(LeadsController.new);

class LeadsController extends AsyncNotifier<LeadsState> {
  LeadRepository get _repo => ref.read(leadRepositoryProvider);

  @override
  Future<LeadsState> build() async {
    // Both sort and filter are server-side, so either change re-fetches.
    final sort = ref.watch(leadSortProvider);
    final filter = ref.watch(leadFilterProvider);
    return _fetchFirstPage(sort, filter);
  }

  Future<LeadsState> _fetchFirstPage(
    LeadSort sort,
    LeadFilter filter, {
    bool forceRefresh = false,
  }) async {
    final page = await _repo.getLeads(
      page: 0,
      size: AppConfig.pageSize,
      sortBy: sort.field,
      sortDir: sort.direction,
      filter: filter,
      forceRefresh: forceRefresh,
    );

    return LeadsState(
      leads: page.leads,
      totalElements: page.totalElements,
      pageNumber: page.pageNumber,
      hasMore: page.hasMore,
    );
  }

  /// Pull-to-refresh. Bypasses the repository cache.
  Future<void> refresh() async {
    final sort = ref.read(leadSortProvider);
    final filter = ref.read(leadFilterProvider);
    state = await AsyncValue.guard(() => _fetchFirstPage(sort, filter, forceRefresh: true));
    ref.invalidate(leadStageCountsProvider);
  }

  /// Append the next page. No-op while one is already in flight or at the end.
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));

    try {
      final next = await _repo.getLeads(
        page: current.pageNumber + 1,
        size: AppConfig.pageSize,
        sortBy: ref.read(leadSortProvider).field,
        sortDir: ref.read(leadSortProvider).direction,
        filter: ref.read(leadFilterProvider),
      );

      state = AsyncData(
        current.copyWith(
          leads: [...current.leads, ...next.leads],
          pageNumber: next.pageNumber,
          hasMore: next.hasMore,
          totalElements: next.totalElements,
          loadingMore: false,
        ),
      );
    } catch (_) {
      // Keep the rows already on screen; only the append failed.
      state = AsyncData(current.copyWith(loadingMore: false));
      rethrow;
    }
  }

  /// Replace one row in place after an edit or stage change elsewhere.
  void upsert(Lead lead) {
    final current = state.value;
    if (current == null) return;

    final index = current.leads.indexWhere((l) => l.id == lead.id);
    if (index < 0) {
      state = AsyncData(
        current.copyWith(
          leads: [lead, ...current.leads],
          totalElements: current.totalElements + 1,
        ),
      );
      return;
    }

    final updated = [...current.leads];
    updated[index] = lead;
    state = AsyncData(current.copyWith(leads: updated));
  }

  void remove(String publicId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        leads: current.leads.where((l) => l.id != publicId).toList(growable: false),
        totalElements: (current.totalElements - 1).clamp(0, 1 << 30),
      ),
    );
  }
}
