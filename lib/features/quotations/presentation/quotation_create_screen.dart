import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/quotation_api.dart';
import '../../../domain/entities/lead.dart';
import '../../../router/routes.dart';
import '../../../router/safe_pop.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../../../widgets/state_views.dart';
import '../../leads/providers/lead_detail_provider.dart';
import '../../masters/presentation/widgets/form_fields.dart';
import '../../masters/presentation/widgets/geography_providers.dart';
import 'quotation_edit_screen.dart' show sectionAmount;
import 'widgets/hotel_row_sheet.dart';
import 'widgets/sightseeing_activity_sheet.dart';
import 'widgets/vehicle_row_sheet.dart';

/// The package templates that fit one lead, ranked by the server.
final templateMatchesProvider = FutureProvider.autoDispose
    .family<List<TemplateMatchDto>, String>(
      (ref, leadId) => ref.watch(quotationApiProvider).matchTemplates(leadId),
    );

/// Build a quotation for a lead in one page — the phone's answer to the
/// console's `/createquotation?leadId=…`.
///
/// Everything is chosen here and sent in a single `POST /api/quotations`:
/// hotels, vehicles, and sightseeing day by day. The traveller details are not
/// asked for at all — `linkLeadAndSnapshot` copies the customer, pax, travel
/// date and destination off the lead server-side.
///
/// Applying a package instead is one tap and fills every section at once, which
/// is why it sits above the manual blocks rather than below them.
///
/// Flights, cruises and add-ons are not offered: they are long forms nobody
/// fills on a phone, and leaving them out of the body simply leaves them empty
/// on a new quotation.
class QuotationCreateScreen extends ConsumerStatefulWidget {
  const QuotationCreateScreen({super.key, required this.leadId});

  final String leadId;

  @override
  ConsumerState<QuotationCreateScreen> createState() =>
      _QuotationCreateScreenState();
}

class _QuotationCreateScreenState extends ConsumerState<QuotationCreateScreen> {
  final _hotels = <Map<String, dynamic>>[];
  final _vehicles = <Map<String, dynamic>>[];

  /// `sightseeing.days` as the wire wants it, keyed by day number so an empty
  /// day costs nothing to keep around while the agent fills the others.
  final _days = <int, Map<String, dynamic>>{};

  int? _destinationId;
  bool _seeded = false;
  bool _showAllTemplates = false;

  String? _busyTemplateId;
  bool _saving = false;

  bool get _busy => _busyTemplateId != null || _saving;

  /// Fills the destination from the lead's own itinerary, once.
  ///
  /// The agent has already said where the trip goes when the lead was taken;
  /// asking again is a question with a known answer.
  void _seedFrom(Lead lead) {
    if (_seeded) return;
    _seeded = true;
    for (final stop in lead.itinerary) {
      if (stop.destinationId != null) {
        _destinationId = stop.destinationId;
        break;
      }
    }
  }

  List<String> _cities(Lead lead) => lead.itinerary
      .map((s) => s.city)
      .where((c) => c.isNotEmpty)
      .toSet()
      .toList(growable: false);

  /// One day per night, plus the day of departure — the same `nights + 1` the
  /// server uses when it derives `days`.
  int _dayCount(Lead lead) {
    final nights = lead.itinerary.fold<int>(0, (sum, s) => sum + s.nights);
    return nights > 0 ? nights + 1 : 1;
  }

  double get _subtotal =>
      sectionAmount('hotel', _hotels) +
      sectionAmount('vehicle', _vehicles) +
      _sightseeingAmount;

  double get _sightseeingAmount {
    var total = 0.0;
    for (final day in _days.values) {
      final price = day['pricePerPax'];
      final pax = day['pax'];
      if (price is num) {
        total += price.toDouble() * (pax is num && pax > 0 ? pax.toInt() : 1);
      }
    }
    return total;
  }

  List<Map<String, dynamic>> get _filledDays {
    final days =
        _days.entries
            .where((e) => (e.value['activities'] as List?)?.isNotEmpty ?? false)
            .map((e) => e.value)
            .toList()
          ..sort((a, b) => (a['day'] as int).compareTo(b['day'] as int));
    return days;
  }

