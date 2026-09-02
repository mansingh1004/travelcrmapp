import 'package:crmapp/data/dto/lead_dto.dart';
import 'package:crmapp/data/mappers/lead_mapper.dart';
import 'package:crmapp/domain/entities/lead.dart';
import 'package:crmapp/domain/entities/lead_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LeadDto.fromJson', () {
    test('parses a full LeadResponseDto exactly as the backend sends it', () {
      // Shape copied from LeadResponseDto — enums arrive as display names and
      // ids are publicId UUIDs.
      final dto = LeadDto.fromJson(const {
        'id': 'a3f1c2d4-5e6f-4a7b-8c9d-0e1f2a3b4c5d',
        'leadCode': 'LD-2418',
        'customerName': 'Rahul Sharma',
        'phone': '9822041155',
        'email': 'rahul.sharma@gmail.com',
        'customerWhatsapp': '9822041155',
        'customerCity': 'Pune',
        'leadSource': 'Google Ads',
        'leadType': 'Hot',
        'leadStage': 'Qualified',
        'assignedUser': {
          'publicId': 'b4c5d6e7-8f90-4a1b-9c2d-3e4f5a6b7c8d',
          'fullName': 'Manasi Deshmukh',
          'role': 'TRAVEL_AGENT',
        },
        'birthDate': '1988-04-12',
        'followUpDate': '2026-09-02',
        'travelDate': '2026-09-12',
        'returnDate': '2026-09-19',
        'budget': 185000,
        'logCount': 3,
        'departCountry': 'India',
        'departCity': 'Pune',
        'rooms': 2,
        'adults': 4,
        'children': 2,
        'infants': 0,
        'extraBeds': 1,
        'services': ['Hotel', 'Vehicle'],
        'notes': 'Prefers 4-star',
        'itinerary': [
          // UUIDs, not Longs — the running server sends public ids here too.
          {
            'id': '99f8aaac-45e6-4d8d-a83f-5313eb2c15ab',
            'destination': 'Nepal',
            'city': 'Kathmandu',
            'nights': 3,
          },
          {
            'id': '519e3e13-b530-48a6-a632-22e3b8c33208',
            'destination': 'Nepal',
            'city': 'Pokhara',
            'nights': 3,
          },
        ],
        'latestQuotation': {'publicId': 'c5d6e7f8-9012-4b3c-8d4e-5f6a7b8c9d0e', 'grandTotal': 212000},
        'createdAt': '2026-08-20T11:30:00.123',
      });

      final lead = LeadMapper.toEntity(dto);

      expect(lead.id, 'a3f1c2d4-5e6f-4a7b-8c9d-0e1f2a3b4c5d');
      expect(lead.leadCode, 'LD-2418');
      expect(lead.customerName, 'Rahul Sharma');
      expect(lead.source, 'Google Ads');
      expect(lead.type, LeadType.hot);
      expect(lead.stage, LeadStage.qualified);
      expect(lead.assignedTo?.name, 'Manasi Deshmukh');
      expect(lead.budget, 185000);
      expect(lead.followUpDate, DateTime(2026, 9, 2));
      expect(lead.travelDate, DateTime(2026, 9, 12));
      expect(lead.latestQuotationTotal, 212000);
      expect(lead.itinerary, hasLength(2));
      expect(lead.itinerary.first.city, 'Kathmandu');
      // LocalDateTime has no zone designator, so it must stay local.
      expect(lead.createdAt, DateTime(2026, 8, 20, 11, 30, 0, 123));
    });

    test('tolerates an unknown enum value instead of throwing', () {
      // A new stage added server-side must not blank the whole list.
      final dto = LeadDto.fromJson(const {
        'id': 'd6e7f8a9-0123-4c4d-8e5f-6a7b8c9d0e1f',
        'customerName': 'A B',
        'phone': '9000000000',
        'leadStage': 'Some Future Stage',
        'leadType': 'Hot',
      });

      final lead = LeadMapper.toEntity(dto);

      expect(lead.stage, isNull);
      expect(lead.type, LeadType.hot, reason: 'other enums still resolve');
    });

    test('accepts constant names as well as display names', () {
      // The backend's @JsonCreator accepts both forms, case-insensitively.
      expect(LeadStage.tryParse('NEW_LEAD'), LeadStage.newLead);
      expect(LeadStage.tryParse('New Lead'), LeadStage.newLead);
      expect(LeadStage.tryParse('new lead'), LeadStage.newLead);
      expect(LeadStage.tryParse('Proposal Sent'), LeadStage.proposalSent);
      expect(LeadStage.tryParse('Follow Up'), LeadStage.followUp);
      expect(LeadType.tryParse('Hot'), LeadType.hot);
      // Legacy long form from the older schema still maps.
      expect(LeadType.tryParse('Hot Lead'), LeadType.hot);
    });

    test('fills defaults when optional collections are absent', () {
      final lead = LeadMapper.toEntity(
        LeadDto.fromJson(const {
          'id': 'e7f8a9b0-1234-4d5e-8f60-7a8b9c0d1e2f',
          'customerName': 'C D',
        }),
      );

      expect(lead.services, isEmpty);
      expect(lead.itinerary, isEmpty);
      expect(lead.phone, '');
      expect(lead.logCount, 0);
    });
  });

  group('LeadMapper.createBody', () {
    test('writes display names and normalises phone and email', () {
      final body = LeadMapper.createBody(
        customerName: '  Rahul Sharma ',
        phone: '+91 98220 41155',
        email: 'Rahul.Sharma@Gmail.com',
        sourceWire: 'Walk-in',
        type: LeadType.hot,
        stage: LeadStage.proposalSent,
        assignedUserId: 'b4c5d6e7-8f90-4a1b-9c2d-3e4f5a6b7c8d',
        travelDate: DateTime(2026, 9, 12),
        budget: 185000,
      );

      expect(body['phone'], '9822041155');
      expect(body['email'], 'rahul.sharma@gmail.com');
      expect(body['customerName'], 'Rahul Sharma');
      expect(body['leadSource'], 'Walk-in');
      expect(body['leadType'], 'Hot');
      expect(body['leadStage'], 'Proposal Sent');
      expect(body['assignedUserId'], 'b4c5d6e7-8f90-4a1b-9c2d-3e4f5a6b7c8d');
      expect(body['travelDate'], '2026-09-12');
      expect(body['budget'], 185000);
    });

    test('drops nulls so @Min constraints are not tripped', () {
      final body = LeadMapper.createBody(
        customerName: 'A B',
        phone: '9822041155',
        sourceWire: 'Website',
        type: LeadType.fresh,
        stage: LeadStage.newLead,
        assignedUserId: 'b4c5d6e7-8f90-4a1b-9c2d-3e4f5a6b7c8d',
      );

      expect(body.containsKey('adults'), isFalse);
      expect(body.containsKey('notes'), isFalse);
      expect(body.containsKey('itinerary'), isFalse);
      expect(body.containsKey('email'), isFalse);
      expect(body['customerName'], 'A B');
    });
  });

  group('LeadMapper.toStats', () {
    test('maps stage and type roll-ups into keyed maps', () {
      final stats = LeadMapper.toStats(
        LeadStatsSummaryDto.fromJson(const {
          'totalLeads': 40,
          'activeLeads': 28,
          'convertedLeads': 7,
          'lostLeads': 5,
          'proposalSentLeads': 6,
          'byStage': [
            {'stage': 'New Lead', 'count': 12},
            {'stage': 'Qualified', 'count': 9},
          ],
          'byType': [
            {'type': 'Hot', 'count': 4},
          ],
          'activePipelineValue': 4250000,
          'quotedValue': 1875000,
          'followUpsOverdue': 3,
          'followUpsDueToday': 2,
          'createdInPeriod': 15,
          'convertedInPeriod': 4,
          'conversionRate': 26.7,
        }),
      );

      expect(stats.byStage[LeadStage.newLead], 12);
      expect(stats.byStage[LeadStage.qualified], 9);
      expect(stats.hotLeads, 4);
      expect(stats.activePipelineValue, 4250000);
      expect(stats.conversionRate, 26.7);
    });

    test('keeps a null conversion rate null — it differs from zero', () {
      final stats = LeadMapper.toStats(
        LeadStatsSummaryDto.fromJson(const {'totalLeads': 0, 'createdInPeriod': 0}),
      );

      expect(stats.conversionRate, isNull);
      expect(stats.totalLeads, 0);
    });
  });

  group('Lead derived fields', () {
    const lead = Lead(
      id: 'a3f1c2d4-5e6f-4a7b-8c9d-0e1f2a3b4c5d',
      customerName: 'Rahul Sharma',
      phone: '9822041155',
      adults: 4,
      children: 2,
      itinerary: [
        LeadItineraryStop(destination: 'Nepal', city: 'Kathmandu', nights: 3),
        LeadItineraryStop(destination: 'Nepal', city: 'Pokhara', nights: 3),
      ],
    );

    test('initials, pax and nights are derived, not stored', () {
      expect(lead.initials, 'RS');
      expect(lead.paxLabel, '4A 2C');
      expect(lead.totalPax, 6);
      // Days = nights + 1 by travel convention; the backend has no days field.
      expect(lead.nightsLabel, '6N / 7D');
      expect(lead.destinationLabel, 'Nepal · Kathmandu & Pokhara');
    });

    test('single-word name still yields initials', () {
      const single = Lead(id: 'x', customerName: 'Rahul', phone: '9');
      expect(single.initials, 'RA');
    });
  });
}
