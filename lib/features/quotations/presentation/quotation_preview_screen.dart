import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/quotation.dart';
import '../../../domain/entities/quotation_enums.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../../profile/presentation/profile_screen.dart' show companyProvider;
import '../providers/quotations_controller.dart';
import '../../../router/safe_pop.dart';

/// Quotation preview — the document as the customer sees it: header, travel
/// summary, price break-up, inclusions and policies.
///
/// **The price break-up is displayed, never recomputed.** Discount, markup and
/// tax are server-calculated; showing a locally derived total would risk
/// disagreeing with the PDF the customer receives.
class QuotationPreviewScreen extends ConsumerWidget {
  const QuotationPreviewScreen({super.key, required this.publicId});

  final String publicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(quotationDetailProvider(publicId));

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Quotation preview', style: AppType.h2),
            Text(
              switch (async) {
                AsyncData(:final value) => [
                    if (value.quoteNo != null) 'QT-${value.quoteNo}',
                    if (value.version != null) 'v${value.version}',
                  ].join(' · '),
                _ => 'Loading…',
              },
              style: AppType.monoSm.copyWith(color: AppColors.faint),
            ),
          ],
        ),
        actions: [
          if (async.value != null)
            IconButton(
              onPressed: () => _copyShareLink(context, ref, async.value!.id),
              icon: const AppIcon(Ic.clip, size: 18, color: AppColors.body),
              tooltip: 'Copy share link',
            ),
          if (async.value?.pdfUrl != null)
            IconButton(
              onPressed: () => _openPdf(context, async.value!.pdfUrl!),
              icon: const AppIcon(Ic.download, size: 18, color: AppColors.body),
              tooltip: 'Download PDF',
            ),
        ],
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (async) {
        AsyncLoading() => const SkeletonList(itemCount: 3, itemHeight: 160),
        AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () => ref.invalidate(quotationDetailProvider(publicId)),
          ),
        AsyncData(:final value) => _Preview(quotation: value),
      },
      // The two things an agent actually does with a quotation stay pinned to
      // the thumb, so they are reachable without scrolling past the whole
      // document to find them.
      bottomNavigationBar:
          async.value == null ? null : _SendBar(quotation: async.value!),
    );
  }
}

class _Preview extends ConsumerWidget {
  const _Preview({required this.quotation});

