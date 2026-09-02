import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// The spec's `border-top:1px dashed #EAEEF6` — the rule that separates a
/// card's identity from its figures.
///
/// It is dashed rather than solid on purpose: a solid rule reads as the end of
/// the card, a dashed one as a fold inside it. Flutter has no dashed border, so
/// the dashes are painted.
class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    this.color = AppColors.line,
    this.dash = 3,
    this.gap = 3,
  });

  final Color color;
  final double dash;
  final double gap;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: const Size(double.infinity, 1),
        painter: _DashedPainter(color: color, dash: dash, gap: gap),
      );
}

class _DashedPainter extends CustomPainter {
  const _DashedPainter({required this.color, required this.dash, required this.gap});

  final Color color;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.square;

    for (var x = 0.0; x < size.width; x += dash + gap) {
      canvas.drawLine(
        Offset(x, 0.5),
        Offset((x + dash).clamp(0.0, size.width), 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedPainter old) =>
      old.color != color || old.dash != dash || old.gap != gap;
}
