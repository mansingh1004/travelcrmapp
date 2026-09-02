import 'package:flutter/foundation.dart';

import 'customer_enums.dart';

/// A customer, mapped from `CustomerResponse`.
///
/// `bookings`, `spent` and `lastBooking` are **server-derived** from the
/// customer's real bookings — the client never sums anything itself.
@immutable
class Customer {
  const Customer({
    required this.id,
    this.code,
    required this.name,
    required this.phone,
    this.email,
    this.alternatePhone,
    this.type,
    this.tier,
    this.status,
    this.commPref,
    this.city,
    this.state,
    this.address,
    this.pincode,
    this.country,
    this.gstin,
    this.legalName,
    this.birthday,
    this.anniversary,
    this.passportNo,
    this.passportExpiry,
    this.panNo,
    this.nationality,
    this.notes,
    this.bookingCount = 0,
    this.spent,
    this.lastBooking,
    this.createdAt,
  });

  /// Public UUID.
  final String id;

  /// Human code, e.g. `CUS10001`.
  final String? code;

  final String name;
  final String phone;
  final String? email;
  final String? alternatePhone;

  final CustomerType? type;
  final LoyaltyTier? tier;
  final CustomerStatus? status;
  final CommunicationPreference? commPref;

  final String? city;
  final String? state;
  final String? address;
  final String? pincode;
  final String? country;

  final String? gstin;
  final String? legalName;

  final DateTime? birthday;
  final DateTime? anniversary;
  final String? passportNo;
  final DateTime? passportExpiry;
  final String? panNo;
  final String? nationality;
  final String? notes;

  /// Lifetime bookings, derived server-side.
  final int bookingCount;

  /// Lifetime value, derived server-side.
  final double? spent;

  final DateTime? lastBooking;
  final DateTime? createdAt;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// `Pune, Maharashtra` — whichever parts exist.
  String get locationLabel =>
      [city, state].where((p) => p != null && p.isNotEmpty).join(', ');

  @override
  bool operator ==(Object other) => other is Customer && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// `GET /api/customers/{id}/summary` — the customer-360 header.
@immutable
class CustomerSummary {
  const CustomerSummary({
    required this.id,
    this.code,
    required this.name,
    this.legalName,
    required this.phone,
    this.alternatePhone,
    this.email,
    this.type,
    this.tier,
    this.status,
    this.city,
    this.state,
    this.country,
    this.gstin,
    this.ownerName,
    required this.totalBilled,
    required this.totalCollected,
    required this.outstanding,
    required this.totalRefunded,
    required this.activeBookingCount,
    required this.cancelledBookingCount,
    this.lastBookingDate,
    this.nextDueTravelDate,
    required this.leadCount,
    required this.quotationCount,
    required this.invoiceCount,
    required this.documentCount,
    required this.documentsExpiringSoon,
    this.passportExpiry,
    this.hasPortalAccount = false,
  });

  final String id;
  final String? code;
  final String name;
  final String? legalName;
  final String phone;
  final String? alternatePhone;
  final String? email;

  final CustomerType? type;
  final LoyaltyTier? tier;
  final CustomerStatus? status;

  final String? city;
  final String? state;
  final String? country;
  final String? gstin;
  final String? ownerName;

  /// Sum of `totalPayable`, tax-inclusive. Not the same figure as
  /// [Customer.spent].
  final double totalBilled;

  /// Sum of `paidAmount`, **gross of refunds** — [totalRefunded] is reported
  /// alongside rather than netted off, because they are different facts.
  final double totalCollected;

  final double outstanding;
  final double totalRefunded;

  final int activeBookingCount;
  final int cancelledBookingCount;
  final DateTime? lastBookingDate;

  /// When a balance is due by travel date — not an instalment due date.
  final DateTime? nextDueTravelDate;

  final int leadCount;
  final int quotationCount;
  final int invoiceCount;
  final int documentCount;
  final int documentsExpiringSoon;
  final DateTime? passportExpiry;
  final bool hasPortalAccount;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

/// `GET /api/customers/stats` — tenant-wide aggregates.
@immutable
class CustomerStats {
  const CustomerStats({
    required this.total,
    required this.active,
    required this.inactive,
    required this.blocked,
    required this.vip,
    required this.corporate,
    required this.regular,
    required this.totalRevenue,
    required this.totalBookings,
    required this.repeatCustomers,
  });

  final int total;
  final int active;
  final int inactive;
  final int blocked;
  final int vip;
  final int corporate;
  final int regular;
  final double totalRevenue;
  final int totalBookings;

  /// Customers with three or more bookings.
  final int repeatCustomers;
}
