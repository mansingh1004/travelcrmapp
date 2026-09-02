import 'dart:convert';

import 'package:crmapp/data/dto/lead_dto.dart';
import 'package:crmapp/data/mappers/lead_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

/// A row copied verbatim out of a live `GET /api/leads` response, trimmed to
/// the fields whose wire types this app got wrong.
///
/// Both offenders look numeric but are not: the quotation `version` is the
/// label `"v1.0"` (the number lives in `versionNumber`), and an itinerary row
/// carries a UUID like every other public id. Declaring either as `int?` made
/// generated `fromJson` throw a `TypeError` on a perfectly good 200 — which
/// the leads list then rendered as a server error.
const _liveRow = '''
{
  "id": "fe3f9e63-1de4-4792-a234-e5e45e9ffcd1",
  "leadCode": "LD-26-0030",
  "customerName": "raju",
  "leadStage": "Converted",
  "leadType": "Fresh",
  "itinerary": [
    {
      "id": "99f8aaac-45e6-4d8d-a83f-5313eb2c15ab",
      "destination": "Pokhara",
      "city": "Kaski",
      "nights": 2,
      "dayNumber": 1
    }
  ],
  "latestQuotation": {
    "publicId": "60ca74da-9122-45c4-bca3-c2433527939b",
    "grandTotal": 5321.00,
    "version": "v1.0",
    "templateStyle": "CLASSIC"
  },
  "createdAt": "2026-08-25T17:10:00.942081"
}
''';

void main() {
  test('a live lead row parses — version is a label, itinerary ids are UUIDs', () {
    final dto = LeadDto.fromJson(jsonDecode(_liveRow) as Map<String, dynamic>);

    expect(dto.latestQuotation?.version, 'v1.0');
    expect(dto.itinerary.single.id, '99f8aaac-45e6-4d8d-a83f-5313eb2c15ab');

    final lead = LeadMapper.toEntity(dto);
    expect(lead.itinerary.single.destination, 'Pokhara');
    expect(lead.latestQuotationTotal, 5321.0);
  });
}
