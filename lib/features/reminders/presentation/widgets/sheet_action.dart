import 'package:flutter/material.dart';

import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';

/// One row in a reminder action sheet — an icon, a label, a divider.
///
/// Shared by the lead-side and booking-side sheets. The two modules are kept
/// apart everywhere else on purpose, but this is chrome, not behaviour, and
/// two identical copies would drift.
class SheetAction extends StatelessWidget {
  const SheetAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.ink,
    this.last = false,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  /// Tints icon and label together — green for the safe action, red for the
  /// destructive one.
  final Color color;

  /// The last row draws no divider under it.
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.x14),
            child: Row(
              children: [
                AppIcon(icon, size: 18, color: color),
                const SizedBox(width: AppSpacing.x12),
                Text(label, style: AppType.body.copyWith(color: color)),
              ],
            ),
          ),
        ),
        if (!last) const Divider(height: 1, color: AppColors.line),
      ],
    );
  }
}
