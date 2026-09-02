import 'package:flutter/widgets.dart';

/// The categorical palette for charts.
///
/// Deliberately **separate from the status palette**: success / warn / danger
/// mean something specific everywhere else in the app, and reusing them for
/// "series 4" would make a chart segment read as a state.
///
/// The order is fixed and never cycled — a hue belongs to an entity, not to its
/// rank, so filtering a series out must not repaint the survivors. Beyond
/// [values] a category folds into [other] rather than getting a generated hue.
///
/// Validated against a white chart surface for the lightness band, chroma
/// floor, adjacent-pair CVD separation (deutan/protan/tritan), the
/// normal-vision floor and 3:1 contrast. The app ships light-only, so only the
/// light surface was checked. Re-run the check before changing an entry:
///
/// ```
/// node scripts/validate_palette.js \
///   "#2563EB,#DB2777,#0891B2,#7C3AED,#65A30D" --mode light --surface "#FFFFFF"
/// ```
///
/// Note the brand's own accent set does **not** pass: `purple #7C3AED` beside
/// `primary #2563EB` is ΔE 0.4 under deuteranopia — indistinguishable — and
/// `teal #0E7490` / `slate #475467` fall under the chroma floor and read gray.
/// Hence this separate, ordered set.
abstract final class ChartColors {
  static const blue = Color(0xFF2563EB);
  static const pink = Color(0xFFDB2777);
  static const cyan = Color(0xFF0891B2);
  static const purple = Color(0xFF7C3AED);
  static const lime = Color(0xFF65A30D);

  /// Fixed assignment order.
  static const values = <Color>[blue, pink, cyan, purple, lime];

  /// Everything past the fifth category. Grey is intentional: "Other" is not an
  /// identity, so it should not compete with one.
  static const other = Color(0xFF667085);

  /// How many real categories a chart shows before folding the tail.
  static const maxCategories = 5;

  /// The hue for the category at [index] in a **stable** ordering — one derived
  /// from the data's identity, not from its current rank.
  static Color at(int index) =>
      index < values.length ? values[index] : other;

  /// Single-series bars (revenue over time, agent totals) use one hue. Ranking
  /// is already carried by bar length and row order; colouring by rank would
  /// imply a category that is not there.
  static const series = blue;
}
