/// Every route path in the app, in one place.
///
/// All 25 screens from the spec are present (option B): the 7 that the backend
/// supports render real data, the other 18 render a `ComingSoonView` naming the
/// endpoint they need. Navigation, drawer and deep links are therefore complete
/// today, and each screen lights up as its API lands.
abstract final class Routes {
  // ── Auth ───────────────────────────────────────────────────────────────
  static const splash = '/';
  static const login = '/login';

  // ── Bottom-nav tabs ────────────────────────────────────────────────────
  static const dashboard = '/dashboard';
  static const leads = '/leads';
  static const calendar = '/calendar';
  static const bookings = '/bookings';
  static const inbox = '/inbox';

  // ── Sales ──────────────────────────────────────────────────────────────
  static const leadCreate = '/leads/new';
  static const leadDetail = '/leads/:id';
  static const customers = '/customers';
  static const customerDetail = '/customers/:id';


  // ── Booking ────────────────────────────────────────────────────────────
  static const quotations = '/quotations';
  static const quotationCreate = '/quotations/new';
  static const quotationPreview = '/quotations/:id/preview';
  static const quotationEdit = '/quotations/:id/edit';
  static const itinerary = '/itinerary';
  static const bookingDetail = '/bookings/:id';
  static const bookingConvert = '/bookings/convert';

  // ── Operations ─────────────────────────────────────────────────────────
  static const operations = '/operations';
  static const operationsDetail = '/operations/:id';

  // ── Finance ────────────────────────────────────────────────────────────
  static const payments = '/payments';
  static const paymentDetail = '/payments/:id';
  static const reports = '/reports';

  // ── Communication ──────────────────────────────────────────────────────
  static const chat = '/inbox/:id';
  static const notifications = '/notifications';

  // ── Management ─────────────────────────────────────────────────────────
  static const masters = '/masters';
  static const vendors = '/vendors';
  static const profile = '/profile';
  static const settings = '/settings';
  static const search = '/search';

  /// Detail routes are addressed by publicId — the only identifier the API
  /// exposes. Internal ids never cross the wire.
  static String leadDetailFor(String publicId) => '/leads/$publicId';

  static String customerDetailFor(String publicId) => '/customers/$publicId';

  static String bookingDetailFor(String publicId) => '/bookings/$publicId';

  static String bookingConvertFor(String leadId, {String? quotationId}) =>
      '/bookings/convert?leadId=$leadId'
      '${quotationId == null ? '' : '&quotationId=$quotationId'}';

  static String quotationPreviewFor(String publicId) => '/quotations/$publicId/preview';

  static String quotationEditFor(String publicId) => '/quotations/$publicId/edit';

  static String operationsDetailFor(String bookingPublicId) =>
      '/operations/$bookingPublicId';

  static String chatFor(String conversationPublicId) => '/inbox/$conversationPublicId';
}
