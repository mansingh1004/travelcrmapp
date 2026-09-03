import 'package:dio/dio.dart';

import '../../../data/dto/envelopes.dart';
import '../../../data/remote/failure_mapper.dart';

/// Which catalog a Masters tab shows.
enum MasterKind {
  hotels('/api/hotels', 'Hotels', 'name'),
  vehicles('/api/vehicles', 'Vehicles', 'name'),
  // `/api/sightseeings` **500s** when a `sortBy` is sent — it has no sort
  // whitelist — so it is requested unsorted and the server's own order stands.
  sightseeing('/api/sightseeings', 'Sightseeing', null),
  vendors('/api/vendors', 'Vendors', 'vendorName');

  const MasterKind(this.path, this.label, this.sortBy);

  final String path;
  final String label;

  /// The catalog's name column, or null when the endpoint rejects sorting.
  final String? sortBy;

  /// One row of this catalog, lower case, for button and message copy.
  ///
  /// Not `label` minus its "s": "Sightseeing" is already singular, and reads
  /// wrong as "Add sightseeing entry" only if spelled out here.
  String get singular => switch (this) {
        MasterKind.hotels => 'hotel',
        MasterKind.vehicles => 'vehicle',
        MasterKind.sightseeing => 'sightseeing',
        MasterKind.vendors => 'vendor',
      };
}

/// A catalog row, flattened to what the list actually renders.
///
/// The four catalogs have different DTOs with little in common, so rather than
/// four near-identical models this reduces each to the same display fields.
class MasterRow {
  const MasterRow({
    required this.id,
    required this.title,
    this.numericId,
    this.subtitle,
    this.trailing,
    this.tags = const [],
    this.readOnly = false,
  });

  final String id;
  final String title;

  /// The hotel catalog is addressed by its numeric id, not its public one:
  /// `/api/hotels/{id}` declares `@PathVariable Long`. Null for the catalogs
  /// this app does not write to.
  final int? numericId;

  final String? subtitle;

  /// Right-aligned value — a rating, a rate, or an outstanding balance.
  final String? trailing;

  final List<String> tags;

  /// True for platform-synced rows the tenant cannot edit.
  final bool readOnly;
}

/// A `value`/`label` pair from `/api/masters/dropdown/*`.
class DropdownOption {
  const DropdownOption({required this.value, required this.label});

  factory DropdownOption.fromJson(Map<String, dynamic> json) => DropdownOption(
        value: (json['value'] as num?)?.toInt() ?? 0,
        label: MastersApi._str(json['label']) ?? '',
      );

  final int value;
  final String label;
}

/// One tenant hotel, as the create/edit form needs it.
///
/// Only the fields the form actually writes. The catalog carries far more —
/// room types, meal plans, images, marketplace links — but those are the
/// desktop console's business, not this app's.
class HotelMaster {
  const HotelMaster({
    required this.id,
    required this.name,
    this.destinationId,
    this.destinationName,
    this.city,
    this.stars,
    this.address,
    this.contactPerson,
    this.phone,
    this.email,
    this.imagePath,
    this.platformOwned = false,
  });

  factory HotelMaster.fromJson(Map<String, dynamic> json) => HotelMaster(
        id: (json['hotelId'] as num?)?.toInt() ?? 0,
        name: MastersApi._str(json['name']) ?? '',
        destinationId: (json['destinationId'] as num?)?.toInt(),
        destinationName: MastersApi._str(json['destinationName']),
        city: MastersApi._str(json['city']),
        stars: (json['stars'] as num?)?.toInt(),
        address: MastersApi._str(json['address']),
        contactPerson: MastersApi._str(json['contactPerson']),
        phone: MastersApi._str(json['phone']),
        email: MastersApi._str(json['email']),
        imagePath: MastersApi._str(json['imagePath']),
        platformOwned: json['platformOwned'] as bool? ?? false,
      );

  final int id;
  final String name;

