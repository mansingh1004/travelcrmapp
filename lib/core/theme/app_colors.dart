import 'package:flutter/widgets.dart';

/// Every colour in the app. Nothing outside this file may declare a `Color`.
///
/// Values are lifted verbatim from the HTML prototype's inline styles and its
/// `C` / `STAGE` / `PRI` / `AV` token objects — not approximated.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1D4ED8);
  static const primaryDeep = Color(0xFF1E40AF);
  static const primaryTint = Color(0xFFEFF4FF);

  // ── Text ───────────────────────────────────────────────────────────────
  static const ink = Color(0xFF0F172A);
  static const body = Color(0xFF344054);
  static const muted = Color(0xFF667085);
  static const faint = Color(0xFF98A2B3);
  static const onPrimary = Color(0xFFFFFFFF);

  // ── Surfaces ───────────────────────────────────────────────────────────
  static const surface = Color(0xFFFFFFFF);
  static const canvas = Color(0xFFF4F6FA);
  static const line = Color(0xFFEAEEF6);
  static const border = Color(0xFFE4E9F2);

  /// The page behind the device frame in the prototype. Used only by the
  /// optional web shell, never inside the app itself.
  static const stage = Color(0xFFE6EAF2);

  /// Second stop of the spec's dark gradient (`#0F172A → #1E293B`) — the
  /// quotation letterhead and the Payments summary card.
  static const inkSoft = Color(0xFF1E293B);

  // ── Faint row tints ────────────────────────────────────────────────────
  // The spec washes rows and nested panels with tints a shade off white. They
  // read as "almost white" but they are what keeps a long list from looking
  // flat, so each one is a token rather than an opacity guess.

  /// Unread row in the inbox and notifications.
  static const tintUnread = Color(0xFFFBFDFF);

  /// Pressed / selected row.
  static const tintRow = Color(0xFFF7FAFF);

  /// Panel nested inside a card (login gradient's lower stop, drawer hover).
  static const tintPanel = Color(0xFFF4F7FE);

  /// Nested list row inside a card — ops services, booking documents.
  static const tintNested = Color(0xFFF9FAFD);

  /// Neutral inset block — traveller counts, notes.
  static const tintInset = Color(0xFFF7F9FC);

  // ── Structure ──────────────────────────────────────────────────────────
  /// Border of a selected chip and the ring around the header avatar.
  static const borderActive = Color(0xFFBFDBFE);

  /// Border a card takes when it is pressed.
  static const borderHover = Color(0xFFC7D7F7);

  /// Dashed placeholder border — "add day", "add note".
  static const borderDashed = Color(0xFFC7D0DE);

  /// Skeleton block while a list loads.
  static const skeleton = Color(0xFFEDF1F8);

  /// Track behind a progress bar.
  static const track = Color(0xFFEEF2F9);

  /// Disabled chevron / drag handle.
  static const disabled = Color(0xFFC3CBDA);

  // ── Semantic pairs (foreground, background) ────────────────────────────
  static const success = Color(0xFF059669);
  static const successBg = Color(0xFFECFDF5);

  static const warn = Color(0xFFD97706);
  static const warnBg = Color(0xFFFFF7ED);

  static const danger = Color(0xFFDC2626);
  static const dangerBg = Color(0xFFFEF2F2);

  static const purple = Color(0xFF7C3AED);
  static const purpleBg = Color(0xFFF5F3FF);

  static const slate = Color(0xFF475467);
  static const slateBg = Color(0xFFF2F5FB);

  /// Teal — prototype `STAGE.Qualified`.
  static const teal = Color(0xFF0E7490);
  static const tealBg = Color(0xFFECFEFF);

  /// Amber — prototype `STAGE.Negotiation`.
  static const amber = Color(0xFFB45309);
  static const amberBg = Color(0xFFFEF3C7);

  /// Blue tint used by avatar/stage fills that are deeper than [primaryTint].
  static const blueTint = Color(0xFFDBEAFE);

  // ── Deeper semantic fills ──────────────────────────────────────────────
  // The pairs above are the everyday chip colours. These are the stronger
  // fills the spec reaches for when something needs to be read as an alert or
  // a quoted message rather than a label.

  /// Amber note block — the lead's yellow Notes card.
  static const noteBg = Color(0xFFFFFBEB);
  static const noteBorder = Color(0xFFFDE68A);
  static const noteInk = Color(0xFF78350F);

  /// Critical operations banner.
  static const criticalBorder = Color(0xFFFECACA);
  static const criticalTint = Color(0xFFFEE2E2);
  static const criticalInk = Color(0xFF991B1B);

  /// The customer's own words, quoted back — booking detail, chat summary.
  static const quoteBg = Color(0xFFF0FDF4);
  static const quoteBorder = Color(0xFFBBF7D0);
  static const quoteInk = Color(0xFF166534);

  // ── On a dark surface ──────────────────────────────────────────────────
  // Figures printed on [ink] / [inkSoft]. The everyday [success] and [danger]
  // do not survive that background, so the spec brightens them.
  static const onDarkMuted = Color(0xFF94A3B8);
  static const onDarkPositive = Color(0xFF86EFAC);
  static const onDarkNegative = Color(0xFFFCA5A5);
  static const onDarkWarning = Color(0xFFFCD34D);
  static const onDarkLink = Color(0xFF60A5FA);

  /// Hairline between rows printed on a dark card — spec
  /// `rgba(255,255,255,.2)`.
  static const onDarkLine = Color(0x33FFFFFF);

  /// Fill of an inset panel on a dark card — spec `rgba(255,255,255,.16)`.
  static const onDarkPanel = Color(0x29FFFFFF);

  // ── WhatsApp thread ────────────────────────────────────────────────────
  // The chat is drawn as WhatsApp itself draws it, because that is what the
  // agent is looking at on the other phone.
  static const chatCanvas = Color(0xFFEDEAE4);
  static const chatOutbound = Color(0xFFD9FDD3);
  static const chatMeta = Color(0xFF8A9099);
  static const chatTick = Color(0xFF34B7F1);
  static const chatDivider = Color(0xFF7A756C);

  // ── Avatar palette (prototype `AV`) ────────────────────────────────────
  /// Deterministic avatar colours: index by `name.hashCode % length`.
  static const avatarBackgrounds = <Color>[
    Color(0xFFDBEAFE),
    Color(0xFFDCFCE7),
    Color(0xFFFEF3C7),
    Color(0xFFEDE9FE),
    Color(0xFFFFE4E6),
    Color(0xFFCFFAFE),
  ];

  static const avatarForegrounds = <Color>[
    Color(0xFF1D4ED8),
    Color(0xFF047857),
    Color(0xFFB45309),
    Color(0xFF6D28D9),
    Color(0xFFBE123C),
    Color(0xFF0E7490),
  ];

  /// Stable avatar colour pair for a person's name.
  static (Color background, Color foreground) avatarFor(String seed) {
    final i = seed.isEmpty ? 0 : seed.codeUnits.fold(0, (a, b) => a + b) % avatarBackgrounds.length;
    return (avatarBackgrounds[i], avatarForegrounds[i]);
  }
}
