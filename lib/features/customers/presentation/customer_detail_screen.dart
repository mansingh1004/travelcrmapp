import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/formatters/phone.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/customer.dart';
import '../../../widgets/app_avatar.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../providers/customers_controller.dart';
import '../../../router/safe_pop.dart';

/// Customer 360.
///
/// The header comes from `GET /api/customers/{id}/summary` — the one eager
/// call — and the contact/personal block from the full record. Money figures
/// are shown exactly as the server reports them: `totalCollected` is gross and
/// `totalRefunded` sits beside it rather than being netted off, because the
/// two answer different questions.
class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.publicId});

  final String publicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(customerSummaryProvider(publicId));

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Customer', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (summary) {
        AsyncLoading() => const SkeletonList(itemCount: 3, itemHeight: 150),
        AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () => ref.invalidate(customerSummaryProvider(publicId)),
          ),
        AsyncData(:final value) => _Detail(summary: value, publicId: publicId),
      },
    );
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.summary, required this.publicId});

  final CustomerSummary summary;
  final String publicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(customerDetailProvider(publicId));
    final type = summary.type;
    final tier = summary.tier;
    final status = summary.status;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref
          ..invalidate(customerSummaryProvider(publicId))
          ..invalidate(customerDetailProvider(publicId));
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
                    AppAvatar(initials: summary.initials, seed: summary.name, size: 52),
                    const SizedBox(width: AppSpacing.x14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            summary.name.isEmpty ? 'Unnamed customer' : summary.name,
                            style: AppType.h1Large,
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          Text(
                            [
                              if (summary.code != null) summary.code!,
                              if (summary.city != null) summary.city!,
                              if (summary.ownerName != null) 'Owner: ${summary.ownerName}',
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
                    if (status != null)
                      StatusChip(
                        label: status.label,
                        palette: StatusColors.customerStatus(status),
                      ),
                    if (type != null)
                      StatusChip(
                        label: type.label,
                        palette: StatusColors.customerType(type),
                      ),
                    if (tier != null)
                      StatusChip(label: tier.label, palette: StatusColors.tier(tier)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x12),
          _MoneyStrip(summary: summary),
          const SizedBox(height: AppSpacing.x12),
          _ActionRow(phone: summary.phone),
          if (summary.documentsExpiringSoon > 0 || summary.outstanding > 0) ...[
            const SizedBox(height: AppSpacing.x12),
            _AlertRail(summary: summary),
          ],
          const SizedBox(height: AppSpacing.x12),
          _CountsGrid(summary: summary),
          const SizedBox(height: AppSpacing.x12),
          switch (detail) {
            AsyncData(:final value) => _Records(customer: value, summary: summary),
            AsyncError() => AppCard(
                child: Text('Could not load full details.', style: AppType.bodySm),
              ),
            _ => const SkeletonList(itemCount: 1, itemHeight: 180),
          },
          const SizedBox(height: AppSpacing.x24),
        ],
      ),
    );
  }
}

/// Billed / collected / outstanding, plus refunds when there are any.
class _MoneyStrip extends StatelessWidget {
  const _MoneyStrip({required this.summary});

  final CustomerSummary summary;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      gradient: AppGradients.brandHeader,
      borderColor: AppColors.primaryDeep,
      shadow: AppShadows.heroGlow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lifetime billed',
            style: AppType.caption.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          Text(
            Inr.compact(summary.totalBilled),
            style: AppType.monoDisplay.copyWith(color: AppColors.onPrimary),
          ),
          const SizedBox(height: AppSpacing.x14),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Collected',
                  value: Inr.compact(summary.totalCollected),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'Outstanding',
                  value: Inr.compact(summary.outstanding),
                  emphasise: summary.outstanding > 0,
                ),
              ),
              if (summary.totalRefunded > 0)
                Expanded(
                  child: _MiniStat(
                    label: 'Refunded',
                    value: Inr.compact(summary.totalRefunded),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    this.emphasise = false,
  });

  final String label;
  final String value;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppType.caption.copyWith(
            color: AppColors.onPrimary.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: AppType.monoStrong.copyWith(
            color: emphasise ? AppColors.warnBg : AppColors.onPrimary,
          ),
        ),
      ],
    );
  }
}

/// What needs attention: money owed, or documents about to expire.
class _AlertRail extends StatelessWidget {
  const _AlertRail({required this.summary});

