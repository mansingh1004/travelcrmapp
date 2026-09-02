/// Lead enums, mirroring the RUNNING backend exactly (`C:\travelcrmbackend`,
/// module extraction `api_lead.json`).
///
/// The backend puts `@JsonValue` on `getDisplayName()`, so the wire value is
/// the human string ("New Lead"), never the constant name. Its `@JsonCreator`
/// accepts either form case-insensitively on writes; reads are always the
/// display name.
///
/// `LeadSource` is deliberately NOT an enum here: the server has 25 values
/// (JustDial, Meta Ads, IVR Call, …) and adds machine-only ones over time, so
/// the app carries it as the display `String` and loads pickable options from
/// `GET /api/leads/meta/sources`.
library;

/// Lowercased alphanumerics only, so "NEW_LEAD", "New Lead" and "new lead"
/// all collapse to the same key — mirroring the backend's lenient parser.
String _fold(String value) =>
    value.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');

/// `lead.enums.LeadStage` — 8 pipeline stages.
enum LeadStage {
  newLead('New Lead'),
  contacted('Contacted'),
  followUp('Follow Up'),
  qualified('Qualified'),
  proposalSent('Proposal Sent'),
  converted('Converted'),
  reopened('Reopened'),
  lost('Lost');

  const LeadStage(this.wire);

  /// The exact string the backend reads and writes.
  final String wire;

  /// Short label for tabs and chips (the prototype's wording where it differs).
  String get label => switch (this) {
        LeadStage.newLead => 'New',
        LeadStage.followUp => 'Follow-up',
        LeadStage.proposalSent => 'Quotation',
        LeadStage.converted => 'Won',
        _ => wire,
      };

  /// Stages that count as "active pipeline" (the server's activeOnly filter is
  /// the complement of the terminal stages).
  bool get isTerminal => this == LeadStage.converted || this == LeadStage.lost;

  static LeadStage? tryParse(String? value) {
    if (value == null) return null;
    final key = _fold(value);
    for (final s in LeadStage.values) {
      if (_fold(s.wire) == key || _fold(s.name) == key) return s;
    }
    return null;
  }
}

/// `lead.enums.LeadType` — the priority chip. Wire values are the short words.
enum LeadType {
  fresh('Fresh'),
  hot('Hot'),
  warm('Warm'),
  cold('Cold');

  const LeadType(this.wire);

  final String wire;

  String get label => wire;

  static LeadType? tryParse(String? value) {
    if (value == null) return null;
    final key = _fold(value);
    for (final t in LeadType.values) {
      // Accept legacy long forms ("Fresh Lead") as well as the wire value.
      if (key == _fold(t.wire) || key == _fold('${t.wire} Lead')) return t;
    }
    return null;
  }
}

/// One pickable lead source from `GET /api/leads/meta/sources`.
///
/// `value` is THE wire value (display name, e.g. "Google Ads"); `code` is the
/// stable enum-constant key (e.g. GOOGLE_ADS) the UI can theme off;
/// only `MANUAL_SELECTABLE` entries belong in a picker.
class LeadSourceOption {
  const LeadSourceOption({
    required this.value,
    required this.code,
    required this.selectable,
  });

  final String value;
  final String code;
  final bool selectable;

  static LeadSourceOption fromJson(Map<String, dynamic> json) => LeadSourceOption(
        value: json['value'] as String? ?? '',
        code: json['code'] as String? ?? '',
        selectable: (json['selectability'] as String?) == 'MANUAL_SELECTABLE',
      );
}
