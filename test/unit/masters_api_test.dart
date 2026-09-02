import 'dart:io';
import 'dart:typed_data';

import 'package:crmapp/features/masters/api/masters_api.dart';
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

    test('carries the numeric hotel id the write routes address', () async {
      // `/api/hotels/{id}` is a `@PathVariable Long`: the UUID identifies the
      // row in the list, but edit and delete need `hotelId`.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[{"hotelId":19,"publicId":"h1",'
        '"name":"Zed","platformOwned":false}],'
        '"pagination":{"page":0,"size":1,"totalElements":1,"totalPages":1,'
        '"first":true,"last":true,"hasNext":false}}',
      );
      final page = await MastersApi(_dio(adapter)).getRows(MasterKind.hotels);

      expect(page.content.single.numericId, 19);
    });
  });

  group('hotel writes', () {
    const created = '{"success":true,"data":{"hotelId":19,"name":"Zed",'
        '"destinationId":8,"destinationName":"bhopal","city":"uper lake",'
        '"stars":4,"phone":"9876500000","contactPerson":"Front Office",'
        '"address":"Lake Road","platformOwned":false}}';

    test('POSTs the destination the server requires and omits blank fields',
        () async {
      // `destinationId` is not in the request DTO's validation — the service
      // throws 400 "destinationId is required to create a hotel" from
      // resolveCity — so it must always go out.
      final adapter = _CapturingAdapter(created);
      await MastersApi(_dio(adapter)).createHotel(
        name: '  Zed  ',
        destinationId: 8,
        city: 'uper lake',
        stars: 4,
        phone: '',
        address: '   ',
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.method, 'POST');
      expect(adapter.captured!.path, '/api/hotels');
      expect(body['name'], 'Zed', reason: 'the name is trimmed');
      expect(body['destinationId'], 8);
      expect(body['city'], 'uper lake');
      expect(body['stars'], 4);
      expect(
        body.containsKey('phone'),
        isFalse,
        reason: 'an untouched field is omitted, not written as an empty string',
      );
      expect(body.containsKey('address'), isFalse);
    });

    test('PUTs to the numeric id and maps the response back', () async {
      final adapter = _CapturingAdapter(created);
      final hotel = await MastersApi(_dio(adapter)).updateHotel(
        19,
        name: 'Zed',
        destinationId: 8,
        city: 'uper lake',
      );

      expect(adapter.captured!.method, 'PUT');
      expect(adapter.captured!.path, '/api/hotels/19');
      expect(hotel.id, 19);
      expect(hotel.destinationId, 8);
      expect(hotel.destinationName, 'bhopal');
      expect(hotel.city, 'uper lake');
      expect(hotel.contactPerson, 'Front Office');
      expect(hotel.platformOwned, isFalse);
    });

    test('DELETE tolerates the empty body the server returns', () async {
      final adapter = _CapturingAdapter('');
      await MastersApi(_dio(adapter)).deleteHotel(19);

      expect(adapter.captured!.method, 'DELETE');
      expect(adapter.captured!.path, '/api/hotels/19');
    });
  });

  group('hotel image', () {
    test('reads the URL out of the upload response', () async {
      // The live shape, verified against the running backend:
      // {"success":true,"data":{"imagePath":"https://res.cloudinary.com/..."}}
      final adapter = _CapturingAdapter(
        '{"success":true,"message":"Image uploaded","data":{"imagePath":'
        '"https://res.cloudinary.com/x/image/upload/v1/hotels/a.png"}}',
      );
      final file = File('${Directory.systemTemp.path}/masters_api_test.png')
        ..writeAsBytesSync(const [137, 80, 78, 71]);
      // Swallowed: Dio's MultipartFile still holds the handle open when the
      // test ends, and Windows refuses to delete an open file.
      addTearDown(() {
        try {
          file.deleteSync();
        } on FileSystemException {
          // Left in the temp directory; the OS clears it.
        }
      });

      final url = await MastersApi(_dio(adapter)).uploadHotelImage(file.path);

      expect(adapter.captured!.method, 'POST');
      expect(adapter.captured!.path, '/api/hotels/upload-image');
      expect(
        adapter.captured!.data,
        isA<FormData>().having(
          (f) => f.files.single.key,
          'field name',
          'file',
        ),
        reason: 'the server reads @RequestParam("file")',
      );
      expect(url, 'https://res.cloudinary.com/x/image/upload/v1/hotels/a.png');
    });

    test('sends the stored URL back as imagePath on save', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"hotelId":19,"name":"Zed",'
        '"imagePath":"https://res.cloudinary.com/x/a.png"}}',
      );
      final hotel = await MastersApi(_dio(adapter)).createHotel(
        name: 'Zed',
        destinationId: 8,
        imagePath: 'https://res.cloudinary.com/x/a.png',
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(body['imagePath'], 'https://res.cloudinary.com/x/a.png');
      expect(hotel.imagePath, 'https://res.cloudinary.com/x/a.png');
    });
  });

  group('vehicle writes', () {
    const created = '{"success":true,"data":{"publicId":"5018fd27",'
        '"name":"Zed Innova","type":"SUV","capacity":7,'
        '"description":"AC, 4 bags","global":false}}';

    test('POSTs name and type, and omits a blank note', () async {
      final adapter = _CapturingAdapter(created);
      final vehicle = await MastersApi(_dio(adapter)).createVehicle(
        name: 'Zed Innova',
        type: 'SUV',
        capacity: 7,
        description: '  ',
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.path, '/api/vehicles');
      expect(body['name'], 'Zed Innova');
      expect(body['type'], 'SUV');
      expect(body['capacity'], 7);
      expect(body.containsKey('description'), isFalse);
      expect(vehicle.publicId, '5018fd27');
      expect(vehicle.global, isFalse);
    });

    test('addresses edit and delete by UUID, not a numeric id', () async {
      // `/api/vehicles/{publicId}` is a `@PathVariable UUID`.
      final adapter = _CapturingAdapter(created);
      await MastersApi(_dio(adapter))
          .updateVehicle('5018fd27', name: 'Zed', type: 'SUV');
      expect(adapter.captured!.method, 'PUT');
      expect(adapter.captured!.path, '/api/vehicles/5018fd27');

      final deleteAdapter = _CapturingAdapter('{"success":true}');
      await MastersApi(_dio(deleteAdapter)).deleteVehicle('5018fd27');
      expect(deleteAdapter.captured!.method, 'DELETE');
      expect(deleteAdapter.captured!.path, '/api/vehicles/5018fd27');
    });
  });

  group('sightseeing writes', () {
    const created = '{"success":true,"data":{"sightseeingId":15,'
        '"title":"Zed Fort Tour","destination":"bhopal","city":"uper lake",'
        '"estimatedHours":3.5,"description":"Tickets included"}}';

    test('sends destination and city as names, which the server requires',
        () async {
      // Only `title` is @NotBlank, but resolveCityByName throws 400 unless both
      // destination and city are present, and 404 if the pair does not exist.
      final adapter = _CapturingAdapter(created);
      final entry = await MastersApi(_dio(adapter)).createSightseeing(
        title: 'Zed Fort Tour',
        destination: 'bhopal',
        city: 'uper lake',
        estimatedHours: 3.5,
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(body['destination'], 'bhopal');
      expect(body['city'], 'uper lake');
      expect(body['estimatedHours'], 3.5);
      expect(entry.id, 15, reason: 'the numeric id is `sightseeingId`');
    });

    test('addresses edit and delete by the numeric id', () async {
      final adapter = _CapturingAdapter(created);
      await MastersApi(_dio(adapter)).updateSightseeing(
        15,
        title: 'Zed',
        destination: 'bhopal',
        city: 'uper lake',
      );
      expect(adapter.captured!.path, '/api/sightseeings/15');

      final deleteAdapter = _CapturingAdapter('');
      await MastersApi(_dio(deleteAdapter)).deleteSightseeing(15);
      expect(deleteAdapter.captured!.method, 'DELETE');
      expect(deleteAdapter.captured!.path, '/api/sightseeings/15');
    });

    test('list rows carry the numeric id the write routes need', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[{"sightseeingId":15,"publicId":"s1",'
        '"title":"Rajwada","city":"vijay nagar","destination":"indore"}],'
        '"pagination":{"page":0,"size":1,"totalElements":1,"totalPages":1,'
        '"first":true,"last":true,"hasNext":false}}',
      );
      final page =
          await MastersApi(_dio(adapter)).getRows(MasterKind.sightseeing);

      expect(page.content.single.numericId, 15);
    });
  });

  group('geography', () {
    test('always sends a country when creating a destination', () async {
      // `name` is the only @NotBlank, but createFlat throws 400 "Either
      // countryId or country name is required" without one.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"destinationId":14,"name":"Zed Valley",'
        '"type":"Domestic","countryId":6,"countryName":"Afghanistan"}}',
      );
      final destination = await MastersApi(_dio(adapter)).createDestination(
        name: 'Zed Valley',
        countryId: 6,
        type: 'Domestic',
      );

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.path, '/api/destinations');
      expect(body['countryId'], 6);
      expect(destination.id, 14);
      expect(destination.countryName, 'Afghanistan');
    });

    test('reads the list DTO, which names the key `id` and not `destinationId`',
        () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[{"id":14,"name":"Zed Valley",'
        '"country":"Afghanistan","type":"Domestic","global":true}],'
        '"pagination":{"page":0,"size":100,"totalElements":1,"totalPages":1,'
        '"first":true,"last":true,"hasNext":false}}',
      );
      final rows = await MastersApi(_dio(adapter)).getDestinationRows();

      expect(rows.single.id, 14);
      expect(rows.single.countryName, 'Afghanistan');
      expect(
        rows.single.global,
        isTrue,
        reason: 'a global destination is not this tenant\'s to edit',
      );
    });

    test('creates a city through the nested route', () async {
      // The nested path guarantees the destination: a city with none would be
      // invisible to the hotel and sightseeing forms, which look it up by
      // destination.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"cityId":21,"name":"Zed Town","state":"MP",'
        '"destinationId":15,"destinationName":"Zed Valley"}}',
      );
      final city = await MastersApi(_dio(adapter))
          .createCity(15, name: 'Zed Town', state: 'MP');

      expect(adapter.captured!.path, '/api/v1/destinations/15/cities');
      expect(city.id, 21);
      expect(city.destinationId, 15);
    });

    test('edits and deletes a city on the flat route', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"cityId":21,"name":"Zed Town 2"}}',
      );
      await MastersApi(_dio(adapter))
          .updateCity(21, name: 'Zed Town 2', destinationId: 15);

      expect(adapter.captured!.path, '/api/cities/21');
      expect(
        (adapter.captured!.data! as Map<String, dynamic>)['destinationId'],
        15,
        reason: 'the flat update carries the destination in the body',
      );

      final deleteAdapter = _CapturingAdapter('');
      await MastersApi(_dio(deleteAdapter)).deleteCity(21);
      expect(deleteAdapter.captured!.method, 'DELETE');
      expect(deleteAdapter.captured!.path, '/api/cities/21');
    });

    test('lists cities under one destination', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[{"cityId":21,"name":"Zed Town","state":"MP",'
        '"destinationId":15,"destinationName":"Zed Valley"}],'
        '"pagination":{"page":0,"size":100,"totalElements":1,"totalPages":1,'
        '"first":true,"last":true,"hasNext":false}}',
      );
      final rows = await MastersApi(_dio(adapter)).getCityRows(15);

      expect(adapter.captured!.path, '/api/cities/destination/15');
      expect(rows.single.name, 'Zed Town');
      expect(rows.single.state, 'MP');
    });
  });

  group('dropdowns', () {
    test('reads value/label pairs for the destination picker', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"message":"Destinations",'
        '"data":[{"value":8,"label":"bhopal"},{"value":1,"label":"Goa"}]}',
      );
      final options = await MastersApi(_dio(adapter)).getDestinations();

      expect(adapter.captured!.path, '/api/masters/dropdown/destinations');
      expect(options.map((o) => o.value), [8, 1]);
      expect(options.map((o) => o.label), ['bhopal', 'Goa']);
    });

    test('scopes cities to one destination', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[{"value":9,"label":"uper lake"}]}',
      );
      final options = await MastersApi(_dio(adapter)).getCities(8);

      // The endpoint 400s when neither destinationId nor countryId is sent.
      expect(adapter.captured!.uri.queryParameters['destinationId'], '8');
      expect(options.single.label, 'uper lake');
    });
  });
}
