import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Type scale. Sizes, weights, line heights and letter-spacings are read off
/// the prototype's inline `font:` shorthands.
///
/// Two families, used exactly as the spec dictates:
///   • Plus Jakarta Sans — all UI text
///   • IBM Plex Mono     — numbers, IDs, currency, dates
///
/// Both are **bundled** (see `pubspec.yaml`). They are deliberately not loaded
/// through `google_fonts`: that package fetches its faces over HTTP on first
/// paint, which hangs the UI thread when the device is offline.
abstract final class AppType {
  static const sansFamily = 'Plus Jakarta Sans';
  static const monoFamily = 'IBM Plex Mono';

  /// System stacks to fall back to if a face ever fails to resolve.
  static const _sansFallback = ['Roboto', 'sans-serif'];
  static const _monoFallback = ['Roboto Mono', 'monospace'];

  static TextStyle _sans({
    required double size,
    required FontWeight weight,
    double? height,
    double? letterSpacing,
    Color color = AppColors.ink,
  }) =>
      TextStyle(
        fontFamily: sansFamily,
        fontFamilyFallback: _sansFallback,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );

  static TextStyle _mono({
    required double size,
    required FontWeight weight,
    double? height,
    double? letterSpacing,
    Color color = AppColors.ink,
  }) =>
      TextStyle(
        fontFamily: monoFamily,
        fontFamilyFallback: _monoFallback,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );


  // ── Display & headings ─────────────────────────────────────────────────
  //
  // Every size below is a `font:` shorthand read off the spec, with the count
  // of how often it appears there. Where the spec uses a size at two weights
  // for the same job, the more frequent one wins.

  /// Login wordmark — spec `800 30px/1.15`, tracking −0.6.
  static TextStyle get display => _sans(
        size: 30,
        weight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.6,
      );

  /// Screen title — spec `800 18px`, tracking −0.4 (6 screens: Notifications,
  /// Reports, Settings, Calendar month, Prototype states, Search).
  static TextStyle get h1 => _sans(size: 18, weight: FontWeight.w800, height: 1.2, letterSpacing: -0.4);

  /// The greeting and record names that sit one step above [h1] — spec
  /// `800 20px` (customer, profile) and `800 21px/1.2` (dashboard greeting).
  static TextStyle get h1Large => _sans(size: 20, weight: FontWeight.w800, height: 1.2, letterSpacing: -0.4);

  /// App-bar and sheet title — spec `700 15.5px` (7×) / `700 16px` (8×).
  static TextStyle get h2 => _sans(size: 15.5, weight: FontWeight.w700, height: 1.25, letterSpacing: -0.2);

  /// Card and section title — spec `700 12.5px`, the single most common title
  /// in the whole design (44×): "Customer information", "Payment", "Stay".
  static TextStyle get h3 => _sans(size: 12.5, weight: FontWeight.w700, height: 1.3, letterSpacing: -0.1);

  /// The name at the head of a list row — spec `700 14px` (lead card) and
  /// `700 13.5px` (booking, ops). Sits above [h3], below [h2].
  static TextStyle get rowTitle => _sans(size: 14, weight: FontWeight.w700, height: 1.25, letterSpacing: -0.2);

  // ── Body ───────────────────────────────────────────────────────────────

  /// Spec `500 14px/1.5` — the login paragraph, the only true body copy.
  static TextStyle get body => _sans(size: 14, weight: FontWeight.w500, height: 1.5, color: AppColors.body);

  /// Spec `500 14.5px` — form field values.
  static TextStyle get fieldValue => _sans(size: 14.5, weight: FontWeight.w500);

  /// Spec `500 11.5px` (18×) — the second line of a card. Not 13px: at 13 the
  /// destination line crowds the name above it and the card grows a row taller.
  static TextStyle get bodySm => _sans(size: 11.5, weight: FontWeight.w500, height: 1.45, color: AppColors.muted);

  /// Spec `500 11px` (16×) — captions and meta lines.
  static TextStyle get caption => _sans(size: 11, weight: FontWeight.w500, height: 1.4, color: AppColors.muted);

