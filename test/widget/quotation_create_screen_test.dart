import 'dart:async';
import 'dart:typed_data';

import 'package:crmapp/core/di.dart';
import 'package:crmapp/core/theme/app_theme.dart';
import 'package:crmapp/data/services/quotation_api.dart';
import 'package:crmapp/domain/entities/lead.dart';
import 'package:crmapp/domain/repositories/lead_repository.dart';
import 'package:crmapp/features/quotations/presentation/quotation_create_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Replays a canned body, and can hang to pin the loading state.
class _Adapter implements HttpClientAdapter {
  _Adapter(this.body, {this.hang = false});

  final String body;
  final bool hang;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (hang) return Completer<ResponseBody>().future;
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

/// Only `getLead` is reached by this screen; the rest must never be called.
class _FakeLeadRepository implements LeadRepository {
  _FakeLeadRepository(this.lead);

  final Lead lead;

  @override
  Future<Lead> getLead(String publicId) async => lead;

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}

const _lead = Lead(
  id: 'lead-1',
  customerName: 'rahul',
  phone: '87232341',
  adults: 2,
);

Widget _app(String body, {bool hang = false}) {
  final dio = Dio(BaseOptions(baseUrl: 'http://x'))
    ..httpClientAdapter = _Adapter(body, hang: hang);

  return ProviderScope(
    overrides: [
      leadRepositoryProvider.overrideWithValue(_FakeLeadRepository(_lead)),
      quotationApiProvider.overrideWithValue(QuotationApi(dio)),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const QuotationCreateScreen(leadId: 'lead-1'),
    ),
  );
}

void main() {
  const oneTemplate = '{"success":true,"data":[{"id":"t1",'
      '"name":"Goa & Manali Grand Tour","matchPercentage":44,'
      '"durationNights":5,"durationDays":6,"hotelTier":3,"basePrice":88000.00,'
      '"cities":["Panaji","Shimla"],"belowThreshold":false}]}';

  testWidgets('loading state raises no layout exception', (tester) async {
    await tester.pumpWidget(_app(oneTemplate, hang: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      tester.takeException(),
      isNull,
      reason: 'the skeleton must shrink-wrap inside the page list',
    );
  });

  testWidgets('renders the lead summary and the ranked templates', (tester) async {
    await tester.pumpWidget(_app(oneTemplate));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('rahul'), findsOneWidget);
    expect(find.text('Goa & Manali Grand Tour'), findsOneWidget);
    expect(find.text('44% match'), findsOneWidget);
    expect(find.text('Panaji · Shimla'), findsOneWidget);
    // The blocks below the fold are only built as the list scrolls to them,
    // so reaching them is the assertion.
    for (final label in ['Hotels', 'Vehicles', 'Sightseeing']) {
      await tester.scrollUntilVisible(find.text(label), 250);
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('still lets the agent build one when no package matches',
      (tester) async {
    await tester.pumpWidget(_app('{"success":true,"data":[]}'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.textContaining('No package templates yet'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Add hotel'), 250);
    expect(find.text('Add hotel'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Add vehicle'), 250);
    expect(find.text('Add vehicle'), findsOneWidget);
  });

  testWidgets('the button says the quotation would be empty', (tester) async {
    // Nothing has been added, so the submit is honest about what it makes
    // rather than pretending a quotation is being built.
    await tester.pumpWidget(_app('{"success":true,"data":[]}'));
    await tester.pumpAndSettle();

    expect(find.text('Save as empty draft'), findsOneWidget);
  });
}
