import 'package:flutter/foundation.dart';

import 'booking_enums.dart';

/// A booking, mapped from `BookingResponseDTO`.
///
/// **No money is computed here.** GST, TCS, the payable total, the balance and
/// profit all arrive already calculated — the server owns those rules and
/// rejects them if sent in a request.
@immutable
class Booking {
  const Booking({
    required this.id,
    this.code,
    required this.customerName,
    this.customerId,
    this.destination,
    this.leadId,
    this.quotationId,
    this.agentName,
    this.bookingDate,
    this.travelDate,
    this.vendorName,
    required this.customerAmount,
    required this.gst,
    required this.tcs,
    required this.totalPayable,
    required this.paidAmount,
    required this.pendingAmount,
    required this.refundedAmount,
    this.netProfit,
    this.status,
    this.paymentStatus,
    this.services = const [],
    this.tripSummary,
    this.createdAt,
    this.overseas = false,
  });

  final String id;

  /// Human reference, e.g. `BK-26-0142`.
  final String? code;

  final String customerName;
  final String? customerId;
  final String? destination;

  /// Set when the booking came from a converted lead.
  final String? leadId;
  final String? quotationId;

  final String? agentName;
  final DateTime? bookingDate;
  final DateTime? travelDate;
  final String? vendorName;

  final double customerAmount;
  final double gst;
  final double tcs;
  final double totalPayable;
  final double paidAmount;

  /// Balance still owed — server-derived, never `totalPayable - paidAmount`
  /// computed here (adjustments and refunds also feed it).
  final double pendingAmount;

  final double refundedAmount;

  /// Null unless the caller holds the profit-read permission.
  final double? netProfit;

  final BookingStatus? status;
  final PaymentStatus? paymentStatus;

  /// Free-text service labels on the booking header.
  final List<String> services;

  final String? tripSummary;
  final DateTime? createdAt;
  final bool overseas;

  String get initials {
    final parts = customerName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// 0–1 for the payment progress bar. Guards a zero total so a fully unpaid
  /// booking does not render as complete.
  double get paidFraction {
    if (totalPayable <= 0) return 0;
    return (paidAmount / totalPayable).clamp(0.0, 1.0);
  }

  /// Days until travel; negative once it has passed.
  int? get daysToTravel {
    final date = travelDate;
    if (date == null) return null;
    final now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  @override
  bool operator ==(Object other) => other is Booking && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// One service line on a booking, with its confirmation state — the input to
/// the operations-readiness view.
@immutable
class BookingService {
  const BookingService({
    required this.id,
    this.type,
    this.title,
    this.status,
    this.vendorName,
    this.confirmationNumber,
    this.serviceDate,
    this.cost,
  });

  final String id;
  final String? type;
  final String? title;
  final ServiceItemStatus? status;
  final String? vendorName;
  final String? confirmationNumber;
  final DateTime? serviceDate;
  final double? cost;

  bool get isConfirmed => status == ServiceItemStatus.confirmed;
}

/// `GET /api/bookings/stats`.
@immutable
class BookingStats {
  const BookingStats({
    required this.total,
    required this.confirmed,
    required this.pending,
    required this.cancelled,
    required this.completed,
    required this.refunded,
    required this.totalRevenue,
    required this.totalCollected,
    required this.totalPending,
    required this.totalRefunded,
    this.netProfit,
  });

  final int total;
  final int confirmed;
  final int pending;
  final int cancelled;
  final int completed;
  final int refunded;

  final double totalRevenue;
  final double totalCollected;
  final double totalPending;
  final double totalRefunded;

  /// Null unless the caller holds the profit-read permission.
  final double? netProfit;

  int countFor(BookingStatus? status) => switch (status) {
        null => total,
        BookingStatus.confirmed => confirmed,
        BookingStatus.pending => pending,
        BookingStatus.cancelled => cancelled,
        BookingStatus.completed => completed,
        BookingStatus.refunded => refunded,
      };
}
