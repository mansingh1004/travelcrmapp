import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/status_colors.dart';
import '../../../../core/formatters/app_date.dart';
import '../../../../core/formatters/inr.dart';
import '../../../../core/formatters/phone.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/lead.dart';
import '../../../../widgets/app_avatar.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/status_chip.dart';

/// A lead row, ported from the prototype's card.
///
/// Layout follows the prototype: temperature beside the name, **stage** in the
/// top-right corner, then the reference line (`LD-26-0030 · Website · Priya
/// M.`), the destination, the trip facts, and the next follow-up in the footer
/// beside the call actions.
///
/// Two prototype details are deliberately absent. The lead-score bar (`★ 86`)
/// has no backend equivalent, and the follow-up shows a **day**, not a time —
/// `followUpDate` is a `yyyy-MM-dd` date on the wire, so "Today, 11:30 AM"
/// would be an invented time.
///
/// Call and WhatsApp are device intents (`tel:` / `wa.me`), not API calls.
class LeadCard extends StatelessWidget {
  const LeadCard({super.key, required this.lead, required this.onTap});

  final Lead lead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stage = lead.stage;
    final type = lead.type;
    final reference = _reference(lead);
    final followUp = lead.followUpDate;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(initials: lead.initials, seed: lead.customerName),
              const SizedBox(width: AppSpacing.x12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            lead.customerName.isEmpty ? 'Unnamed lead' : lead.customerName,
                            style: AppType.rowTitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (type != null) ...[
                          const SizedBox(width: AppSpacing.x8),
                          StatusChip(
                            label: type.label,
                            palette: StatusColors.priority(type),
                            dense: true,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Stage is the card's headline state, so it takes the corner the
              // eye lands on rather than sitting in the footer.
              if (stage != null) ...[
                const SizedBox(width: AppSpacing.x8),
                StatusChip(label: stage.label, palette: StatusColors.stage(stage)),
              ],
            ],
          ),
          // Full width, not indented under the name: sharing that row with the
          // stage chip left barely half the card for three fields, and the
          // owner was always the one that got eaten by the ellipsis.
          if (reference != null) ...[
            const SizedBox(height: AppSpacing.x8),
            Text(
              reference,
              style: AppType.monoXs,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: AppSpacing.x8),
          Row(
            children: [
              const AppIcon(Ic.pin, size: 14, color: AppColors.faint),
              const SizedBox(width: AppSpacing.x6),
              Expanded(
                child: Text(
                  lead.destinationLabel,
                  style: AppType.bodySm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x10),
          Wrap(
            spacing: AppSpacing.x14,
            runSpacing: AppSpacing.x6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (lead.travelDate != null)
                _Meta(icon: Ic.calendar, text: AppDate.display(lead.travelDate)),
              if (lead.totalPax > 0) _Meta(icon: Ic.users, text: lead.paxLabel),
              if (lead.nightsLabel != null)
                _Meta(icon: Ic.clock, text: lead.nightsLabel!),
              if (lead.budget != null)
                _Meta(icon: Ic.wallet, text: Inr.compact(lead.budget!)),
            ],
          ),
          const SizedBox(height: AppSpacing.x12),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.x6),
          Row(
            children: [
              Expanded(
                child: followUp == null
                    ? Text('No follow-up set', style: AppType.caption)
                    : _Meta(
                        icon: Ic.bell,
                        text: 'Follow-up ${AppDate.relative(followUp).toLowerCase()}',
                        // Overdue follow-ups are the whole point of the list.
                        color: _isOverdue(followUp) ? AppColors.danger : null,
                      ),
              ),
              _ActionButton(
                icon: Ic.phone,
                label: 'Call ${lead.customerName}',
                onTap: () => _launch(context, Phone.dialUri(lead.phone)),
              ),
              const SizedBox(width: AppSpacing.x4),
              _ActionButton(
                icon: Ic.wa,
                label: 'WhatsApp ${lead.customerName}',
                color: AppColors.success,
                onTap: () => _launch(context, Phone.whatsAppUri(lead.phone)),
              ),
              const SizedBox(width: AppSpacing.x4),
              const AppIcon(Ic.chevronRight, size: 16, color: AppColors.faint),
            ],
          ),
        ],
      ),
    );
  }

  /// `LD-26-0030 · Website · Priya M.` — whichever of the three exist.
  static String? _reference(Lead lead) {
    final owner = lead.assignedTo?.name;
    final parts = <String>[
      if (lead.leadCode != null && lead.leadCode!.isNotEmpty) lead.leadCode!,
      if (lead.source != null && lead.source!.isNotEmpty) lead.source!,
      if (owner != null && owner.isNotEmpty) _shortName(owner),
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  /// `Priya Mehta` → `Priya M.` — the line holds three fields on one row, and
  /// a full second name is what pushes it into an ellipsis.
  static String _shortName(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length < 2) return name.trim();
    return '${parts.first} ${parts.last[0].toUpperCase()}.';
  }

  /// A follow-up date before today, compared by calendar day.
  static bool _isOverdue(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day));
  }

  Future<void> _launch(BuildContext context, String uri) async {
    final ok = await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      AppToast.error(context, 'Could not open', 'No app available to handle that.');
    }
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text, this.color});

  final String icon;
  final String text;

  /// Overrides both icon and label colour, e.g. red for an overdue follow-up.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(icon, size: 14, color: color ?? AppColors.faint),
        const SizedBox(width: AppSpacing.x6),
        Text(
          text,
          style: color == null ? AppType.monoSm : AppType.monoSm.copyWith(color: color),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
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
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: SizedBox(
          width: AppSpacing.minTouchTarget,
          height: AppSpacing.minTouchTarget,
          child: Center(
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadii.chip),
              ),
              child: AppIcon(icon, size: 17, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
