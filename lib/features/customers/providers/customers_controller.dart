import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/di.dart';
import '../../../domain/entities/customer.dart';
import '../../../domain/entities/customer_enums.dart';
import '../../../domain/repositories/customer_repository.dart';

/// Sort options. `sortBy` maps to a real `Customer` column server-side.
enum CustomerSort {
  recent('createdAt', 'desc', 'Recently added'),
  nameAsc('name', 'asc', 'Name (A–Z)'),
  lastBooking('lastBooking', 'desc', 'Last booking');

  const CustomerSort(this.field, this.direction, this.label);

  final String field;
  final String direction;
  final String label;
}

@immutable
class CustomersState {
  const CustomersState({
    this.customers = const [],
    this.totalElements = 0,
    this.pageNumber = 0,
    this.hasMore = false,
    this.loadingMore = false,
  });

  final List<Customer> customers;
  final int totalElements;
  final int pageNumber;
  final bool hasMore;
  final bool loadingMore;

  CustomersState copyWith({
    List<Customer>? customers,
    int? totalElements,
    int? pageNumber,
    bool? hasMore,
    bool? loadingMore,
  }) =>
      CustomersState(
        customers: customers ?? this.customers,
        totalElements: totalElements ?? this.totalElements,
        pageNumber: pageNumber ?? this.pageNumber,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

final customerSortProvider =
    NotifierProvider<CustomerSortNotifier, CustomerSort>(CustomerSortNotifier.new);

class CustomerSortNotifier extends Notifier<CustomerSort> {
  @override
  CustomerSort build() => CustomerSort.recent;

  void set(CustomerSort sort) => state = sort;
}

final customerFilterProvider =
    NotifierProvider<CustomerFilterNotifier, CustomerFilter>(CustomerFilterNotifier.new);

class CustomerFilterNotifier extends Notifier<CustomerFilter> {
  Timer? _debounce;

  @override
  CustomerFilter build() {
    ref.onDispose(() => _debounce?.cancel());
    return CustomerFilter.none;
  }

  void set(CustomerFilter filter) => state = filter;

  /// Debounced so typing does not fire a request per keystroke.
  void setQuery(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      state = state.copyWith(search: query.trim().isEmpty ? null : query.trim());
    });
  }

  void setStatus(CustomerStatus? status) => state = state.copyWith(status: status);

  void clear() => state = CustomerFilter(search: state.search);
}

/// Tenant-wide aggregates. Resolves to `null` when the caller lacks CRM_FULL,
/// which the UI treats as "hide the tiles", not as an error.
final customerStatsProvider = FutureProvider.autoDispose<CustomerStats?>(
  (ref) => ref.watch(customerRepositoryProvider).getStats(),
);

final customersControllerProvider =
    AsyncNotifierProvider<CustomersController, CustomersState>(CustomersController.new);

class CustomersController extends AsyncNotifier<CustomersState> {
  CustomerRepository get _repo => ref.read(customerRepositoryProvider);

  @override
  Future<CustomersState> build() async {
    final sort = ref.watch(customerSortProvider);
    final filter = ref.watch(customerFilterProvider);
    return _fetchFirstPage(sort, filter);
  }

  Future<CustomersState> _fetchFirstPage(CustomerSort sort, CustomerFilter filter) async {
    final page = await _repo.getCustomers(
      page: 0,
      size: AppConfig.pageSize,
      sortBy: sort.field,
      sortDir: sort.direction,
      filter: filter,
    );

    return CustomersState(
      customers: page.customers,
      totalElements: page.totalElements,
      pageNumber: page.pageNumber,
      hasMore: page.hasMore,
    );
  }

  Future<void> refresh() async {
    final sort = ref.read(customerSortProvider);
    final filter = ref.read(customerFilterProvider);
    state = await AsyncValue.guard(() => _fetchFirstPage(sort, filter));
    ref.invalidate(customerStatsProvider);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));

    try {
      final sort = ref.read(customerSortProvider);
      final next = await _repo.getCustomers(
        page: current.pageNumber + 1,
        size: AppConfig.pageSize,
        sortBy: sort.field,
        sortDir: sort.direction,
        filter: ref.read(customerFilterProvider),
      );

      state = AsyncData(
        current.copyWith(
          customers: [...current.customers, ...next.customers],
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
}

/// The customer-360 header — the detail screen's only eager call.
final customerSummaryProvider =
    FutureProvider.autoDispose.family<CustomerSummary, String>(
  (ref, publicId) => ref.watch(customerRepositoryProvider).getSummary(publicId),
);

/// The full record, for the contact and personal-details sections.
final customerDetailProvider = FutureProvider.autoDispose.family<Customer, String>(
  (ref, publicId) => ref.watch(customerRepositoryProvider).getCustomer(publicId),
);
