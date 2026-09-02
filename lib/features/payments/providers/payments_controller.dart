import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../../../domain/entities/booking.dart';
import '../../../domain/entities/payment.dart';

/// Bookings with money still owed, worst first.
///
/// There is no global receivables endpoint, so this is assembled from the
/// bookings list: every booking carries a server-computed `pendingAmount`.
final receivablesProvider = FutureProvider.autoDispose<List<Booking>>((ref) async {
  final page = await ref.watch(bookingRepositoryProvider).getBookings(size: 100);
  final owing = page.bookings.where((b) => b.pendingAmount > 0).toList()
    // Nearest travel date first — that is when the money actually has to land.
    ..sort((a, b) {
      final at = a.travelDate;
      final bt = b.travelDate;
      if (at == null && bt == null) return b.pendingAmount.compareTo(a.pendingAmount);
      if (at == null) return 1;
      if (bt == null) return -1;
      return at.compareTo(bt);
    });
  return owing;
});

/// Bookings that are fully settled — the "collected" side of the screen.
final collectedProvider = FutureProvider.autoDispose<List<Booking>>((ref) async {
  final page = await ref.watch(bookingRepositoryProvider).getBookings(size: 100);
  return page.bookings
      .where((b) => b.pendingAmount <= 0 && b.paidAmount > 0)
      .toList(growable: false);
});

/// Money roll-up. Null when the caller lacks CRM_FULL, in which case the
/// screen hides the summary rather than showing zeroes.
final paymentStatsProvider = FutureProvider.autoDispose<BookingStats?>(
  (ref) => ref.watch(bookingRepositoryProvider).getStats(),
);

/// One booking's ledger.
final bookingPaymentsProvider =
    FutureProvider.autoDispose.family<List<Payment>, String>(
  (ref, bookingId) => ref.watch(paymentApiProvider).getPayments(bookingId),
);

/// Record a receipt, then refresh everything that shows the balance.
final paymentActionsProvider = Provider.autoDispose<PaymentActions>(PaymentActions.new);

class PaymentActions {
  PaymentActions(this._ref);

  final Ref _ref;

  Future<Payment> record(
    String bookingId, {
    required double amount,
    String? paymentType,
    String? method,
    String? reference,
    String? notes,
    DateTime? date,
  }) async {
    final payment = await _ref.read(paymentApiProvider).recordPayment(
          bookingId,
          amount: amount,
          paymentType: paymentType,
          method: method,
          reference: reference,
          notes: notes,
          date: date,
        );

    // The balance and payment status are derived server-side, so every view of
    // them has to be re-read rather than adjusted locally.
    _ref
      ..invalidate(bookingPaymentsProvider(bookingId))
      ..invalidate(receivablesProvider)
      ..invalidate(collectedProvider)
      ..invalidate(paymentStatsProvider);
    return payment;
  }
}
