import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Elevation tokens. CSS `box-shadow` values ported 1:1 — a CSS blur radius of
/// `N` maps to Flutter `blurRadius: N`, and CSS has no spread here.
abstract final class AppShadows {
  /// `0 1px 2px rgba(16,24,40,.04)` — every card in the prototype.
  static const card = <BoxShadow>[
    BoxShadow(
      color: Color(0x0A101828),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  /// `0 8px 20px rgba(37,99,235,.28)` — primary buttons.
  static const primaryButton = <BoxShadow>[
    BoxShadow(
      color: Color(0x472563EB),
      offset: Offset(0, 8),
      blurRadius: 20,
    ),
  ];

  /// `0 10px 24px rgba(37,99,235,.32)` — the login mark and the FAB.
  static const brandLift = <BoxShadow>[
    BoxShadow(
      color: Color(0x522563EB),
      offset: Offset(0, 10),
      blurRadius: 24,
    ),
  ];

  /// `0 12px 26px rgba(37,99,235,.26)` — the blue hero card. Without it the
  /// card sits flat on the canvas instead of lifting off it.
  static const heroGlow = <BoxShadow>[
    BoxShadow(
      color: Color(0x422563EB),
      offset: Offset(0, 12),
      blurRadius: 26,
    ),
  ];

  /// `0 12px 26px rgba(15,23,42,.22)` — the same lift under a dark hero.
  static const darkGlow = <BoxShadow>[
    BoxShadow(
      color: Color(0x380F172A),
      offset: Offset(0, 12),
      blurRadius: 26,
    ),
  ];

  /// Bottom sheets and the drawer.
  static const sheet = <BoxShadow>[
    BoxShadow(
      color: Color(0x1F101828),
      offset: Offset(0, -4),
      blurRadius: 24,
    ),
  ];

  /// Toasts, which float above the bottom nav.
  static const toast = <BoxShadow>[
    BoxShadow(
      color: Color(0x291E293B),
      offset: Offset(0, 6),
      blurRadius: 18,
    ),
  ];

  /// Hairline used where a border reads better than a shadow.
  static const hairline = BorderSide(color: AppColors.border, width: 1);
  static const hairlineFaint = BorderSide(color: AppColors.line, width: 1);
}

/// The spec's two hero fills. Both are diagonal (`135deg` in CSS, which is
/// top-left to bottom-right), and both carry a coloured lift rather than the
/// hairline every other card uses.
abstract final class AppGradients {
  /// `linear-gradient(135deg,#2563EB 0%,#1D4ED8 60%,#1E40AF 100%)` — the
  /// dashboard target band and the leads pipeline card. The middle stop is what
  /// stops it reading as one flat block of blue.
  static const brandHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryDark, AppColors.primaryDeep],
    stops: [0.0, 0.6, 1.0],
  );

  /// `linear-gradient(135deg,#0F172A,#1E293B)` — the quotation letterhead and
  /// the Payments summary card.
  static const inkHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.ink, AppColors.inkSoft],
  );

  /// `linear-gradient(150deg,#2563EB,#1E40AF)` — the customer and profile
  /// headers, which run steeper than [brandHero] and skip the middle stop.
  static const brandHeader = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryDeep],
  );

  /// `linear-gradient(180deg,#FFFFFF 0%,#F4F7FE 100%)` — the login page.
  static const page = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.surface, AppColors.tintPanel],
  );
}
