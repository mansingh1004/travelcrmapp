import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../../../domain/entities/operations.dart';
import '../../../domain/entities/operations_enums.dart';
import '../../../domain/repositories/operations_repository.dart';

/// The board's window and tab. The window defaults to whatever the server
/// picks (the next fortnight), so nothing is sent until the user narrows it.
@immutable
class OpsQuery {
  const OpsQuery({this.tab = OpsBoardTab.all, this.from, this.to, this.search});

  final OpsBoardTab tab;
  final DateTime? from;
  final DateTime? to;
  final String? search;

  OpsQuery copyWith({
    OpsBoardTab? tab,
    Object? from = _unset,
    Object? to = _unset,
    Object? search = _unset,
  }) =>
      OpsQuery(
        tab: tab ?? this.tab,
        from: from == _unset ? this.from : from as DateTime?,
        to: to == _unset ? this.to : to as DateTime?,
        search: search == _unset ? this.search : search as String?,
      );

  static const _unset = Object();
}

final opsQueryProvider = NotifierProvider<OpsQueryNotifier, OpsQuery>(OpsQueryNotifier.new);

class OpsQueryNotifier extends Notifier<OpsQuery> {
  Timer? _debounce;

  @override
  OpsQuery build() {
    ref.onDispose(() => _debounce?.cancel());
    return const OpsQuery();
  }

  void setTab(OpsBoardTab tab) => state = state.copyWith(tab: tab);

  void setQuery(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      state = state.copyWith(search: query.trim().isEmpty ? null : query.trim());
    });
  }

  /// Narrow the window to a single day — what the Today / Tomorrow shortcuts do.
  void setDay(DateTime? day) =>
      state = state.copyWith(from: day, to: day);

  void setWindow(DateTime? from, DateTime? to) =>
      state = state.copyWith(from: from, to: to);
}

/// Badge counts. Each uses the same predicate as its tab's list.
final opsTabCountsProvider = FutureProvider.autoDispose<Map<OpsBoardTab, int>>((ref) {
  final query = ref.watch(opsQueryProvider);
  return ref.watch(operationsRepositoryProvider).getTabCounts(
        from: query.from,
        to: query.to,
        search: query.search,
      );
});

/// Headline cards, counted over the whole window rather than the page.
final opsSummaryProvider = FutureProvider.autoDispose<OpsSummary>((ref) {
  final query = ref.watch(opsQueryProvider);
  return ref.watch(operationsRepositoryProvider).getSummary(
        from: query.from,
        to: query.to,
        search: query.search,
      );
});

@immutable
class OpsBoardState {
  const OpsBoardState({
    this.rows = const [],
    this.totalElements = 0,
    this.pageNumber = 0,
    this.hasMore = false,
    this.loadingMore = false,
  });

  final List<OpsBoardRow> rows;
  final int totalElements;
  final int pageNumber;
  final bool hasMore;
  final bool loadingMore;

  OpsBoardState copyWith({
    List<OpsBoardRow>? rows,
    int? totalElements,
    int? pageNumber,
    bool? hasMore,
    bool? loadingMore,
  }) =>
      OpsBoardState(
        rows: rows ?? this.rows,
        totalElements: totalElements ?? this.totalElements,
        pageNumber: pageNumber ?? this.pageNumber,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

final opsBoardControllerProvider =
    AsyncNotifierProvider<OpsBoardController, OpsBoardState>(OpsBoardController.new);

class OpsBoardController extends AsyncNotifier<OpsBoardState> {
  OperationsRepository get _repo => ref.read(operationsRepositoryProvider);

  @override
  Future<OpsBoardState> build() async => _fetchFirstPage(ref.watch(opsQueryProvider));

  Future<OpsBoardState> _fetchFirstPage(OpsQuery query) async {
    final page = await _repo.getBoard(
      tab: query.tab,
      from: query.from,
      to: query.to,
      search: query.search,
    );
    return OpsBoardState(
      rows: page.rows,
      totalElements: page.totalElements,
      pageNumber: page.pageNumber,
      hasMore: page.hasMore,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _fetchFirstPage(ref.read(opsQueryProvider)));
    ref
      ..invalidate(opsTabCountsProvider)
      ..invalidate(opsSummaryProvider);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));

    try {
      final query = ref.read(opsQueryProvider);
      final next = await _repo.getBoard(
        tab: query.tab,
        from: query.from,
        to: query.to,
        search: query.search,
        page: current.pageNumber + 1,
      );

      state = AsyncData(
        current.copyWith(
          rows: [...current.rows, ...next.rows],
          pageNumber: next.pageNumber,
          hasMore: next.hasMore,
          totalElements: next.totalElements,
          loadingMore: false,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
      rethrow;
    }
  }
}

/// One booking's checkpoints.
final opsDetailProvider = FutureProvider.autoDispose.family<OpsDetail, String>(
  (ref, bookingId) => ref.watch(operationsRepositoryProvider).getCheckpoints(bookingId),
);

/// Confirm or update one checkpoint, then refresh what depends on it.
final opsActionsProvider = Provider.autoDispose<OpsActions>(OpsActions.new);

class OpsActions {
  OpsActions(this._ref);

  final Ref _ref;

  Future<void> setCheckpointStatus(
    String bookingId,
    String checkpointId,
    OpsCheckpointStatus status, {
    String? vendorName,
    String? referenceNo,
    String? notes,
  }) async {
    await _ref.read(operationsRepositoryProvider).updateCheckpoint(
          checkpointId,
          status: status,
          vendorName: vendorName,
          referenceNo: referenceNo,
          notes: notes,
        );
    // Severity and readiness are derived server-side, so both the detail and
    // the board have to be re-read rather than patched locally.
    _ref
      ..invalidate(opsDetailProvider(bookingId))
      ..invalidate(opsBoardControllerProvider)
      ..invalidate(opsTabCountsProvider)
      ..invalidate(opsSummaryProvider);
  }
}
