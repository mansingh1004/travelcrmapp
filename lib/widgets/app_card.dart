import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// The prototype's card: white, 1px #E4E9F2 border, radius 16,
/// `0 1px 2px rgba(16,24,40,.04)`.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.x14),
    this.onTap,
    this.borderColor,
    this.background,
    this.gradient,
    this.shadow,
    this.radius = AppRadii.card,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? background;

  /// A hero card's fill. The spec's blue and dark cards are gradients, not flat
  /// colours; passing one here overrides [background].
  final Gradient? gradient;

  /// Overrides the default hairline shadow — a hero card carries a coloured
  /// lift instead (see [AppShadows.heroGlow]).
  final List<BoxShadow>? shadow;

  final double radius;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);

    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: gradient == null ? background ?? AppColors.surface : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: shadow ?? AppShadows.card,
      ),
      child: onTap == null
          ? Padding(padding: padding, child: child)
          : Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: borderRadius,
                child: Padding(padding: padding, child: child),
              ),
            ),
    );

    return margin == null ? content : Padding(padding: margin!, child: content);
  }
}
