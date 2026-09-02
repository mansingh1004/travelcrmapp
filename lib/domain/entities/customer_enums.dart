/// Customer enums, mirroring the backend's `@JsonValue` display names.
///
/// Reads always carry the display name; writes accept either form
/// case-insensitively, so the display name is what the app sends.
library;

String _fold(String value) =>
    value.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');

/// `customer.enums.CustomerStatus`.
enum CustomerStatus {
  active('Active'),
  inactive('Inactive'),
  blocked('Blocked');

  const CustomerStatus(this.wire);

  final String wire;

  String get label => wire;

  static CustomerStatus? tryParse(String? value) => _parse(value, CustomerStatus.values, (e) => e.wire);
}

/// `customer.enums.CustomerType`.
enum CustomerType {
  individual('Individual'),
  regular('Regular'),
  corporate('Corporate'),
  vip('VIP'),
  group('Group'),
  agent('Agent');

  const CustomerType(this.wire);

  final String wire;

  String get label => wire;

  static CustomerType? tryParse(String? value) => _parse(value, CustomerType.values, (e) => e.wire);
}

/// `customer.enums.LoyaltyTier`.
enum LoyaltyTier {
  bronze('Bronze'),
  silver('Silver'),
  gold('Gold'),
  platinum('Platinum');

  const LoyaltyTier(this.wire);

  final String wire;

  String get label => wire;

  static LoyaltyTier? tryParse(String? value) => _parse(value, LoyaltyTier.values, (e) => e.wire);
}

/// How the customer prefers to be contacted. Shared with the lead module.
enum CommunicationPreference {
  whatsapp('WhatsApp'),
  sms('SMS'),
  email('Email'),
  phoneCall('Phone Call'),
  allChannels('All Channels');

  const CommunicationPreference(this.wire);

  final String wire;

  String get label => wire;

  static CommunicationPreference? tryParse(String? value) =>
      _parse(value, CommunicationPreference.values, (e) => e.wire);
}

/// Shared lenient parser: matches the wire value or the constant name,
/// ignoring case and punctuation — the same tolerance the server has.
T? _parse<T extends Enum>(String? value, List<T> values, String Function(T) wireOf) {
  if (value == null || value.isEmpty) return null;
  final key = _fold(value);
  for (final entry in values) {
    if (_fold(wireOf(entry)) == key || _fold(entry.name) == key) return entry;
  }
  return null;
}
