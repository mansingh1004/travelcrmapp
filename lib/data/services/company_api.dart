import 'package:dio/dio.dart';

import '../dto/envelopes.dart';
import '../remote/failure_mapper.dart';

/// The agency's own record — `GET /api/company`.
class Company {
  const Company({
    required this.name,
    this.prefix,
    this.email,
    this.phone,
    this.website,
    this.gstin,
    this.tan,
    this.address,
    this.state,
    this.whatsappNumber,
    this.operatingSince,
    this.tripsSold,
    this.status,
    this.createdDate,
  });

  final String name;

  /// Code prefix stamped on lead and booking numbers.
  final String? prefix;

  final String? email;
  final String? phone;
  final String? website;
  final String? gstin;
  final String? tan;
  final String? address;
  final String? state;
  final String? whatsappNumber;
  final int? operatingSince;
  final int? tripsSold;
  final String? status;

  /// Already formatted by the server, e.g. "May 29, 2026".
  final String? createdDate;
}

/// The signed-in user's own profile — `GET /api/me/profile`.
class MeProfile {
  const MeProfile({
    required this.name,
    required this.username,
    this.email,
    this.phoneNumber,
    this.role,
  });

  final String name;

  /// The login id. Read-only — only an admin can change it.
  final String username;

  /// Contact only; not unique and not the login id.
  final String? email;

  final String? phoneNumber;
  final String? role;
}

/// `CompanyController` and `MeProfileController`.
class CompanyApi {
  const CompanyApi(this._dio);

  final Dio _dio;

  Future<Company> getCompany() async {
    try {
      final response = await _dio.get<dynamic>('/api/company');
      final envelope = ApiEnvelope.from<Company>(
        response.data,
        (data) => _toCompany(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  Future<MeProfile> getProfile() async {
    try {
      final response = await _dio.get<dynamic>('/api/me/profile');
      final envelope = ApiEnvelope.from<MeProfile>(
        response.data,
        (data) => _toProfile(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  /// `PUT /api/me/profile` — only name and phone are editable; email, username
  /// and role are read-only and the server ignores them.
  Future<MeProfile> updateProfile({
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        '/api/me/profile',
        data: <String, dynamic>{
          'name': name.trim(),
          'phoneNumber': ?phoneNumber,
        },
      );
      final envelope = ApiEnvelope.from<MeProfile>(
        response.data,
        (data) => _toProfile(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static Company _toCompany(Map<String, dynamic> json) => Company(
        name: _str(json['name']) ?? 'Your agency',
        prefix: _str(json['prefix']),
        email: _str(json['email']),
        phone: _str(json['phone']),
        website: _str(json['website']),
        gstin: _str(json['gstin']),
        tan: _str(json['tan']),
        address: _str(json['address']),
        state: _str(json['state']),
        whatsappNumber: _str(json['whatsappNumber']),
        operatingSince: (json['operatingSince'] as num?)?.toInt(),
        tripsSold: (json['tripsSold'] as num?)?.toInt(),
        status: _str(json['status']),
        createdDate: _str(json['createdDate']),
      );

  static MeProfile _toProfile(Map<String, dynamic> json) => MeProfile(
        name: _str(json['name']) ?? '',
        username: _str(json['username']) ?? '',
        email: _str(json['email']),
        phoneNumber: _str(json['phoneNumber']),
        role: _str(json['role']),
      );

  static String? _str(Object? value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }
}
