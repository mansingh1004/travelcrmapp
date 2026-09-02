/// Booking enums. Unlike the lead/customer ones these carry **no**
/// `@JsonValue`, so the wire value is the plain constant name.
library;

String _fold(String value) =>
    value.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');

/// `booking.enums.BookingStatus`.
enum BookingStatus {
  confirmed('CONFIRMED', 'Confirmed'),
  pending('PENDING', 'Pending'),
  cancelled('CANCELLED', 'Cancelled'),
  completed('COMPLETED', 'Completed'),
  refunded('REFUNDED', 'Refunded');

  const BookingStatus(this.wire, this.label);

  final String wire;
  final String label;

  static BookingStatus? tryParse(String? value) =>
      _parse(value, BookingStatus.values, (e) => e.wire);
}

/// `booking.enums.PaymentStatus` — derived server-side from paid vs payable.
enum PaymentStatus {
  paid('PAID', 'Paid'),
  partial('PARTIAL', 'Part paid'),
  unpaid('UNPAID', 'Unpaid'),
  refunded('REFUNDED', 'Refunded');

  const PaymentStatus(this.wire, this.label);

  final String wire;
  final String label;

  static PaymentStatus? tryParse(String? value) =>
      _parse(value, PaymentStatus.values, (e) => e.wire);
}

/// Per-service confirmation state — what drives the ops-readiness chips.
enum ServiceItemStatus {
  pending('PENDING', 'Pending'),
  requested('REQUESTED', 'Requested'),
  confirmed('CONFIRMED', 'Confirmed'),
  cancelled('CANCELLED', 'Cancelled');

  const ServiceItemStatus(this.wire, this.label);

  final String wire;
  final String label;

  static ServiceItemStatus? tryParse(String? value) =>
      _parse(value, ServiceItemStatus.values, (e) => e.wire);
}

T? _parse<T extends Enum>(String? value, List<T> values, String Function(T) wireOf) {
  if (value == null || value.isEmpty) return null;
  final key = _fold(value);
  for (final entry in values) {
    if (_fold(wireOf(entry)) == key || _fold(entry.name) == key) return entry;
  }
  return null;
}
