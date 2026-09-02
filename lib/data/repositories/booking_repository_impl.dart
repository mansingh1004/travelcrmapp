import '../../core/errors/failure.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/booking_enums.dart';
import '../../domain/repositories/booking_repository.dart';
import '../mappers/booking_mapper.dart';
import '../services/booking_api.dart';

class BookingRepositoryImpl implements BookingRepository {
  const BookingRepositoryImpl(this._api);

  final BookingApi _api;

  @override
  Future<BookingPage> getBookings({
    int page = 0,
    int size = 20,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    BookingFilter filter = BookingFilter.none,
  }) async {
    // With no facet set, use the paged endpoint. With one set, the server only
    // offers unpaged search/filter — so page it client-side and report the real
    // total, rather than pretending there is more to fetch.
    if (filter.appliedCount == 0) {
      final envelope = await _api.getBookings(
        page: page,
        size: size,
        sortBy: sortBy,
        sortDir: sortDir,
      );
      return BookingPage(
        bookings: envelope.content
            .map(BookingMapper.toEntity)
            .where((b) => b.id.isNotEmpty)
            .toList(growable: false),
        pageNumber: envelope.pageNumber,
        totalElements: envelope.totalElements,
        hasMore: envelope.hasMore,
      );
    }

    final search = filter.search?.trim();
    final rows = (search != null && search.isNotEmpty)
        ? await _api.searchBookings(search)
        : await _api.filterBookings(
            status: filter.status?.wire,
            paymentStatus: filter.paymentStatus?.wire,
          );

    var bookings = rows
        .map(BookingMapper.toEntity)
        .where((b) => b.id.isNotEmpty)
        .toList(growable: false);

    // `/search` matches text only, so any status facet set alongside it still
    // has to be honoured here.
    if (search != null && search.isNotEmpty) {
      if (filter.status != null) {
        bookings = bookings.where((b) => b.status == filter.status).toList(growable: false);
      }
      if (filter.paymentStatus != null) {
        bookings = bookings
            .where((b) => b.paymentStatus == filter.paymentStatus)
            .toList(growable: false);
      }
    }

    final start = page * size;
    final slice = start >= bookings.length
        ? const <Booking>[]
        : bookings.sublist(start, (start + size).clamp(0, bookings.length));

    return BookingPage(
      bookings: slice,
      pageNumber: page,
      totalElements: bookings.length,
      hasMore: start + slice.length < bookings.length,
    );
  }

  @override
  Future<Booking> getBooking(String publicId) async =>
      BookingMapper.toEntity(await _api.getBooking(publicId));

  @override
  Future<List<BookingService>> getServices(String publicId) async {
    final rows = await _api.getServices(publicId);
    return rows.map(BookingMapper.toService).toList(growable: false);
  }

  @override
  Future<Booking> changeStatus(String publicId, BookingStatus status) async =>
      BookingMapper.toEntity(await _api.changeStatus(publicId, status.wire));

  @override
  Future<BookingStats?> getStats() async {
    try {
      return BookingMapper.toStats(await _api.getStats());
    } on PermissionFailure {
      // Stats are CRM_FULL-only; a sub-agent simply sees no tiles.
      return null;
    }
  }
}
