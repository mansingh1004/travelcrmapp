import 'package:freezed_annotation/freezed_annotation.dart';

part 'operations_dto.freezed.dart';
part 'operations_dto.g.dart';

/// One row of `GET /api/operations/board`.
///
/// `readiness` and `dimensionCounts` are keyed by `OpsDimension`; the server
/// always sends all eight dimensions, so a missing key means a parse problem
/// rather than "not applicable".
@freezed
abstract class OpsBoardRowDto with _$OpsBoardRowDto {
  const factory OpsBoardRowDto({
    String? bookingPublicId,
    String? bookingCode,
    String? customerName,
    String? destination,
    String? travelDate,
    String? tripEndDate,

    /// Negative once departure has passed. Computed against the tenant's clock.
    int? daysToDeparture,
    String? status,
    String? paymentStatus,
    @Default(<String, String>{}) Map<String, String> readiness,
    @Default(<String, DimensionCountDto>{}) Map<String, DimensionCountDto> dimensionCounts,
    int? suppliersConfirmed,
    int? suppliersTotal,
    int? pax,
    num? balanceDue,
    bool? needsAttention,
    String? overallStatus,

    /// Null for bookings with no ops record yet — the UI falls back to the
    /// readiness map rather than showing a blank severity.
    OpsStandingDto? ops,
  }) = _OpsBoardRowDto;

  factory OpsBoardRowDto.fromJson(Map<String, dynamic> json) =>
      _$OpsBoardRowDtoFromJson(json);
}

@freezed
abstract class DimensionCountDto with _$DimensionCountDto {
  const factory DimensionCountDto({int? confirmed, int? total}) = _DimensionCountDto;

  factory DimensionCountDto.fromJson(Map<String, dynamic> json) =>
      _$DimensionCountDtoFromJson(json);
}

/// The ops record attached to a booking — severity and ownership.
@freezed
abstract class OpsStandingDto with _$OpsStandingDto {
  const factory OpsStandingDto({
    String? severity,
    int? hoursToDeparture,
    String? departureAt,
    String? departureAtSourceLabel,
    String? opsOwnerPublicId,
    String? opsOwnerName,
    bool? readyToTravel,
  }) = _OpsStandingDto;

  factory OpsStandingDto.fromJson(Map<String, dynamic> json) =>
      _$OpsStandingDtoFromJson(json);
}

/// `GET /api/operations/summary` — the window headline cards. Counted over
/// every booking in the window, not just the visible page.
@freezed
abstract class OpsSummaryDto with _$OpsSummaryDto {
  const factory OpsSummaryDto({
    String? from,
    String? to,
    int? totalBookings,
    int? ready,
    int? actionNeeded,
    int? urgent,
    num? balancePending,
  }) = _OpsSummaryDto;

  factory OpsSummaryDto.fromJson(Map<String, dynamic> json) => _$OpsSummaryDtoFromJson(json);
}

/// `GET /api/operations/bookings/{id}/checkpoints` — one booking's standing.
@freezed
abstract class OpsDetailDto with _$OpsDetailDto {
  const factory OpsDetailDto({
    String? publicId,
    String? bookingPublicId,
    String? bookingCode,
    String? opsOwnerPublicId,
    String? opsOwnerName,
    String? departureAt,
    String? departureAtSourceLabel,
    String? tripEndDate,
    String? pickupLocation,
    String? pickupAt,
    String? dropLocation,
    String? dropAt,
    String? severity,
    int? hoursToDeparture,
    bool? readyToTravel,
    @Default(<OpsCheckpointDto>[]) List<OpsCheckpointDto> checkpoints,
  }) = _OpsDetailDto;

  factory OpsDetailDto.fromJson(Map<String, dynamic> json) => _$OpsDetailDtoFromJson(json);
}

/// One of the nine checkpoints on a booking.
@freezed
abstract class OpsCheckpointDto with _$OpsCheckpointDto {
  const factory OpsCheckpointDto({
    String? publicId,
    String? checkpoint,
    String? status,
    String? source,
    String? vendorName,
    String? referenceNo,
    String? notes,
    String? dueAt,
    bool? mandatory,
  }) = _OpsCheckpointDto;

  factory OpsCheckpointDto.fromJson(Map<String, dynamic> json) =>
      _$OpsCheckpointDtoFromJson(json);
}
