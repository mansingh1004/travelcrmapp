import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/formatters/phone.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/lead.dart';
import '../../../domain/entities/lead_enums.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../providers/lead_detail_provider.dart';
import 'widgets/log_followup_sheet.dart';
import '../../../router/routes.dart';
import '../../../router/safe_pop.dart';

/// Lead detail — header, actions, customer, travel requirement and the
/// follow-up timeline.
///
/// Stage change (`PATCH .../stage`) and follow-up logging (`POST .../logs`) are
/// both real endpoints on this backend, so the stage chip is a picker and the
/// timeline is live. Convert-to-booking exists too, but belongs to the bookings
/// screen, which is not wired yet.
class LeadDetailScreen extends ConsumerWidget {
  const LeadDetailScreen({super.key, required this.publicId});

  /// The lead's public UUID.
  final String publicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(leadDetailProvider(publicId));

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Lead', style: AppType.h2),
        actions: [
          // Only once the lead has loaded: both actions need it — edit to fill
          // the form, delete to name what is being deleted.
          if (async.value case final lead?) _LeadMenu(lead: lead),
        ],
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (async) {
        AsyncLoading() => const SkeletonList(itemCount: 3, itemHeight: 140),
        AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () => ref.invalidate(leadDetailProvider(publicId)),
          ),
        AsyncData(:final value) => _Detail(lead: value),
      },
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = lead.type;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref
          ..invalidate(leadDetailProvider(lead.id))
          ..invalidate(leadLogsProvider(lead.id));
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppAvatar(
                      initials: lead.initials,
                      seed: lead.customerName,
                      size: 52,
                    ),
                    const SizedBox(width: AppSpacing.x14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lead.customerName.isEmpty ? 'Unnamed lead' : lead.customerName,
                            style: AppType.h1Large,
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          Text(
                            [
                              if (lead.leadCode != null) lead.leadCode!,
                              if (lead.city != null) lead.city!,
                              if (lead.source != null) lead.source!,
                            ].join(' · '),
                            style: AppType.bodySm,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x14),
                Wrap(
                  spacing: AppSpacing.x8,
                  runSpacing: AppSpacing.x8,
                  children: [
                    // Tapping the stage chip opens the change-stage sheet.
                    _StageChip(lead: lead),
                    if (type != null)
                      StatusChip(label: type.label, palette: StatusColors.priority(type)),
                    if (lead.budget != null)
                      StatusChip(
                        label: Inr.compact(lead.budget!),
                        palette: StatusColors.neutral,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          _ActionRow(lead: lead),
          const SizedBox(height: AppSpacing.x12),
          _Section(
            title: 'Customer',
            rows: [
              ('Phone', Phone.display(lead.phone)),
              if (lead.whatsapp != null) ('WhatsApp', Phone.display(lead.whatsapp!)),
              if (lead.email != null) ('Email', lead.email!),
              if (lead.city != null) ('City', lead.city!),
              if (lead.state != null) ('State', lead.state!),
              if (lead.country != null) ('Country', lead.country!),
              if (lead.birthDate != null) ('Birthday', AppDate.display(lead.birthDate)),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          _Section(
            title: 'Travel requirement',
            rows: [
              if (lead.destinationLabel != '—') ('Destination', lead.destinationLabel),
              if (lead.departCity != null || lead.departCountry != null)
                (
                  'Departing from',
                  [lead.departCity, lead.departCountry].whereType<String>().join(', ')
                ),
              if (lead.travelDate != null) ('Travel date', AppDate.display(lead.travelDate)),
              if (lead.returnDate != null) ('Return date', AppDate.display(lead.returnDate)),
              if (lead.nightsLabel != null) ('Duration', lead.nightsLabel!),
              if (lead.totalPax > 0) ('Travellers', lead.paxLabel),
              if ((lead.rooms ?? 0) > 0) ('Rooms', '${lead.rooms}'),
              if ((lead.extraBeds ?? 0) > 0) ('Extra beds', '${lead.extraBeds}'),
              if (lead.budget != null) ('Budget', Inr.format(lead.budget)),
            ],
          ),
          if (lead.itinerary.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Itinerary', style: AppType.h3),
                  const SizedBox(height: AppSpacing.x12),
                  for (final stop in lead.itinerary)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.x10),
                      child: Row(
                        children: [
                          const AppIcon(Ic.pin, size: 15, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.x10),
                          Expanded(
                            child: Text(
                              '${stop.city}, ${stop.destination}',
                              style: AppType.fieldValue,
                            ),
                          ),
                          Text('${stop.nights}N', style: AppType.monoSm),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (lead.services.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Services requested', style: AppType.h3),
                  const SizedBox(height: AppSpacing.x12),
                  Wrap(
                    spacing: AppSpacing.x8,
                    runSpacing: AppSpacing.x8,
                    children: [
                      for (final service in lead.services)
                        StatusChip(label: service, palette: StatusColors.neutral),
                    ],
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x12),
          _Timeline(lead: lead),
          if (lead.notes != null) ...[
            const SizedBox(height: AppSpacing.x12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notes', style: AppType.h3),
                  const SizedBox(height: AppSpacing.x8),
                  Text(lead.notes!, style: AppType.body),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x24),
        ],
      ),
    );
  }
}

/// The stage chip, which opens a picker and commits via `PATCH .../stage`.
class _StageChip extends ConsumerWidget {
  const _StageChip({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = lead.stage;

    return Semantics(
      button: true,
      label: 'Stage: ${stage?.label ?? 'not set'}. Tap to change.',
      child: InkWell(
        onTap: () => _pick(context, ref),
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: StatusChip(
          label: stage?.label ?? 'Set stage',
          palette: stage == null ? StatusColors.neutral : StatusColors.stage(stage),
          trailingIcon: Ic.chevronDown,
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final picked = await showModalBottomSheet<LeadStage>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.x16),
                child: Text('Move to stage', style: AppType.h2),
              ),
              for (final stage in LeadStage.values)
                ListTile(
                  onTap: () => Navigator.of(context).pop(stage),
                  leading: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: StatusColors.stage(stage).foreground,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(stage.label, style: AppType.fieldValue),
                  trailing: stage == lead.stage
                      ? const AppIcon(Ic.check, size: 18, color: AppColors.primary)
                      : null,
                ),
              const SizedBox(height: AppSpacing.x8),
            ],
          ),
        ),
      ),
    );

    if (picked == null || picked == lead.stage || !context.mounted) return;

    try {
      await ref.read(leadActionsProvider).changeStage(lead.id, picked);
      if (context.mounted) {
        AppToast.show(context, title: 'Stage updated', message: 'Moved to ${picked.label}.');
      }
    } on Failure catch (f) {
      if (context.mounted) AppToast.error(context, 'Could not update stage', f.message);
    }
  }
}

class _ActionRow extends ConsumerWidget {
  const _ActionRow({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x8,
        vertical: AppSpacing.x12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Action(
            icon: Ic.phone,
            label: 'Call',
            onTap: () => _launch(context, Phone.dialUri(lead.phone)),
          ),
          _Action(
            icon: Ic.wa,
            label: 'WhatsApp',
            color: AppColors.success,
            onTap: () => _launch(context, Phone.whatsAppUri(lead.whatsapp ?? lead.phone)),
          ),
          _Action(
            icon: Ic.clock,
            label: 'Follow-up',
            color: AppColors.warn,
            onTap: () => _logFollowUp(context, ref, lead.id),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(BuildContext context, String uri) async {
    final ok = await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      AppToast.error(context, 'Could not open', 'No app available to handle that.');
    }
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.primary,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.tile),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x14,
            vertical: AppSpacing.x6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadii.tile),
                ),
                child: AppIcon(icon, size: 19, color: color),
              ),
              const SizedBox(height: AppSpacing.x6),
              Text(label, style: AppType.caption),
            ],
          ),
        ),
      ),
    );
  }
}

