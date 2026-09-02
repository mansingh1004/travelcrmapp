/// Operations enums. All are plain constant names on the wire.
library;

String _fold(String value) =>
    value.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');

/// The board's tab strip. Each tab is a real server predicate, so the counts
/// and the list always agree.
enum OpsBoardTab {
  all('ALL', 'All'),
  actionNeeded('ACTION_NEEDED', 'Action needed'),
  urgent('URGENT', 'Urgent'),
  departingToday('DEPARTING_TODAY', 'Departing today'),
  ready('READY', 'Ready'),
  notPlanned('NOT_PLANNED', 'Not planned'),
  unconfirmed('UNCONFIRMED', 'Unconfirmed'),
  awaitingSupplier('AWAITING_SUPPLIER', 'Awaiting supplier'),
  holdExpiring('HOLD_EXPIRING', 'Hold expiring'),
  paymentPending('PAYMENT_PENDING', 'Payment pending');

  const OpsBoardTab(this.wire, this.label);

  final String wire;
  final String label;
}

/// The eight readiness dimensions every board row reports.
enum OpsDimension {
  hotel('HOTEL', 'Hotel'),
  vehicle('VEHICLE', 'Vehicle'),
  travel('TRAVEL', 'Travel'),
  documents('DOCUMENTS', 'Documents'),
  activities('ACTIVITIES', 'Activities'),
  payment('PAYMENT', 'Payment'),
  guide('GUIDE', 'Guide'),
  other('OTHER', 'Other');

  const OpsDimension(this.wire, this.label);

  final String wire;
  final String label;

  static OpsDimension? tryParse(String? value) =>
      _parse(value, OpsDimension.values, (e) => e.wire);
}

enum OpsReadinessStatus {
  notStarted('NOT_STARTED', 'Not started'),
  inProgress('IN_PROGRESS', 'In progress'),
  ready('READY', 'Ready'),
  notApplicable('NOT_APPLICABLE', 'N/A');

  const OpsReadinessStatus(this.wire, this.label);

  final String wire;
  final String label;

  static OpsReadinessStatus? tryParse(String? value) =>
      _parse(value, OpsReadinessStatus.values, (e) => e.wire);
}

/// The row's headline state — Ready / Action needed / Urgent.
enum OpsOverallStatus {
  ready('READY', 'Ready'),
  actionNeeded('ACTION_NEEDED', 'Action needed'),
  urgent('URGENT', 'Urgent');

  const OpsOverallStatus(this.wire, this.label);

  final String wire;
  final String label;

  static OpsOverallStatus? tryParse(String? value) =>
      _parse(value, OpsOverallStatus.values, (e) => e.wire);
}

/// How close to breaking the booking is. Derived server-side at read time
/// against the tenant's clock — never stored, never computed here.
enum OpsSeverity {
  none('NONE', 'On track'),
  watch('WATCH', 'Watch'),
  warning('WARNING', 'Warning'),
  critical('CRITICAL', 'Critical');

  const OpsSeverity(this.wire, this.label);

  final String wire;
  final String label;

  static OpsSeverity? tryParse(String? value) =>
      _parse(value, OpsSeverity.values, (e) => e.wire);
}

/// The nine operational checkpoints on a booking.
enum OpsCheckpoint {
  hotel('HOTEL', 'Hotel'),
  transport('TRANSPORT', 'Transport'),
  driver('DRIVER', 'Driver'),
  sightseeing('SIGHTSEEING', 'Sightseeing'),
  customerPayment('CUSTOMER_PAYMENT', 'Customer payment'),
  vendorPayment('VENDOR_PAYMENT', 'Vendor payment'),
  tripAdvance('TRIP_ADVANCE', 'Trip advance'),
  docsVoucher('DOCS_VOUCHER', 'Documents & vouchers'),
  preDepartureCheck('PRE_DEPARTURE_CHECK', 'Pre-departure check');

  const OpsCheckpoint(this.wire, this.label);

  final String wire;
  final String label;

  static OpsCheckpoint? tryParse(String? value) =>
      _parse(value, OpsCheckpoint.values, (e) => e.wire);
}

enum OpsCheckpointStatus {
  pending('PENDING', 'Pending'),
  requested('REQUESTED', 'Requested'),
  confirmed('CONFIRMED', 'Confirmed'),
  rejected('REJECTED', 'Rejected'),
  expired('EXPIRED', 'Expired'),
  blocked('BLOCKED', 'Blocked'),
  notApplicable('NOT_APPLICABLE', 'N/A');

  const OpsCheckpointStatus(this.wire, this.label);

  final String wire;
  final String label;

  /// Whether this checkpoint still needs someone to act.
  bool get isOutstanding => switch (this) {
        OpsCheckpointStatus.confirmed || OpsCheckpointStatus.notApplicable => false,
        _ => true,
      };

  static OpsCheckpointStatus? tryParse(String? value) =>
      _parse(value, OpsCheckpointStatus.values, (e) => e.wire);
}

T? _parse<T extends Enum>(String? value, List<T> values, String Function(T) wireOf) {
  if (value == null || value.isEmpty) return null;
  final key = _fold(value);
  for (final entry in values) {
    if (_fold(wireOf(entry)) == key || _fold(entry.name) == key) return entry;
  }
  return null;
}
