import 'package:dio/dio.dart';

import '../../../core/errors/failure.dart';
import '../../../data/dto/envelopes.dart';
import '../../../data/remote/failure_mapper.dart';

/// One supplier, as the app reads it.
///
/// The wire DTO carries forty-odd fields — bank account, IFSC, GST, PAN,
/// credit limit, coverage areas. Only what a phone shows or sends is modelled;
/// the rest stays on the desktop console and is never round-tripped, so this
/// app cannot blank it by accident.
class Vendor {
  const Vendor({
    required this.id,
    required this.name,
    this.publicId,
    this.code,
    this.type,
    this.contactPerson,
    this.phone,
    this.whatsapp,
    this.email,
    this.city,
    this.state,
    this.status,
    this.payStatus,
    this.services = const [],
    this.totalBusiness = 0,
    this.totalPaid = 0,
    this.outstanding = 0,
    this.rating,
    this.ratingCount,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: (json['id'] as num?)?.toInt() ?? 0,
        publicId: str(json['publicId']),
        code: str(json['vendorCode']),
        name: str(json['vendorName']) ?? 'Unnamed vendor',
        type: str(json['vendorType']),
        contactPerson: str(json['contactPerson']),
        phone: str(json['phone']),
        whatsapp: str(json['whatsapp']),
        email: str(json['email']),
        city: str(json['city']),
        state: str(json['state']),
        status: str(json['status']),
        payStatus: str(json['payStatus']),
        services: (json['services'] as List? ?? const [])
            .map((s) => s.toString())
            .where((s) => s.isNotEmpty)
            .toList(growable: false),
        totalBusiness: (json['totalBusiness'] as num?)?.toDouble() ?? 0,
        totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0,
        outstanding: (json['outstanding'] as num?)?.toDouble() ?? 0,
        rating: (json['rating'] as num?)?.toDouble(),
        ratingCount: (json['ratingCount'] as num?)?.toInt(),
      );

  /// The numeric id every vendor route is keyed on — `@PathVariable Long`.
  /// `publicId` exists too, but only the booking request uses it.
  final int id;

  final String? publicId;

  /// `VEN10002`, generated server-side.
  final String? code;

  final String name;

  /// One of Hotel, Airlines, Transport, DMC.
  final String? type;

  final String? contactPerson;
  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? city;
  final String? state;

  /// ACTIVE, INACTIVE, SUSPENDED or BLACKLISTED.
  final String? status;

  /// PAID, UNPAID, PARTIALLY_PAID or OVERDUE.
  final String? payStatus;

  final List<String> services;
  final double totalBusiness;
  final double totalPaid;
  final double outstanding;
  final double? rating;
  final int? ratingCount;

  /// How much of the business done with this vendor has been settled, 0–1.
  ///
  /// No business counts as nothing paid rather than as fully paid: a full bar
  /// against no business would read as a settled account.
  double get paidFraction =>
      totalBusiness > 0 ? (totalPaid / totalBusiness).clamp(0, 1).toDouble() : 0;

  /// Whether this vendor may still be given work.
  ///
  /// A suspended or blacklisted supplier is kept on file — the ledger has to
  /// survive — but must not be offered when a booking is placed.
  bool get bookable => status == null || status == 'ACTIVE';

  static String? str(Object? value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }
}

/// `VendorController` — `/api/vendors`.
///
/// Vendors sit outside the master catalogs on purpose. They carry a ledger
/// (`outstanding`, `totalBusiness`, credit terms), their own lifecycle
/// (`PATCH /{id}/status`, `PATCH /{id}/payment`) and their own permissions —
/// `VENDOR_READ` / `CREATE` / `UPDATE` / `DELETE` rather than the single
/// `MASTER_MANAGE` the hotel and vehicle catalogs share.
class VendorApi {
  const VendorApi(this._dio);

  final Dio _dio;

  /// The four values `VendorStatus` takes, in the order the console shows them.
  static const statuses = ['ACTIVE', 'INACTIVE', 'SUSPENDED', 'BLACKLISTED'];

  /// The four vendor types. A fixed vocabulary, not free text.
  static const types = ['Hotel', 'Airlines', 'Transport', 'DMC'];