  final Quotation quotation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = quotation.customer;
    final totals = quotation.totals;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.invalidate(quotationDetailProvider(quotation.id)),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          _HeroCard(quotation: quotation),
          const SizedBox(height: AppSpacing.x12),
          _StatusRow(quotation: quotation),
          if (quotation.dayPlan.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            _DayPlanCard(days: quotation.dayPlan),
          ],
          if (quotation.hotels.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            _StayCard(stays: quotation.hotels),
          ],
          if (quotation.vehicles.isNotEmpty || quotation.flights.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            _TransportCard(
              vehicles: quotation.vehicles,
              flights: quotation.flights,
            ),
          ],
          if (quotation.inclusions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            _InclusionChips(items: quotation.inclusions),
          ],
          if (totals != null) ...[
            const SizedBox(height: AppSpacing.x12),
            _PriceCard(totals: totals),
          ],
          if (customer != null) ...[
            const SizedBox(height: AppSpacing.x12),
            _ContactCard(customer: customer),
          ],
          if (quotation.exclusions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            _ListCard(
              title: 'Exclusions',
              icon: Ic.close,
              accent: AppColors.danger,
              items: quotation.exclusions,
            ),
          ],
          if (quotation.paymentPolicies.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            _ListCard(
              title: 'Payment terms',
              icon: Ic.wallet,
              accent: AppColors.primary,
              items: quotation.paymentPolicies,
            ),
          ],
          if (quotation.cancellationPolicies.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            _ListCard(
              title: 'Cancellation policy',
              icon: Ic.alert,
              accent: AppColors.warn,
              items: quotation.cancellationPolicies,
            ),
          ],
          if (quotation.bookingTerms.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x12),
            _ListCard(
              title: 'Booking terms',
              icon: Ic.file,
              accent: AppColors.slate,
              items: quotation.bookingTerms,
            ),
          ],
          if (quotation.notes != null) ...[
            const SizedBox(height: AppSpacing.x12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notes', style: AppType.h3),
                  const SizedBox(height: AppSpacing.x8),
                  Text(quotation.notes!, style: AppType.body),
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

/// The document header as the customer sees it — the agency's letterhead, the
/// package headline and the three facts that identify the trip.
///
/// The agency name and GSTIN come from `GET /api/company`; nothing here is
/// hard-coded, so a different tenant's quotation carries its own letterhead.
class _HeroCard extends ConsumerWidget {
  const _HeroCard({required this.quotation});

  final Quotation quotation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final company = ref.watch(companyProvider).value;
    final customer = quotation.customer;

    // Prefer the destination the quotation was built for; the title is the
    // builder's own label and is often just the customer's name.
    final headline = customer?.destination?.trim().isNotEmpty ?? false
        ? customer!.destination!
        : quotation.title?.trim().isNotEmpty ?? false
            ? quotation.title!
            : 'Travel quotation';

    final duration = quotation.durationLabel;
    final cities = quotation.hotels
        .map((h) => h.city?.trim())
        .whereType<String>()
        .where((c) => c.isNotEmpty)
        .toSet()
        .join(' · ');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.x16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.card),
        gradient: AppGradients.inkHero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                ),
                child: const AppIcon(Ic.plane, size: 13, color: AppColors.onPrimary),
              ),
              const SizedBox(width: AppSpacing.x8),
              Expanded(
                child: Text(
                  company?.name ?? 'Quotation',
                  style: AppType.h3.copyWith(color: AppColors.onPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (company?.gstin != null)
                Text(
                  'GSTIN ${company!.gstin}',
                  style: AppType.monoSm.copyWith(
                    fontSize: 9.5,
                    color: AppColors.onPrimary.withValues(alpha: 0.65),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x16),
          Text(
            duration == null ? headline : '$headline · $duration',
            style: AppType.h1.copyWith(color: AppColors.onPrimary),
          ),
          if (cities.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x4),
            Text(
              cities,
              style: AppType.bodySm.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroFact(label: 'Guest', value: customer?.name ?? '—'),
              _HeroFact(
                label: 'Travel',
                value: customer?.travelDate == null
                    ? '—'
                    : AppDate.display(customer!.travelDate),
              ),
              _HeroFact(label: 'Pax', value: customer?.paxLabel ?? '—'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroFact extends StatelessWidget {
  const _HeroFact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppType.overline.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            value,
            style: AppType.fieldValue.copyWith(color: AppColors.onPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Stage, template and author — the internal facts, kept off the letterhead.
class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.quotation});

  final Quotation quotation;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x8,
      runSpacing: AppSpacing.x8,
      children: [
        _StageChipPicker(quotation: quotation),
        StatusChip(
          label: quotation.templateStyle.label,
          palette: StatusColors.neutral,
        ),
        if (quotation.createdBy != null)
          StatusChip(label: 'By ${quotation.createdBy}', palette: StatusColors.neutral),
        if (quotation.createdAt != null)
          StatusChip(
            label: AppDate.display(quotation.createdAt),
            palette: StatusColors.neutral,
          ),
      ],
    );
  }
}

/// Stage chip that commits through `PATCH /api/quotations/{id}/stage`.
class _StageChipPicker extends ConsumerWidget {
  const _StageChipPicker({required this.quotation});

  final Quotation quotation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stage = quotation.stage;

    return Semantics(
      button: true,
      label: 'Stage: ${stage?.label ?? 'not set'}. Tap to change.',
      child: InkWell(
        onTap: () => _pick(context, ref),
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: StatusChip(
          label: stage?.label ?? 'Set stage',
          palette:
              stage == null ? StatusColors.neutral : StatusColors.quotationStage(stage),
          trailingIcon: Ic.chevronDown,
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final picked = await showModalBottomSheet<QuotationStage>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.x16),
              child: Text('Change stage', style: AppType.h2),
            ),
            for (final stage in QuotationStage.values)
              ListTile(
                onTap: () => Navigator.of(context).pop(stage),
                leading: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: StatusColors.quotationStage(stage).foreground,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(stage.label, style: AppType.fieldValue),
                trailing: stage == quotation.stage
                    ? const AppIcon(Ic.check, size: 18, color: AppColors.primary)
                    : null,
              ),
            const SizedBox(height: AppSpacing.x8),
          ],
        ),
      ),
    );

    if (picked == null || picked == quotation.stage || !context.mounted) return;

    try {
      await ref.read(quotationRepositoryProvider).changeStage(quotation.id, picked);
      ref.invalidate(quotationDetailProvider(quotation.id));
      ref.invalidate(quotationsControllerProvider);
      if (context.mounted) {
        AppToast.show(context, title: 'Stage updated', message: 'Now ${picked.label}.');
      }
    } on Failure catch (f) {
      if (context.mounted) AppToast.error(context, 'Could not update stage', f.message);
    }
  }
}

