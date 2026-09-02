import 'package:intl/intl.dart';

/// Indian rupee formatting with lakh/crore grouping (2,2,3), per the spec.
///
/// **The app never computes money.** GST, TCS, markup, totals and profit are
/// all derived server-side and rejected if sent in a request, so these are
/// presentation helpers only — they format values the server supplies.
abstract final class Inr {
  static final _whole = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final _precise = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final _plain = NumberFormat.decimalPattern('en_IN');

  /// `1850000` → `₹18,50,000`
  static String format(num? value) => value == null ? '—' : _whole.format(value);

  /// `1850000.5` → `₹18,50,000.50`
  static String formatPrecise(num? value) => value == null ? '—' : _precise.format(value);

  /// `1850000` → `18,50,000` (no symbol)
  static String plain(num? value) => value == null ? '—' : _plain.format(value);

  /// Compact Indian form for tight spaces: `₹18.5L`, `₹1.85Cr`, `₹85,000`.
  static String compact(num? value) {
    if (value == null) return '—';
    final v = value.abs();
    final sign = value < 0 ? '-' : '';
    if (v >= 10000000) {
      return '$sign₹${_trim(v / 10000000)}Cr';
    }
    if (v >= 100000) {
      return '$sign₹${_trim(v / 100000)}L';
    }
    return format(value);
  }

  static String _trim(double v) {
    final s = v.toStringAsFixed(2);
    return s.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
