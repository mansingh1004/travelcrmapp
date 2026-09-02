import 'package:flutter/foundation.dart';

import 'booking_enums.dart';
import 'operations_enums.dart';

/// One booking on the operations board.
///
/// Readiness, severity and the days-to-departure countdown are all computed
/// **server-side** against the tenant's clock — the app displays them, so a
/// device with a wrong clock cannot mislabel a departure as urgent.
@immutable
class OpsBoardRow {
  const OpsBoardRow({
    required this.bookingId,
    this.bookingCode,
    required this.customerName,
    this.destination,
    this.travelDate,
    this.tripEndDate,
    this.daysToDeparture,
    this.status,
    this.paymentStatus,
    required this.readiness,
    required this.dimensionCounts,
    required this.suppliersConfirmed,
    required this.suppliersTotal,
    required this.pax,
    required this.balanceDue,
    required this.needsAttention,
    this.overallStatus,
    this.severity,
    this.opsOwnerName,
    this.readyToTravel = false,
  });

  final String bookingId;
  final String? bookingCode;
  final String customerName;
  final String? destination;
  final DateTime? travelDate;
  final DateTime? tripEndDate;

  /// Negative once departure has passed.
  final int? daysToDeparture;

  final BookingStatus? status;
  final PaymentStatus? paymentStatus;

  /// All eight dimensions, always present.
  final Map<OpsDimension, OpsReadinessStatus> readiness;
  final Map<OpsDimension, ({int confirmed, int total})> dimensionCounts;

  final int suppliersConfirmed;
  final int suppliersTotal;

  /// Adults + children; infants excluded by the server.
  final int pax;

  final double balanceDue;
  final bool needsAttention;
  final OpsOverallStatus? overallStatus;

  /// Null for a booking with no ops record yet.
  final OpsSeverity? severity;

  final String? opsOwnerName;
  final bool readyToTravel;

  String get supplierLabel => '$suppliersConfirmed/$suppliersTotal confirmed';

  /// `Departs today` / `In 3 days` / `Departed 2 days ago`.
  String? get departureLabel {
    final days = daysToDeparture;
    if (days == null) return null;
    if (days == 0) return 'Departs today';
    if (days == 1) return 'Departs tomorrow';
    if (days > 0) return 'In $days days';
    return 'Departed ${-days} day${days == -1 ? '' : 's'} ago';
  }
}

/// `GET /api/operations/summary` — headline cards for the window.
@immutable
class OpsSummary {
  const OpsSummary({
    this.from,
    this.to,
    required this.totalBookings,
    required this.ready,
    required this.actionNeeded,
    required this.urgent,
    required this.balancePending,
  });

  final DateTime? from;
  final DateTime? to;
  final int totalBookings;
  final int ready;
  final int actionNeeded;
  final int urgent;
  final double balancePending;
}

/// One booking's operational standing, with its nine checkpoints.
@immutable
class OpsDetail {
  const OpsDetail({
    required this.bookingId,
    this.bookingCode,
    this.opsOwnerName,
    this.departureAt,
    this.departureSourceLabel,
    this.tripEndDate,
    this.pickupLocation,
    this.pickupAt,
    this.dropLocation,
    this.dropAt,
    this.severity,
    this.hoursToDeparture,
    required this.readyToTravel,
    required this.checkpoints,
  });

  final String bookingId;
  final String? bookingCode;
  final String? opsOwnerName;
  final DateTime? departureAt;

  /// How the departure time was arrived at — 'pickup time', 'assumed' or
  /// 'date only'. Shown so an assumed time is never mistaken for a real one.
  final String? departureSourceLabel;

  final DateTime? tripEndDate;
  final String? pickupLocation;
  final DateTime? pickupAt;
  final String? dropLocation;
  final DateTime? dropAt;

  final OpsSeverity? severity;
  final int? hoursToDeparture;

  /// True when no mandatory checkpoint is outstanding. Server-derived.
  final bool readyToTravel;

  final List<OpsCheckpointFact> checkpoints;

  int get confirmedCount => checkpoints.where((c) => !c.isOutstanding).length;
}

/// One checkpoint row.
@immutable
class OpsCheckpointFact {
  const OpsCheckpointFact({
    required this.id,
    this.checkpoint,
    this.status,
    this.vendorName,
    this.referenceNo,
    this.notes,
    this.dueAt,
    this.mandatory = false,
  });

  final String id;
  final OpsCheckpoint? checkpoint;
  final OpsCheckpointStatus? status;
  final String? vendorName;
  final String? referenceNo;
  final String? notes;
  final DateTime? dueAt;
  final bool mandatory;

  String get label => checkpoint?.label ?? 'Checkpoint';

  bool get isOutstanding => status?.isOutstanding ?? true;
}
