import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/communication_api.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';

/// The inbox's tab strip. Each maps to a real query the server supports.
enum InboxTab {
  all('All'),
  unread('Unread'),
  leads('Leads'),
  vendors('Vendors');

  const InboxTab(this.label);

  final String label;
}

final inboxTabProvider = NotifierProvider<InboxTabNotifier, InboxTab>(InboxTabNotifier.new);

class InboxTabNotifier extends Notifier<InboxTab> {
  @override
  InboxTab build() => InboxTab.all;

  void set(InboxTab tab) => state = tab;
}

final inboxSearchProvider =
    NotifierProvider<InboxSearchNotifier, String?>(InboxSearchNotifier.new);

class InboxSearchNotifier extends Notifier<String?> {
  Timer? _debounce;

  @override
  String? build() {
    ref.onDispose(() => _debounce?.cancel());
    return null;
  }

  void set(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      state = query.trim().isEmpty ? null : query.trim();
    });
  }
}

final conversationsProvider = FutureProvider.autoDispose<List<Conversation>>((ref) async {
  final tab = ref.watch(inboxTabProvider);
  final search = ref.watch(inboxSearchProvider);

  final page = await ref.watch(communicationApiProvider).getConversations(
        unreadOnly: tab == InboxTab.unread,
        kind: switch (tab) {
          InboxTab.leads => 'CUSTOMER',
          InboxTab.vendors => 'VENDOR',
          _ => null,
        },
        search: search,
      );
  return page.content;
});

/// Inbox — WhatsApp, email and internal threads in one list.
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(inboxTabProvider);
    final async = ref.watch(conversationsProvider);

    return Column(
      children: [
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.x12,
            AppSpacing.gutter,
            AppSpacing.x12,
          ),
          child: SizedBox(
            height: 42,
            child: TextField(
              controller: _searchController,
              onChanged: (q) => ref.read(inboxSearchProvider.notifier).set(q),
              style: AppType.fieldValue,
              cursorColor: AppColors.primary,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                // The server matches contact, subject and preview — not bodies.
                hintText: 'Search name, number or subject',
                fillColor: AppColors.canvas,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: AppSpacing.x12, right: AppSpacing.x8),
                  child: AppIcon(Ic.search, size: 18, color: AppColors.faint),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                border: OutlineInputBorder(
                  borderRadius: AppRadii.rTile,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadii.rTile,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadii.rTile,
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.line)),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            0,
            AppSpacing.gutter,
            AppSpacing.x12,
          ),
          child: Row(
            children: [
              for (final t in InboxTab.values) ...[
                if (t != InboxTab.values.first) const SizedBox(width: AppSpacing.x6),
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: t == tab,
                    child: InkWell(
                      onTap: () => ref.read(inboxTabProvider.notifier).set(t),
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                      child: Container(
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: t == tab ? AppColors.primary : AppColors.canvas,
                          borderRadius: BorderRadius.circular(AppRadii.chip),
                        ),
                        child: Text(
                          t.label,
                          style: AppType.tab.copyWith(
                            color: t == tab ? AppColors.onPrimary : AppColors.body,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: switch (async) {
            AsyncLoading() => const SkeletonList(itemCount: 6, itemHeight: 84),
            AsyncError(:final error) when error is PermissionFailure => EmptyStateView(
                icon: Ic.shield,
                title: 'Inbox is restricted',
                message: error.message,
              ),
            AsyncError(:final error) => ErrorStateView(
                failure: asFailure(error),
                onRetry: () => ref.invalidate(conversationsProvider),
              ),
            AsyncData(:final value) => RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => ref.invalidate(conversationsProvider),
                child: value.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(
                            height: 380,
                            child: EmptyStateView(
                              icon: Ic.chat,
                              title: 'No conversations',
                              message: 'WhatsApp and email threads with customers '
                                  'and vendors appear here.',
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.gutter),
                        itemCount: value.length,
                        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x10),
                        itemBuilder: (context, index) => _ConversationRow(
                          conversation: value[index],
                          onTap: () =>
                              context.push(Routes.chatFor(value[index].id)),
                        ),
                      ),
              ),
          },
        ),
      ],
    );
  }
}

class _ConversationRow extends StatelessWidget {
  const _ConversationRow({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final channel = conversation.channel;
    final unread = conversation.unreadCount > 0;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAvatar(
            initials: conversation.initials,
            seed: conversation.contactName,
          ),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        conversation.contactName,
                        style: unread
                            ? AppType.h3
                            : AppType.h3.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (conversation.lastMessageAt != null)
                      Text(
                        AppDate.relative(conversation.lastMessageAt),
                        style: AppType.caption.copyWith(fontSize: 11),
                      ),
                  ],
                ),
                if (conversation.lastMessagePreview != null) ...[
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    conversation.lastMessagePreview!,
                    style: AppType.bodySm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.x8),
                Row(
                  children: [
                    if (channel != null)
                      StatusChip(
                        label: channel.label,
                        palette: StatusColors.commChannel(channel),
                        dense: true,
                      ),
                    if (conversation.awaitingReply) ...[
                      const SizedBox(width: AppSpacing.x6),
                      const StatusChip(
                        label: 'Awaiting reply',
                        palette: StatusPalette(AppColors.warn, AppColors.warnBg),
                        dense: true,
                      ),
                    ],
                    const Spacer(),
                    if (unread)
                      Container(
                        constraints: const BoxConstraints(minWidth: 20),
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                        child: Text(
                          '${conversation.unreadCount}',
                          style: AppType.monoSm.copyWith(
                            fontSize: 10,
                            height: 1,
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
