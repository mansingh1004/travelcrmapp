import '../../core/formatters/app_date.dart';
import '../../domain/entities/booking_enums.dart';
import '../../domain/entities/operations.dart';
import '../../domain/entities/operations_enums.dart';
import '../dto/operations_dto.dart';

abstract final class OperationsMapper {
  static OpsBoardRow toBoardRow(OpsBoardRowDto dto) {
    final readiness = <OpsDimension, OpsReadinessStatus>{};
    dto.readiness.forEach((key, value) {
      final dimension = OpsDimension.tryParse(key);
      final status = OpsReadinessStatus.tryParse(value);
      if (dimension != null && status != null) readiness[dimension] = status;
    });

    final counts = <OpsDimension, ({int confirmed, int total})>{};
    dto.dimensionCounts.forEach((key, value) {
      final dimension = OpsDimension.tryParse(key);
      if (dimension != null) {
        counts[dimension] = (confirmed: value.confirmed ?? 0, total: value.total ?? 0);
      }
    });

    return OpsBoardRow(
      bookingId: dto.bookingPublicId ?? '',
      bookingCode: _blankToNull(dto.bookingCode),
      customerName: dto.customerName?.trim() ?? '',
      destination: _blankToNull(dto.destination),
      travelDate: AppDate.parseDate(dto.travelDate),
      tripEndDate: AppDate.parseDate(dto.tripEndDate),
      daysToDeparture: dto.daysToDeparture,
      status: BookingStatus.tryParse(dto.status),
      paymentStatus: PaymentStatus.tryParse(dto.paymentStatus),
      readiness: readiness,
      dimensionCounts: counts,
      suppliersConfirmed: dto.suppliersConfirmed ?? 0,
      suppliersTotal: dto.suppliersTotal ?? 0,
      pax: dto.pax ?? 0,
      balanceDue: dto.balanceDue?.toDouble() ?? 0,
      needsAttention: dto.needsAttention ?? false,
      overallStatus: OpsOverallStatus.tryParse(dto.overallStatus),
      severity: OpsSeverity.tryParse(dto.ops?.severity),
      opsOwnerName: _blankToNull(dto.ops?.opsOwnerName),
      readyToTravel: dto.ops?.readyToTravel ?? false,
    );
  }

  static OpsSummary toSummary(OpsSummaryDto dto) => OpsSummary(
        from: AppDate.parseDate(dto.from),
        to: AppDate.parseDate(dto.to),
        totalBookings: dto.totalBookings ?? 0,
        ready: dto.ready ?? 0,
        actionNeeded: dto.actionNeeded ?? 0,
        urgent: dto.urgent ?? 0,
        balancePending: dto.balancePending?.toDouble() ?? 0,
      );

  static OpsDetail toDetail(OpsDetailDto dto) => OpsDetail(
        bookingId: dto.bookingPublicId ?? '',
        bookingCode: _blankToNull(dto.bookingCode),
        opsOwnerName: _blankToNull(dto.opsOwnerName),
        departureAt: AppDate.parseDateTime(dto.departureAt),
        departureSourceLabel: _blankToNull(dto.departureAtSourceLabel),
        tripEndDate: AppDate.parseDate(dto.tripEndDate),
        pickupLocation: _blankToNull(dto.pickupLocation),
        pickupAt: AppDate.parseDateTime(dto.pickupAt),
        dropLocation: _blankToNull(dto.dropLocation),
        dropAt: AppDate.parseDateTime(dto.dropAt),
        severity: OpsSeverity.tryParse(dto.severity),
        hoursToDeparture: dto.hoursToDeparture,
        readyToTravel: dto.readyToTravel ?? false,
        checkpoints: dto.checkpoints.map(toCheckpoint).toList(growable: false),
      );

  static OpsCheckpointFact toCheckpoint(OpsCheckpointDto dto) => OpsCheckpointFact(
        id: dto.publicId ?? '',
        checkpoint: OpsCheckpoint.tryParse(dto.checkpoint),
        status: OpsCheckpointStatus.tryParse(dto.status),
        vendorName: _blankToNull(dto.vendorName),
        referenceNo: _blankToNull(dto.referenceNo),
        notes: _blankToNull(dto.notes),
        dueAt: AppDate.parseDateTime(dto.dueAt),
        mandatory: dto.mandatory ?? false,
      );

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
