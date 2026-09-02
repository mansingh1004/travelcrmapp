import 'dart:typed_data';

import 'package:crmapp/data/services/masters_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Captures the request Dio would send, and replays a canned response.
class _CapturingAdapter implements HttpClientAdapter {
  _CapturingAdapter(this.body);

  final String body;
  RequestOptions? captured;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    captured = options;
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Dio _dio(_CapturingAdapter adapter) => Dio(BaseOptions(baseUrl: 'http://x'))
  ..httpClientAdapter = adapter;

void main() {
  group('MastersApi query params', () {
    test('sends sortBy for catalogs that accept it', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[],"pagination":{"page":0,"size":25,'
        '"totalElements":0,"totalPages":0,"first":true,"last":true,'
        '"hasNext":false}}',
      );
      await MastersApi(_dio(adapter)).getRows(MasterKind.hotels);

      expect(adapter.captured!.queryParameters['sortBy'], 'name');
      expect(adapter.captured!.queryParameters['sortDir'], 'asc');
    });

    test('omits sortBy for sightseeing, which 500s when it is sent', () async {
      // The server has no sort whitelist on /api/sightseeings: sending
      // sortBy=name returns 500 INTERNAL_ERROR. Verified against the running
      // backend, so this must not regress.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[],"pagination":{"page":0,"size":25,'
        '"totalElements":0,"totalPages":0,"first":true,"last":true,'
        '"hasNext":false}}',
      );
      await MastersApi(_dio(adapter)).getRows(MasterKind.sightseeing);

      expect(adapter.captured!.queryParameters.containsKey('sortBy'), isFalse);
      expect(adapter.captured!.queryParameters.containsKey('sortDir'), isFalse);
    });
  });

  group('MastersApi row mapping', () {
    test('maps a vehicle from its real field names', () async {
      // `type`, not `vehicleType`; `global`, not a platformOwned flag; and
      // there is no city field at all.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[{"publicId":"v1","name":"Fortuner",'
        '"type":"luxury","capacity":5,"global":true}],'
        '"pagination":{"page":0,"size":1,"totalElements":1,"totalPages":1,'
        '"first":true,"last":true,"hasNext":false}}',
      );
      final page = await MastersApi(_dio(adapter)).getRows(MasterKind.vehicles);

      final row = page.content.single;
      expect(row.id, 'v1');
      expect(row.title, 'Fortuner');
      expect(row.subtitle, 'luxury · 5 seats');
      expect(row.readOnly, isTrue, reason: 'a global vehicle is not editable here');
    });

    test('maps sightseeing from title/destination/estimatedHours', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[{"publicId":"s1","title":"Rajwada",'
        '"city":"vijay nagar","destination":"indore","estimatedHours":3.0}],'
        '"pagination":{"page":0,"size":1,"totalElements":1,"totalPages":1,'
        '"first":true,"last":true,"hasNext":false}}',
      );
      final page = await MastersApi(_dio(adapter)).getRows(MasterKind.sightseeing);

      final row = page.content.single;
      expect(row.title, 'Rajwada', reason: 'the field is `title`, not `name`');
      expect(row.subtitle, 'vijay nagar, indore');
      expect(row.trailing, '3.0h');
    });

    test('marks a platform-synced hotel read-only', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[{"publicId":"h1","name":"Marriott",'
        '"city":"Mumbai","destinationName":"Maharashtra","stars":5,'
        '"platformOwned":true,"amenities":["Pool","Spa","Gym","Bar"]}],'
        '"pagination":{"page":0,"size":1,"totalElements":1,"totalPages":1,'
        '"first":true,"last":true,"hasNext":false}}',
      );
      final page = await MastersApi(_dio(adapter)).getRows(MasterKind.hotels);

      final row = page.content.single;
      expect(row.title, 'Marriott');
      expect(row.subtitle, 'Mumbai, Maharashtra');
      expect(row.trailing, '5★');
      expect(row.readOnly, isTrue);
      expect(row.tags, hasLength(3), reason: 'amenities are capped at three');
    });
  });
}
