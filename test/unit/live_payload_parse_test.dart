import 'dart:convert';
import 'dart:io';

import 'package:crmapp/data/dto/booking_dto.dart';
import 'package:crmapp/data/dto/customer_dto.dart';
import 'package:crmapp/data/dto/lead_dto.dart';
import 'package:crmapp/data/dto/operations_dto.dart';
import 'package:crmapp/data/dto/quotation_dto.dart';
import 'package:crmapp/data/mappers/booking_mapper.dart';
import 'package:crmapp/data/mappers/customer_mapper.dart';
import 'package:crmapp/data/mappers/lead_mapper.dart';
import 'package:crmapp/data/mappers/operations_mapper.dart';
import 'package:crmapp/data/mappers/quotation_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Parses payloads captured from the running backend through the real DTOs.
///
/// Two shipped bugs began as a wire-type mismatch that only surfaced on the
/// device — `version` arriving as `"v1.0"` where the DTO said `int?`, and
/// `quoteNo` arriving as a bare number where it said `String?`. Both threw a
/// `TypeError` out of generated `fromJson` code and the screen showed a generic
/// failure. A green `flutter analyze` cannot see any of that: the JSON is
/// `dynamic` until it is cast at runtime.
///
/// Refresh the fixtures by re-running the capture against a live backend; if a
/// field changes shape, this test fails here instead of on a user's phone.
void main() {
  final dir = Directory('test/_live');
  if (!dir.existsSync()) {
    // The fixtures are captured from a running backend, not committed noise —
    // skip rather than fail when someone runs the suite without them.
    return;
  }

  dynamic payload(String name) {
    final file = File('test/_live/$name.json');
    if (!file.existsSync()) return null;
    return jsonDecode(file.readAsStringSync().replaceFirst('﻿', ''));
  }

  /// The envelope every endpoint but `/api/calendar` and `/api/tasks` uses.
  dynamic data(String name) {
    final body = payload(name);
    if (body == null) return null;
    return body is Map<String, dynamic> && body.containsKey('data')
        ? body['data']
        : body;
  }

  List<Map<String, dynamic>> rows(String name) {
    final d = data(name);
    if (d == null) return const [];
    final list = d is List ? d : (d is Map && d['content'] is List ? d['content'] : const []);
    return (list as List).cast<Map<String, dynamic>>();
  }

  /// Parses every row, so a bad value in row 12 is caught as surely as row 0.
  void parsesAll<T>(String fixture, T Function(Map<String, dynamic>) parse) {
    final all = rows(fixture);
    if (all.isEmpty) return;
    for (var i = 0; i < all.length; i++) {
      expect(
        () => parse(all[i]),
        returnsNormally,
        reason: '$fixture row $i failed to parse: ${all[i]}',
      );
    }
  }

  void parsesOne<T>(String fixture, T Function(Map<String, dynamic>) parse) {
    final d = data(fixture);
    if (d is! Map<String, dynamic>) return;
    expect(() => parse(d), returnsNormally, reason: '$fixture failed to parse');
  }

  group('list rows parse and map', () {
    test('leads', () {
      parsesAll('leads', (j) => LeadMapper.toEntity(LeadDto.fromJson(j)));
    });

    test('customers', () {
      parsesAll('customers', (j) => CustomerMapper.toEntity(CustomerDto.fromJson(j)));
    });

    test('bookings', () {
      parsesAll('bookings', (j) => BookingMapper.toEntity(BookingDto.fromJson(j)));
    });

    test('quotations', () {
      parsesAll(
        'quotations',
        (j) => QuotationMapper.toSummary(QuotationSummaryDto.fromJson(j)),
      );
    });

    test('quotations for one lead', () {
      parsesAll(
        'quotations_for_lead',
        (j) => QuotationMapper.toSummary(QuotationSummaryDto.fromJson(j)),
      );
    });

    test('lead logs', () {
      parsesAll('lead_logs', (j) => LeadMapper.toLog(LeadLogDto.fromJson(j)));
    });

    test('booking services', () {
      parsesAll(
        'booking_services',
        (j) => BookingMapper.toService(BookingServiceDto.fromJson(j)),
      );
    });

    test('operations board', () {
      parsesAll(
        'ops_board',
        (j) => OperationsMapper.toBoardRow(OpsBoardRowDto.fromJson(j)),
      );
    });
  });

  group('detail payloads parse and map', () {
    test('lead detail', () {
      parsesOne('lead_detail', (j) => LeadMapper.toEntity(LeadDto.fromJson(j)));
    });

    test('lead detail keeps the fields only the edit form needs', () {
      // `PUT /api/leads/{id}` takes the create DTO and assigns every field
      // unconditionally, so an edit posts the whole lead back. Anything the
      // entity drops, the form re-sends as its own default — turning a save
      // into a silent wipe. These seven were on the wire and unmodelled while
      // the app was read-only here; this fixture is a real lead that has them.
      final lead = LeadMapper.toEntity(
        LeadDto.fromJson(data('lead_detail')! as Map<String, dynamic>),
      );

      expect(lead.male, 3);
      expect(lead.female, 2);
      expect(lead.packageType, 'Family');
      expect(lead.departureMode, 'Car / Road');
      expect(lead.specialAssistanceRequired, isFalse);
      expect(lead.assistancePassengerCount, 0);
    });

    test('customer detail', () {
      parsesOne('customer_detail', (j) => CustomerMapper.toEntity(CustomerDto.fromJson(j)));
    });

    test('customer summary', () {
      parsesOne(
        'customer_summary',
        (j) => CustomerMapper.toSummary(CustomerSummaryDto.fromJson(j)),
      );
    });

    test('booking detail', () {
      parsesOne('booking_detail', (j) => BookingMapper.toEntity(BookingDto.fromJson(j)));
    });

    test('booking straight out of a lead conversion', () {
      // The one booking payload that carries a `tripSnapshot`, because the
      // conversion builds it from the lead. Reading that object into the DTO's
      // `String?` threw a TypeError, and the screen span for ever on a booking
      // the server had already created.
      parsesOne(
        'booking_convert',
        (j) => BookingMapper.toEntity(BookingDto.fromJson(j)),
      );
    });

    test('quotation detail', () {
      parsesOne('quotation_detail', (j) => QuotationMapper.toEntity(QuotationDto.fromJson(j)));
    });
  });

  group('stats payloads parse and map', () {
    test('lead stats', () {
      parsesOne(
        'lead_stats',
        (j) => LeadMapper.toStats(LeadStatsSummaryDto.fromJson(j)),
      );
    });

    test('customer stats', () {
      parsesOne(
        'customer_stats',
        (j) => CustomerMapper.toStats(CustomerStatsDto.fromJson(j)),
      );
    });

    test('booking stats', () {
      parsesOne(
        'booking_stats',
        (j) => BookingMapper.toStats(BookingStatsDto.fromJson(j)),
      );
    });

    test('operations summary', () {
      parsesOne(
        'ops_summary',
        (j) => OperationsMapper.toSummary(OpsSummaryDto.fromJson(j)),
      );
    });
  });
}
