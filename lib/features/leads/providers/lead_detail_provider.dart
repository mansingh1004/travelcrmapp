import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../../../domain/entities/lead.dart';
import '../../../domain/entities/lead_enums.dart';
import 'leads_controller.dart';

/// One lead by publicId — `GET /api/leads/{publicId}`.
final leadDetailProvider = FutureProvider.autoDispose.family<Lead, String>(
  (ref, publicId) => ref.watch(leadRepositoryProvider).getLead(publicId),
);

/// That lead's activity log — `GET /api/leads/{publicId}/logs`, newest first.
final leadLogsProvider = FutureProvider.autoDispose.family<List<LeadLog>, String>(
  (ref, publicId) => ref.watch(leadRepositoryProvider).getLogs(publicId),
);

/// Mutations on a single lead. Each refreshes the detail providers and patches
/// the list in place so both screens agree without a full reload.
final leadActionsProvider = Provider.autoDispose<LeadActions>(LeadActions.new);

class LeadActions {
  LeadActions(this._ref);

  final Ref _ref;

  /// `PATCH /api/leads/{publicId}/stage`.
  Future<Lead> changeStage(String publicId, LeadStage stage) async {
    final lead = await _ref.read(leadRepositoryProvider).changeStage(publicId, stage);
    _ref.read(leadsControllerProvider.notifier).upsert(lead);
    _ref.invalidate(leadDetailProvider(publicId));
    _ref.invalidate(leadStageCountsProvider);
    return lead;
  }

  /// `POST /api/leads/{publicId}/logs` — log a follow-up, optionally creating
  /// a reminder (the server requires a date when it does).
  Future<LeadLog> logFollowUp(
    String publicId, {
    required String comment,
    bool createReminder = false,
    DateTime? followUpDate,
  }) async {
    final log = await _ref.read(leadRepositoryProvider).addLog(
          publicId,
          comment: comment,
          createReminder: createReminder,
          followUpDate: followUpDate,
        );
    _ref.invalidate(leadLogsProvider(publicId));
    _ref.invalidate(leadDetailProvider(publicId));
    return log;
  }

  /// `DELETE /api/leads/{publicId}` — soft delete.
  Future<void> delete(String publicId) async {
    await _ref.read(leadRepositoryProvider).deleteLead(publicId);
    _ref.read(leadsControllerProvider.notifier).remove(publicId);
    _ref.invalidate(leadStageCountsProvider);
  }
}