  /// Required on create — the server refuses a hotel that sits under no
  /// destination — and required again on update whenever a city is sent.
  final int? destinationId;

  final String? destinationName;

  /// The city **name**, which the server resolves against the destination. It
  /// must already exist: a hotel cannot create a city.
  final String? city;

  final int? stars;
  final String? address;
  final String? contactPerson;
  final String? phone;
  final String? email;

  /// The stored photo's URL. Written as a string; the bytes go up separately
  /// through [MastersApi.uploadHotelImage].
  final String? imagePath;

  /// Synced from the Hotel Marketplace. The server rejects edits to every
  /// field this form writes, so such a row is shown but never opened for edit.
  final bool platformOwned;
}

/// One tenant vehicle, as the create/edit form needs it.
class VehicleMaster {
  const VehicleMaster({
    required this.publicId,
    required this.name,
    required this.type,
    this.capacity,
    this.description,
    this.global = false,
  });

  factory VehicleMaster.fromJson(Map<String, dynamic> json) => VehicleMaster(
        publicId: MastersApi._str(json['publicId']) ?? '',
        name: MastersApi._str(json['name']) ?? '',
        type: MastersApi._str(json['type']) ?? '',
        capacity: (json['capacity'] as num?)?.toInt(),
        description: MastersApi._str(json['description']),
        global: json['global'] as bool? ?? false,
      );

  /// The vehicle routes are keyed by UUID, not by a numeric id.
  final String publicId;

  final String name;

  /// Free text on the wire — Sedan, SUV, Tempo Traveller — not an enum.
  final String type;

  final int? capacity;
  final String? description;

  /// Platform-wide, shared with every tenant. The server answers 403 to any
  /// edit, so the list shows it but never opens it.
  final bool global;
}

/// One tenant sightseeing entry, as the create/edit form needs it.
class SightseeingMaster {
  const SightseeingMaster({
    required this.id,
    required this.title,
    this.destination,
    this.city,
    this.estimatedHours,
    this.description,
  });

  factory SightseeingMaster.fromJson(Map<String, dynamic> json) =>
      SightseeingMaster(
        id: (json['sightseeingId'] as num?)?.toInt() ?? 0,
        title: MastersApi._str(json['title']) ?? '',
        destination: MastersApi._str(json['destination']),
        city: MastersApi._str(json['city']),
        estimatedHours: (json['estimatedHours'] as num?)?.toDouble(),
        description: MastersApi._str(json['description']),
      );

  final int id;
  final String title;

  /// Destination and city travel as **names**, not ids, and the server refuses
  /// a request that omits either or names a pair it cannot find.
  final String? destination;
  final String? city;

  final double? estimatedHours;
  final String? description;
}

/// One destination — the geography every hotel and sightseeing entry hangs off.
class DestinationMaster {
  const DestinationMaster({
    required this.id,
    required this.name,
    this.type,
    this.description,
    this.countryId,
    this.countryName,
    this.global = false,
  });

  /// Reads both shapes: the list DTO calls the key `id` and the country
  /// `country`, while the detail DTO calls them `destinationId` and
  /// `countryName`.
  factory DestinationMaster.fromJson(Map<String, dynamic> json) =>
      DestinationMaster(
        id: (json['destinationId'] ?? json['id'] as Object?) is num
            ? ((json['destinationId'] ?? json['id']) as num).toInt()
            : 0,
        name: MastersApi._str(json['name']) ?? '',
        type: MastersApi._str(json['type']),
        description: MastersApi._str(json['description']),
        countryId: (json['countryId'] as num?)?.toInt(),
        countryName:
            MastersApi._str(json['countryName'] ?? json['country']),
        global: json['global'] as bool? ?? false,
      );

  final int id;
  final String name;

  /// "Domestic" or "International" on this backend.
  final String? type;

  final String? description;
  final int? countryId;
  final String? countryName;

