import 'package:flutter/material.dart';

import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';

/// Shown while the stored token is read and validated.
///
/// Exists so the app never flashes Login before auto-login resolves.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Mark(),
            SizedBox(height: AppSpacing.x22),
            Text(
              'TravelCRM',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.onPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Mark extends StatelessWidget {
  const _Mark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: const AppIcon(Ic.plane, size: 26, color: AppColors.onPrimary),
    );
  }
}
