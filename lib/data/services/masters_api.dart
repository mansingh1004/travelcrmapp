import 'package:dio/dio.dart';

import '../dto/envelopes.dart';
import '../remote/failure_mapper.dart';

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
}

/// A catalog row, flattened to what the list actually renders.
///
/// The four catalogs have different DTOs with little in common, so rather than
/// four near-identical models this reduces each to the same four display
/// fields. Nothing here is written back, so the detail is not needed.
class MasterRow {
  const MasterRow({
    required this.id,
    required this.title,
    this.subtitle,
    this.trailing,
    this.tags = const [],
    this.readOnly = false,
  });

  final String id;
  final String title;
  final String? subtitle;

  /// Right-aligned value — a rating, a rate, or an outstanding balance.
  final String? trailing;

  final List<String> tags;

  /// True for platform-synced rows the tenant cannot edit.
  final bool readOnly;
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

  static String? _str(Object? value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  static List<String> _strings(Object? value) => value is List
      ? value.map((e) => e.toString()).where((s) => s.isNotEmpty).toList(growable: false)
      : const [];
}
