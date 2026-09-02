import 'package:flutter/material.dart';

import '../core/constants/status_colors.dart';
import '../core/icons/app_icon.dart';
import '../core/theme/app_theme.dart';

/// Small pill used for stage, priority, source and every other status.
///
/// Colours always come from [StatusColors] so the status map is applied
/// consistently, as the spec requires.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.palette,
    this.dense = false,
    this.leading,
    this.trailingIcon,
  });

  final String label;
  final StatusPalette palette;

  /// Tighter padding, for chips sitting inside a dense card row.
  final bool dense;

  final Widget? leading;

  /// Drawn after the label in the palette's foreground colour — used to mark a
  /// chip that opens a picker.
  final String? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? AppSpacing.x8 : AppSpacing.x10,
        vertical: dense ? AppSpacing.x4 : AppSpacing.x6,
      ),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: AppRadii.rChip,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.x4),
          ],
          Text(
            label,
            style: AppType.chip.copyWith(color: palette.foreground),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: AppSpacing.x4),
            AppIcon(trailingIcon!, size: 13, color: palette.foreground),
          ],
        ],
      ),
    );
  }
}
