import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_dto.freezed.dart';
part 'customer_dto.g.dart';

/// Wire model for `customer/dto/CustomerResponse`.
///
/// `bookings`, `spent` and `lastBooking` are derived live by the server from
/// the customer's bookings — the client never computes them.
@freezed
abstract class CustomerDto with _$CustomerDto {
  const factory CustomerDto({
    /// Public UUID.
    String? id,

    /// Human code, e.g. `CUS10001`.
    String? customerId,
    String? name,
    String? phone,
    String? email,
    String? alternatePhone,
    String? type,
    String? commPref,
    String? tier,
    String? status,
    String? city,
    String? state,
    String? address,
    String? pincode,
    String? country,
    String? gstin,
    String? legalName,
    String? birthday,
    String? anniversary,
    String? passportNo,
    String? passportExpiry,
    String? nationality,
    String? panNo,
    String? notes,
    int? bookings,
    num? spent,
    String? lastBooking,
    String? createdAt,
  }) = _CustomerDto;

  factory CustomerDto.fromJson(Map<String, dynamic> json) => _$CustomerDtoFromJson(json);
}

/// `GET /api/customers/{id}/summary` → the customer-360 header.
///
/// `totalBilled` is tax-inclusive and is **not** the same figure as
/// `CustomerDto.spent`; `totalCollected` is gross of refunds, which are
/// reported separately rather than netted.
@freezed
abstract class CustomerSummaryDto with _$CustomerSummaryDto {
  const factory CustomerSummaryDto({
    String? id,
    String? customerId,
    String? name,
    String? legalName,
    String? phone,
    String? alternatePhone,
    String? email,
    String? type,
    String? tier,
    String? status,
    String? commPref,
    String? city,
    String? state,
    String? country,
    String? gstin,
    String? ownerUserName,
    num? totalBilled,
    num? totalCollected,
    num? outstanding,
    num? totalRefunded,
    int? activeBookingCount,
    int? cancelledBookingCount,
    String? lastBookingDate,
    String? nextDueTravelDate,
    int? leadCount,
    int? quotationCount,
    int? invoiceCount,
    int? documentCount,
    int? documentsExpiringSoon,
    String? passportExpiry,
    bool? hasPortalAccount,
  }) = _CustomerSummaryDto;

  factory CustomerSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerSummaryDtoFromJson(json);
}

/// `GET /api/customers/stats` — tenant-wide aggregates (CRM_FULL only, so a
/// sub-agent gets 403 and the tiles are hidden rather than zeroed).
@freezed
abstract class CustomerStatsDto with _$CustomerStatsDto {
  const factory CustomerStatsDto({
    int? total,
    int? active,
    int? inactive,
    int? blocked,
    int? vip,
    int? corporate,
    int? regular,
    num? totalRevenue,
    int? totalBookings,
    int? repeatCustomers,
  }) = _CustomerStatsDto;

  factory CustomerStatsDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerStatsDtoFromJson(json);
}
