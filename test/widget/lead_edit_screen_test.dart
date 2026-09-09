import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crmapp/core/di.dart';
import 'package:crmapp/core/theme/app_theme.dart';
import 'package:crmapp/data/dto/lead_dto.dart';
import 'package:crmapp/data/mappers/lead_mapper.dart';
import 'package:crmapp/domain/entities/lead.dart';
import 'package:crmapp/features/leads/leads.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Captures what the screen would PUT, and answers with the same lead back.
class _CapturingAdapter implements HttpClientAdapter {
  _CapturingAdapter(this.body);

  final String body;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
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

/// The live lead captured under `test/_live` — a real one, carrying the seven
/// fields the detail screen never shows.
Lead? _liveLead() {
  final file = File('test/_live/lead_detail.json');
  if (!file.existsSync()) return null;
  final body = jsonDecode(file.readAsStringSync().replaceFirst('﻿', ''));
  final data = body is Map<String, dynamic> && body.containsKey('data')
      ? body['data']
      : body;
  return LeadMapper.toEntity(LeadDto.fromJson(data as Map<String, dynamic>));
}

Widget _app(Lead lead, _CapturingAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'http://x'))..httpClientAdapter = adapter;

  return ProviderScope(
    overrides: [dioProvider.overrideWithValue(dio)],
    child: MaterialApp(
      theme: AppTheme.light,
      home: LeadCreateScreen(lead: lead),
    ),
  );
}

void main() {
  final lead = _liveLead();
  if (lead == null) {
    // The fixture is captured from a running backend, not committed noise.
    return;
  }

  testWidgets('editing opens the add-lead form, filled in', (tester) async {
    // Edit is not a form of its own: `PUT /api/leads/{publicId}` takes the
    // create DTO, so the screen an agent edits in is the one they created in.
    await tester.pumpWidget(_app(lead, _CapturingAdapter('{}')));
    await tester.pumpAndSettle();

    expect(find.text('Edit lead'), findsOneWidget);
    expect(find.text('New lead'), findsNothing);
    // Same wizard, same steps — nothing is hidden because this is an edit.
    expect(find.textContaining('Step 1 of 5'), findsOneWidget);

    // The controllers render their text through EditableText, so finding the
    // value on screen is finding the filled field.
    final first = lead.customerName.trim().split(RegExp(r'\s+')).first;
    expect(find.text(first), findsOneWidget);
    expect(find.text(lead.phone), findsOneWidget);
  });

  testWidgets('the submit button says it is saving changes', (tester) async {
    await tester.pumpWidget(_app(lead, _CapturingAdapter('{}')));
    await tester.pumpAndSettle();

    // Last step is where the primary button submits.
    await tester.tap(find.text('Follow-up'));
    await tester.pumpAndSettle();

    expect(find.text('Save changes'), findsOneWidget);
    expect(find.text('Save lead'), findsNothing);
  });

  test('the departure mode survives the round trip', () {
    // The app sends `CAR`, the server answers `"Car / Road"`. Reading it back
    // by the sent spelling alone would leave the control unset — and because
    // the update is a full replace, the next save would null the column. The
    // backend warns about precisely this: "the lead saves, then reopens with
    // the transport section unset and every field under it orphaned."
    expect(
      lead.departureMode,
      'Car / Road',
      reason: 'the fixture is a lead that actually has one',
    );
  });

  test('the fields no screen shows are still on the entity', () {
    // These exist only so an edit posts back what it was given. If any of them
    // drops out of the chain again, the form silently sends its own default
    // over the top on the next save.
    expect(lead.male, isNotNull);
    expect(lead.female, isNotNull);
    expect(lead.packageType, isNotNull);
    expect(lead.departureMode, isNotNull);
  });
}
