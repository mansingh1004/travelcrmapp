import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Initials avatar. Colour is derived deterministically from the name, so the
/// same person keeps the same colour across screens.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.initials,
    required this.seed,
    this.size = 42,
  });

  final String initials;

  /// Usually the person's full name.
  final String seed;

  final double size;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = AppColors.avatarFor(seed);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Text(
        initials,
        style: AppType.h3.copyWith(
          color: foreground,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}
