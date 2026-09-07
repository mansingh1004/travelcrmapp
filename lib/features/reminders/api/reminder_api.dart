import 'package:dio/dio.dart';

import '../../../data/remote/failure_mapper.dart';

/// One reminder, as the app reads it.
///
/// Reminders are mostly created *for* the agent rather than by them: logging a
/// follow-up on a lead raises one, and `ReminderScheduler` flips it to
/// `OVERDUE` once its due date passes. So the phone's job is to show what is
/// owed today and let it be acted on — complete, snooze, dismiss.
class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    this.description,
    this.type,
    this.priority,
    this.status,
    this.leadPublicId,
    this.leadName,
    this.phone,
    this.assignToName,
    this.dueDate,
    this.snoozedUntil,
    this.notes,
    this.createdAt,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: str(json['title']) ?? 'Untitled reminder',
        description: str(json['description']),
        type: str(json['type']),
        priority: str(json['priority']),
        status: str(json['status']),
        leadPublicId: str(json['leadPublicId']),
        // `leadName` and `phone` are the legacy string columns, but they are
        // the only customer identity on the row the list can show without a
        // second call — `leadDisplayCode` came back null on every live row.
        leadName: str(json['leadName']),
        phone: str(json['phone']),
        assignToName: str(json['assignToName']),
        dueDate: _instant(json['dueDate']),
        snoozedUntil: _instant(json['snoozedUntil']),
        notes: str(json['notes']),
        // `createdAt` is a Jackson LocalDateTime — no zone designator — so it
        // parses as local already and must NOT be shifted like the two above.
        createdAt: _local(json['createdAt']),
      );

  /// `@PathVariable Long` — every reminder route is keyed on this numeric id,
  /// not on a UUID like most of this backend.
  final int id;

  final String title;
  final String? description;

  /// One of [types]. Mixed case on the wire — `Follow_up`, not `FOLLOW_UP`.
  final String? type;

  /// `High`, `Medium` or `Low`.
  final String? priority;

  /// `Active`, `Snoozed`, `Completed`, `Dismissed` or `OVERDUE`.
  final String? status;

  /// The lead this hangs off, when it came from a follow-up.
  final String? leadPublicId;

  final String? leadName;
  final String? phone;
  final String? assignToName;

  /// Due moment in **local** time — see [_instant].
  final DateTime? dueDate;

  final DateTime? snoozedUntil;
  final String? notes;
  final DateTime? createdAt;

  /// Past due and still open.
  ///
  /// Both `Active` and `OVERDUE` count: the scheduler flips the stored status
  /// on its own clock, so a reminder that just came due is still `Active` for
  /// a while. `ReminderServiceImpl.OVERDUE_STATUSES` treats them the same way.
  bool get isOverdue {
    final due = dueDate;
    if (due == null) return false;
    if (status == 'Completed' || status == 'Dismissed') return false;
    return status == 'OVERDUE' || due.isBefore(DateTime.now());
  }

  /// Whether acting on this still changes anything.
  bool get isOpen => status != 'Completed' && status != 'Dismissed';

  /// `Follow_up` → `Follow up`, for display only. Never send this back.
  String get typeLabel => type == null ? '—' : reminderTypeLabel(type!);

  static String? str(Object? value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  /// Parse a Java `Instant` — `"2026-09-10T09:30:00Z"`, always zoned UTC.
  ///
  /// `.toLocal()` is the whole point: a reminder set for 09:00 IST comes back
  /// as `03:30Z`, and showing the parsed value straight would put it on the
  /// wrong side of breakfast — and, near midnight, on the wrong day.
  static DateTime? _instant(Object? value) {
    if (value == null) return null;
    final parsed = DateTime.tryParse(value.toString());
    return parsed?.toLocal();
  }

  /// Parse a Java `LocalDateTime` — `"2026-08-31T17:15:20.978041"`, no zone.
  static DateTime? _local(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

/// `GET /api/reminders/stats`. Needs `CRM_FULL`, so sub-agents get a 403.
class ReminderStats {
  const ReminderStats({
    this.total = 0,
    this.active = 0,
    this.overdue = 0,
    this.completed = 0,
    this.snoozed = 0,
  });

  factory ReminderStats.fromJson(Map<String, dynamic> json) => ReminderStats(
        total: (json['total'] as num?)?.toInt() ?? 0,
        active: (json['active'] as num?)?.toInt() ?? 0,
        overdue: (json['overdue'] as num?)?.toInt() ?? 0,
        completed: (json['completed'] as num?)?.toInt() ?? 0,
        snoozed: (json['snoozed'] as num?)?.toInt() ?? 0,
      );

  final int total;
  final int active;
  final int overdue;
  final int completed;
  final int snoozed;
}

/// `ReminderController` — `/api/reminders`.
///
/// **Every route here answers with the DTO bare — no `ApiResponse` wrapper.**
/// The controller returns `ResponseEntity<List<ReminderResponseDto>>`, and a
/// live `GET /api/reminders` opens with `[`, not `{`. Reading a `data` node off
/// these would find nothing.
///
/// Permissions are `REMINDER_READ` / `_CREATE` / `_UPDATE` / `_DELETE`.
/// `TRAVEL_AGENT` holds every one except `_DELETE`, so deletion is left out of
/// this client entirely — dismissing is the reversible equivalent and is what
/// an agent is allowed to do.
class ReminderApi {
  const ReminderApi(this._dio);

  final Dio _dio;

  /// The five values `ReminderStatus` takes, **exactly as spelled on the wire**.
  ///
  /// Note `OVERDUE` is the one screaming-case member; the rest are capitalised
  /// words. That is not a typo here — it is the enum.
  static const statuses = ['Active', 'Snoozed', 'Completed', 'Dismissed', 'OVERDUE'];

  /// `ReminderType`, wire spelling. `Follow_up` carries an underscore.
  static const types = [
    'First_contact',
    'Follow_up',
    'Quotation',
    'Payment',
    'Document',
    'Birthday',
    'Confirmation',
    'Custom',
  ];

  /// `ReminderPriority`, wire spelling.
  static const priorities = ['High', 'Medium', 'Low'];

  /// `GET /api/reminders` — filtered server-side, sorted by due date ascending.
  ///
  /// ⚠ The filters are matched with `ReminderStatus.valueOf(value.trim())`,
  /// which is **case-sensitive and fails silently**: `parseStatus` swallows the
  /// `IllegalArgumentException` and returns null, which drops the clause. Live
  /// proof on the same ten rows — `?status=ACTIVE` → 10 rows (filter gone),
  /// `?status=Active` → 0 rows (the real answer). Only pass values from
  /// [statuses], [types] and [priorities]; anything else quietly returns
  /// everything and looks like it worked.
  Future<List<Reminder>> getReminders({
    String? status,
    String? priority,
    String? type,
  }) =>
      _list(
        '/api/reminders',
        query: <String, dynamic>{
          'status': ?status,
          'priority': ?priority,
          'type': ?type,
        },
      );

  /// `GET /api/reminders/overdue` — open and past due, oldest first.
  Future<List<Reminder>> getOverdue() => _list('/api/reminders/overdue');

  /// `GET /api/reminders/due-today`.
  ///
  /// "Today" is measured in the **tenant's** zone server-side, not UTC and not
  /// the phone's — so the client sends no date and must not compute its own.
  Future<List<Reminder>> getDueToday() => _list('/api/reminders/due-today');

  /// `GET /api/reminders/stats` — needs `CRM_FULL`.
  Future<ReminderStats> getStats() async {
    try {
      final response = await _dio.get<dynamic>('/api/reminders/stats');
      final data = response.data;
      return ReminderStats.fromJson(
        data is Map<String, dynamic> ? data : const <String, dynamic>{},
      );
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/reminders` → 201 with the new row.
  ///
  /// Only `title` and `dueDate` are validated (`@NotBlank` / `@NotNull`), and
  /// the server sets `status` to `Active` itself — sending one would be a guess
  /// at a field it owns.
  Future<Reminder> createReminder({
    required String title,
    required DateTime dueDate,
    String? description,
    String? type,
    String? priority,
    String? leadPublicId,
    String? notes,
  }) =>
      _write(
        'POST',
        '/api/reminders',
        body: <String, dynamic>{
          'title': title.trim(),
          'dueDate': toWireInstant(dueDate),
          'description': ?_trimToNull(description),
          'type': ?type,
          'priority': ?priority,
          'leadPublicId': ?_trimToNull(leadPublicId),
          'notes': ?_trimToNull(notes),
        },
      );

  /// `PUT /api/reminders/{id}` — a **partial** update despite the verb.
  ///
  /// `ReminderMapper.updateEntity` "applies only the non-null fields", so an
  /// omitted key leaves that column alone rather than blanking it. Only what
  /// the form actually changed goes out.
  ///
  /// Moving `dueDate` also revives the reminder: the service clears `notified`
  /// on any date change and, if the caller states no status, flips an `OVERDUE`
  /// row back to `Active` — because OVERDUE is precisely the state a reminder
  /// gets rescheduled from, and it would otherwise keep a badge it no longer
  /// earns while staying silent.
  Future<Reminder> updateReminder(
    int id, {
    String? title,
    DateTime? dueDate,
    String? description,
    String? type,
    String? priority,
    String? notes,
  }) =>
      _write(
        'PUT',
        '/api/reminders/$id',
        body: <String, dynamic>{
          'title': ?_trimToNull(title),
          'dueDate': ?(dueDate == null ? null : toWireInstant(dueDate)),
          'description': ?_trimToNull(description),
          'type': ?type,
          'priority': ?priority,
          'notes': ?_trimToNull(notes),
        },
      );

  /// `PATCH /api/reminders/{id}/complete`.
  Future<Reminder> markComplete(int id) =>
      _write('PATCH', '/api/reminders/$id/complete');

  /// `PATCH /api/reminders/{id}/dismiss`.
  Future<Reminder> dismiss(int id) =>
      _write('PATCH', '/api/reminders/$id/dismiss');

  /// `PATCH /api/reminders/{id}/snooze`.
  ///
  /// Sets the status to `Snoozed` and stores the new moment; it does not move
  /// `dueDate`, so the original commitment stays on the record.
  Future<Reminder> snooze(int id, DateTime until) => _write(
        'PATCH',
        '/api/reminders/$id/snooze',
        body: <String, dynamic>{'snoozedUntil': toWireInstant(until)},
      );

  /// `POST /api/reminders/{id}/logs` — appends one timestamped line.
  Future<Reminder> addLog(int id, String log) => _write(
        'POST',
        '/api/reminders/$id/logs',
        body: <String, dynamic>{'log': log.trim()},
      );

  Future<List<Reminder>> _list(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await _dio.get<dynamic>(path, queryParameters: query);
      return remindersFrom(response.data);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<Reminder> _write(
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
      return Reminder.fromJson(
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

/// Read a reminder list off whatever the server sent.
///
/// The bare array is what this controller actually returns; the enveloped
/// branch is there so the app keeps working if these routes are ever brought
/// into line with the rest of the API.
List<Reminder> remindersFrom(Object? data) {
  final rows = switch (data) {
    List<dynamic> list => list,
    Map<String, dynamic> map when map['data'] is List => map['data'] as List,
    _ => const <dynamic>[],
  };
  return rows
      .whereType<Map<String, dynamic>>()
      .map(Reminder.fromJson)
      .toList(growable: false);
}

/// `Follow_up` → `Follow up`.
///
/// Display only. The underscore is part of the enum, so the wire value has to
/// travel back untouched — a filter built from a prettified label matches
/// nothing, and this server drops an unmatched filter without complaining.
String reminderTypeLabel(String wire) => wire.replaceAll('_', ' ');

/// Format a moment the way `Instant` expects it: UTC, `Z`-suffixed.
///
/// A local `DateTime` is converted first. Sending the wall-clock time with a
/// `Z` on it would book the reminder 5½ hours early for an Indian agency.
String toWireInstant(DateTime moment) =>
    '${moment.toUtc().toIso8601String().split('.').first}Z';
