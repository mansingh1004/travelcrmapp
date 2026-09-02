import 'package:flutter/material.dart';

import '../core/icons/app_icon.dart';
import '../core/theme/app_theme.dart';

/// Toast kinds, matching the prototype's `toast(title, body, kind)`.
enum ToastKind { success, info, warning, error }

/// Toasts anchored **above the bottom nav**, as the spec requires.
///
/// Implemented over [ScaffoldMessenger] so it survives navigation, with a
/// bottom margin that clears the 64px nav bar plus the safe area.
abstract final class AppToast {
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    ToastKind kind = ToastKind.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final (icon, foreground, background) = switch (kind) {
      ToastKind.success => (Ic.checkCircle, AppColors.success, AppColors.successBg),
      ToastKind.info => (Ic.bell, AppColors.primary, AppColors.primaryTint),
      ToastKind.warning => (Ic.alert, AppColors.warn, AppColors.warnBg),
      ToastKind.error => (Ic.alert, AppColors.danger, AppColors.dangerBg),
    };

    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();

    // Clear the bottom nav when one is on screen.
    final hasNav = Scaffold.maybeOf(context)?.widget.bottomNavigationBar != null;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surface,
        elevation: 0,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(
          left: AppSpacing.gutter,
          right: AppSpacing.gutter,
          bottom: (hasNav ? AppSpacing.bottomNavHeight + bottomInset : 0) + AppSpacing.x12,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rField),
        content: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.rField,
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.toast,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.x12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(AppRadii.chip),
                  ),
                  child: AppIcon(icon, size: 17, color: foreground),
                ),
                const SizedBox(width: AppSpacing.x12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: AppType.h3.copyWith(fontSize: 13.5)),
                      if (message != null) ...[
                        const SizedBox(height: AppSpacing.x2),
                        Text(message, style: AppType.caption),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void success(BuildContext context, String title, [String? message]) =>
      show(context, title: title, message: message, kind: ToastKind.success);

  static void error(BuildContext context, String title, [String? message]) =>
      show(context, title: title, message: message, kind: ToastKind.error);
}
