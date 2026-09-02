import 'package:flutter/foundation.dart';

/// Money in or out. A refund is stored as a separate entry rather than a
/// negative receipt, so the two are never netted by accident.
enum PaymentEntryType {
  receipt('RECEIPT', 'Received'),
  refund('REFUND', 'Refunded');

  const PaymentEntryType(this.wire, this.label);

  final String wire;
  final String label;

  static PaymentEntryType tryParse(String? value) {
    if (value == null || value.isEmpty) return PaymentEntryType.receipt;
    return value.toUpperCase() == 'REFUND'
        ? PaymentEntryType.refund
        : PaymentEntryType.receipt;
  }
}

/// One row of a booking's payment ledger.
@immutable
class Payment {
  const Payment({
    required this.id,
    required this.amount,
    required this.entryType,
    this.paymentType,
    this.method,
    this.account,
    this.paidByName,
    this.receivedByName,
    this.date,
    this.reference,
    this.notes,
    this.amended = false,
    this.amendmentReason,
    this.createdBy,
  });

  final String id;
  final double amount;
  final PaymentEntryType entryType;

  /// Free label the agency chose — Advance / Partial / Balance.
  final String? paymentType;

  final String? method;
  final String? account;
  final String? paidByName;
  final String? receivedByName;
  final DateTime? date;
  final String? reference;
  final String? notes;

  /// True when the entry was later corrected — shown so a changed figure is
  /// never mistaken for the original.
  final bool amended;
  final String? amendmentReason;

  final String? createdBy;

  bool get isRefund => entryType == PaymentEntryType.refund;
}