  Future<void> _addHotel(Lead lead) async {
    final row = await HotelRowSheet.show(
      context,
      destinationId: _destinationId,
      cities: _cities(lead),
    );
    if (row != null) setState(() => _hotels.add(row));
  }

  Future<void> _editHotel(int index, Lead lead) async {
    final row = await HotelRowSheet.show(
      context,
      row: _hotels[index],
      destinationId: _destinationId,
      cities: _cities(lead),
    );
    if (row != null) setState(() => _hotels[index] = row);
  }

  Future<void> _addVehicle() async {
    final row = await VehicleRowSheet.show(context);
    if (row != null) setState(() => _vehicles.add(row));
  }

  Future<void> _editVehicle(int index) async {
    final row = await VehicleRowSheet.show(context, row: _vehicles[index]);
    if (row != null) setState(() => _vehicles[index] = row);
  }

  Future<void> _addActivity(int dayNumber, Lead lead) async {
    final day = _days[dayNumber];
    final entry = await SightseeingActivitySheet.show(
      context,
      dayNumber: dayNumber,
      destinationId: _destinationId,
      pricePerPax: (day?['pricePerPax'] as num?)?.toDouble(),
      pax:
          (day?['pax'] as num?)?.toInt() ??
          (lead.totalPax > 0 ? lead.totalPax : null),
    );
    if (entry == null) return;

    setState(() {
      final existing = _days[dayNumber];
      final activities = <Map<String, dynamic>>[
        ...?(existing?['activities'] as List?)?.whereType<Map>().map(
          Map<String, dynamic>.from,
        ),
        entry.activity,
      ];
      _days[dayNumber] = {
        'day': dayNumber,
        'activities': activities,
        // The day carries the money; the activity has nowhere to put it.
        'pricePerPax': entry.pricePerPax ?? existing?['pricePerPax'],
        'pax': entry.pax ?? existing?['pax'],
      };
    });
  }

  void _removeActivity(int dayNumber, int index) {
    setState(() {
      final day = _days[dayNumber];
      if (day == null) return;
      final activities = (day['activities'] as List).toList()..removeAt(index);
      if (activities.isEmpty) {
        _days.remove(dayNumber);
      } else {
        _days[dayNumber] = {...day, 'activities': activities};
      }
    });
  }

  /// The body for `POST /api/quotations`.
  ///
  /// A section only goes out when it has rows, and always with its own
  /// `amount`: `computeTotals` sums the section scalars and never reads the
  /// rows, so a section without one is stored and then ignored by every total.
  ///
  /// **The destination is deliberately not sent.** The quotation's
  /// `destinationId` is the destination's *public UUID*, not the numeric
  /// geography id the master dropdowns use — sending the number is rejected
  /// with "Please enter a valid Destination Id." It only picks a cover image
  /// anyway, and `resolveDestinationForCover` already falls back to the lead's
  /// own itinerary. The picker above narrows the master lists and nothing else.
  Map<String, dynamic> _body(Lead lead) => buildQuotationBody(
    leadId: widget.leadId,
    title: 'Quotation for ${lead.customerName}',
    hotels: _hotels,
    vehicles: _vehicles,
    days: _filledDays,
  );

  Future<void> _create(Lead lead) async {
    setState(() => _saving = true);
    try {
      final draft = await ref
          .read(quotationApiProvider)
          .createQuotationRaw(_body(lead));
      if (!mounted) return;
      // Replace: going back should land on the lead, not on a builder for a
      // quotation that now exists.
      context.pushReplacement(Routes.quotationPreviewFor(draft.publicId ?? ''));
    } on Failure catch (f) {
      if (mounted) {
        setState(() => _saving = false);
        AppToast.error(context, 'Could not create the quotation', f.message);
      }
    }
  }

