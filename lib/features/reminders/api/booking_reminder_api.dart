import 'package:dio/dio.dart';

import '../../../data/remote/failure_mapper.dart';
import 'reminder_api.dart' show reminderTypeLabel, toWireInstant;

/// A reminder that hangs off a booking rather than a lead.
///
/// **A different module from [Reminder], not a variant of it.** Separate table
/// (`booking_reminders`), separate service that never touches the other, its
/// own type and status vocabularies, and it does not appear in the calendar
/// feed. The only thing the two share is the word.
class BookingReminder {
  const BookingReminder({
    required this.id,
    this.bookingCode,
    this.customerName,
    this.phone,
    this.destination,
    this.reminderType,
    this.message,
    this.travelDate,
    this.reminderDate,
    this.status,
    this.amount,
    this.createdAt,
  });

  factory BookingReminder.fromJson(Map<String, dynamic> json) =>
      BookingReminder(
        id: (json['id'] as num?)?.toInt() ?? 0,
        bookingCode: str(json['bookingCode']),
        customerName: str(json['customerName']),
        phone: str(json['phone']),
        destination: str(json['destination']),
        reminderType: str(json['reminderType']),
        message: str(json['message']),
        travelDate: instant(json['travelDate']),
        reminderDate: instant(json['reminderDate']),
        status: str(json['status']),
        amount: (json['amount'] as num?)?.toDouble(),
        createdAt: local(json['createdAt']),
      );

  /// `@PathVariable Long`, as on the other reminder module.
  final int id;

  final String? bookingCode;
  final String? customerName;
  final String? phone;
  final String? destination;

  /// One of [BookingReminderApi.types].
  final String? reminderType;

  final String? message;

  /// When the trip departs. `/upcoming` is keyed on this, not on
  /// [reminderDate] — see [BookingReminderApi.getUpcoming].
  final DateTime? travelDate;

  /// When this reminder is meant to fire. Local, converted from the Instant.
  final DateTime? reminderDate;

  /// `Pending`, `Sent` or `Completed`.
  final String? status;

  /// Money the reminder is about — a payment reminder without it says nothing.
  final double? amount;

  final DateTime? createdAt;

  /// Still worth acting on.
  bool get isOpen => status != 'Completed';

  /// Past due and not yet dealt with.
  bool get isOverdue {
    final due = reminderDate;
    if (due == null || !isOpen) return false;
    return due.isBefore(DateTime.now());
  }

  /// `Payment_due` → `Payment due`. Display only.
  String get typeLabel =>
      reminderType == null ? '—' : reminderTypeLabel(reminderType!);

  static String? str(Object? value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  /// A Java `Instant`, brought into local time — the same rule and the same
  /// reason as on the lead-side reminders.
  static DateTime? instant(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString())?.toLocal();
  }

