import 'package:dio/dio.dart';

import '../remote/failure_mapper.dart';

/// What kind of work a task is. These map closely onto the calendar's own
/// event vocabulary, which is why the calendar's "add event" writes a task.
enum TaskCategory {
  followUp('FOLLOW_UP', 'Follow-up'),
  call('CALL', 'Call'),
  meeting('MEETING', 'Meeting'),
  payment('PAYMENT', 'Payment'),
  document('DOCUMENT', 'Document'),
  visa('VISA', 'Visa'),
  travel('TRAVEL', 'Travel'),
  general('GENERAL', 'General');

  const TaskCategory(this.wire, this.label);

  final String wire;
  final String label;
}

enum TaskPriority {
  low('LOW', 'Low'),
  medium('MEDIUM', 'Medium'),
  high('HIGH', 'High'),
  urgent('URGENT', 'Urgent');

  const TaskPriority(this.wire, this.label);

  final String wire;
  final String label;
}

/// `TaskController` — `/api/tasks`.
///
/// Only the create call is used: the calendar reads tasks back through
/// `GET /api/calendar`, which already merges them with the other six sources.
class TaskApi {
  const TaskApi(this._dio);

  final Dio _dio;

  /// `POST /api/tasks` — requires `TASK_CREATE`.
  ///
  /// The calendar plots a task at `startAt`, falling back to `dueDate` when
  /// `startAt` is null. Both are sent as the same instant so the row lands on
  /// the chosen day whichever field the server reads.
  ///
  /// Times go out as **UTC instants**; the picker works in local time.
  Future<void> createTask({
    required String title,
    required DateTime at,
    required bool allDay,
    TaskCategory? category,
    TaskPriority? priority,
    String? location,
    String? notes,
    /// Links the task to a lead, so it shows in that lead's work as well as on
    /// the calendar. This is how the create-lead wizard stores a follow-up's
    /// **time** and **type** — the lead's own `followUpDate` is a date only.
    String? leadPublicId,
  }) async {
    try {
      final instant = at.toUtc().toIso8601String();

      await _dio.post<dynamic>(
        '/api/tasks',
        data: <String, dynamic>{
          'title': title.trim(),
          'category': ?category?.wire,
          'priority': ?priority?.wire,
          'startAt': instant,
          'dueDate': instant,
          'allDay': allDay,
          'location': ?location,
          'notes': ?notes,
          'leadPublicId': ?leadPublicId,
        },
      );
    } on DioException catch (e) {
      // A 403 here means the role lacks TASK_CREATE — the mapper turns that
      // into a PermissionFailure, which the sheet reports as a permission
      // problem rather than a form error.
      throw FailureMapper.from(e);
    }
  }
}
