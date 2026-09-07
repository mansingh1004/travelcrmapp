import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/icons/app_icon.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/providers/auth_controller.dart';
import '../router/routes.dart';
import 'app_avatar.dart';

/// Left drawer, grouped exactly as the spec lists:
/// Sales · Booking · Operations · Finance · Communication · Management.
///
/// Entries whose backend does not exist are still present and still navigate —
/// they land on a screen that names the endpoint it is waiting for. They are
/// marked so it is honest about what works today.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  static const _groups = <_Group>[
    _Group('Sales', [
      _Entry('Leads', Ic.users, Routes.leads, live: true),
      _Entry('Customers', Ic.user, Routes.customers, live: true),
      _Entry('Quotations', Ic.file, Routes.quotations, live: true),
    ]),
    _Group('Booking', [
      _Entry('Bookings', Ic.package, Routes.bookings, live: true),
      _Entry('Itinerary', Ic.pin, Routes.itinerary),
    ]),
    _Group('Operations', [
      _Entry('Operations board', Ic.checkCircle, Routes.operations, live: true),
      _Entry('Calendar', Ic.calendar, Routes.calendar, live: true),
      // Beside the calendar because they share its feed, but its own screen:
      // the calendar shows a reminder, this is where one is worked off.
      _Entry('Reminders', Ic.clock, Routes.reminders, live: true),
    ]),
    _Group('Finance', [
      _Entry('Payments', Ic.wallet, Routes.payments, live: true),
      _Entry('Reports', Ic.chart, Routes.reports, live: true),
    ]),
    _Group('Communication', [
      _Entry('Inbox', Ic.chat, Routes.inbox, live: true),
      _Entry('Notifications', Ic.bell, Routes.notifications, live: true),
    ]),
    _Group('Management', [
      _Entry('Masters', Ic.grid, Routes.masters, live: true),
      // Its own entry, not a Masters tab: a vendor carries a ledger, its own
      // lifecycle and its own permissions, and the desktop console separates
      // them the same way.
      _Entry('Vendors', Ic.building, Routes.vendors, live: true),
      _Entry('Profile', Ic.user, Routes.profile, live: true),
      _Entry('Settings', Ic.cog, Routes.settings, live: true),
    ]),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    return Drawer(
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(AppRadii.sheet)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x16),
              child: Row(
                children: [
                  AppAvatar(
                    initials: session?.initials ?? '—',
                    seed: session?.email ?? '',
                    size: 44,
                  ),
                  const SizedBox(width: AppSpacing.x12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session?.displayName ?? 'Signed out',
                          style: AppType.h3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          session?.email ?? '',
                          style: AppType.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x8),
                children: [
                  for (final group in _groups) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.x16,
                        AppSpacing.x12,
                        AppSpacing.x16,
                        AppSpacing.x6,
                      ),
                      child: Text(group.title.toUpperCase(), style: AppType.overline),
                    ),
                    for (final entry in group.entries)
                      _DrawerRow(
                        entry: entry,
                        onTap: () {
                          Navigator.of(context).pop();
                          context.go(entry.route);
                        },
                      ),
                  ],
                ],
              ),
            ),
            const Divider(),
            _DrawerRow(
              entry: const _Entry('Sign out', Ic.logout, '', live: true),
              danger: true,
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(authControllerProvider.notifier).logout();
              },
            ),
            const SizedBox(height: AppSpacing.x8),
          ],
        ),
      ),
    );
  }
}

class _Group {
  const _Group(this.title, this.entries);

  final String title;
  final List<_Entry> entries;
}

class _Entry {
  const _Entry(this.label, this.icon, this.route, {this.live = false});

  final String label;
  final String icon;
  final String route;

  /// True when the screen is backed by a real endpoint today.
  final bool live;
}

class _DrawerRow extends StatelessWidget {
  const _DrawerRow({required this.entry, required this.onTap, this.danger = false});

  final _Entry entry;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.body;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x16,
          vertical: AppSpacing.x12,
        ),
        child: Row(
          children: [
            AppIcon(entry.icon, size: 19, color: color),
            const SizedBox(width: AppSpacing.x12),
            Expanded(
              child: Text(
                entry.label,
                style: AppType.fieldValue.copyWith(color: color),
              ),
            ),
            if (!entry.live && !danger)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x6,
                  vertical: AppSpacing.x2,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.slateBg,
                  borderRadius: AppRadii.rChip,
                ),
                child: Text(
                  'Soon',
                  style: AppType.caption.copyWith(
                    fontSize: 10,
                    color: AppColors.faint,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
