import 'package:dio/dio.dart';

import '../../core/formatters/app_date.dart';
import '../../domain/entities/payment.dart';
import '../dto/envelopes.dart';
import '../remote/failure_mapper.dart';

/// `BookingPaymentController` — `/api/bookings/{id}/payments`.
///
/// Payments live **under a booking**; there is no global payments collection,
/// so the Payments screen is assembled from the bookings list plus these
/// per-booking ledgers.
///
/// Mapped inline: the payload is flat, so a freezed DTO plus mapper would only
/// add indirection.
class PaymentApi {
  const PaymentApi(this._dio);

  final Dio _dio;

  /// `GET /api/bookings/{bookingPublicId}/payments`.
  Future<List<Payment>> getPayments(String bookingPublicId) async {
    try {
      final response =
          await _dio.get<dynamic>('/api/bookings/$bookingPublicId/payments');
      final envelope = ApiEnvelope.from<List<Payment>>(
        response.data,
        (data) => (data! as List)
            .whereType<Map<String, dynamic>>()
            .map(_toPayment)
            .toList(growable: false),
      );
      return envelope.data ?? const [];
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/bookings/{bookingPublicId}/payments` — record a receipt.
  ///
  /// Only `amount` is required; everything else is optional and the server
  /// stamps the current user and today's date when they are omitted.
  Future<Payment> recordPayment(
    String bookingPublicId, {
    required double amount,
    String? paymentType,
    String? method,
    String? account,
    String? paidByName,
    DateTime? date,
    String? reference,
    String? notes,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/bookings/$bookingPublicId/payments',
        data: <String, dynamic>{
          'amount': amount,
          'paymentType': ?paymentType,
          'paymentMethod': ?method,
          'paymentAccount': ?account,
          'paidByName': ?paidByName,
          if (date != null) 'paymentDate': AppDate.toWire(date),
          'reference': ?reference,
          'notes': ?notes,
        },
      );

      final envelope = ApiEnvelope.from<Payment>(
        response.data,
        (data) => _toPayment(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static Payment _toPayment(Map<String, dynamic> json) => Payment(
        id: json['publicId'] as String? ?? '',
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        entryType: PaymentEntryType.tryParse(json['entryType'] as String?),
        paymentType: _blankToNull(json['paymentType'] as String?),
        method: _blankToNull(json['paymentMethod'] as String?),
        account: _blankToNull(json['paymentAccount'] as String?),
        paidByName: _blankToNull(json['paidByName'] as String?),
        receivedByName: _blankToNull(json['receivedByName'] as String?),
        date: AppDate.parseDate(json['paymentDate'] as String?),
        reference: _blankToNull(json['reference'] as String?),
        notes: _blankToNull(json['notes'] as String?),
        amended: json['amended'] as bool? ?? false,
        amendmentReason: _blankToNull(json['amendmentReason'] as String?),
        createdBy: _blankToNull(json['createdBy'] as String?),
      );

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
