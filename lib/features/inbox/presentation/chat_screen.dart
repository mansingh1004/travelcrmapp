import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/communication_api.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import 'inbox_screen.dart';
import '../../../router/safe_pop.dart';

final chatMessagesProvider =
    FutureProvider.autoDispose.family<List<CommMessage>, String>(
  (ref, conversationId) =>
      ref.watch(communicationApiProvider).getMessages(conversationId),
);

/// One conversation's thread.
///
/// Outside WhatsApp's 24-hour window the server only accepts an approved
/// template, which this app does not compose — so the composer is disabled and
/// says why, rather than letting a message fail on send.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _composer = TextEditingController();
  bool _sending = false;
  bool _asNote = false;

  @override
  void initState() {
    super.initState();
    // Opening a thread clears its unread badge.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ref.read(communicationApiProvider).markRead(widget.conversationId);
        ref.invalidate(conversationsProvider);
      } on Failure {
        // Not being able to clear the badge must not block reading.
      }
    });
  }

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  Conversation? get _conversation {
    final list = ref.read(conversationsProvider).value;
    if (list == null) return null;
    for (final c in list) {
      if (c.id == widget.conversationId) return c;
    }
    return null;
  }

  Future<void> _send() async {
    final text = _composer.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    try {
      final api = ref.read(communicationApiProvider);
      if (_asNote) {
        await api.addNote(conversationId: widget.conversationId, text: text);
      } else {
        await api.sendWhatsApp(conversationId: widget.conversationId, text: text);
      }
      _composer.clear();
      ref
        ..invalidate(chatMessagesProvider(widget.conversationId))
        ..invalidate(conversationsProvider);
    } on Failure catch (f) {
      if (mounted) AppToast.error(context, 'Could not send', f.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(chatMessagesProvider(widget.conversationId));
    final conversation = _conversation;
    final windowClosed = conversation != null && !conversation.freeTextAllowed;

    return Scaffold(
      backgroundColor: AppColors.chatCanvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(conversation?.contactName ?? 'Conversation', style: AppType.h3),
            if (conversation?.contactValue != null)
              Text(conversation!.contactValue!, style: AppType.caption),
          ],
        ),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: Column(
        children: [
          Expanded(
            child: switch (async) {
              AsyncLoading() => const SkeletonList(itemCount: 5, itemHeight: 64),
              AsyncError(:final error) => ErrorStateView(
                  failure: asFailure(error),
                  onRetry: () =>
                      ref.invalidate(chatMessagesProvider(widget.conversationId)),
                ),
              AsyncData(:final value) => value.isEmpty
                  ? const EmptyStateView(
                      icon: Ic.chat,
                      title: 'No messages yet',
                      message: 'Send the first message to start this thread.',
                    )
                  : _Thread(messages: value),
            },
          ),
          _Composer(
            controller: _composer,
            sending: _sending,
            asNote: _asNote,
            windowClosed: windowClosed,
            onToggleNote: () => setState(() => _asNote = !_asNote),
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

class _Thread extends StatelessWidget {
  const _Thread({required this.messages});

  final List<CommMessage> messages;

  @override
  Widget build(BuildContext context) {
    // The API returns newest first; a thread reads oldest-to-newest with the
    // latest at the bottom, so reverse and pin the list to the end.
    final ordered = messages.reversed.toList();

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(AppSpacing.gutter),
      itemCount: ordered.length,
      itemBuilder: (context, index) {
        // `reverse: true` counts from the bottom, so walk the list backwards.
        final position = ordered.length - 1 - index;
        final message = ordered[position];
        final previous = position == 0 ? null : ordered[position - 1];

        final showDivider = previous == null ||
            !_sameDay(previous.occurredAt, message.occurredAt);

        return Column(
          children: [
            if (showDivider && message.occurredAt != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
                child: Text(
                  AppDate.relative(message.occurredAt),
                  style: AppType.caption.copyWith(fontSize: 11),
                ),
              ),
            _Bubble(message: message),
          ],
        );
      },
    );
  }

  static bool _sameDay(DateTime? a, DateTime? b) =>
      a != null &&
      b != null &&
      a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final CommMessage message;

  @override
  Widget build(BuildContext context) {
    // An internal note is nobody's message — it is centred and tinted so it
    // can never be mistaken for something the customer saw.
    if (message.internal) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.x10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.x12),
          decoration: BoxDecoration(
            color: AppColors.amberBg,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: AppColors.amber.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppIcon(Ic.edit, size: 13, color: AppColors.amber),
                  const SizedBox(width: AppSpacing.x6),
                  Text(
                    'Internal note${message.senderName == null ? '' : ' · ${message.senderName}'}',
                    style: AppType.caption.copyWith(
                      fontSize: 11,
                      color: AppColors.amber,
                    ),
                  ),
                ],
              ),
              if (message.body != null) ...[
                const SizedBox(height: AppSpacing.x6),
                Text(message.body!, style: AppType.body),
              ],
            ],
          ),
        ),
      );
    }

    final outbound = message.outbound;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x8),
      child: Row(
        mainAxisAlignment:
            outbound ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 300),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x12,
                vertical: AppSpacing.x10,
              ),
              decoration: BoxDecoration(
                color: outbound ? AppColors.chatOutbound : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  // The squared corner is the tail — it points at the sender.
                  bottomLeft: Radius.circular(outbound ? 14 : 3),
                  bottomRight: Radius.circular(outbound ? 3 : 14),
                ),
                border: outbound ? null : Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.body != null)
                    Text(
                      message.body!,
                      style: AppType.body.copyWith(
                        color: AppColors.ink,
                      ),
                    ),
                  if (message.attachmentCount > 0) ...[
                    const SizedBox(height: AppSpacing.x6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(
                          Ic.clip,
                          size: 13,
                          color: outbound
                              ? AppColors.chatMeta
                              : AppColors.muted,
                        ),
                        const SizedBox(width: AppSpacing.x4),
                        Text(
                          '${message.attachmentCount} attachment'
                          '${message.attachmentCount == 1 ? '' : 's'}',
                          style: AppType.caption.copyWith(
                            fontSize: 11,
                            color: outbound
                                ? AppColors.chatMeta
                                : AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppDate.time(message.occurredAt),
                        style: AppType.caption.copyWith(
                          fontSize: 10,
                          color: outbound
                              ? AppColors.chatMeta
                              : AppColors.faint,
                        ),
                      ),
                      if (outbound) ...[
                        const SizedBox(width: AppSpacing.x4),
                        // Ticks mirror WhatsApp: one sent, two delivered, blue
                        // read. A failure gets a warning glyph instead.
                        if (message.failed)
                          const AppIcon(Ic.alert, size: 12, color: AppColors.danger)
                        else
                          AppIcon(
                            message.delivered ? Ic.checkCircle : Ic.check,
                            size: 12,
                            color: message.read
                                ? AppColors.chatTick
                                : AppColors.chatMeta,
                          ),
                      ],
                    ],
                  ),
                  if (message.failed && message.errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      message.errorMessage!,
                      style: AppType.caption.copyWith(
                        fontSize: 10,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.sending,
    required this.asNote,
    required this.windowClosed,
    required this.onToggleNote,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final bool asNote;
  final bool windowClosed;
  final VoidCallback onToggleNote;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final blocked = windowClosed && !asNote;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x12),
          child: Column(
            children: [
              if (blocked)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x10),
                  child: Row(
                    children: [
                      const AppIcon(Ic.clock, size: 14, color: AppColors.warn),
                      const SizedBox(width: AppSpacing.x8),
                      Expanded(
                        child: Text(
                          "WhatsApp's 24-hour window has closed. Only an approved "
                          'template can be sent — use the web console, or add an '
                          'internal note here.',
                          style: AppType.caption.copyWith(color: AppColors.warn),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Semantics(
                    button: true,
                    selected: asNote,
                    label: asNote ? 'Sending as internal note' : 'Send as message',
                    child: InkWell(
                      onTap: onToggleNote,
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                      child: Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: asNote ? AppColors.amberBg : AppColors.canvas,
                          borderRadius: BorderRadius.circular(AppRadii.chip),
                        ),
                        child: AppIcon(
                          Ic.edit,
                          size: 18,
                          color: asNote ? AppColors.amber : AppColors.muted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      enabled: !sending && !blocked,
                      maxLines: 4,
                      minLines: 1,
                      style: AppType.fieldValue,
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText: asNote ? 'Internal note…' : 'Message…',
                        fillColor: AppColors.canvas,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.x14,
                          vertical: AppSpacing.x10,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: AppRadii.rTile,
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: AppRadii.rTile,
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: AppRadii.rTile,
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x8),
                  Semantics(
                    button: true,
                    label: 'Send',
                    child: InkWell(
                      onTap: (sending || blocked) ? null : onSend,
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                      child: Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: blocked ? AppColors.border : AppColors.primary,
                          borderRadius: BorderRadius.circular(AppRadii.chip),
                        ),
                        child: sending
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.onPrimary,
                                ),
                              )
                            : const AppIcon(
                                Ic.send,
                                size: 18,
                                color: AppColors.onPrimary,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
