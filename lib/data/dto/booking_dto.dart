import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_dto.freezed.dart';
part 'booking_dto.g.dart';

/// Wire model for `booking/dto/BookingResponseDTO`.
///
/// Every money figure here is **server-derived** — `gst`, `tcs`,
/// `totalPayable`, `pendingAmount` and `netProfit` are computed by the backend
/// and rejected if sent in a request. The client only ever displays them.
///
/// Profit fields (`netProfit`, `totalVendorCosts`, …) are omitted entirely for
/// callers without the profit-read permission, so they arrive as null.
@freezed
abstract class BookingDto with _$BookingDto {
  const factory BookingDto({
    String? publicId,
    String? bookingCode,
    String? customerId,
    String? customerNameSnapshot,
    String? destinationSnapshot,
    String? sourceLeadPublicId,
    String? sourceQuotationPublicId,
    String? assignedUserId,
    String? assignedUserName,
    String? bookingDate,
    String? travelDate,
    bool? overseasTourPackage,
    num? customerAmount,
    num? vendorCost,
    String? vendorPublicId,
    String? vendorName,
    num? gst,
    num? tcs,
    num? totalPayable,
    num? paidAmount,
    num? pendingAmount,
    num? refundedAmount,
    num? netProfit,
    String? status,
    String? paymentStatus,
    @Default(<String>[]) List<String> services,
    String? tripSnapshot,
    String? createdAt,
  }) = _BookingDto;

  factory BookingDto.fromJson(Map<String, dynamic> json) => _$BookingDtoFromJson(json);
}

/// `GET /api/bookings/stats` — requires CRM_FULL.
@freezed
abstract class BookingStatsDto with _$BookingStatsDto {
  const factory BookingStatsDto({
    int? totalBookings,
    int? confirmedBookings,
    int? pendingBookings,
    int? cancelledBookings,
    int? completedBookings,
    int? refundedBookings,
    num? totalRevenue,
    num? totalCollected,
    num? totalPending,
    num? totalRefundAmount,
    // Only present with the profit-read permission.
    num? netProfit,
    num? totalVendorCost,
  }) = _BookingStatsDto;

  factory BookingStatsDto.fromJson(Map<String, dynamic> json) =>
      _$BookingStatsDtoFromJson(json);
}

/// One row of `GET /api/bookings/{id}/services` — a hotel, vehicle, flight or
/// other service on the booking, with its confirmation state.
@freezed
abstract class BookingServiceDto with _$BookingServiceDto {
  const factory BookingServiceDto({
    String? publicId,
    String? serviceType,
    String? title,
    String? status,
    String? vendorName,
    String? confirmationNumber,
    String? serviceDate,
    num? cost,
  }) = _BookingServiceDto;

  factory BookingServiceDto.fromJson(Map<String, dynamic> json) =>
      _$BookingServiceDtoFromJson(json);
}