/// `GET /api/leads/{id}/logs` — the follow-up history, newest first.
class _Timeline extends ConsumerWidget {
  const _Timeline({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(leadLogsProvider(lead.id));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Follow-up history', style: AppType.h3),
              const Spacer(),
              TextButton(
                onPressed: () => _logFollowUp(context, ref, lead.id),
                child: const Text('Log'),
              ),
            ],
          ),
          switch (async) {
            AsyncLoading() => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.x20),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            AsyncError() => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
                child: Text('Could not load the history.', style: AppType.bodySm),
              ),
            AsyncData(:final value) => value.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
                    child: Text(
                      'No follow-ups logged yet.',
                      style: AppType.bodySm,
                    ),
                  )
                : Column(
                    children: [
                      for (final log in value) _LogRow(log: log, isLast: log == value.last),
                    ],
                  ),
          },
        ],
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.log, required this.isLast});

  final LeadLog log;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final stage = log.stage;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rail: dot plus connector down to the next entry.
          Column(
            children: [
              Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(top: AppSpacing.x14),
                decoration: BoxDecoration(
                  color: stage == null
                      ? AppColors.border
                      : StatusColors.stage(stage).foreground,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                const Expanded(
                  child: VerticalDivider(width: 9, thickness: 1, color: AppColors.line),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.x12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.x12,
                bottom: isLast ? 0 : AppSpacing.x12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.comment, style: AppType.body),
                  const SizedBox(height: AppSpacing.x6),
                  Wrap(
                    spacing: AppSpacing.x10,
                    runSpacing: AppSpacing.x4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (log.createdAt != null)
                        Text(AppDate.dateTime(log.createdAt), style: AppType.monoSm),
                      if (log.addedBy != null)
                        Text('by ${log.addedBy}', style: AppType.caption),
                      if (log.followUpDate != null)
                        Text(
                          'Next: ${AppDate.display(log.followUpDate)}',
                          style: AppType.monoSm.copyWith(color: AppColors.warn),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppType.h3),
          const SizedBox(height: AppSpacing.x12),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 118,
                    child: Text(label, style: AppType.caption),
                  ),
                  Expanded(child: Text(value, style: AppType.fieldValue)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Opens the follow-up sheet, then confirms once it has closed.
///
/// The toast belongs here rather than inside the sheet: a popped sheet's
/// element is deactivated, and `AppToast` has to walk up from the context it
/// is handed.
Future<void> _logFollowUp(BuildContext context, WidgetRef ref, String leadId) async {
  final logged = await LogFollowUpSheet.show(context, ref, leadId: leadId);
  if (logged != null && context.mounted) {
    AppToast.show(context, title: 'Follow-up logged', message: logged);
  }
}

enum _LeadAction { edit, delete }

/// Edit and delete, in the same place bookings and vendors keep theirs.
///
/// **Delete is unconditional here, unlike on a booking.** `LeadServiceImpl`
/// puts no state behind it — no "cannot delete a converted lead" — and it is a
/// soft delete, so the row survives in Trash. A booking has to guard the
/// equivalent because the server refuses a CONFIRMED one outright.
class _LeadMenu extends ConsumerWidget {
  const _LeadMenu({required this.lead});

  final Lead lead;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Delete ${lead.customerName.isEmpty ? 'this lead' : lead.customerName}?',
          style: AppType.h3,
        ),
        content: Text(
          'It moves to Trash along with its follow-up history. A lead that '
          'went cold is better marked Lost — that keeps it in the pipeline '
          'figures.',
          style: AppType.bodySm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(leadActionsProvider).delete(lead.id);
      if (context.mounted) {
        AppToast.success(context, 'Lead deleted', lead.customerName);
        // Back to the list: the screen behind this one is now showing a lead
        // that no longer exists.
        context.backOrHome();
      }
    } on Failure catch (f) {
      if (context.mounted) AppToast.error(context, 'Could not delete', f.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_LeadAction>(
      tooltip: 'Lead actions',
      color: AppColors.surface,
      icon: const AppIcon(Ic.dots, size: 18, color: AppColors.body),
      onSelected: (action) => switch (action) {
        _LeadAction.edit => context.push(Routes.leadEditFor(lead.id)),
        _LeadAction.delete => _delete(context, ref),
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _LeadAction.edit,
          child: Row(
            children: [
              const AppIcon(Ic.edit, size: 16, color: AppColors.muted),
              const SizedBox(width: AppSpacing.x10),
              Text('Edit', style: AppType.body),
            ],
          ),
        ),
        PopupMenuItem(
          value: _LeadAction.delete,
          child: Row(
            children: [
              const AppIcon(Ic.trash, size: 16, color: AppColors.danger),
              const SizedBox(width: AppSpacing.x10),
              Text('Delete', style: AppType.body.copyWith(color: AppColors.danger)),
            ],
          ),
        ),
      ],
    );
  }
}