  Future<void> _apply(TemplateMatchDto template) async {
    setState(() => _busyTemplateId = template.id);
    try {
      final draft = await ref
          .read(quotationApiProvider)
          .applyTemplate(template.id, leadId: widget.leadId);
      if (!mounted) return;
      context.pushReplacement(Routes.quotationPreviewFor(draft.publicId ?? ''));
    } on Failure catch (f) {
      if (mounted) {
        setState(() => _busyTemplateId = null);
        AppToast.error(context, 'Could not apply the package', f.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final leadAsync = ref.watch(leadDetailProvider(widget.leadId));
    final lead = leadAsync.value;
    if (lead != null) _seedFrom(lead);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('New quotation', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (leadAsync) {
        AsyncLoading() => const SkeletonList(itemCount: 4, itemHeight: 96),
        AsyncError(:final error) => ErrorStateView(
          failure: asFailure(error),
          onRetry: () => ref.invalidate(leadDetailProvider(widget.leadId)),
        ),
        AsyncData(:final value) => _buildForm(value),
      },
      bottomNavigationBar: lead == null ? null : _bottomBar(lead),
    );
  }

  Widget _bottomBar(Lead lead) {
    final empty = _hotels.isEmpty && _vehicles.isEmpty && _filledDays.isEmpty;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text('Subtotal', style: AppType.bodySm),
                const Spacer(),
                Text(Inr.format(_subtotal), style: AppType.monoStrong),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            // Said plainly, because the number above is not the quotation's
            // total: tax, discount and markup are applied server-side and the
            // preview is where the real figure appears.
            Text(
              'Taxes and discounts are added by the server on the next screen.',
              style: AppType.captionSm.copyWith(color: AppColors.faint),
            ),
            const SizedBox(height: AppSpacing.x10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _busy ? null : () => _create(lead),
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onPrimary,
                        ),
                      )
                    : Text(empty ? 'Save as empty draft' : 'Create quotation'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(Lead lead) {
    final matches = ref.watch(templateMatchesProvider(lead.id));
    final destinations = ref.watch(destinationsProvider);
    final dayCount = _dayCount(lead);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      children: [
        _LeadSummary(lead: lead),
        const SizedBox(height: AppSpacing.x16),
        SheetPicker<int>(
          label: 'Destination',
          hint: 'Choose a destination',
          enabled: !_busy,
          value: _destinationId,
          options: asyncOptions(destinations),
          optionValue: (o) => o.value,
          // The lead's own itinerary named it; the id may not be in the list
          // yet while the dropdown is still loading.
          fallbackLabel: lead.itinerary.isEmpty
              ? null
              : lead.itinerary.first.destination,
          onChanged: (value) => setState(() => _destinationId = value),
        ),
        const SizedBox(height: AppSpacing.x6),
        Text(
          'Filters the hotels and sightseeing below.',
          style: AppType.captionSm.copyWith(color: AppColors.faint),
        ),
        const SizedBox(height: AppSpacing.x18),
        _PackageBlock(
          matches: matches,
          busy: _busy,
          busyTemplateId: _busyTemplateId,
          showAll: _showAllTemplates,
          onToggleAll: () =>
              setState(() => _showAllTemplates = !_showAllTemplates),
          onApply: _apply,
          onRetry: () => ref.invalidate(templateMatchesProvider(lead.id)),
        ),
        const SizedBox(height: AppSpacing.x18),
        const _Divider(label: 'or build it yourself'),
        const SizedBox(height: AppSpacing.x18),
        _RowSection(
          label: 'Hotels',
          icon: Ic.bed,
          addLabel: 'Add hotel',
          onAdd: _busy ? null : () => _addHotel(lead),
          children: [
            for (var i = 0; i < _hotels.length; i++)
              _LineTile(
                title: _hotels[i]['name'] as String? ?? 'Hotel',
                subtitle: _hotelSubtitle(_hotels[i]),
                amount: sectionAmount('hotel', [_hotels[i]]),
                onTap: () => _editHotel(i, lead),
                onRemove: () => setState(() => _hotels.removeAt(i)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x18),
        _RowSection(
          label: 'Vehicles',
          icon: Ic.car,
          addLabel: 'Add vehicle',
          note:
              'The vehicle master has no location, so every vehicle is listed.',
          onAdd: _busy ? null : _addVehicle,
          children: [
            for (var i = 0; i < _vehicles.length; i++)
              _LineTile(
                title:
                    _vehicles[i]['model'] as String? ??
                    _vehicles[i]['type'] as String? ??
                    'Vehicle',
                subtitle: _vehicleSubtitle(_vehicles[i]),
                amount: sectionAmount('vehicle', [_vehicles[i]]),
                onTap: () => _editVehicle(i),
                onRemove: () => setState(() => _vehicles.removeAt(i)),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x18),
        Row(
          children: [
            const AppIcon(Ic.pin, size: 16, color: AppColors.muted),
            const SizedBox(width: AppSpacing.x8),
            Text('Sightseeing', style: AppType.overline),
            const Spacer(),
            Text('$dayCount days', style: AppType.captionSm),
          ],
        ),
        const SizedBox(height: AppSpacing.x10),
        for (var day = 1; day <= dayCount; day++) ...[
          _DayCard(
            dayNumber: day,
            day: _days[day],
            onAdd: _busy ? null : () => _addActivity(day, lead),
            onRemoveActivity: (i) => _removeActivity(day, i),
          ),
          const SizedBox(height: AppSpacing.x8),
        ],
        const SizedBox(height: AppSpacing.x16),
      ],
    );
  }

  static String? _hotelSubtitle(Map<String, dynamic> row) {
    final parts = <String>[
      if (row['city'] is String && (row['city'] as String).isNotEmpty)
        row['city'] as String,
      if (row['roomType'] is String && (row['roomType'] as String).isNotEmpty)
        row['roomType'] as String,
      if (row['rooms'] is num) '${row['rooms']} rooms',
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  static String? _vehicleSubtitle(Map<String, dynamic> row) {
    final parts = <String>[
      if (row['type'] is String && (row['type'] as String).isNotEmpty)
        row['type'] as String,
      if (row['pickup'] is String && (row['pickup'] as String).isNotEmpty)
        '${row['pickup']} → ${row['drop'] ?? ''}'.trim(),
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }
}

/// What the server will copy onto the quotation, shown before it happens.
class _LeadSummary extends StatelessWidget {
  const _LeadSummary({required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('For this lead', style: AppType.overline),
          const SizedBox(height: AppSpacing.x8),
          Text(
            lead.customerName.isEmpty ? 'Unnamed lead' : lead.customerName,
            style: AppType.rowTitle,
          ),
          const SizedBox(height: AppSpacing.x6),
          Wrap(
            spacing: AppSpacing.x14,
            runSpacing: AppSpacing.x6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Fact(icon: Ic.pin, text: lead.destinationLabel),
              if (lead.travelDate != null)
                _Fact(
                  icon: Ic.calendar,
                  text: AppDate.display(lead.travelDate),
                ),
              if (lead.totalPax > 0) _Fact(icon: Ic.users, text: lead.paxLabel),
              if (lead.nightsLabel != null)
                _Fact(icon: Ic.clock, text: lead.nightsLabel!),
            ],
          ),
        ],
      ),
    );
  }
}

class _PackageBlock extends StatelessWidget {
  const _PackageBlock({
    required this.matches,
    required this.busy,
    required this.busyTemplateId,
    required this.showAll,
    required this.onToggleAll,
    required this.onApply,
    required this.onRetry,
  });

  final AsyncValue<List<TemplateMatchDto>> matches;
  final bool busy;
  final String? busyTemplateId;
  final bool showAll;
  final VoidCallback onToggleAll;
  final ValueChanged<TemplateMatchDto> onApply;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Start from a package', style: AppType.h3),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'One tap fills the hotels, days and pricing from the package.',
          style: AppType.bodySm,
        ),
        const SizedBox(height: AppSpacing.x12),
        switch (matches) {
          // Shrink-wrapped: this sits inside the page's own ListView, and a
          // nested scrollable with unbounded height does not lay out.
          AsyncLoading() => const SkeletonList(
            itemCount: 2,
            itemHeight: 88,
            shrinkWrap: true,
          ),
          AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: onRetry,
          ),
          AsyncData(:final value) when value.isEmpty => AppCard(
            child: Row(
              children: [
                const AppIcon(Ic.file, size: 18, color: AppColors.faint),
                const SizedBox(width: AppSpacing.x10),
                Expanded(
                  child: Text(
                    'No package templates yet. Build the quotation below, or '
                    'save one from an existing quotation on the console.',
                    style: AppType.bodySm,
                  ),
                ),
              ],
            ),
          ),
          AsyncData(:final value) => Column(
            children: [
              for (final template in showAll ? value : value.take(1)) ...[
                _TemplateCard(
                  template: template,
                  busy: busy,
                  applying: busyTemplateId == template.id,
                  onTap: () => onApply(template),
                ),
                const SizedBox(height: AppSpacing.x8),
              ],
              if (value.length > 1)
                TextButton(
                  onPressed: onToggleAll,
                  child: Text(
                    showAll
                        ? 'Show fewer'
                        : '${value.length - 1} more packages',
                  ),
                ),
            ],
          ),
        },
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
          child: Text(label, style: AppType.captionSm),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _RowSection extends StatelessWidget {
  const _RowSection({
    required this.label,
    required this.icon,
    required this.addLabel,
    required this.onAdd,
    required this.children,
    this.note,
  });

  final String label;
  final String icon;
  final String addLabel;
  final VoidCallback? onAdd;
  final List<Widget> children;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppIcon(icon, size: 16, color: AppColors.muted),
            const SizedBox(width: AppSpacing.x8),
            Text(label, style: AppType.overline),
          ],
        ),
        if (note != null) ...[
          const SizedBox(height: AppSpacing.x4),
          Text(
            note!,
            style: AppType.captionSm.copyWith(color: AppColors.faint),
          ),
        ],
        const SizedBox(height: AppSpacing.x10),
        for (final child in children) ...[
          child,
          const SizedBox(height: AppSpacing.x8),
        ],
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const AppIcon(Ic.plus, size: 15, color: AppColors.primary),
          label: Text(addLabel),
        ),
      ],
    );
  }
}

class _LineTile extends StatelessWidget {
  const _LineTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.onTap,
    required this.onRemove,
  });

  final String title;
  final String? subtitle;
  final double amount;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppType.rowTitle,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    subtitle!,
                    style: AppType.bodySm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (amount > 0) ...[
            const SizedBox(width: AppSpacing.x10),
            Text(Inr.compact(amount), style: AppType.monoSm),
          ],
          IconButton(
            onPressed: onRemove,
            iconSize: 16,
            tooltip: 'Remove',
            icon: const AppIcon(Ic.trash, size: 16, color: AppColors.faint),
          ),
        ],
      ),
    );
  }
}

