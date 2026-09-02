import 'dart:async';

import 'package:crmapp/core/di.dart';
import 'package:crmapp/core/errors/failure.dart';
import 'package:crmapp/core/theme/app_theme.dart';
import 'package:crmapp/domain/entities/lead.dart';
import 'package:crmapp/domain/entities/lead_enums.dart';
import 'package:crmapp/domain/repositories/lead_repository.dart';
import 'package:crmapp/features/leads/presentation/leads_screen.dart';
import 'package:crmapp/widgets/state_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A repository double. Mocks live only in tests — the shipped app has no
/// hardcoded data anywhere.
class _FakeLeadRepository implements LeadRepository {
  _FakeLeadRepository({
    this.page,
    this.error,
    this.neverCompletes = false,
    this.stats,
  });

  final LeadPage? page;
  final Object? error;
  final LeadStats? stats;

  /// When true, [getLeads] hangs forever — pins the UI in its loading state.
  final bool neverCompletes;

  /// Filters the screen asked the server for, so tests can assert that the
  /// tabs push the filter down rather than filtering locally.
  LeadFilter? lastFilter;

  @override
  LeadPage? get cached => null;

  @override
  Future<LeadPage> getLeads({
    int page = 0,
    int size = 20,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    LeadFilter filter = LeadFilter.none,
    bool forceRefresh = false,
  }) async {
    lastFilter = filter;
    if (neverCompletes) return Completer<LeadPage>().future;
    if (error != null) throw error!;

    final all = this.page ?? LeadPage.empty;
    if (filter.stage == null) return all;

    // Stand in for the server's own stage predicate.
    final matching = all.leads.where((l) => l.stage == filter.stage).toList();
    return LeadPage(
      leads: matching,
      pageNumber: 0,
      totalElements: matching.length,
      hasMore: false,
    );
  }

  @override
  Future<LeadStats> getStats({DateTime? from, DateTime? to}) async =>
      stats ??
      const LeadStats(
        totalLeads: 0,
        activeLeads: 0,
        convertedLeads: 0,
        lostLeads: 0,
        proposalSentLeads: 0,
        byStage: {},
        byType: {},
        activePipelineValue: 0,
        quotedValue: 0,
        followUpsOverdue: 0,
        followUpsDueToday: 0,
        createdInPeriod: 0,
        convertedInPeriod: 0,
      );

  @override
  Future<Lead> getLead(String publicId) => throw UnimplementedError();

  @override
  Future<Lead> createLead(Map<String, dynamic> body) => throw UnimplementedError();

  @override
  Future<Lead> updateLead(String publicId, Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<Lead> changeStage(String publicId, LeadStage stage) => throw UnimplementedError();

  @override
  Future<void> deleteLead(String publicId) => throw UnimplementedError();

  @override
  Future<List<LeadLog>> getLogs(String publicId) async => const [];

  @override
  Future<LeadLog> addLog(
    String publicId, {
    required String comment,
    bool createReminder = false,
    DateTime? followUpDate,
  }) =>
      throw UnimplementedError();

  @override
  Future<List<LeadSourceOption>> getSelectableSources() async => const [];

  @override
  Future<AssignmentChoice> getAssignmentChoice() async =>
      const AssignmentChoice(forcedSelf: true, eligibleUsers: []);
}

Widget _harness(LeadRepository repo) => ProviderScope(
      overrides: [leadRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: LeadsScreen()),
      ),
    );

const _lead = Lead(
  id: 'a3f1c2d4-5e6f-4a7b-8c9d-0e1f2a3b4c5d',
  customerName: 'Rahul Sharma',
  phone: '9822041155',
  email: 'rahul@example.com',
  stage: LeadStage.qualified,
  type: LeadType.hot,
  adults: 4,
  children: 2,
  itinerary: [
    LeadItineraryStop(destination: 'Nepal', city: 'Kathmandu', nights: 3),
  ],
);

const _otherLead = Lead(
  id: 'b4c5d6e7-8f90-4a1b-9c2d-3e4f5a6b7c8d',
  customerName: 'Sneha Kulkarni',
  phone: '9021033471',
  email: 'sneha@example.com',
  stage: LeadStage.newLead,
  type: LeadType.warm,
);

void main() {
  testWidgets('shows a skeleton while the first page loads', (tester) async {
    await tester.pumpWidget(_harness(_FakeLeadRepository(neverCompletes: true)));
    await tester.pump();

    expect(find.byType(SkeletonList), findsOneWidget);
  });

  testWidgets('renders leads once loaded', (tester) async {
    await tester.pumpWidget(
      _harness(
        _FakeLeadRepository(
          page: const LeadPage(
            leads: [_lead],
            pageNumber: 0,
            totalElements: 1,
            hasMore: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rahul Sharma'), findsOneWidget);
    expect(find.text('Nepal · Kathmandu'), findsOneWidget);
    // Priority chip is driven by leadType.
    expect(find.text('Hot'), findsOneWidget);
    expect(find.text('Qualified'), findsWidgets);
  });

  testWidgets('shows the empty state with a create CTA when there are no leads',
      (tester) async {
    await tester.pumpWidget(_harness(_FakeLeadRepository(page: LeadPage.empty)));
    await tester.pumpAndSettle();

    expect(find.text('No leads yet'), findsOneWidget);
    expect(find.text('Create lead'), findsOneWidget);
  });

  testWidgets('shows the error state with a retry when the request fails',
      (tester) async {
    await tester.pumpWidget(
      _harness(_FakeLeadRepository(error: const ServerFailure(status: 500))),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ErrorStateView), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('tab counts come from the stats endpoint, not the loaded page',
      (tester) async {
    await tester.pumpWidget(
      _harness(
        _FakeLeadRepository(
          page: const LeadPage(
            leads: [_lead],
            pageNumber: 0,
            totalElements: 1,
            hasMore: false,
          ),
          // 40 leads exist server-side even though one row is loaded.
          stats: const LeadStats(
            totalLeads: 40,
            activeLeads: 28,
            convertedLeads: 7,
            lostLeads: 5,
            proposalSentLeads: 6,
            byStage: {LeadStage.newLead: 12, LeadStage.qualified: 9},
            byType: {},
            activePipelineValue: 0,
            quotedValue: 0,
            followUpsOverdue: 0,
            followUpsDueToday: 0,
            createdInPeriod: 0,
            convertedInPeriod: 0,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('12'), findsOneWidget, reason: 'New tab shows the global count');
    expect(find.text('21'), findsOneWidget, reason: 'All tab sums the stage counts');
  });

  testWidgets('stage tabs push the filter to the server', (tester) async {
    final repo = _FakeLeadRepository(
      page: const LeadPage(
        leads: [_lead, _otherLead],
        pageNumber: 0,
        totalElements: 2,
        hasMore: false,
      ),
    );

    await tester.pumpWidget(_harness(repo));
    await tester.pumpAndSettle();

    expect(find.text('Rahul Sharma'), findsOneWidget);
    expect(find.text('Sneha Kulkarni'), findsOneWidget);

    await tester.tap(find.widgetWithText(InkWell, 'New').first);
    await tester.pumpAndSettle();

    expect(repo.lastFilter?.stage, LeadStage.newLead);
    expect(find.text('Sneha Kulkarni'), findsOneWidget);
    expect(find.text('Rahul Sharma'), findsNothing);
  });
}
