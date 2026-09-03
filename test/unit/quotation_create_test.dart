import 'dart:typed_data';

import 'package:crmapp/data/services/quotation_api.dart';
import 'package:crmapp/features/quotations/presentation/quotation_create_screen.dart';
import 'package:crmapp/features/quotations/presentation/quotation_edit_screen.dart';
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

Dio _dio(_CapturingAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'http://x'))..httpClientAdapter = adapter;

/// Starting a quotation from a lead.
///
/// The bodies below are trimmed from responses captured against the running
/// backend, so the field names are the server's and not a guess.
void main() {
  group('template match', () {
    test('posts the lead and reads the server\'s ranking', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":[{"id":"8fbd7b46","name":"Goa & Manali Grand Tour",'
        '"matchPercentage":44,"durationNights":5,"durationDays":6,"hotelTier":3,'
        '"basePrice":88000.00,"cities":["Panaji","Shimla"],"belowThreshold":false}]}',
      );
      final matches = await QuotationApi(
        _dio(adapter),
      ).matchTemplates('lead-1');

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.method, 'POST');
      expect(adapter.captured!.path, '/api/quotation-templates/match');
      expect(body['leadId'], 'lead-1', reason: 'leadId is the only @NotNull');

      final match = matches.single;
      expect(match.id, '8fbd7b46');
      expect(match.matchPercentage, 44);
      expect(match.cities, ['Panaji', 'Shimla']);
      expect(match.basePrice, 88000.00);
    });

    test('an empty ranking is a normal answer, not a failure', () async {
      // A tenant with no saved templates gets an empty list; the screen offers
      // the empty draft instead.
      final adapter = _CapturingAdapter('{"success":true,"data":[]}');
      final matches = await QuotationApi(
        _dio(adapter),
      ).matchTemplates('lead-1');

      expect(matches, isEmpty);
    });
  });

  group('apply', () {
    test('creates a filled draft for the lead', () async {
      // Verified live: the draft comes back with the lead's customer block and
      // the template's priced sections already on it.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"publicId":"e96176cb","title":"Goa & Manali",'
        '"version":"v2.0","quotationStage":"Draft","quoteNo":26,"nights":5,'
        '"customer":{"name":"rahul","adults":2},'
        '"totals":{"grandTotal":47900.00}}}',
      );
      final draft = await QuotationApi(
        _dio(adapter),
      ).applyTemplate('8fbd7b46', leadId: 'lead-1');

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.path, '/api/quotation-templates/8fbd7b46/apply');
      expect(body['leadId'], 'lead-1');
      expect(draft.publicId, 'e96176cb');
      expect(draft.quotationStage, 'Draft');
    });

    test('omits a blank title rather than sending an empty one', () async {
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"publicId":"e96176cb"}}',
      );
      await QuotationApi(
        _dio(adapter),
      ).applyTemplate('t1', leadId: 'lead-1', title: '   ');

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(body.containsKey('title'), isFalse);
    });
  });

  group('quotation body', () {
    final hotels = <Map<String, dynamic>>[
      {'name': 'Taj Hotel', 'rooms': 2, 'pricePerRoom': 5000},
    ];
    final vehicles = <Map<String, dynamic>>[
      {'model': 'Innova', 'qty': 1, 'pricePerVehicle': 4500},
    ];
    final days = <Map<String, dynamic>>[
      {
        'day': 1,
        'pricePerPax': 600,
        'pax': 2,
        'activities': [
          {'attraction': 'Gateway of India', 'startTime': '09:00'},
        ],
      },
    ];

    test('never sends a destination', () {
      // A quotation's `destinationId` is the destination's public UUID, not the
      // numeric geography id the master dropdowns use. Sending the number came
      // back 400 "Please enter a valid Destination Id." — the picker on the
      // screen filters the masters and must not travel.
      final body = buildQuotationBody(
        leadId: 'lead-1',
        title: 'Quotation for rahul',
        hotels: hotels,
        vehicles: vehicles,
        days: days,
      );

      expect(body.containsKey('destinationId'), isFalse);
    });

    test('gives every section its own amount', () {
      final body = buildQuotationBody(
        leadId: 'lead-1',
        title: 'q',
        hotels: hotels,
        vehicles: vehicles,
        days: days,
      );

      expect((body['hotel'] as Map)['amount'], 10000);
      expect((body['vehicle'] as Map)['amount'], 4500);
      // Sightseeing is priced on the day, per head: 600 × 2.
      expect((body['sightseeing'] as Map)['amount'], 1200);
      expect((body['hotel'] as Map)['included'], isTrue);
    });

    test('leaves out a section with no rows', () {
      final body = buildQuotationBody(
        leadId: 'lead-1',
        title: 'q',
        hotels: hotels,
        vehicles: const [],
        days: const [],
      );

      expect(body.keys, containsAll(['leadId', 'title', 'hotel']));
      expect(body.containsKey('vehicle'), isFalse);
      expect(body.containsKey('sightseeing'), isFalse);
    });

    test('sends nothing about the traveller — the server snapshots it', () {
      final body = buildQuotationBody(
        leadId: 'lead-1',
        title: 'q',
        hotels: const [],
        vehicles: const [],
        days: const [],
      );

      expect(body.keys.toList(), ['leadId', 'title']);
    });
  });

  group('section amount', () {
    // Verified against the running backend: a hotel section PUT without an
    // `amount` dropped out of the grand total (47,900 → 13,800) even though its
    // rows were stored. `computeTotals` sums the section scalars, never rows.

    test('hotels are priced per room times rooms', () {
      final amount = sectionAmount('hotel', [
        {'pricePerRoom': 5000, 'rooms': 2},
        {'pricePerRoom': 3200.50, 'rooms': 1},
      ]);

      expect(amount, 13200.50);
    });

    test('vehicles are priced per vehicle times quantity', () {
      final amount = sectionAmount('vehicle', [
        {'pricePerVehicle': 4500, 'qty': 2},
        // An older line may carry `price` instead.
        {'price': 1000, 'qty': 1},
      ]);

      expect(amount, 10000);
    });

    test('a missing quantity counts as one, a missing price as nothing', () {
      expect(
        sectionAmount('hotel', [
          {'pricePerRoom': 5000},
        ]),
        5000,
      );
      expect(
        sectionAmount('hotel', [
          {'rooms': 3},
        ]),
        0,
      );
      expect(sectionAmount('hotel', const []), 0);
    });
  });

  group('editable document', () {
    // `PUT /api/quotations/{id}` re-maps every section, so a body that omits
    // one erases it. These guard the round trip the service editor depends on.

    test('keeps every section, even the ones the app cannot edit', () {
      final raw = <String, dynamic>{
        'publicId': 'q1',
        'leadId': 'lead-1',
        'title': 'Goa',
        'hotel': {'included': true, 'hotels': []},
        'vehicle': {'included': false, 'vehicles': []},
        'sightseeing': {
          'included': true,
          'days': [
            {'day': 1},
          ],
        },
        'flight': {
          'included': true,
          'segments': [
            {'airline': 'AI'},
          ],
        },
        'cruise': {'included': false},
        'addons': {'included': false},
        'inclusions': ['Breakfast'],
        'pricing': {'tax': 5},
      };

      final body = QuotationApi.editableDocument(raw);

      expect(body['sightseeing'], raw['sightseeing']);
      expect(body['flight'], raw['flight'], reason: 'never edited, never lost');
      expect(body['cruise'], raw['cruise']);
      expect(body['addons'], raw['addons']);
      expect(body['inclusions'], ['Breakfast']);
    });

    test('drops the computed fields the request has no place for', () {
      final body = QuotationApi.editableDocument(<String, dynamic>{
        'publicId': 'q1',
        'title': 'Goa',
        'quoteNo': 26,
        'nights': 5,
        'days': 6,
        'rooms': 2,
        'customer': {'name': 'rahul'},
        'totals': {'grandTotal': 47900},
        'allowedServices': ['hotel'],
        'pdfUrl': 'https://x/q.pdf',
        'createdBy': 'tenant_admin',
        'createdAt': '2026-09-02T16:29:10',
        'pricing': {'tax': 5},
      });

      for (final key in [
        'publicId',
        'quoteNo',
        'nights',
        'days',
        'rooms',
        'customer',
        'totals',
        'allowedServices',
        'pdfUrl',
        'createdBy',
        'createdAt',
      ]) {
        expect(body.containsKey(key), isFalse, reason: '$key is read-only');
      }
      // Kept: the client states the tax it wants and the server does the sums.
      expect(body['pricing'], {'tax': 5});
      expect(body['title'], 'Goa');
    });

    test('omits keys the quotation does not have rather than sending null', () {
      final body = QuotationApi.editableDocument(<String, dynamic>{
        'title': 'Goa',
        'notes': null,
        'cruise': null,
      });

      expect(body.keys, ['title']);
    });
  });

  group('empty draft', () {
    test('sends only the lead, which the server snapshots from', () async {
      // `linkLeadAndSnapshot` copies the customer, pax, travel date and
      // destination server-side, so the client sends none of them.
      final adapter = _CapturingAdapter(
        '{"success":true,"data":{"publicId":"new-1","version":"v1.0",'
        '"quotationStage":"Draft"}}',
      );
      final draft = await QuotationApi(
        _dio(adapter),
      ).createForLead(leadId: 'lead-1', title: 'Quotation for rahul');

      final body = adapter.captured!.data! as Map<String, dynamic>;
      expect(adapter.captured!.path, '/api/quotations');
      expect(body['leadId'], 'lead-1');
      expect(body['title'], 'Quotation for rahul');
      expect(
        body.containsKey('destinationId'),
        isFalse,
        reason: 'omitted, not sent as null',
      );
      expect(draft.publicId, 'new-1');
    });
  });
}