/// One day of the itinerary, with whatever has been put on it.
class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.dayNumber,
    required this.day,
    required this.onAdd,
    required this.onRemoveActivity,
  });

  final int dayNumber;
  final Map<String, dynamic>? day;
  final VoidCallback? onAdd;
  final ValueChanged<int> onRemoveActivity;

  @override
  Widget build(BuildContext context) {
    final activities = (day?['activities'] as List? ?? const [])
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .toList();
    final price = day?['pricePerPax'];
    final pax = day?['pax'];
    final dayTotal = price is num
        ? price.toDouble() * (pax is num && pax > 0 ? pax.toInt() : 1)
        : 0.0;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Day $dayNumber', style: AppType.rowTitle),
              const Spacer(),
              Text(
                dayTotal > 0 ? Inr.compact(dayTotal) : '—',
                style: AppType.monoSm,
              ),
            ],
          ),
          for (var i = 0; i < activities.length; i++) ...[
            const SizedBox(height: AppSpacing.x8),
            Row(
              children: [
                const Text('•  '),
                Expanded(
                  child: Text(
                    activities[i]['attraction'] as String? ?? 'Activity',
                    style: AppType.bodySm,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (activities[i]['startTime'] is String) ...[
                  const SizedBox(width: AppSpacing.x8),
                  Text(
                    activities[i]['startTime'] as String,
                    style: AppType.monoXs,
                  ),
                ],
                IconButton(
                  onPressed: () => onRemoveActivity(i),
                  iconSize: 14,
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Remove',
                  icon: const AppIcon(
                    Ic.close,
                    size: 14,
                    color: AppColors.faint,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.x8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onAdd,
              icon: const AppIcon(Ic.plus, size: 14, color: AppColors.primary),
              label: Text('Add to day $dayNumber'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIcon(icon, size: 12, color: AppColors.faint),
        const SizedBox(width: AppSpacing.x6),
        Text(text, style: AppType.bodySm),
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.busy,
    required this.applying,
    required this.onTap,
  });

  final TemplateMatchDto template;
  final bool busy;
  final bool applying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final duration = template.durationNights == null
        ? null
        : '${template.durationNights}N / ${template.durationDays ?? template.durationNights! + 1}D';

    return AppCard(
      onTap: busy ? null : onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        template.name,
                        style: AppType.rowTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x8),
                    // The server's own score, not a number invented here.
                    _MatchBadge(percentage: template.matchPercentage),
                  ],
                ),
                if (template.cities.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x6),
                  Text(
                    template.cities.join(' · '),
                    style: AppType.bodySm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.x8),
                Wrap(
                  spacing: AppSpacing.x14,
                  runSpacing: AppSpacing.x6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (duration != null) _Fact(icon: Ic.clock, text: duration),
                    if (template.hotelTier != null)
                      _Fact(icon: Ic.star, text: '${template.hotelTier}★'),
                    if (template.basePrice != null)
                      _Fact(
                        icon: Ic.wallet,
                        text: Inr.compact(template.basePrice!.toDouble()),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x10),
          SizedBox(
            width: 20,
            height: 20,
            child: applying
                ? const CircularProgressIndicator(strokeWidth: 2)
                : const AppIcon(
                    Ic.chevronRight,
                    size: 16,
                    color: AppColors.faint,
                  ),
          ),
        ],
      ),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  const _MatchBadge({required this.percentage});

  final int percentage;

  @override
  Widget build(BuildContext context) {
    // The server ranks but does not label; these bands only colour its number.
    final (fg, bg) = switch (percentage) {
      >= 70 => (AppColors.success, AppColors.successBg),
      >= 40 => (AppColors.warn, AppColors.warnBg),
      _ => (AppColors.muted, AppColors.slateBg),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x8,
          vertical: 2,
        ),
        child: Text(
          '$percentage% match',
          style: AppType.chip.copyWith(color: fg),
        ),
      ),
    );
  }
}

