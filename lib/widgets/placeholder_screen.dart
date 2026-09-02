import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/errors/failure.dart';
import '../core/icons/app_icon.dart';
import '../core/theme/app_theme.dart';
import 'state_views.dart';
import '../router/safe_pop.dart';

/// A fully-chromed screen whose content is the "waiting on backend" panel.
///
/// This is what the 18 unbacked screens render. It is a real route with a real
/// app bar and real back behaviour — only the data is missing — so the shell is
/// complete today and each screen becomes live the moment its endpoint exists.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.failure,
  });

  final String title;
  final String icon;
  final NotImplementedFailure failure;

  @override
  Widget build(BuildContext context) {
    final canPop = context.canPop();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: canPop
            ? IconButton(
                onPressed: context.backOrHome,
                icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
                tooltip: 'Back',
              )
            : null,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            AppIcon(icon, size: 19, color: AppColors.ink),
            const SizedBox(width: AppSpacing.x8),
            Text(title, style: AppType.h2),
          ],
        ),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: ComingSoonView(failure: failure),
    );
  }
}