  final CustomerSummary summary;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      background: AppColors.warnBg,
      borderColor: AppColors.warn.withValues(alpha: 0.25),
      padding: const EdgeInsets.all(AppSpacing.x12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summary.outstanding > 0)
            _AlertRow(
              icon: Ic.wallet,
              text: summary.nextDueTravelDate == null
                  ? '${Inr.format(summary.outstanding)} outstanding'
                  : '${Inr.format(summary.outstanding)} due by travel on '
                      '${AppDate.display(summary.nextDueTravelDate)}',
            ),
          if (summary.documentsExpiringSoon > 0) ...[
            if (summary.outstanding > 0) const SizedBox(height: AppSpacing.x8),
            _AlertRow(
              icon: Ic.file,
              text: '${summary.documentsExpiringSoon} document'
                  '${summary.documentsExpiringSoon == 1 ? '' : 's'} expiring soon',
            ),
          ],
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIcon(icon, size: 16, color: AppColors.warn),
        const SizedBox(width: AppSpacing.x10),
        Expanded(
          child: Text(
            text,
            style: AppType.bodySm.copyWith(color: AppColors.noteInk),
          ),
        ),
      ],
    );
  }
}

/// Tab-count badges from the summary: enquiries, quotations, bookings, docs.
class _CountsGrid extends StatelessWidget {
  const _CountsGrid({required this.summary});

  final CustomerSummary summary;

  @override
  Widget build(BuildContext context) {
    final counts = <(String, String, int)>[
      ('Enquiries', Ic.users, summary.leadCount),
      ('Quotations', Ic.file, summary.quotationCount),
      ('Bookings', Ic.package, summary.activeBookingCount),
      ('Invoices', Ic.receipt, summary.invoiceCount),
    ];

    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x14),
      child: Row(
        children: [
          for (final (label, icon, count) in counts)
            Expanded(
              child: Column(
                children: [
                  AppIcon(icon, size: 18, color: AppColors.muted),
                  const SizedBox(height: AppSpacing.x8),
                  Text('$count', style: AppType.monoStrong),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    label,
                    style: AppType.caption.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
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
            onTap: () => _launch(context, Phone.dialUri(phone)),
          ),
          _Action(
            icon: Ic.wa,
            label: 'WhatsApp',
            color: AppColors.success,
            onTap: () => _launch(context, Phone.whatsAppUri(phone)),
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
            horizontal: AppSpacing.x20,
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

/// Contact and personal details from the full customer record.
class _Records extends StatelessWidget {
  const _Records({required this.customer, required this.summary});

  final Customer customer;
  final CustomerSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Section(
          title: 'Contact',
          rows: [
            ('Phone', Phone.display(customer.phone)),
            if (customer.alternatePhone != null)
              ('Alternate', Phone.display(customer.alternatePhone!)),
            if (customer.email != null) ('Email', customer.email!),
            if (customer.commPref != null) ('Prefers', customer.commPref!.label),
            if (customer.address != null) ('Address', customer.address!),
            if (customer.locationLabel.isNotEmpty) ('City', customer.locationLabel),
            if (customer.pincode != null) ('PIN', customer.pincode!),
            if (customer.country != null) ('Country', customer.country!),
          ],
        ),
        const SizedBox(height: AppSpacing.x12),
        _Section(
          title: 'Personal & documents',
          rows: [
            if (customer.birthday != null)
              ('Birthday', AppDate.display(customer.birthday)),
            if (customer.anniversary != null)
              ('Anniversary', AppDate.display(customer.anniversary)),
            if (customer.panNo != null) ('PAN', customer.panNo!),
            if (customer.passportNo != null) ('Passport', customer.passportNo!),
            if (customer.passportExpiry != null)
              ('Passport expiry', AppDate.display(customer.passportExpiry)),
            if (customer.nationality != null) ('Nationality', customer.nationality!),
            if (customer.gstin != null) ('GSTIN', customer.gstin!),
            if (customer.legalName != null) ('Legal name', customer.legalName!),
          ],
        ),
        _Section(
          title: 'Trips',
          rows: [
            ('Completed', '${customer.bookingCount}'),
            ('Active', '${summary.activeBookingCount}'),
            if (summary.cancelledBookingCount > 0)
              ('Cancelled', '${summary.cancelledBookingCount}'),
            if (customer.lastBooking != null)
              ('Last trip', AppDate.display(customer.lastBooking)),
          ],
        ),
        if (customer.notes != null) ...[
          const SizedBox(height: AppSpacing.x12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notes', style: AppType.h3),
                const SizedBox(height: AppSpacing.x8),
                Text(customer.notes!, style: AppType.body),
              ],
            ),
          ),
        ],
      ],
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

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x12),
      child: AppCard(
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
      ),
    );
  }
}