/// Opens the server-rendered PDF. The app never draws a second document of its
/// own — a locally composed one could disagree with what the customer receives.
Future<void> _openPdf(BuildContext context, String url) async {
  final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    AppToast.error(context, 'Could not open', 'No app available to open the PDF.');
  }
}

/// Copies the quotation's public link, when the server has minted one.
Future<void> _copyShareLink(BuildContext context, WidgetRef ref, String id) async {
  try {
    final link = await ref.read(quotationRepositoryProvider).getShareLink(id);
    if (!context.mounted) return;
    if (link == null) {
      AppToast.error(context, 'No share link', 'This quotation has no public link yet.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: link));
    if (context.mounted) AppToast.success(context, 'Link copied', link);
  } on Failure catch (f) {
    if (context.mounted) AppToast.error(context, 'Could not get link', f.message);
  }
}

/// The pinned send bar — WhatsApp and email, the two ways a quotation actually
/// leaves the office.
///
/// Both go through the backend (`POST /api/quotations/{id}/send-whatsapp` and
/// `/send-email`), not through a share sheet: the server owns the message body,
/// the PDF it attaches and the record that the quotation was sent.
class _SendBar extends ConsumerStatefulWidget {
  const _SendBar({required this.quotation});

  final Quotation quotation;

  @override
  ConsumerState<_SendBar> createState() => _SendBarState();
}

class _SendBarState extends ConsumerState<_SendBar> {
  /// Which channel is in flight, if any. Sending twice by double tap would send
  /// the customer two copies, so the bar locks while a request is open.
  bool? _sendingWhatsApp;

  @override
  Widget build(BuildContext context) {
    final busy = _sendingWhatsApp != null;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.x10,
            AppSpacing.gutter,
            AppSpacing.x10,
          ),
          child: Row(
            children: [
              Expanded(
                child: _SendButton(
                  icon: Ic.wa,
                  label: 'Send WhatsApp',
                  background: AppColors.success,
                  busy: _sendingWhatsApp == true,
                  onPressed: busy ? null : () => _send(whatsApp: true),
                ),
              ),
              const SizedBox(width: AppSpacing.x10),
              Expanded(
                child: _SendButton(
                  icon: Ic.send,
                  label: 'Email quote',
                  background: AppColors.primary,
                  busy: _sendingWhatsApp == false,
                  onPressed: busy ? null : () => _send(whatsApp: false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _send({required bool whatsApp}) async {
    setState(() => _sendingWhatsApp = whatsApp);
    final repo = ref.read(quotationRepositoryProvider);
    try {
      if (whatsApp) {
        await repo.sendWhatsApp(widget.quotation.id);
      } else {
        await repo.sendEmail(widget.quotation.id);
      }
      if (mounted) {
        AppToast.success(
          context,
          whatsApp ? 'Sent on WhatsApp' : 'Sent by email',
          'The customer has been sent this quotation.',
        );
      }
    } on Failure catch (f) {
      if (mounted) AppToast.error(context, 'Could not send', f.message);
    } finally {
      if (mounted) setState(() => _sendingWhatsApp = null);
    }
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.busy,
    required this.onPressed,
  });

  final String icon;
  final String label;
  final Color background;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: Colors.white,
        disabledBackgroundColor: background.withValues(alpha: 0.45),
        disabledForegroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (busy)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          else
            AppIcon(icon, size: 16, color: Colors.white),
          const SizedBox(width: AppSpacing.x8),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.button.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// The price break-up, exactly as the server computed it.
class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.totals});

  final QuotationTotals totals;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price break-up', style: AppType.h3),
          const SizedBox(height: AppSpacing.x12),
          _Row(label: 'Subtotal', value: Inr.format(totals.subtotal)),
          if (totals.addonsTotal > 0)
            _Row(label: 'Add-ons', value: Inr.format(totals.addonsTotal)),
          if (totals.markup > 0) _Row(label: 'Markup', value: Inr.format(totals.markup)),
          if (totals.discountAmount > 0)
            _Row(
              label: totals.discountType == '%'
                  ? 'Discount (${totals.discount.toStringAsFixed(0)}%)'
                  : 'Discount',
              value: '− ${Inr.format(totals.discountAmount)}',
              tint: AppColors.success,
            ),
          if (totals.taxAmount > 0)
            _Row(
              label: totals.taxPercent > 0
                  ? 'Tax (${totals.taxPercent.toStringAsFixed(0)}%)'
                  : 'Tax',
              value: Inr.format(totals.taxAmount),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.x10),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Text('Total payable', style: AppType.h3),
              const Spacer(),
              Text(
                Inr.format(totals.grandTotal),
                style: AppType.monoDisplay.copyWith(fontSize: 20),
              ),
            ],
          ),
          if (totals.perAdult != null && totals.perAdult! > 0) ...[
            const SizedBox(height: AppSpacing.x4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${Inr.format(totals.perAdult)} per adult',
                style: AppType.caption,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.tint});

  final String label;
  final String value;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppType.body)),
          Text(
            value,
            style: tint == null
                ? AppType.monoBase
                : AppType.monoBase.copyWith(color: tint),
          ),
        ],
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.title,
    required this.icon,
    required this.accent,
    required this.items,
  });

  final String title;
  final String icon;
  final Color accent;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppType.h3),
          const SizedBox(height: AppSpacing.x12),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: AppIcon(icon, size: 15, color: accent),
                  ),
                  const SizedBox(width: AppSpacing.x10),
                  Expanded(child: Text(item, style: AppType.body)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


/// The day-wise plan, from the quotation's sightseeing block.
class _DayPlanCard extends StatelessWidget {
  const _DayPlanCard({required this.days});

  final List<QuotationDay> days;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Day plan', style: AppType.h3),
          const SizedBox(height: AppSpacing.x12),
          for (final day in days)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.x8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                    ),
                    child: Text(
                      'D${day.day}',
                      style: AppType.monoSm.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (day.date != null)
                          Text(
                            AppDate.display(day.date),
                            style: AppType.caption.copyWith(fontSize: 10),
                          ),
                        for (final activity in day.activities)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.x2),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: activity.attraction,
                                    style: AppType.bodySm.copyWith(
                                      color: AppColors.ink,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (activity.description != null)
                                    TextSpan(
                                      text: ' — ${activity.description}',
                                      style: AppType.bodySm,
                                    ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The hotels quoted, in check-in order.
class _StayCard extends StatelessWidget {
  const _StayCard({required this.stays});

  final List<QuotationStay> stays;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIcon(Ic.bed, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.x8),
              Text('Stay', style: AppType.h3),
              const Spacer(),
              Text(
                '${stays.length} hotel${stays.length == 1 ? '' : 's'}',
                style: AppType.caption,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          for (final stay in stays)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stay.name,
                          style: AppType.fieldValue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (stay.stars != null)
                        Text(
                          '${stay.stars}★',
                          style: AppType.monoSm.copyWith(color: AppColors.warn),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    [
                      if (stay.city != null) stay.city!,
                      if (stay.checkIn != null && stay.checkOut != null)
                        '${AppDate.displayShort(stay.checkIn)} – ${AppDate.displayShort(stay.checkOut)}',
                      if (stay.nights != null) '${stay.nights}N',
                      if ((stay.rooms ?? 0) > 0)
                        '${stay.rooms} room${stay.rooms == 1 ? '' : 's'}',
                      if (stay.roomType != null) stay.roomType!,
                      if (stay.mealPlan != null) stay.mealPlan!,
                    ].join(' · '),
                    style: AppType.caption,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Vehicles and flights, whichever the quotation carries.
class _TransportCard extends StatelessWidget {
  const _TransportCard({required this.vehicles, required this.flights});

  final List<QuotationTransport> vehicles;
  final List<QuotationFlightLeg> flights;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppIcon(Ic.car, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.x8),
              Text('Transport', style: AppType.h3),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          for (final vehicle in vehicles)
            _TransportRow(
              icon: Ic.car,
              title: vehicle.label,
              subtitle: [
                if (vehicle.route != null) vehicle.route!,
                if (vehicle.startDate != null && vehicle.endDate != null)
                  '${AppDate.displayShort(vehicle.startDate)} – ${AppDate.displayShort(vehicle.endDate)}',
                if ((vehicle.qty ?? 0) > 1) '${vehicle.qty} vehicles',
              ].join(' · '),
            ),
          for (final flight in flights)
            _TransportRow(
              icon: Ic.plane,
              title: flight.route ?? flight.carrier ?? 'Flight',
              subtitle: [
                if (flight.carrier != null) flight.carrier!,
                if (flight.cabinClass != null) flight.cabinClass!,
                if (flight.departure != null) AppDate.displayShort(flight.departure),
                if (flight.departureTime != null) flight.departureTime!,
              ].join(' · '),
            ),
        ],
      ),
    );
  }
}

class _TransportRow extends StatelessWidget {
  const _TransportRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: AppSpacing.x2),
          AppIcon(icon, size: 14, color: AppColors.faint),
          const SizedBox(width: AppSpacing.x10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppType.fieldValue),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x2),
                  Text(subtitle, style: AppType.caption),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Inclusions as ticked chips — the customer scans these, so they read better
/// as a block of green than as a bulleted list.
class _InclusionChips extends StatelessWidget {
  const _InclusionChips({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Inclusions', style: AppType.h3),
          const SizedBox(height: AppSpacing.x12),
          Wrap(
            spacing: AppSpacing.x6,
            runSpacing: AppSpacing.x6,
            children: [
              for (final item in items)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x8,
                    vertical: AppSpacing.x4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(AppRadii.chip),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppIcon(Ic.check, size: 11, color: AppColors.success),
                      const SizedBox(width: AppSpacing.x4),
                      Text(
                        item,
                        style: AppType.caption.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Who the quotation is for. Kept below the price, where an agent checks it,
/// rather than in the letterhead the customer reads first.
class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.customer});

  final QuotationCustomer customer;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      if (customer.name != null) ('Name', customer.name!),
      if (customer.phone != null) ('Phone', customer.phone!),
      if (customer.email != null) ('Email', customer.email!),
      if (customer.destination != null) ('Destination', customer.destination!),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Customer', style: AppType.h3),
          const SizedBox(height: AppSpacing.x12),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 96,
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
