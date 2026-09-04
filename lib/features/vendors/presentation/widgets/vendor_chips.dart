import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// `PARTIALLY_PAID` → `Partially paid`.
///
/// The enums come off the wire SHOUTING, and the console lowercases them the
/// same way rather than shipping a lookup table per screen.
String statusLabel(String wire) {
  final words = wire.toLowerCase().split('_');
  if (words.isEmpty) return wire;
  final first = words.first;
  return [
    first.isEmpty ? first : first[0].toUpperCase() + first.substring(1),
    ...words.skip(1),
  ].join(' ');
}

/// A vendor's standing. Blacklisted and suspended are the ones that matter, so
/// they are the ones that are loud.
class VendorStatusChip extends StatelessWidget {
  const VendorStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = switch (status) {
      'ACTIVE' => (AppColors.success, AppColors.successBg),
      'SUSPENDED' => (AppColors.warn, AppColors.warnBg),
      'BLACKLISTED' => (AppColors.danger, AppColors.dangerBg),
      _ => (AppColors.muted, AppColors.slateBg),
    };
    return _Chip(label: statusLabel(status), fg: fg, bg: bg, dot: true);
  }
}

/// Hotel, Airlines, Transport or DMC — the four the backend accepts.
class VendorTypeChip extends StatelessWidget {
  const VendorTypeChip({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = switch (type) {
      'Hotel' => (AppColors.primary, AppColors.primaryTint),
      'Airlines' => (AppColors.teal, AppColors.tealBg),
      'Transport' => (AppColors.warn, AppColors.warnBg),
      'DMC' => (AppColors.success, AppColors.successBg),
      _ => (AppColors.muted, AppColors.slateBg),
    };
    return _Chip(label: type, fg: fg, bg: bg);
  }
}

/// Where the account with this vendor stands.
class VendorPayChip extends StatelessWidget {
  const VendorPayChip({super.key, required this.payStatus});

  final String payStatus;

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = switch (payStatus) {
      'PAID' => (AppColors.success, AppColors.successBg),
      'PARTIALLY_PAID' => (AppColors.warn, AppColors.warnBg),
      'OVERDUE' => (AppColors.danger, AppColors.dangerBg),
      _ => (AppColors.muted, AppColors.slateBg),
    };
    return _Chip(label: statusLabel(payStatus), fg: fg, bg: bg);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.fg,
    required this.bg,
    this.dot = false,
  });

  final String label;
  final Color fg;
  final Color bg;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x8,
          vertical: 3,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dot) ...[
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.x6),
            ],
            Text(label, style: AppType.chip.copyWith(color: fg)),
          ],
        ),
      ),
    );
  }
}