  /// `GET /api/vendors` — paged, and **filtered server-side**.
  ///
  /// Search and the status/type facets are query params rather than a local
  /// filter, matching the console, whose own note says "the server does the
  /// narrowing" — filtering one page in the client would silently hide matches
  /// sitting on page two.
  Future<PageEnvelope<Vendor>> getVendors({
    int page = 0,
    int size = 25,
    String? search,
    String? status,
    String? type,
    String? payStatus,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/vendors',
        queryParameters: <String, dynamic>{
          'page': page,
          'size': size,
          'sortBy': 'vendorName',
          'sortDir': 'asc',
          if (search != null && search.trim().isNotEmpty) 'q': search.trim(),
          'status': ?status,
          'type': ?type,
          'payStatus': ?payStatus,
        },
      );
      return PageEnvelope.from<Vendor>(response.data, Vendor.fromJson);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/vendors/{id}` — returns the DTO **bare**, with no envelope.
  ///
  /// Unlike almost every other endpoint on this backend, the vendor detail and
  /// create routes answer with the object itself (`ResponseEntity.ok(dto)`), so
  /// reading a `data` node off it would find nothing. Both shapes are accepted
  /// in case that is ever brought into line.
  Future<Vendor> getVendor(int id) async {
    try {
      final response = await _dio.get<dynamic>('/api/vendors/$id');
      return _vendorFrom(response.data);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/vendors` — needs `VENDOR_CREATE`.
  ///
  /// Only `vendorName`, `vendorType` and `phone` are validated. Everything the
  /// ledger cares about — bank details, GST, PAN, credit limit — is left out
  /// entirely rather than sent empty, so the console keeps ownership of it.
  Future<Vendor> createVendor({
    required String name,
    required String type,
    required String phone,
    String? contactPerson,
    String? city,
    String? state,
    String? email,
    String? whatsapp,
  }) =>
      _write('POST', '/api/vendors', _body(
        name: name,
        type: type,
        phone: phone,
        contactPerson: contactPerson,
        city: city,
        state: state,
        email: email,
        whatsapp: whatsapp,
      ));

  /// `PUT /api/vendors/{id}` — needs `VENDOR_UPDATE`.
  ///
  /// The request is the same DTO as create, so its three `@NotBlank` fields go
  /// out every time even when only the city changed.
  Future<Vendor> updateVendor(
    int id, {
    required String name,
    required String type,
    required String phone,
    String? contactPerson,
    String? city,
    String? state,
    String? email,
    String? whatsapp,
  }) =>
      _write('PUT', '/api/vendors/$id', _body(
        name: name,
        type: type,
        phone: phone,
        contactPerson: contactPerson,
        city: city,
        state: state,
        email: email,
        whatsapp: whatsapp,
      ));

  /// `PATCH /api/vendors/{id}/status`.
  ///
  /// Its own route, not part of the update: blacklisting a supplier is a
  /// decision rather than an edit, and the console keeps the two apart.
  Future<Vendor> changeStatus(int id, String status) =>
      _write('PATCH', '/api/vendors/$id/status', {'status': status});

  static Map<String, dynamic> _body({
    required String name,
    required String type,
    required String phone,
    String? contactPerson,
    String? city,
    String? state,
    String? email,
    String? whatsapp,
  }) =>
      <String, dynamic>{
        'vendorName': name.trim(),
        'vendorType': type.trim(),
        'phone': phone.trim(),
        'contactPerson': ?Vendor.str(contactPerson),
        'city': ?Vendor.str(city),
        'state': ?Vendor.str(state),
        'email': ?Vendor.str(email),
        'whatsapp': ?Vendor.str(whatsapp),
      };

  Future<Vendor> _write(
    String method,
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        options: Options(method: method),
      );
      return _vendorFrom(response.data);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// Accepts the bare DTO these routes return, or an enveloped one.
  static Vendor _vendorFrom(Object? body) {
    if (body is! Map<String, dynamic>) {
      throw const ParseFailure(cause: 'Vendor response was not a JSON object');
    }
    final data = body['data'];
    return Vendor.fromJson(data is Map<String, dynamic> ? data : body);
  }
}
