import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/di.dart';
import '../../../domain/entities/quotation.dart';
import '../../../domain/entities/quotation_enums.dart';
import '../../../domain/repositories/quotation_repository.dart';

@immutable
class QuotationsState {
  const QuotationsState({
    this.quotations = const [],
    this.totalElements = 0,
    this.pageNumber = 0,
    this.hasMore = false,
    this.loadingMore = false,
  });

  final List<QuotationSummary> quotations;
  final int totalElements;
  final int pageNumber;
  final bool hasMore;
  final bool loadingMore;

  /// Sum of the loaded rows' grand totals — labelled in the UI as covering the
  /// loaded page, never presented as a global pipeline figure the server did
  /// not supply.
  double get loadedValue =>
      quotations.fold<double>(0, (sum, q) => sum + q.grandTotal);

  /// Approved rows among those loaded. Like [loadedValue] this covers the rows
  /// in hand only — the list endpoint reports no per-stage totals.
  int get approvedCount =>
      quotations.where((q) => q.stage == QuotationStage.approved).length;

  QuotationsState copyWith({
    List<QuotationSummary>? quotations,
    int? totalElements,
    int? pageNumber,
    bool? hasMore,
    bool? loadingMore,
  }) =>
      QuotationsState(
        quotations: quotations ?? this.quotations,
        totalElements: totalElements ?? this.totalElements,
        pageNumber: pageNumber ?? this.pageNumber,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

final quotationFilterProvider =
    NotifierProvider<QuotationFilterNotifier, QuotationFilter>(QuotationFilterNotifier.new);

class QuotationFilterNotifier extends Notifier<QuotationFilter> {
  Timer? _debounce;

  @override
  QuotationFilter build() {
    ref.onDispose(() => _debounce?.cancel());
    return QuotationFilter.none;
  }

  void set(QuotationFilter filter) => state = filter;

  void setQuery(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      state = state.copyWith(search: query.trim().isEmpty ? null : query.trim());
    });
  }

  void setStage(QuotationStage? stage) => state = state.copyWith(stage: stage);

  void clear() => state = QuotationFilter(search: state.search);
}

final quotationsControllerProvider =
    AsyncNotifierProvider<QuotationsController, QuotationsState>(QuotationsController.new);

class QuotationsController extends AsyncNotifier<QuotationsState> {
  QuotationRepository get _repo => ref.read(quotationRepositoryProvider);

  @override
  Future<QuotationsState> build() async =>
      _fetchFirstPage(ref.watch(quotationFilterProvider));

  Future<QuotationsState> _fetchFirstPage(QuotationFilter filter) async {
    final page = await _repo.getQuotations(size: AppConfig.pageSize, filter: filter);
    return QuotationsState(
      quotations: page.quotations,
      totalElements: page.totalElements,
      pageNumber: page.pageNumber,
      hasMore: page.hasMore,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => _fetchFirstPage(ref.read(quotationFilterProvider)),
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));

    try {
      final next = await _repo.getQuotations(
        page: current.pageNumber + 1,
        size: AppConfig.pageSize,
        filter: ref.read(quotationFilterProvider),
      );

      state = AsyncData(
        current.copyWith(
          quotations: [...current.quotations, ...next.quotations],
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

  void upsert(QuotationSummary quotation) {
    final current = state.value;
    if (current == null) return;
    final index = current.quotations.indexWhere((q) => q.id == quotation.id);
    if (index < 0) return;
    final updated = [...current.quotations];
    updated[index] = quotation;
    state = AsyncData(current.copyWith(quotations: updated));
  }
}

final quotationDetailProvider = FutureProvider.autoDispose.family<Quotation, String>(
  (ref, publicId) => ref.watch(quotationRepositoryProvider).getQuotation(publicId),
);

/// Quotations raised for one lead — the lead detail screen's list.
final leadQuotationsProvider =
    FutureProvider.autoDispose.family<List<QuotationSummary>, String>(
  (ref, leadId) => ref.watch(quotationRepositoryProvider).getForLead(leadId),
);
