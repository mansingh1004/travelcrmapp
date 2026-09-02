import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/di.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/entities/booking_enums.dart';
import '../../../domain/repositories/booking_repository.dart';

@immutable
class BookingsState {
  const BookingsState({
    this.bookings = const [],
    this.totalElements = 0,
    this.pageNumber = 0,
    this.hasMore = false,
    this.loadingMore = false,
  });

  final List<Booking> bookings;
  final int totalElements;
  final int pageNumber;
  final bool hasMore;
  final bool loadingMore;

  BookingsState copyWith({
    List<Booking>? bookings,
    int? totalElements,
    int? pageNumber,
    bool? hasMore,
    bool? loadingMore,
  }) =>
      BookingsState(
        bookings: bookings ?? this.bookings,
        totalElements: totalElements ?? this.totalElements,
        pageNumber: pageNumber ?? this.pageNumber,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

final bookingFilterProvider =
    NotifierProvider<BookingFilterNotifier, BookingFilter>(BookingFilterNotifier.new);

class BookingFilterNotifier extends Notifier<BookingFilter> {
  Timer? _debounce;

  @override
  BookingFilter build() {
    ref.onDispose(() => _debounce?.cancel());
    return BookingFilter.none;
  }

  void set(BookingFilter filter) => state = filter;

  void setQuery(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      state = state.copyWith(search: query.trim().isEmpty ? null : query.trim());
    });
  }

  void setStatus(BookingStatus? status) => state = state.copyWith(status: status);

  void clear() => state = BookingFilter(search: state.search);
}

/// Status counts and money roll-up. Null when the caller lacks CRM_FULL.
final bookingStatsProvider = FutureProvider.autoDispose<BookingStats?>(
  (ref) => ref.watch(bookingRepositoryProvider).getStats(),
);

final bookingsControllerProvider =
    AsyncNotifierProvider<BookingsController, BookingsState>(BookingsController.new);

class BookingsController extends AsyncNotifier<BookingsState> {
  BookingRepository get _repo => ref.read(bookingRepositoryProvider);

  @override
  Future<BookingsState> build() async {
    final filter = ref.watch(bookingFilterProvider);
    return _fetchFirstPage(filter);
  }

  Future<BookingsState> _fetchFirstPage(BookingFilter filter) async {
    final page = await _repo.getBookings(size: AppConfig.pageSize, filter: filter);
    return BookingsState(
      bookings: page.bookings,
      totalElements: page.totalElements,
      pageNumber: page.pageNumber,
      hasMore: page.hasMore,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => _fetchFirstPage(ref.read(bookingFilterProvider)),
    );
    ref.invalidate(bookingStatsProvider);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));

    try {
      final next = await _repo.getBookings(
        page: current.pageNumber + 1,
        size: AppConfig.pageSize,
        filter: ref.read(bookingFilterProvider),
      );

      state = AsyncData(
        current.copyWith(
          bookings: [...current.bookings, ...next.bookings],
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

  void upsert(Booking booking) {
    final current = state.value;
    if (current == null) return;
    final index = current.bookings.indexWhere((b) => b.id == booking.id);
    if (index < 0) return;
    final updated = [...current.bookings];
    updated[index] = booking;
    state = AsyncData(current.copyWith(bookings: updated));
  }
}

final bookingDetailProvider = FutureProvider.autoDispose.family<Booking, String>(
  (ref, publicId) => ref.watch(bookingRepositoryProvider).getBooking(publicId),
);

/// The booking's service rows — hotels, vehicles, flights and their
/// confirmation state.
final bookingServicesProvider =
    FutureProvider.autoDispose.family<List<BookingService>, String>(
  (ref, publicId) => ref.watch(bookingRepositoryProvider).getServices(publicId),
);
