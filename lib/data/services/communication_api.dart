import 'package:dio/dio.dart';

import '../../core/formatters/app_date.dart';
import '../dto/envelopes.dart';
import '../remote/failure_mapper.dart';

/// Which channel a thread runs on.
enum CommChannel {
  whatsapp('WHATSAPP', 'WhatsApp'),
  email('EMAIL', 'Email'),
  sms('SMS', 'SMS'),
  call('CALL', 'Call'),
  internalChat('INTERNAL_CHAT', 'Internal'),
  internalNote('INTERNAL_NOTE', 'Note');

  const CommChannel(this.wire, this.label);

  final String wire;
  final String label;

  static CommChannel? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    final key = value.toUpperCase();
    for (final c in CommChannel.values) {
      if (c.wire == key) return c;
    }
    return null;
  }
}

/// A conversation row.
class Conversation {
  const Conversation({
    required this.id,
    this.channel,
    this.subject,
    required this.contactName,
    this.contactValue,
    this.status,
    required this.unreadCount,
    this.lastMessageAt,
    this.lastMessagePreview,
    required this.awaitingReply,
    required this.freeTextAllowed,
    this.assignedUserName,
    this.leadId,
    this.customerId,
    this.bookingId,
    this.kind,
  });

  final String id;
  final CommChannel? channel;
  final String? subject;
  final String contactName;
  final String? contactValue;
  final String? status;
  final int unreadCount;
  final DateTime? lastMessageAt;
  final String? lastMessagePreview;

  /// The customer wrote last and nobody has replied.
  final bool awaitingReply;

  /// WhatsApp's 24-hour window: false means only an approved template may be
  /// sent, not free text. Always true for email, SMS and internal threads.
  final bool freeTextAllowed;

  final String? assignedUserName;
  final String? leadId;
  final String? customerId;
  final String? bookingId;

  /// CUSTOMER / VENDOR / INTERNAL.
  final String? kind;

  String get initials {
    final parts =
        contactName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

/// One message in a thread.
class CommMessage {
  const CommMessage({
    required this.id,
    this.channel,
    required this.outbound,
    required this.internal,
    this.body,
    this.status,
    this.senderName,
    this.occurredAt,
    this.errorMessage,
    this.attachmentCount = 0,
  });

  final String id;
  final CommChannel? channel;

  /// Sent by the agency rather than received from the contact.
  final bool outbound;

  /// A private note, never delivered to the contact.
  final bool internal;

  final String? body;

  /// QUEUED / SENT / DELIVERED / READ / FAILED / SKIPPED / RECEIVED.
  final String? status;

  final String? senderName;
  final DateTime? occurredAt;

  /// Only set when [status] is FAILED.
  final String? errorMessage;

  final int attachmentCount;

  bool get failed => status?.toUpperCase() == 'FAILED';

  /// Read receipts, as WhatsApp shows them.
  bool get delivered => switch (status?.toUpperCase()) {
        'DELIVERED' || 'READ' => true,
        _ => false,
      };

  bool get read => status?.toUpperCase() == 'READ';
}

/// `CommInboxController` and `CommOutboundController`.
class CommunicationApi {
  const CommunicationApi(this._dio);

  final Dio _dio;

  Future<PageEnvelope<Conversation>> getConversations({
    int page = 0,
    int size = 25,
    String? channel,
    String? kind,
    bool? unreadOnly,
    String? search,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/communication/conversations',
        queryParameters: <String, dynamic>{
          'page': page,
          'size': size,
          'channel': ?channel,
          'kind': ?kind,
          if (unreadOnly ?? false) 'unreadOnly': true,
          if (search != null && search.trim().isNotEmpty) 'q': search.trim(),
        },
      );
      return PageEnvelope.from<Conversation>(response.data, _toConversation);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// Messages, newest-page first — the screen reverses them for display.
  Future<List<CommMessage>> getMessages(String conversationId, {int size = 50}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/communication/conversations/$conversationId/messages',
        queryParameters: {'page': 0, 'size': size},
      );
      final page = PageEnvelope.from<CommMessage>(response.data, _toMessage);
      return page.content;
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/communication/messages/whatsapp` in free-text mode.
  ///
  /// Only valid while the thread's 24-hour window is open; outside it the
  /// server requires an approved template, which this app does not compose.
  Future<void> sendWhatsApp({
    required String conversationId,
    required String text,
  }) async {
    try {
      await _dio.post<dynamic>(
        '/api/communication/messages/whatsapp',
        data: {
          'conversationPublicId': conversationId,
          'mode': 'TEXT',
          'text': text.trim(),
        },
      );
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/communication/conversations/{id}/notes` — internal only.
  Future<void> addNote({required String conversationId, required String text}) async {
    try {
      await _dio.post<dynamic>(
        '/api/communication/conversations/$conversationId/notes',
        data: {'text': text.trim()},
      );
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<void> markRead(String conversationId) async {
    try {
      await _dio.put<dynamic>('/api/communication/conversations/$conversationId/read');
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static Conversation _toConversation(Map<String, dynamic> json) => Conversation(
        id: json['publicId'] as String? ?? '',
        channel: CommChannel.tryParse(json['channel'] as String?),
        subject: _str(json['subject']),
        contactName: _str(json['contactName']) ?? _str(json['contactValue']) ?? 'Unknown',
        contactValue: _str(json['contactValue']),
        status: _str(json['status']),
        unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
        lastMessageAt: AppDate.parseDateTime(json['lastMessageAt'] as String?),
        lastMessagePreview: _str(json['lastMessagePreview']),
        awaitingReply: json['awaitingReply'] as bool? ?? false,
        freeTextAllowed: json['freeTextAllowed'] as bool? ?? true,
        assignedUserName: _str(json['assignedUserName']),
        leadId: _str(json['leadPublicId']),
        customerId: _str(json['customerPublicId']),
        bookingId: _str(json['bookingPublicId']),
        kind: _str(json['kind']),
      );

  static CommMessage _toMessage(Map<String, dynamic> json) {
    final direction = (json['direction'] as String?)?.toUpperCase();
    return CommMessage(
      id: json['publicId'] as String? ?? '',
      channel: CommChannel.tryParse(json['channel'] as String?),
      outbound: direction == 'OUTBOUND',
      internal: (json['note'] as bool? ?? false) || direction == 'INTERNAL',
      body: _str(json['bodyText']),
      status: _str(json['status']),
      senderName: _str(json['senderName']),
      occurredAt: AppDate.parseDateTime(json['occurredAt'] as String?),
      errorMessage: _str(json['errorMessage']),
      attachmentCount: (json['attachmentCount'] as num?)?.toInt() ?? 0,
    );
  }

  static String? _str(Object? value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }
}
