import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/icons/app_icon.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/providers/auth_controller.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../router/routes.dart';
import 'app_drawer.dart';
import 'radial_fab.dart';

/// The persistent chrome: top app bar, 5-tab bottom nav, and the floating "+".
///
/// Matches the prototype's measurements — 54px bar, 38×38 icon buttons at
/// radius 11, 22px brand mark, 32px avatar with a 1.5px ring.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.state, required this.child});

  final GoRouterState state;
  final Widget child;

  /// Which tab lights up for a given route. Detail screens keep their parent
  /// tab active, exactly as the prototype's `activeNav` map does.
  static const _tabs = <_NavItem>[
    _NavItem(Routes.dashboard, 'Home', Ic.home),
    _NavItem(Routes.leads, 'Leads', Ic.users),
    _NavItem(Routes.calendar, 'Calendar', Ic.calendar),
    _NavItem(Routes.bookings, 'Bookings', Ic.package),
    _NavItem(Routes.inbox, 'Inbox', Ic.chat),
  ];

  int _activeIndex(String location) {
    final index = _tabs.indexWhere((t) => location.startsWith(t.route));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final active = _activeIndex(state.matchedLocation);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          _TopBar(initials: session?.initials ?? '—'),
          Expanded(child: child),
        ],
      ),
      floatingActionButton: const RadialFab(),
      bottomNavigationBar: _BottomNav(
        items: _tabs,
        activeIndex: active,
        onTap: (i) => context.go(_tabs[i].route),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.route, this.label, this.icon);

  final String route;
  final String label;
  final String icon;
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 54,
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.x8, right: AppSpacing.x12),
            child: Row(
              children: [
                _BarButton(
                  icon: Ic.menu,
                  size: 21,
                  semanticLabel: 'Open menu',
                  onTap: () => Scaffold.of(context).openDrawer(),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const AppIcon(Ic.plane, size: 13, color: AppColors.onPrimary),
                    ),
                    const SizedBox(width: AppSpacing.x8),
                    Text(
                      'TravelCRM',
                      style: AppType.h2.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.4),
                    ),
                  ],
                ),
                const Spacer(),
                _BarButton(
                  icon: Ic.search,
                  size: 19,
                  semanticLabel: 'Search',
                  onTap: () => context.push(Routes.search),
                ),
                _NotificationButton(),
                const SizedBox(width: AppSpacing.x4),
                Semantics(
                  button: true,
                  label: 'Profile',
                  child: GestureDetector(
                    onTap: () => context.push(Routes.profile),
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.blueTint,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFBFDBFE), width: 1.5),
                      ),
                      child: Text(
                        initials,
                        style: AppType.chip.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The bell, with the server's unread count as a badge.
///
/// A failed count is shown as no badge rather than a zero — "we could not ask"
/// and "there is nothing" are different, and only one of them should look calm.
class _NotificationButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadCountProvider).value ?? 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _BarButton(
          icon: Ic.bell,
          size: 19,
          semanticLabel: unread == 0
              ? 'Notifications'
              : 'Notifications, $unread unread',
          onTap: () => context.push(Routes.notifications),
        ),
        if (unread > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              constraints: const BoxConstraints(minWidth: 16),
              height: 16,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.danger,
                borderRadius: BorderRadius.circular(AppRadii.pill),
                border: Border.all(color: AppColors.surface, width: 1.5),
              ),
              child: Text(
                unread > 99 ? '99+' : '$unread',
                style: AppType.monoSm.copyWith(
                  fontSize: 9,
                  height: 1,
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
    this.size = 20,
  });

  final String icon;
  final VoidCallback onTap;
  final String semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    // 38×38 visual, but wrapped so the tap target still reaches 44×44.
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: SizedBox(
          width: AppSpacing.minTouchTarget,
          height: AppSpacing.minTouchTarget,
          child: Center(
            child: SizedBox(
              width: 38,
              height: 38,
              child: Center(child: AppIcon(icon, size: size, color: AppColors.body)),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.items,
    required this.activeIndex,
    required this.onTap,
  });

  final List<_NavItem> items;
  final int activeIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSpacing.bottomNavHeight,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavButton(
                    item: items[i],
                    active: i == activeIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.active, required this.onTap});

  final _NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.faint;

    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(item.icon, size: 21, color: color),
            const SizedBox(height: AppSpacing.x4),
            Text(item.label, style: AppType.navLabel.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