  /// Spec `500 10.5px` (10×) — the smallest supporting line, used under a row
  /// title where [caption] would still be too loud.
  static TextStyle get captionSm => _sans(size: 10.5, weight: FontWeight.w500, height: 1.4, color: AppColors.faint);

  // ── Labels ─────────────────────────────────────────────────────────────

  /// Spec `600 9px`, tracking 0.5, uppercase — **48 occurrences, the most-used
  /// style in the design**: the little grey label above every field value.
  static TextStyle get overline => _sans(
        size: 9,
        weight: FontWeight.w600,
        letterSpacing: 0.5,
        color: AppColors.faint,
      );

  /// Spec `700 10px`, tracking 0.9, uppercase — the label that heads a whole
  /// section rather than a single field ("SERVICES", "DAY PLAN").
  static TextStyle get sectionLabel => _sans(
        size: 10,
        weight: FontWeight.w700,
        letterSpacing: 0.9,
        color: AppColors.faint,
      );

  /// Spec `700 9.5px` — status chips and badges.
  static TextStyle get chip => _sans(size: 9.5, weight: FontWeight.w700, letterSpacing: 0.3);

  /// Spec `600 10.5px` — a chip that reads as text rather than a status.
  static TextStyle get chipSoft => _sans(size: 10.5, weight: FontWeight.w600);

  /// Spec `700 11.5px` (19×) — tab labels and small pill buttons.
  static TextStyle get tab => _sans(size: 11.5, weight: FontWeight.w700);

  /// Spec `700 13px` (17×) — the standard button label.
  static TextStyle get button => _sans(size: 13, weight: FontWeight.w700, letterSpacing: 0.1);

  /// Spec `700 15px` — the login button, the one full-width primary action.
  static TextStyle get buttonLarge => _sans(size: 15, weight: FontWeight.w700, letterSpacing: 0.1);

  /// Spec `600 9.5px`, tracking 0.1 — bottom-nav item label.
  static TextStyle get navLabel => _sans(size: 9.5, weight: FontWeight.w600, letterSpacing: 0.1);

  // ── Mono: numbers, IDs, currency, dates ────────────────────────────────
  //
  // The spec sets figures at 700/800. Its own stylesheet ships only 400/500/600
  // and lets the browser fake the bold; this app bundles the real Bold face so
  // the weight is drawn rather than smeared. 800 maps to 700 — Plex Mono has no
  // heavier cut, which is exactly what the browser falls back to as well.

  /// The one big number on a screen — spec `800 28px`, tracking −1.2
  /// (Payments outstanding, quotation grand total).
  static TextStyle get monoHero => _mono(size: 28, weight: FontWeight.w700, letterSpacing: -1.2);

  /// KPI and card headline figures — spec `700 21px`, tracking −0.6.
  static TextStyle get monoDisplay => _mono(size: 21, weight: FontWeight.w700, letterSpacing: -0.6);

  /// A section's total — spec `700 18px`, tracking −0.5.
  static TextStyle get monoLarge => _mono(size: 18, weight: FontWeight.w700, letterSpacing: -0.5);

  /// Money inside a list row — spec `700 15px`, the most common mono size
  /// (10×), tracking −0.4.
  static TextStyle get monoBase => _mono(size: 15, weight: FontWeight.w700, letterSpacing: -0.4);

  /// A figure that must not outshout the row's own amount — spec `700 13px`.
  static TextStyle get monoStrong => _mono(size: 13, weight: FontWeight.w700);

  /// Record IDs, reference lines, dates — spec `600 11px`.
  static TextStyle get monoSm => _mono(size: 11, weight: FontWeight.w600, color: AppColors.muted);

  /// The smallest mono line — timestamps under a message, file sizes.
  /// Spec `500 9.5px`.
  static TextStyle get monoXs => _mono(size: 9.5, weight: FontWeight.w500, color: AppColors.faint);

  /// Status-bar clock. Sans, not mono, in the spec too: `600 13px
  /// 'Plus Jakarta Sans'`, tracking 0.2.
  static TextStyle get monoClock => _sans(size: 13, weight: FontWeight.w600, letterSpacing: 0.2);
}
