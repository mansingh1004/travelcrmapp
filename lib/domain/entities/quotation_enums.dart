/// Quotation enums.
///
/// `QuotationStage` has only **four** values on this backend — the prototype's
/// eight-tab strip (Viewed / Negotiation / Expired …) has no equivalent, so the
/// list shows the four that exist rather than tabs that could never fill.
library;

String _fold(String value) =>
    value.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');

/// `quotation.enums.QuotationStage` — wire value is the label.
enum QuotationStage {
  draft('Draft'),
  sent('Sent'),
  approved('Approved'),
  rejected('Rejected');

  const QuotationStage(this.wire);

  final String wire;

  String get label => wire;

  static QuotationStage? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    final key = _fold(value);
    for (final stage in QuotationStage.values) {
      if (_fold(stage.wire) == key || _fold(stage.name) == key) return stage;
    }
    return null;
  }
}

/// `quotation.enums.TemplateStyle` — plain constant name on the wire; a null
/// column reads as CLASSIC.
enum TemplateStyle {
  classic('CLASSIC', 'Classic'),
  modern('MODERN', 'Modern'),
  premium('PREMIUM', 'Premium'),
  luxury('LUXURY', 'Luxury');

  const TemplateStyle(this.wire, this.label);

  final String wire;
  final String label;

  static TemplateStyle tryParse(String? value) {
    if (value == null || value.isEmpty) return TemplateStyle.classic;
    final key = _fold(value);
    for (final style in TemplateStyle.values) {
      if (_fold(style.wire) == key) return style;
    }
    return TemplateStyle.classic;
  }
}
