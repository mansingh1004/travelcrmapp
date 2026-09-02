import '../entities/booking.dart';
import '../entities/booking_enums.dart';

/// Booking list filters.
///
/// The server splits these across two endpoints: `GET /api/bookings` pages but
/// takes no facets, while `GET /api/bookings/filter` takes facets but returns
/// everything unpaged. The repository picks whichever fits the request.
class BookingFilter {
  const BookingFilter({this.search, this.status, this.paymentStatus});

  final String? search;
  final BookingStatus? status;
  final PaymentStatus? paymentStatus;

  static const none = BookingFilter();

  int get appliedCount => [
        search?.trim().isNotEmpty ?? false,
        status != null,
        paymentStatus != null,
      ].where((applied) => applied).length;

  BookingFilter copyWith({
    Object? search = _unset,
    Object? status = _unset,
    Object? paymentStatus = _unset,
  }) =>
      BookingFilter(
        search: search == _unset ? this.search : search as String?,
        status: status == _unset ? this.status : status as BookingStatus?,
        paymentStatus:
            paymentStatus == _unset ? this.paymentStatus : paymentStatus as PaymentStatus?,
      );

  static const _unset = Object();
}

class BookingPage {
  const BookingPage({
    required this.bookings,
    required this.pageNumber,
    required this.totalElements,
    required this.hasMore,
  });

  final List<Booking> bookings;
  final int pageNumber;
  final int totalElements;
  final bool hasMore;

  static const empty =
      BookingPage(bookings: [], pageNumber: 0, totalElements: 0, hasMore: false);
}

abstract interface class BookingRepository {
  Future<BookingPage> getBookings({
    int page,
    int size,
    String sortBy,
    String sortDir,
    BookingFilter filter,
  });

  Future<Booking> getBooking(String publicId);

  /// The service rows whose confirmation state drives ops readiness.
  Future<List<BookingService>> getServices(String publicId);

  Future<Booking> changeStatus(String publicId, BookingStatus status);

  /// Null when the caller lacks CRM_FULL.
  Future<BookingStats?> getStats();
}
