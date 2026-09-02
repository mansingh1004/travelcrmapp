/// Indian mobile formatting and normalisation.
///
/// The backend validates `^[6-9]\d{9}$` on both `RegisterRequestDTO.phoneNumber`
/// and `CreateLeadRequest.phone`, and it does **not** normalise phone before its
/// duplicate check (`API_GAPS.md` **G-10**) — so the client always sends a bare
/// 10-digit string.
abstract final class Phone {
  static final _indianMobile = RegExp(r'^[6-9]\d{9}$');

  /// Strip `+91`, `0`, spaces, dashes and brackets down to 10 digits.
  static String normalise(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 10 && digits.startsWith('91')) {
      digits = digits.substring(digits.length - 10);
    } else if (digits.length == 11 && digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    return digits;
  }

  /// True when [input] normalises to a valid Indian mobile number.
  static bool isValid(String input) => _indianMobile.hasMatch(normalise(input));

  /// `9822041155` → `+91 98220 41155`, the prototype's display form.
  static String display(String? input) {
    if (input == null || input.isEmpty) return '—';
    final d = normalise(input);
    if (d.length != 10) return input;
    return '+91 ${d.substring(0, 5)} ${d.substring(5)}';
  }

  /// `tel:` URI target.
  static String dialUri(String input) => 'tel:+91${normalise(input)}';

  /// `wa.me` target. WhatsApp is a **device deep link**, not an API call —
  /// the backend exposes no endpoint to send a WhatsApp message
  /// (`API_GAPS.md` § A).
  static String whatsAppUri(String input, {String? message}) {
    final base = 'https://wa.me/91${normalise(input)}';
    if (message == null || message.isEmpty) return base;
    return '$base?text=${Uri.encodeComponent(message)}';
  }
}