/// The body for `POST /api/quotations`, from what the agent chose.
///
/// A section only goes out when it has rows, and always with its own `amount`:
/// `computeTotals` sums the section scalars and never reads the rows, so a
/// section sent without one is stored and then ignored by every total.
///
/// **The destination is deliberately absent.** A quotation's `destinationId` is
/// the destination's *public UUID*, not the numeric geography id the master
/// dropdowns use, and sending the number is rejected outright with "Please
/// enter a valid Destination Id." It only chooses a cover image, and
/// `resolveDestinationForCover` already falls back to the lead's own itinerary,
/// so leaving it out costs nothing. The destination picker on this screen
/// narrows the master lists and does not travel.
///
/// Nothing else about the traveller is sent either: `linkLeadAndSnapshot`
/// copies the customer, phone, email, pax, travel date and destination off the
/// lead server-side.
Map<String, dynamic> buildQuotationBody({
  required String leadId,
  required String title,
  required List<Map<String, dynamic>> hotels,
  required List<Map<String, dynamic>> vehicles,
  required List<Map<String, dynamic>> days,
}) {
  var sightseeingAmount = 0.0;
  for (final day in days) {
    final price = day['pricePerPax'];
    final pax = day['pax'];
    if (price is num) {
      sightseeingAmount +=
          price.toDouble() * (pax is num && pax > 0 ? pax.toInt() : 1);
    }
  }

  return <String, dynamic>{
    'leadId': leadId,
    'title': title,
    if (hotels.isNotEmpty)
      'hotel': {
        'included': true,
        'title': 'Accommodation',
        'amount': sectionAmount('hotel', hotels),
        'hotels': hotels,
      },
    if (vehicles.isNotEmpty)
      'vehicle': {
        'included': true,
        'title': 'Transport',
        'amount': sectionAmount('vehicle', vehicles),
        'vehicles': vehicles,
      },
    if (days.isNotEmpty)
      'sightseeing': {
        'included': true,
        'title': 'Day-wise Itinerary',
        'amount': sightseeingAmount,
        'days': days,
      },
  };
}
