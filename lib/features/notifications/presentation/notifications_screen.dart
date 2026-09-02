import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../api/notification_api.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../../router/safe_pop.dart';

final notificationsProvider = FutureProvider.autoDispose<List<AppNotification>>(
  (ref) => ref.watch(notificationApiProvider).getNotifications(),
);

/// Unread badge count, also read by the app bar's bell.
final unreadCountProvider = FutureProvider.autoDispose<int>(
  (ref) => ref.watch(notificationApiProvider).getUnreadCount(),
);

/// Notifications, grouped Today / Earlier.
///
/// Tapping a row marks it read and opens the record it points at, when that
/// record has a screen. Unknown reference types just mark read.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Notifications', style: AppType.h2),
        actions: [
          if ((async.value?.any((n) => n.unread) ?? false))
            TextButton(
              onPressed: () => _markAllRead(context, ref),
              child: const Text('Mark all read'),
            ),
        ],
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (async) {
        AsyncLoading() => const SkeletonList(itemCount: 5, itemHeight: 88),
        AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () => ref.invalidate(notificationsProvider),
          ),
        AsyncData(:final value) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref
                ..invalidate(notificationsProvider)
                ..invalidate(unreadCountProvider);
            },
            child: value.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(
                        height: 420,
                        child: EmptyStateView(
                          icon: Ic.bell,
                          title: 'Nothing new',
                          message: 'Alerts about leads, bookings and payments '
                              'will show up here.',
                        ),
                      ),
                    ],
                  )
                : _Grouped(notifications: value),
          ),
      },
    );
  }

  Future<void> _markAllRead(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(notificationApiProvider).markAllRead();
      ref
        ..invalidate(notificationsProvider)
        ..invalidate(unreadCountProvider);
    } on Failure catch (f) {
      if (context.mounted) AppToast.error(context, 'Could not mark all read', f.message);
    }
  }
}

class _Grouped extends ConsumerWidget {
  const _Grouped({required this.notifications});

  final List<AppNotification> notifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = <AppNotification>[];
    final earlier = <AppNotification>[];

    for (final n in notifications) {
      final at = n.createdAt;
      final isToday = at != null &&
          at.year == now.year &&
          at.month == now.month &&
          at.day == now.day;
      (isToday ? today : earlier).add(n);
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      children: [
        if (today.isNotEmpty) ...[
          Text('Today', style: AppType.overline),
          const SizedBox(height: AppSpacing.x8),
          for (final n in today)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x10),
              child: _Row(notification: n),
            ),
        ],
        if (earlier.isNotEmpty) ...[
          if (today.isNotEmpty) const SizedBox(height: AppSpacing.x12),
          Text('Earlier', style: AppType.overline),
          const SizedBox(height: AppSpacing.x8),
          for (final n in earlier)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x10),
              child: _Row(notification: n),
            ),
        ],
        const SizedBox(height: AppSpacing.x24),
      ],
    );
  }
}

class _Row extends ConsumerWidget {
  const _Row({required this.notification});

  final AppNotification notification;

  /// Icon by reference type — a lead alert should not look like a payment one.
  String get _icon => switch (notification.referenceType) {
        'LEAD' => Ic.users,
        'BOOKING' => Ic.package,
        'CUSTOMER' => Ic.user,
        'REMINDER' || 'TASK' => Ic.clock,
        'VENDOR' => Ic.building,
        _ => Ic.bell,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      // Unread rows sit on the tint so the difference survives a glance.
      background: notification.unread ? AppColors.primaryTint : AppColors.surface,
      borderColor: notification.unread
          ? AppColors.primary.withValues(alpha: 0.16)
          : AppColors.border,
      padding: const EdgeInsets.all(AppSpacing.x14),
      onTap: () => _open(context, ref),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: notification.unread ? AppColors.surface : AppColors.canvas,
              borderRadius: BorderRadius.circular(AppRadii.chip),
            ),
            child: AppIcon(
              _icon,
              size: 17,
              color: notification.unread ? AppColors.primary : AppColors.muted,
            ),
          ),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title.isEmpty ? 'Notification' : notification.title,
                  style: notification.unread
                      ? AppType.h3
                      : AppType.h3.copyWith(fontWeight: FontWeight.w600),
                ),
                if (notification.message != null) ...[
                  const SizedBox(height: AppSpacing.x4),
                  Text(notification.message!, style: AppType.bodySm),
                ],
                const SizedBox(height: AppSpacing.x6),
                Text(
                  AppDate.dateTime(notification.createdAt),
                  style: AppType.monoSm,
                ),
              ],
            ),
          ),
          if (notification.unread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    if (notification.unread) {
      try {
        await ref.read(notificationApiProvider).markRead(notification.id);
        ref
          ..invalidate(notificationsProvider)
          ..invalidate(unreadCountProvider);
      } on Failure {
        // Failing to mark read must not block opening the record.
      }
    }

    if (!context.mounted) return;
    final id = notification.referenceId;
    if (id == null) return;

    switch (notification.referenceType) {
      case 'LEAD':
        context.push(Routes.leadDetailFor(id));
      case 'BOOKING':
        context.push(Routes.bookingDetailFor(id));
      case 'CUSTOMER':
        context.push(Routes.customerDetailFor(id));
      default:
        break;
    }
  }
}