  /// A Jackson `LocalDateTime`, which carries no zone and needs no shift.
  static DateTime? local(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

/// `GET /api/booking-reminders/stats`.
class BookingReminderStats {
  const BookingReminderStats({
    this.total = 0,
    this.pending = 0,
    this.sent = 0,
    this.completed = 0,
  });

  factory BookingReminderStats.fromJson(Map<String, dynamic> json) =>
      BookingReminderStats(
        total: (json['total'] as num?)?.toInt() ?? 0,
        pending: (json['pending'] as num?)?.toInt() ?? 0,
        sent: (json['sent'] as num?)?.toInt() ?? 0,
        completed: (json['completed'] as num?)?.toInt() ?? 0,
      );

  final int total;
  final int pending;
  final int sent;
  final int completed;
}

/// `BookingReminderController` — `/api/booking-reminders`.
///
/// Like the lead-side module, every route answers with the DTO **bare** — the
/// controller's own note says it returns "raw objects (no ApiResponse
/// envelope)". Unlike it, there is no class-level `@PreAuthorize` here: only
/// `quick-create/payment` names a permission (`REMINDER_CREATE`), and the rest
/// fall under SecurityConfig's authenticated rule.
class BookingReminderApi {
  const BookingReminderApi(this._dio);

  final Dio _dio;

  /// `BookingReminderType`, wire spelling — **not** the lead-side vocabulary.
  ///
  /// Note `Payment_due` here against `Payment` there. Mixing the two is the
  /// easy mistake, and this server drops an unrecognised filter silently
  /// instead of rejecting it, so the symptom would be a list that quietly
  /// ignores the filter rather than an error.
  static const types = [
    'Payment_due',
    'Final_payment',
    'Document',
    'Visa',
    'Travel_date',
    'Itinerary',
  ];

  /// `BookingReminderStatus` — three values, and no `OVERDUE` among them.
  static const statuses = ['Pending', 'Sent', 'Completed'];

  /// `GET /api/booking-reminders`, newest first as the server sorts them.
  Future<List<BookingReminder>> getAll({String? status}) => _list(
        '/api/booking-reminders',
        query: <String, dynamic>{'status': ?status},
      );

  /// `GET /api/booking-reminders/upcoming`.
  ///
  /// ⚠ "Upcoming" means **departing** soon, not due soon: the repository call
  /// is `findBy…TravelDateBetween(now, now + days)`. So this is the trips
  /// leaving this week and the reminders attached to them — which is the list
  /// worth chasing money on, but it is not "what fires next".
  Future<List<BookingReminder>> getUpcoming({int days = 7}) => _list(
        '/api/booking-reminders/upcoming',
        query: <String, dynamic>{'days': days},
      );

  /// `GET /api/booking-reminders/booking/{bookingCode}` — by the human code
  /// (`BK10005`), not by a UUID or the numeric id.
  Future<List<BookingReminder>> getForBooking(String bookingCode) =>
      _list('/api/booking-reminders/booking/$bookingCode');

  /// `GET /api/booking-reminders/stats`.
  Future<BookingReminderStats> getStats() async {
    try {
      final response =
          await _dio.get<dynamic>('/api/booking-reminders/stats');
      final data = response.data;
      return BookingReminderStats.fromJson(
        data is Map<String, dynamic> ? data : const <String, dynamic>{},
      );
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/booking-reminders/quick-create/payment` → 201.
  ///
  /// The one create this app offers, and the only route in the module that
  /// names a permission (`REMINDER_CREATE`). It always writes a `Payment_due`
  /// row, and takes the booking by **publicId** — the one place this module
  /// uses a UUID rather than the booking code.
  ///
  /// `amount` is validated `@DecimalMin("0.01")`, so a zero is rejected rather
  /// than stored as a reminder about nothing.
  Future<BookingReminder> createPaymentReminder({
    required String bookingPublicId,
    required DateTime reminderDate,
    required double amount,
    String? message,
  }) =>
      _write(
        'POST',
        '/api/booking-reminders/quick-create/payment',
        body: <String, dynamic>{
          'bookingPublicId': bookingPublicId,
          'reminderDate': toWireInstant(reminderDate),
          'amount': amount,
          'message': ?_trimToNull(message),
        },
      );

  /// `PATCH /api/booking-reminders/{id}/complete`.
  Future<BookingReminder> markComplete(int id) =>
      _write('PATCH', '/api/booking-reminders/$id/complete');

  /// `PATCH /api/booking-reminders/{id}/pending` — puts one back on the list.
  ///
  /// The lead-side module has no equivalent: there, a completed reminder stays
  /// completed. Here it can be reopened, so a reminder marked done in error is
  /// recoverable.
  Future<BookingReminder> markPending(int id) =>
      _write('PATCH', '/api/booking-reminders/$id/pending');

  // `POST /{id}/send-now` is deliberately not wired.
  //
  // It sends over WhatsApp and answers 422 "WhatsApp is not configured. Set it
  // up in Settings → WhatsApp first." until the tenant's provider is set up
  // server-side — verified live against a reminder that does carry a phone
  // number. A button that can only fail is worse than no button; it belongs
  // here once WhatsApp is configured, which is not something this app can do.

  Future<List<BookingReminder>> _list(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await _dio.get<dynamic>(path, queryParameters: query);
      return bookingRemindersFrom(response.data);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<BookingReminder> _write(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        options: Options(method: method),
      );
      final data = response.data;
      return BookingReminder.fromJson(
        data is Map<String, dynamic> ? data : const <String, dynamic>{},
      );
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static String? _trimToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

/// Read a booking-reminder list off whatever the server sent.
List<BookingReminder> bookingRemindersFrom(Object? data) {
  final rows = switch (data) {
    List<dynamic> list => list,
    Map<String, dynamic> map when map['data'] is List => map['data'] as List,
    _ => const <dynamic>[],
  };
  return rows
      .whereType<Map<String, dynamic>>()
      .map(BookingReminder.fromJson)
      .toList(growable: false);
}
