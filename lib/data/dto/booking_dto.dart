import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_dto.freezed.dart';
part 'booking_dto.g.dart';

/// Reads `tripSnapshot` into the one line the booking screen shows.
///
/// The field is a **`TripSnapshotResponse` object**, not a string — traveller,
/// departure and itinerary detail — and reading it straight into a `String?`
/// throws a `TypeError` out of the generated `fromJson`. It went unnoticed
/// because the seeded bookings carry no snapshot; converting a lead is the
/// first path that fills one, and the whole response then failed to parse
/// after the booking had already been created.
///
/// A short route line is built from the itinerary legs (`Goa → Manali`)
/// because that is all the screen has room for. A plain string is still
/// accepted, in case an older row holds one.
Object? readTripSummary(Map<dynamic, dynamic> json, String key) {
  final value = json[key];
  if (value is String) return value;
  if (value is! Map) return null;

  final legs = value['itinerary'];
  if (legs is! List || legs.isEmpty) return value['packageType'];

  final stops = <String>[];
  for (final leg in legs.whereType<Map>()) {
    final city = leg['city'] ?? leg['destination'];
    if (city is String && city.isNotEmpty && !stops.contains(city)) {
      stops.add(city);
    }
  }
  return stops.isEmpty ? value['packageType'] : stops.join(' → ');
}

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
    @JsonKey(readValue: readTripSummary) String? tripSnapshot,
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
