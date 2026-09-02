import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/icons/app_icon.dart';
import '../core/theme/app_theme.dart';
import '../router/routes.dart';

/// The floating "+" with six radial actions, ported from the prototype's
/// `fabActions` — label pill + 42×42 white icon tile per row, rising in with a
/// scrim behind.
///
/// Only "New lead" reaches a live endpoint today. The other five navigate to
/// their screens, which state which backend endpoint they are waiting on —
/// consistent with the app-wide option-B behaviour. (The prototype faked
/// Follow-up and Note with a success toast; this app does not toast success
/// for something it cannot save.)
class RadialFab extends StatefulWidget {
  const RadialFab({super.key});

  @override
  State<RadialFab> createState() => _RadialFabState();
}

class _FabAction {
  const _FabAction(this.label, this.icon, this.color, this.route);

  final String label;
  final String icon;
  final Color color;
  final String route;
}

class _RadialFabState extends State<RadialFab> with SingleTickerProviderStateMixin {
  static const _actions = <_FabAction>[
    // Prototype order is bottom-up; listed top-down here so the column renders
    // the same way ("Note" nearest the FAB in the prototype's stack).
    _FabAction('New lead', Ic.users, AppColors.primary, Routes.leadCreate),
    _FabAction('New quotation', Ic.file, AppColors.purple, Routes.quotationCreate),
    _FabAction('New booking', Ic.package, AppColors.success, Routes.bookings),
    _FabAction('Follow-up', Ic.clock, AppColors.warn, Routes.calendar),
    _FabAction('Payment', Ic.wallet, AppColors.amber, Routes.payments),
    _FabAction('Note', Ic.edit, AppColors.slate, Routes.leads),
  ];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  bool _open = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _go(String route) {
    _toggle();
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        // Scrim covering the screen while open.
        if (_open)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggle,
              child: FadeTransition(
                opacity: _controller,
                child: ColoredBox(
                  color: AppColors.ink.withValues(alpha: 0.30),
                ),
              ),
            ),
          ),
        // Action column — prototype: right 16, above the FAB, 9px gaps.
        Positioned(
          right: 0,
          bottom: 74,
          child: IgnorePointer(
            ignoring: !_open,
            child: FadeTransition(
              opacity: _controller,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final action in _actions)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: _ActionRow(action: action, onTap: () => _go(action.route)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // The FAB itself, rotating + → × when open.
        Semantics(
          button: true,
          label: _open ? 'Close quick actions' : 'Quick actions',
          child: DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: AppShadows.brandLift,
            ),
            child: FloatingActionButton(
              onPressed: _toggle,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              elevation: 0,
              highlightElevation: 0,
              shape: const CircleBorder(),
              child: RotationTransition(
                turns: Tween<double>(begin: 0, end: 0.125).animate(
                  CurvedAnimation(parent: _controller, curve: Curves.easeOut),
                ),
                child: const AppIcon(Ic.plus, size: 24, color: AppColors.onPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.action, required this.onTap});

  final _FabAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: action.label,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label pill: 700 12px, white, radius 9, soft shadow.
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x10,
                vertical: AppSpacing.x6,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(9),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x290F172A),
                    offset: Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Text(
                action.label,
                style: AppType.chip.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 9),
            // Icon tile: 42×42, radius 14, white, tinted icon.
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.field),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x2E0F172A),
                    offset: Offset(0, 4),
                    blurRadius: 14,
                  ),
                ],
              ),
              child: AppIcon(action.icon, size: 19, color: action.color),
            ),
          ],
        ),
      ),
    );
  }
}
