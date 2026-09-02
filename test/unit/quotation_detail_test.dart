import 'dart:convert';

import 'package:crmapp/data/dto/quotation_dto.dart';
import 'package:crmapp/data/mappers/quotation_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Trimmed from a live `GET /api/quotations/{publicId}` response, keeping the
/// shapes the preview reads.
///
/// Two details here are the reason this test exists: a flight segment's cabin
/// class arrives under the key `class`, which is a Dart keyword and has to be
/// mapped explicitly, and an unrated hotel arrives as `"stars": 0` rather than
/// as null. A third: `quoteNo` is a bare number on the wire.
const _live = '''
{
  "publicId": "60ca74da-9122-45c4-bca3-c2433527939b",
  "title": "raju — Pokhara — 6N",
  "version": "v1.0",
  "versionNumber": 1,
  "quotationStage": "Draft",
  "templateStyle": "CLASSIC",
  "quoteNo": 24,
  "nights": 8,
  "days": 9,
  "rooms": 1,
  "customer": {
    "name": "raju",
    "phone": "12323222",
    "email": null,
    "destination": "Pokhara, mumbai",
    "travelDate": "2026-08-26",
    "adults": 2,
    "children": 0,
    "infants": 0
  },
  "hotel": {
    "included": true,
    "amount": 5310.00,
    "hotels": [
      {
        "name": "merita",
        "city": "Kaski",
        "checkIn": "2026-08-25",
        "checkOut": "2026-08-27",
        "roomType": "",
        "stars": 0,
        "rooms": 1,
        "pricePerRoom": 1222.00
      },
      {
        "name": "Hotel Ajanta",
        "city": "mumbai",
        "checkIn": "2026-08-29",
        "checkOut": "2026-08-31",
        "roomType": "king",
        "stars": 7,
        "rooms": 1,
        "pricePerRoom": 77.00
      }
    ]
  },
  "vehicle": {
    "included": true,
    "amount": 11.00,
    "vehicles": [
      {
        "type": "SUV",
        "model": "6seater",
        "pickup": "Kaski",
        "drop": "mumbai",
        "startDate": "2026-08-26",
        "endDate": "2026-08-31",
        "qty": 1,
        "pricePerVehicle": 11.00
      }
    ]
  },
  "flight": {
    "included": false,
    "journey": "Round Trip",
    "segments": [
      {
        "airline": "",
        "flightNo": "",
        "class": "Economy",
        "from": "",
        "to": "Kaski",
        "depDate": "2026-08-26",
        "depTime": ""
      }
    ]
  },
  "sightseeing": {
    "included": false,
    "days": [
      {
        "day": 7,
        "date": "2026-08-31",
        "pax": 2,
        "activities": [
          {
            "attraction": "Departure from mumbai",
            "startTime": "",
            "description": "Check-out and departure from mumbai.",
            "transfer": "Private"
          }
        ]
      },
      {
        "day": 1,
        "date": "2026-08-25",
        "pax": 2,
        "activities": [{ "attraction": "Arrive Kaski" }]
      },
      { "day": 4, "date": "2026-08-28", "pax": 2, "activities": [] }
    ]
  },
  "inclusions": ["Accommodation as specified", "Transfers as specified"],
  "exclusions": ["Personal expenses"],
  "totals": {
    "subtotal": 5321.00,
    "discountType": "Fixed",
    "grandTotal": 5321.00,
    "perAdult": 2660.50
  }
}
''';

void main() {
  final quotation = QuotationMapper.toEntity(
    QuotationDto.fromJson(jsonDecode(_live) as Map<String, dynamic>),
  );

  test('reads the stay block, treating a zero star rating as unrated', () {
    expect(quotation.hotels, hasLength(2));

    final first = quotation.hotels.first;
    expect(first.name, 'merita');
    expect(first.city, 'Kaski');
    expect(first.stars, isNull, reason: '0 stars means unrated, not zero-star');
    expect(first.nights, 2);
    expect(first.roomType, isNull, reason: 'an empty string is not a room type');

    expect(quotation.hotels[1].stars, 7);
  });

  test('reads the vehicle block', () {
    final vehicle = quotation.vehicles.single;
    expect(vehicle.label, 'SUV · 6seater');
    expect(vehicle.route, 'Kaski → mumbai');
  });

  test('reads a flight segment, including the `class` key', () {
    final flight = quotation.flights.single;
    expect(flight.cabinClass, 'Economy');
    expect(flight.route, 'Kaski', reason: 'a blank origin leaves only the arrival');
    expect(flight.carrier, isNull, reason: 'blank airline and number carry nothing');
  });

  test('day plan is ordered by day and drops days with no activity', () {
    expect(quotation.dayPlan.map((d) => d.day), [1, 7]);
    expect(quotation.dayPlan.first.activities.single.attraction, 'Arrive Kaski');
    expect(
      quotation.dayPlan.last.activities.single.description,
      'Check-out and departure from mumbai.',
    );
  });

  test('reads a numeric quote number as text', () {
    expect(quotation.quoteNo, '24');
  });

  test('duration and totals come straight from the server', () {
    expect(quotation.durationLabel, '8N / 9D');
    expect(quotation.totals!.grandTotal, 5321.0);
    expect(quotation.totals!.perAdult, 2660.5);
  });
}