  /// Platform-wide, created by a platform admin. `findByIdAndTenantId` cannot
  /// see it for this tenant, so editing one answers 404 — the list marks it
  /// read-only instead.
  final bool global;
}

/// One city, always under a destination.
class CityMaster {
  const CityMaster({
    required this.id,
    required this.name,
    this.state,
    this.destinationId,
    this.destinationName,
    this.countryId,
  });

  factory CityMaster.fromJson(Map<String, dynamic> json) => CityMaster(
        id: (json['cityId'] as num?)?.toInt() ?? 0,
        name: MastersApi._str(json['name']) ?? '',
        state: MastersApi._str(json['state']),
        destinationId: (json['destinationId'] as num?)?.toInt(),
        destinationName: MastersApi._str(json['destinationName']),
        countryId: (json['countryId'] as num?)?.toInt(),
      );

  final int id;
  final String name;
  final String? state;
  final int? destinationId;
  final String? destinationName;
  final int? countryId;
}

/// The master catalogs — hotels, vehicles, sightseeing and vendors.
class MastersApi {
  const MastersApi(this._dio);

  final Dio _dio;

  Future<PageEnvelope<MasterRow>> getRows(
    MasterKind kind, {
    int page = 0,
    int size = 25,
    String? search,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        kind.path,
        queryParameters: <String, dynamic>{
          'page': page,
          'size': size,
          if (kind.sortBy != null) ...{'sortBy': kind.sortBy, 'sortDir': 'asc'},
          if (search != null && search.trim().isNotEmpty) 'q': search.trim(),
        },
      );
      return PageEnvelope.from<MasterRow>(
        response.data,
        (json) => _toRow(kind, json),
      );
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static MasterRow _toRow(MasterKind kind, Map<String, dynamic> json) =>
      switch (kind) {
        MasterKind.hotels => MasterRow(
            id: json['publicId'] as String? ?? '${json['hotelId'] ?? ''}',
            numericId: (json['hotelId'] as num?)?.toInt(),
            title: _str(json['name']) ?? 'Unnamed hotel',
            subtitle: [
              _str(json['city']),
              _str(json['destinationName']),
            ].whereType<String>().join(', '),
            trailing: json['stars'] == null ? null : '${json['stars']}★',
            tags: _strings(json['amenities']).take(3).toList(growable: false),
            // Platform-synced hotels belong to the marketplace, not the tenant.
            readOnly: json['platformOwned'] as bool? ?? false,
          ),
        MasterKind.vehicles => MasterRow(
            id: json['publicId'] as String? ?? '',
            title: _str(json['name']) ?? 'Vehicle',
            subtitle: [
              _str(json['type']),
              if (json['capacity'] != null) '${json['capacity']} seats',
            ].whereType<String>().join(' · '),
            // A platform-wide vehicle is shared, not this tenant's to edit.
            readOnly: json['global'] as bool? ?? false,
          ),
        MasterKind.sightseeing => MasterRow(
            id: json['publicId'] as String? ?? '',
            numericId: (json['sightseeingId'] as num?)?.toInt(),
            title: _str(json['title']) ?? 'Sightseeing',
            subtitle: [
              _str(json['city']),
              _str(json['destination']),
            ].whereType<String>().join(', '),
            trailing: json['estimatedHours'] == null
                ? null
                : '${json['estimatedHours']}h',
          ),
        MasterKind.vendors => MasterRow(
            id: json['publicId'] as String? ?? '${json['id'] ?? ''}',
            title: _str(json['vendorName']) ?? 'Vendor',
            subtitle: [
              _str(json['vendorType']),
              _str(json['city']),
            ].whereType<String>().join(' · '),
            trailing: _str(json['vendorCode']),
            tags: [
              if (_str(json['status']) != null) _str(json['status'])!,
              if (json['verified'] as bool? ?? false) 'Verified',
            ],
          ),
      };

  // ── Writes ─────────────────────────────────────────────────────────────
  //
  // Hotels, vehicles and sightseeing are the tenant's own catalogs, and all
  // three write with `PLATFORM_ADMIN` or `MASTER_MANAGE`. Vendors are not
  // written from this app.
  //
  // Rows that belong to the platform rather than the tenant — a hotel synced
  // from the Marketplace, a global vehicle — also appear in the lists, and the
  // server rejects edits to them, so the app never offers one.
  //
  // Every delete below is a **soft** delete: the row moves to Trash and is
  // recoverable, and quotations and bookings keep resolving because they hold
  // a name snapshot rather than a reference.

  /// `GET /api/masters/dropdown/destinations` — every destination the tenant
  /// can see. A hotel must sit under one.
  Future<List<DropdownOption>> getDestinations() =>
      _dropdown('/api/masters/dropdown/destinations');

  /// `GET /api/masters/dropdown/cities?destinationId=` — the cities already
  /// defined under a destination.
  ///
  /// The hotel endpoints take the city by **name** and resolve it against the
  /// destination, and refuse a name that does not exist there, so the form
  /// picks from this list instead of accepting free text.
  Future<List<DropdownOption>> getCities(int destinationId) =>
      _dropdown('/api/masters/dropdown/cities?destinationId=$destinationId');

  // ── Dropdowns a quotation line picks from ──────────────────────────────

  /// `GET /api/masters/dropdown/hotels` — every hotel the tenant can quote,
  /// including the platform-synced ones, which are perfectly usable on a
  /// quotation even though the tenant cannot edit the catalog row.
  Future<List<DropdownOption>> getQuoteHotels({int? destinationId}) =>
      _dropdown(
        destinationId == null
            ? '/api/masters/dropdown/hotels'
            : '/api/masters/dropdown/hotels?destinationId=$destinationId',
      );

  /// `GET /api/masters/dropdown/room-types?hotelId=` — `hotelId` is required.
  Future<List<DropdownOption>> getRoomTypes(int hotelId) =>
      _dropdown('/api/masters/dropdown/room-types?hotelId=$hotelId');

  /// `GET /api/masters/dropdown/meal-plans?hotelId=` — `hotelId` is required.
  Future<List<DropdownOption>> getMealPlans(int hotelId) =>
      _dropdown('/api/masters/dropdown/meal-plans?hotelId=$hotelId');

  /// `GET /api/masters/dropdown/sightseeings?destinationId=`.
  Future<List<DropdownOption>> getQuoteSightseeings({int? destinationId}) =>
      _dropdown(
        destinationId == null
            ? '/api/masters/dropdown/sightseeings'
            : '/api/masters/dropdown/sightseeings?destinationId=$destinationId',
      );

  /// `GET /api/masters/dropdown/vehicles`.
  ///
  /// Takes no filter, and cannot: the vehicle master carries no city or
  /// destination, so a quotation for Mumbai still sees every vehicle.
  Future<List<DropdownOption>> getQuoteVehicles() =>
      _dropdown('/api/masters/dropdown/vehicles');

  Future<List<DropdownOption>> _dropdown(String path) async {
    try {
      final response = await _dio.get<dynamic>(path);
      final envelope = ApiEnvelope.from<List<DropdownOption>>(
        response.data,
        (data) => (data as List? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(DropdownOption.fromJson)
            .toList(growable: false),
      );
      return envelope.data ?? const [];
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/hotels/upload-image` — multipart, under the field name `file`.
  ///
  /// Returns the stored URL, which then travels as `imagePath` on create or
  /// update: two calls, because the catalog endpoints only take the string.
  ///
  /// **Nothing ever deletes a replaced image.** `HotelServiceImpl` only calls
  /// `cloudinaryService.uploadImage`, never `deleteImage`, and the controller
  /// notes the bytes are "irreversibly charged to the tenant's storage quota".
  /// So the form uploads on *save*, not on pick — a cancelled form spends
  /// nothing — and it downscales first.
  ///
  /// The server accepts JPG, PNG, WebP, GIF, SVG, ICO and PDF, up to 11 MB.
  Future<String> uploadHotelImage(String filePath) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/hotels/upload-image',
        data: FormData.fromMap({'file': await MultipartFile.fromFile(filePath)}),
      );
      return ApiEnvelope.from<String>(
        response.data,
        (data) => _str((data! as Map)['imagePath']) ?? '',
      ).requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `GET /api/hotels/{id}` — the row as the edit form needs it.
  Future<HotelMaster> getHotel(int id) async {
    try {
      final response = await _dio.get<dynamic>('/api/hotels/$id');
      final envelope = ApiEnvelope.from<HotelMaster>(
        response.data,
        (data) => HotelMaster.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/hotels`. Only `name` is required by the server; the rest is
  /// omitted rather than sent blank, so an untouched field stays unset instead
  /// of being written as an empty string.
  Future<HotelMaster> createHotel({
    required String name,
    required int destinationId,
    String? city,
    int? stars,
    String? address,
    String? contactPerson,
    String? phone,
    String? email,
    String? imagePath,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/hotels',
        data: _hotelBody(
          name: name,
          destinationId: destinationId,
          city: city,
          stars: stars,
          address: address,
          contactPerson: contactPerson,
          phone: phone,
          email: email,
          imagePath: imagePath,
        ),
      );
      final envelope = ApiEnvelope.from<HotelMaster>(
        response.data,
        (data) => HotelMaster.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `PUT /api/hotels/{id}`.
  Future<HotelMaster> updateHotel(
    int id, {
    required String name,
    required int destinationId,
    String? city,
    int? stars,
    String? address,
    String? contactPerson,
    String? phone,
    String? email,
    String? imagePath,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        '/api/hotels/$id',
        data: _hotelBody(
          name: name,
          destinationId: destinationId,
          city: city,
          stars: stars,
          address: address,
          contactPerson: contactPerson,
          phone: phone,
          email: email,
          imagePath: imagePath,
        ),
      );
      final envelope = ApiEnvelope.from<HotelMaster>(
        response.data,
        (data) => HotelMaster.fromJson(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `DELETE /api/hotels/{id}` — a **soft** delete on the server. The row moves
  /// to Trash and is recoverable, and quotations and bookings keep resolving
  /// because they hold a name snapshot rather than a reference.
  Future<void> deleteHotel(int id) async {
    try {
      await _dio.delete<dynamic>('/api/hotels/$id');
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  // ── Vehicles ───────────────────────────────────────────────────────────

  /// `GET /api/vehicles/{publicId}` — this catalog is keyed by its UUID, not a
  /// numeric id.
  Future<VehicleMaster> getVehicle(String publicId) =>
      _one('/api/vehicles/$publicId', VehicleMaster.fromJson);

  /// `POST /api/vehicles`. `name` and `type` are both `@NotBlank`.
  Future<VehicleMaster> createVehicle({
    required String name,
    required String type,
    int? capacity,
    String? description,
  }) =>
      _write(
        'POST',
        '/api/vehicles',
        _vehicleBody(
          name: name,
          type: type,
          capacity: capacity,
          description: description,
        ),
        VehicleMaster.fromJson,
      );

  /// `PUT /api/vehicles/{publicId}`.
  ///
  /// A global vehicle comes back 403 "Global vehicles can only be modified by
  /// the platform admin" — the list marks those read-only and offers no edit.
  Future<VehicleMaster> updateVehicle(
    String publicId, {
    required String name,
    required String type,
    int? capacity,
    String? description,
  }) =>
      _write(
        'PUT',
        '/api/vehicles/$publicId',
        _vehicleBody(
          name: name,
          type: type,
          capacity: capacity,
          description: description,
        ),
        VehicleMaster.fromJson,
      );

  Future<void> deleteVehicle(String publicId) =>
      _delete('/api/vehicles/$publicId');

  // ── Sightseeing ────────────────────────────────────────────────────────

  /// `GET /api/sightseeings/{id}` — keyed by the numeric `sightseeingId`.
  Future<SightseeingMaster> getSightseeing(int id) =>
      _one('/api/sightseeings/$id', SightseeingMaster.fromJson);

  /// `POST /api/sightseeings`.
  ///
  /// `title` is the DTO's only `@NotBlank`, but `resolveCityByName` rejects the
  /// request unless **both** destination and city are given — by name, and the
  /// pair must already exist for this tenant.
  Future<SightseeingMaster> createSightseeing({
    required String title,
    required String destination,
    required String city,
    double? estimatedHours,
    String? description,
  }) =>
      _write(
        'POST',
        '/api/sightseeings',
        _sightseeingBody(
          title: title,
          destination: destination,
          city: city,
          estimatedHours: estimatedHours,
          description: description,
        ),
        SightseeingMaster.fromJson,
      );

  /// `PUT /api/sightseeings/{id}`.
  Future<SightseeingMaster> updateSightseeing(
    int id, {
    required String title,
    required String destination,
    required String city,
    double? estimatedHours,
    String? description,
  }) =>
      _write(
        'PUT',
        '/api/sightseeings/$id',
        _sightseeingBody(
          title: title,
          destination: destination,
          city: city,
          estimatedHours: estimatedHours,
          description: description,
        ),
        SightseeingMaster.fromJson,
      );

  Future<void> deleteSightseeing(int id) => _delete('/api/sightseeings/$id');

  // ── Geography ──────────────────────────────────────────────────────────
  //
  // Destinations and the cities under them. These come first in practice: a
  // hotel or a sightseeing entry cannot be saved without a destination, and
  // its city must already exist — neither endpoint will create one.

  /// `GET /api/countries/dropdown` equivalent — a destination needs a country,
  /// and the server refuses one with neither `countryId` nor `country`.
  Future<List<DropdownOption>> getCountries() =>
      _dropdown('/api/masters/dropdown/countries');

  /// `GET /api/destinations` — the tenant's destinations plus the global ones.
  Future<List<DestinationMaster>> getDestinationRows({String? search}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/destinations',
        queryParameters: <String, dynamic>{
          'page': 0,
          'size': 100,
          if (search != null && search.trim().isNotEmpty) 'q': search.trim(),
        },
      );
      return PageEnvelope.from<DestinationMaster>(
        response.data,
        DestinationMaster.fromJson,
      ).content;
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<DestinationMaster> getDestination(int id) =>
      _one('/api/destinations/$id', DestinationMaster.fromJson);

  /// `POST /api/destinations`.
  ///
  /// `name` is the only `@NotBlank`, but `createFlat` throws 400 "Either
  /// countryId or country name is required" — so the country always goes out.
  /// A duplicate name for the tenant comes back 409.
  Future<DestinationMaster> createDestination({
    required String name,
    required int countryId,
    String? type,
    String? description,
  }) =>
      _write(
        'POST',
        '/api/destinations',
        <String, dynamic>{
          'name': name.trim(),
          'countryId': countryId,
          'type': ?_str(type),
          'description': ?_str(description),
        },
        DestinationMaster.fromJson,
      );

  /// `PUT /api/destinations/{id}`. The country cannot be changed — the update
  /// DTO has no `countryId`.
  Future<DestinationMaster> updateDestination(
    int id, {
    required String name,
    String? type,
    String? description,
  }) =>
      _write(
        'PUT',
        '/api/destinations/$id',
        <String, dynamic>{
          'name': name.trim(),
          'type': ?_str(type),
          'description': ?_str(description),
        },
        DestinationMaster.fromJson,
      );

  /// `DELETE /api/destinations/{id}` — soft, into Trash.
  ///
  /// Blocked with a 409 while any active **booking** still points at it. Its
  /// cities are not deleted: `detachFromDestination` unhooks them and they
  /// survive without a destination.
  Future<void> deleteDestination(int id) => _delete('/api/destinations/$id');

  /// `GET /api/cities/destination/{destinationId}`.
  Future<List<CityMaster>> getCityRows(int destinationId) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/cities/destination/$destinationId',
        queryParameters: <String, dynamic>{'page': 0, 'size': 100},
      );
      return PageEnvelope.from<CityMaster>(response.data, CityMaster.fromJson)
          .content;
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `POST /api/v1/destinations/{destinationId}/cities` — the nested create,
  /// so the city cannot be saved without its destination.
  Future<CityMaster> createCity(
    int destinationId, {
    required String name,
    String? state,
  }) =>
      _write(
        'POST',
        '/api/v1/destinations/$destinationId/cities',
        <String, dynamic>{'name': name.trim(), 'state': ?_str(state)},
        CityMaster.fromJson,
      );

  /// `PUT /api/cities/{cityId}`.
  Future<CityMaster> updateCity(
    int id, {
    required String name,
    required int destinationId,
    String? state,
  }) =>
      _write(
        'PUT',
        '/api/cities/$id',
        <String, dynamic>{
          'name': name.trim(),
          'destinationId': destinationId,
          'state': ?_str(state),
        },
        CityMaster.fromJson,
      );

  /// `DELETE /api/cities/{cityId}` — soft, into Trash.
  ///
  /// Blocked with a 409 while any active hotel, sightseeing, airline, cruise,
  /// add-on or vehicle still uses the city.
  Future<void> deleteCity(int id) => _delete('/api/cities/$id');

  // ── Plumbing ───────────────────────────────────────────────────────────

  Future<T> _one<T>(String path, T Function(Map<String, dynamic>) parse) async {
    try {
      final response = await _dio.get<dynamic>(path);
      return ApiEnvelope.from<T>(
        response.data,
        (data) => parse(data! as Map<String, dynamic>),
      ).requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<T> _write<T>(
    String method,
    String path,
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) parse,
  ) async {
    try {
      final response = await _dio.request<dynamic>(
        path,
        data: body,
        options: Options(method: method),
      );
      return ApiEnvelope.from<T>(
        response.data,
        (data) => parse(data! as Map<String, dynamic>),
      ).requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<void> _delete(String path) async {
    try {
      await _dio.delete<dynamic>(path);
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static Map<String, dynamic> _vehicleBody({
    required String name,
    required String type,
    int? capacity,
    String? description,
  }) =>
      <String, dynamic>{
        'name': name.trim(),
        'type': type.trim(),
        'capacity': ?capacity,
        'description': ?_str(description),
      };

  static Map<String, dynamic> _sightseeingBody({
    required String title,
    required String destination,
    required String city,
    double? estimatedHours,
    String? description,
  }) =>
      <String, dynamic>{
        'title': title.trim(),
        'destination': destination.trim(),
        'city': city.trim(),
        'estimatedHours': ?estimatedHours,
        'description': ?_str(description),
      };

  static Map<String, dynamic> _hotelBody({
    required String name,
    required int destinationId,
    String? city,
    int? stars,
    String? address,
    String? contactPerson,
    String? phone,
    String? email,
    String? imagePath,
  }) =>
      <String, dynamic>{
        'name': name.trim(),
        'destinationId': destinationId,
        'city': ?_str(city),
        'stars': ?stars,
        'address': ?_str(address),
        'contactPerson': ?_str(contactPerson),
        'phone': ?_str(phone),
        'email': ?_str(email),
        'imagePath': ?_str(imagePath),
      };

  static String? _str(Object? value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  static List<String> _strings(Object? value) => value is List
      ? value.map((e) => e.toString()).where((s) => s.isNotEmpty).toList(growable: false)
      : const [];
}
