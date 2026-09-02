import 'package:crmapp/core/errors/failure.dart';
import 'package:crmapp/data/dto/envelopes.dart';
import 'package:crmapp/data/dto/lead_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PageEnvelope', () {
    test('reads PagedApiResponse exactly as GET /api/leads sends it', () {
      // `data` is a FLAT list and paging lives in a sibling `pagination`
      // object — not a nested Spring Page.
      final page = PageEnvelope.from<LeadDto>(
        const {
          'success': true,
          'message': 'Leads fetched successfully',
          'data': [
            {'id': 'a1', 'customerName': 'A B', 'phone': '9000000001'},
            {'id': 'b2', 'customerName': 'C D', 'phone': '9000000002'},
          ],
          'pagination': {
            'page': 0,
            'size': 10,
            'totalElements': 42,
            'totalPages': 5,
            'first': true,
            'last': false,
            'hasNext': true,
            'hasPrevious': false,
            'sortBy': 'createdAt',
            'sortDir': 'desc',
          },
          'timestamp': '2026-08-29T12:00:00',
        },
        LeadDto.fromJson,
      );

      expect(page.content, hasLength(2));
      expect(page.totalElements, 42);
      expect(page.pageSize, 10);
      expect(page.hasMore, isTrue);
      expect(page.nextPage, 1);
    });

    test('last page reports no more', () {
      final page = PageEnvelope.from<LeadDto>(
        const {
          'success': true,
          'data': <Map<String, dynamic>>[],
          'pagination': {
            'page': 0,
            'size': 10,
            'totalElements': 0,
            'totalPages': 1,
            'first': true,
            'last': true,
            'hasNext': false,
          },
        },
        LeadDto.fromJson,
      );

      expect(page.isEmpty, isTrue);
      expect(page.hasMore, isFalse);
      expect(page.nextPage, isNull);
    });

    test('skips malformed rows instead of failing the whole page', () {
      final page = PageEnvelope.from<LeadDto>(
        const {
          'success': true,
          'data': [
            {'id': 'a1', 'customerName': 'A B'},
            'not-an-object',
          ],
          'pagination': {'page': 0, 'size': 10, 'totalElements': 2, 'totalPages': 1, 'last': true},
        },
        LeadDto.fromJson,
      );

      expect(page.content, hasLength(1));
    });

    test('falls back sensibly when pagination is absent', () {
      final page = PageEnvelope.from<LeadDto>(
        const {
          'success': true,
          'data': [
            {'id': 'a1', 'customerName': 'A B'},
          ],
        },
        LeadDto.fromJson,
      );

      expect(page.content, hasLength(1));
      expect(page.pageNumber, 0);
      expect(page.hasMore, isFalse);
    });
  });

  group('ApiEnvelope', () {
    test('reads the success envelope used across the API', () {
      final envelope = ApiEnvelope.from<LeadDto>(
        const {
          'success': true,
          'message': 'Lead created successfully',
          'data': {'id': 'c3', 'customerName': 'A B'},
          'statusCode': 201,
          'timestamp': '2026-08-29T12:00:00',
        },
        (data) => LeadDto.fromJson(data! as Map<String, dynamic>),
      );

      expect(envelope.success, isTrue);
      expect(envelope.requireData().id, 'c3');
    });

    test('data is absent, not null, when @JsonInclude(NON_NULL) omits it', () {
      final envelope = ApiEnvelope.from<LeadDto>(
        const {'success': true, 'message': 'Nothing to return'},
        (data) => LeadDto.fromJson(data! as Map<String, dynamic>),
      );

      expect(envelope.data, isNull);
      expect(envelope.requireData, throwsA(isA<ParseFailure>()));
    });

    test('a non-object body is a ParseFailure, not a crash', () {
      expect(
        () => ApiEnvelope.from<LeadDto>('oops', (_) => const LeadDto()),
        throwsA(isA<ParseFailure>()),
      );
    });
  });
}
