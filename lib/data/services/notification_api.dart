import 'package:dio/dio.dart';

import '../../core/formatters/app_date.dart';
import '../dto/envelopes.dart';
import '../remote/failure_mapper.dart';

/// One notification row.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    this.message,
    this.type,
    required this.unread,
    this.referenceType,
    this.referenceId,
    this.createdAt,
  });

  final String id;
  final String title;
  final String? message;

  /// Free-form on the wire — modules emit types beyond the documented set, so
  /// this stays a String and unknown values simply get the default icon.
  final String? type;

  final bool unread;

  /// LEAD / BOOKING / REMINDER / CUSTOMER / VENDOR / TASK.
  final String? referenceType;
  final String? referenceId;

  final DateTime? createdAt;
}

/// `NotificationController` — `/api/notifications`.
class NotificationApi {
  const NotificationApi(this._dio);

  final Dio _dio;

  Future<List<AppNotification>> getNotifications({int page = 0, int size = 30}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/notifications',
        queryParameters: {'page': page, 'size': size},
      );

      // This endpoint has been seen both paged and flat, so accept either
      // rather than failing on the wrapper.
      final data = response.data;
      final rows = <Map<String, dynamic>>[];
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is List) {
          rows.addAll(inner.whereType<Map<String, dynamic>>());
        } else if (inner is Map<String, dynamic> && inner['content'] is List) {
          rows.addAll((inner['content'] as List).whereType<Map<String, dynamic>>());
        }
      }
      return rows.map(_toNotification).toList(growable: false);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get<dynamic>('/api/notifications/unread-count');
      final envelope = ApiEnvelope.from<int>(
        response.data,
        (data) => data is num
            ? data.toInt()
            : (data is Map<String, dynamic>
                ? (data['count'] as num?)?.toInt() ?? 0
                : 0),
      );
      return envelope.data ?? 0;
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<void> markRead(String publicId) async {
    try {
      await _dio.put<dynamic>('/api/notifications/$publicId/read');
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<void> markAllRead() async {
    try {
      await _dio.put<dynamic>('/api/notifications/read-all');
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static AppNotification _toNotification(Map<String, dynamic> json) => AppNotification(
        id: json['publicId'] as String? ?? '',
        title: (json['title'] as String?)?.trim() ?? '',
        message: _blankToNull(json['message'] as String?),
        type: _blankToNull(json['type'] as String?),
        unread: (json['status'] as String?)?.toUpperCase() != 'READ',
        referenceType: _blankToNull(json['referenceType'] as String?),
        referenceId: _blankToNull(json['referencePublicId'] as String?),
        createdAt: AppDate.parseDateTime(json['createdAt'] as String?),
      );

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
