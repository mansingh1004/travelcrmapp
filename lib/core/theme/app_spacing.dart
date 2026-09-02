/// Spacing scale — the Tailwind-style ramp the prototype uses.
///
/// Flutter has no Tailwind, so the intent is honoured by making these the only
/// legal spacing values in the app. No widget may write a raw padding number.
abstract final class AppSpacing {
  static const double x2 = 2;
  static const double x4 = 4;
  static const double x5 = 5;
  static const double x6 = 6;
  static const double x8 = 8;
  static const double x10 = 10;
  static const double x12 = 12;
  static const double x14 = 14;
  static const double x16 = 16;
  static const double x18 = 18;
  static const double x20 = 20;
  static const double x22 = 22;
  static const double x24 = 24;
  static const double x26 = 26;
  static const double x28 = 28;
  static const double x30 = 30;
  static const double x36 = 36;
  static const double x44 = 44;

  /// Standard horizontal gutter for screen content (prototype uses 16).
  static const double gutter = x16;

  /// Minimum interactive target, per the accessibility requirement.
  static const double minTouchTarget = 44;

  /// Fixed chrome heights measured from the prototype.
  static const double statusBarHeight = 46;
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 64;
}
