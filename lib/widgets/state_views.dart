import 'package:flutter/material.dart';

import '../core/errors/failure.dart';
import '../core/icons/app_icon.dart';
import '../core/theme/app_theme.dart';

/// Empty state: icon, line, and a call to action — per the global behaviour rule.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final String icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.slateBg,
                borderRadius: AppRadii.rLg,
              ),
              child: AppIcon(icon, size: 26, color: AppColors.faint),
            ),
            const SizedBox(height: AppSpacing.x16),
            Text(title, style: AppType.h3, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.x6),
              Text(message!, style: AppType.bodySm, textAlign: TextAlign.center),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.x20),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, AppSpacing.minTouchTarget),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x20),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state: message, code, retry, and a route to support — per the spec.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.failure,
    this.onRetry,
  });

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    // A missing endpoint is a known state, not a fault — it gets its own view.
    if (failure is NotImplementedFailure) {
      return ComingSoonView(failure: failure as NotImplementedFailure);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.dangerBg,
                borderRadius: AppRadii.rLg,
              ),
              child: const AppIcon(Ic.alert, size: 26, color: AppColors.danger),
            ),
            const SizedBox(height: AppSpacing.x16),
            Text('Something went wrong', style: AppType.h3, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.x6),
            Text(failure.message, style: AppType.bodySm, textAlign: TextAlign.center),
            if (failure.code != null) ...[
              const SizedBox(height: AppSpacing.x10),
              Text(
                'Reference: ${failure.code}',
                style: AppType.monoSm.copyWith(color: AppColors.faint),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.x20),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, AppSpacing.minTouchTarget),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x24),
                ),
                child: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shown by the screens whose endpoints do not exist.
///
/// It names the missing endpoint rather than pretending the feature is merely
/// "coming soon", so it is obvious what has to land for the screen to work.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key, required this.failure});

  final NotImplementedFailure failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primaryTint,
                borderRadius: AppRadii.rLg,
              ),
              child: const AppIcon(Ic.clock, size: 26, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.x16),
            Text('Not available yet', style: AppType.h3, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.x6),
            Text(
              failure.message,
              style: AppType.bodySm,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x14),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x12,
                vertical: AppSpacing.x8,
              ),
              decoration: const BoxDecoration(
                color: AppColors.slateBg,
                borderRadius: AppRadii.rTile,
              ),
              child: Text(
                failure.endpoint,
                style: AppType.monoSm.copyWith(color: AppColors.slate),
              ),
            ),
            const SizedBox(height: AppSpacing.x10),
            Text(
              'This screen is built and waiting on the backend.',
              style: AppType.caption.copyWith(color: AppColors.faint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmering placeholder rows, matching the prototype's `tcSkel` pulse.
class SkeletonList extends StatefulWidget {
  const SkeletonList({super.key, this.itemCount = 5, this.itemHeight = 104});

  final int itemCount;
  final double itemHeight;

  @override
  State<SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<SkeletonList> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      itemCount: widget.itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x12),
      itemBuilder: (_, _) => FadeTransition(
        // 0.5 → 1.0, the prototype's keyframe range.
        opacity: Tween<double>(begin: 0.5, end: 1).animate(_controller),
        child: Container(
          height: widget.itemHeight,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadii.rCard,
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.all(AppSpacing.x14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _box(42, 42, radius: AppRadii.tile),
                  const SizedBox(width: AppSpacing.x12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(double.infinity, 12),
                        const SizedBox(height: AppSpacing.x8),
                        _box(140, 10),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _box(double.infinity, 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box(double width, double height, {double radius = AppRadii.xs}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.line,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
