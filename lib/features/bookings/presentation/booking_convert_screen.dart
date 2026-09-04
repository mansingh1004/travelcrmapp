import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/inr.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/booking_api.dart';
import '../../../domain/entities/lead.dart';
import '../../../router/routes.dart';
import '../../../router/safe_pop.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/state_views.dart';
import '../../leads/providers/lead_detail_provider.dart';
import '../../masters/api/masters_api.dart' show DropdownOption;
import '../../masters/presentation/widgets/form_fields.dart';
import '../../quotations/providers/quotations_controller.dart';

/// A vendor as this form needs it: the request wants `vendorPublicId`, a UUID,
/// while the picker shows a name, so both travel together and the name is only
/// ever a label.
typedef VendorOption = ({String id, String name});

/// The vendors a booking can be placed with.
///
/// **`status=ACTIVE` only.** A suspended or blacklisted supplier stays on file
/// — the ledger has to survive — but must not be offered on new work, and the
/// server narrows the list rather than the client, so nothing is hidden from
/// page two.
///
/// There is no lightweight dropdown for vendors: `MasterDropdownController`
/// has one for hotels, vehicles, sightseeing, cities and half a dozen others,
/// but not this. So the full rows are fetched and capped at 100 — a booking
/// form is no place to scroll a vendor ledger.
final _vendorOptionsProvider =
    FutureProvider.autoDispose<List<VendorOption>>((ref) async {
  final page = await ref
      .watch(vendorApiProvider)
      .getVendors(size: 100, status: 'ACTIVE');
  return [
    for (final vendor in page.content)
      if (vendor.publicId != null) (id: vendor.publicId!, name: vendor.name),
  ];
});

/// Turn a lead — and the quotation the customer accepted — into a booking.
///
/// `POST /api/leads/{publicId}/convert-to-booking`, because that is where the
/// backend puts it: *"Lead → Booking conversion lives on the lead-centric
/// path."* The quotation travels as `quotationPublicId`, which links the two
/// and pins the cancellation policy the customer was actually quoted under.
///
/// **No money is calculated here.** GST and TCS depend on the tenant's
/// accounting settings, which this app does not hold, so every figure in the
/// summary comes from `POST /api/bookings/preview` — re-asked whenever an
/// amount changes.
///
/// The customer, phone and email are resolved server-side from the lead. The
/// amount is not: it is pre-filled from the quotation's grand total here,
/// because the conversion endpoint will happily create a ₹0 booking otherwise.
class BookingConvertScreen extends ConsumerStatefulWidget {
  const BookingConvertScreen({
    super.key,
    required this.leadId,
    this.quotationId,
  });

  final String leadId;

  /// The quotation being converted, when there is one.
  final String? quotationId;

  @override
  ConsumerState<BookingConvertScreen> createState() =>
      _BookingConvertScreenState();
}

class _BookingConvertScreenState extends ConsumerState<BookingConvertScreen> {
  /// Fixed for the life of this screen.
  ///
  /// The header is required, and reusing one key is the whole point: a double
  /// tap, or a retry after a dropped connection, replays the booking that was
  /// already created instead of making a second one.
  final _idempotencyKey = _newKey();

  final _name = TextEditingController();
  final _destination = TextEditingController();
  final _amount = TextEditingController();
  final _paid = TextEditingController();
  final _vendorCost = TextEditingController();

  /// The name shown in the picker, and the id the request needs.
  String? _vendorName;

  /// The vendor's public UUID, once one is picked.
  ///
  /// Optional on the request, and left alone when nothing is arranged yet —
  /// which is the ordinary case at the moment a booking is taken.
  String? _vendorId;

  DateTime? _travelDate;

  /// The three tax switches, **tri-state on purpose**.
  ///
  /// `BookingTaxCalculator` reads them as `Boolean`, and null means *inherit
  /// the tenant's accounting settings*. The backend spells out why the default
  /// is not `false`: "defaulting it to true would force it onto tenants who had
  /// switched it off centrally. Null — inherit — is the only answer that leaves
  /// every existing row behaving exactly as it did."
  ///
  /// So they start null, and stay null unless the agent overrides this one
  /// booking.
  bool? _applyGst;
  bool? _gstInclusive;
  bool? _applyTcs;

  /// Not tri-state — the calculator reads it with `Boolean.TRUE.equals`, so
  /// null and false are the same thing. It changes which TCS band applies.
  bool _overseas = false;

  bool _seeded = false;
  bool _saving = false;
  String? _error;

  /// The server's own arithmetic for the numbers currently in the form.
  BookingFinancials? _financials;
  bool _previewing = false;

  static String _newKey() {
    // A random key, not a hash of the form: it must stay the same while the
    // agent edits, so an edited-then-retried submit is still the same attempt.
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  void _seed(Lead lead, num? quotationTotal) {
    if (_seeded) return;
    _seeded = true;
    _name.text = lead.customerName;
    _destination.text = lead.destinationLabel;
    _travelDate = lead.travelDate;
    if (quotationTotal != null && quotationTotal > 0) {
      _amount.text = quotationTotal.toStringAsFixed(0);
      // Ask the server what that amount actually costs once, up front, so the
      // agent sees the tax before touching anything.
      WidgetsBinding.instance.addPostFrameCallback((_) => _preview());
    }
  }

  double? get _amountValue =>
      double.tryParse(_amount.text.trim().replaceAll(',', ''));

  double? get _vendorCostValue =>
      double.tryParse(_vendorCost.text.trim().replaceAll(',', ''));

  Future<void> _preview() async {
    final amount = _amountValue;
    if (amount == null || amount <= 0) {
      setState(() => _financials = null);
      return;
    }
    setState(() => _previewing = true);
    try {
      final financials = await ref.read(bookingApiProvider).previewFinancials(
            customerAmount: amount,
            vendorCost: _vendorCostValue,
            paidAmount: double.tryParse(_paid.text.trim()),
            applyGst: _applyGst,
            gstInclusive: _gstInclusive,
            applyTcs: _applyTcs,
            overseasTourPackage: _overseas ? true : null,
          );
      if (mounted) setState(() => _financials = financials);
    } on Failure {
      // A failed preview is not a failed booking — the create recomputes
      // everything server-side anyway, so the summary just goes quiet.
      if (mounted) setState(() => _financials = null);
    } finally {
      if (mounted) setState(() => _previewing = false);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _travelDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) setState(() => _travelDate = picked);
  }

  Future<void> _convert(Lead lead) async {
    final name = _name.text.trim();
    final destination = _destination.text.trim();

    if (name.isEmpty) {
      setState(() => _error = 'Enter the customer name.');
      return;
    }
    if (destination.isEmpty) {
      setState(() => _error = 'Enter the destination.');
      return;
    }
    if (_travelDate == null) {
      setState(() => _error = 'Choose the travel date.');
      return;
    }
    // Not a server rule — it accepts a booking with no phone on the request —
    // but the customer is resolved by the **lead's** phone, and without one the
    // create fails deep inside with a message about the lead.
    if (lead.phone.trim().isEmpty) {
      setState(() => _error =
          'This lead has no phone number. Add one to the lead first — the '
          'customer record is matched on it.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final booking = await ref.read(bookingApiProvider).convertLeadToBooking(
            leadPublicId: widget.leadId,
            idempotencyKey: _idempotencyKey,
            body: buildConversionBody(
              customerName: name,
              destination: destination,
              travelDate: _travelDate!,
              quotationId: widget.quotationId,
              customerAmount: _amountValue,
              paidAmount: double.tryParse(_paid.text.trim()),
              vendorId: _vendorId,
              vendorCost: _vendorCostValue,
              applyGst: _applyGst,
              gstInclusive: _gstInclusive,
              applyTcs: _applyTcs,
              overseasTourPackage: _overseas ? true : null,
            ),
          );
      if (!mounted) return;
      final publicId = booking.publicId ?? '';
      context.pushReplacement(Routes.bookingDetailFor(publicId));
    } on Failure catch (f) {
      // The 409 for "this lead already has an active booking" names it, and the
      // 400 for a missing phone explains itself; both read better than anything
      // invented here.
      if (mounted) setState(() => _error = f.message);
    } catch (e) {
      // Anything that is not a Failure — a `TypeError` out of a generated
      // `fromJson`, say. Catching only Failure left the spinner turning for
      // ever on exactly that, with the booking already created server-side, so
      // the agent had no idea whether to try again.
      if (mounted) {
        setState(() => _error =
            'The booking may have been created, but the reply could not be '
            'read. Check the bookings list before trying again.\n\n$e');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _destination.dispose();
    _amount.dispose();
    _paid.dispose();
    _vendorCost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leadAsync = ref.watch(leadDetailProvider(widget.leadId));
    final quotation = widget.quotationId == null
        ? null
        : ref.watch(quotationDetailProvider(widget.quotationId!)).value;

    final lead = leadAsync.value;
    if (lead != null) _seed(lead, quotation?.totals?.grandTotal);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        title: Text('Convert to booking', style: AppType.h2),
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: switch (leadAsync) {
        AsyncLoading() => const SkeletonList(itemCount: 4, itemHeight: 96),
        AsyncError(:final error) => ErrorStateView(
            failure: asFailure(error),
            onRetry: () => ref.invalidate(leadDetailProvider(widget.leadId)),
          ),
        AsyncData(:final value) => _form(value),
      },
      bottomNavigationBar: lead == null ? null : _bar(lead),
    );
  }

  Widget _form(Lead lead) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('From this lead', style: AppType.overline),
              const SizedBox(height: AppSpacing.x8),
              Text(lead.customerName, style: AppType.rowTitle),
              const SizedBox(height: AppSpacing.x4),
              Text(
                lead.phone.isEmpty ? 'No phone on the lead' : lead.phone,
                style: AppType.bodySm.copyWith(
                  color: lead.phone.isEmpty ? AppColors.danger : null,
                ),
              ),
              if (widget.quotationId != null) ...[
                const SizedBox(height: AppSpacing.x8),
                Row(
                  children: [
                    const AppIcon(Ic.file, size: 13, color: AppColors.faint),
                    const SizedBox(width: AppSpacing.x6),
                    Text(
                      'Linked to the quotation you were viewing',
                      style: AppType.captionSm,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x18),
        SheetField(
          label: 'Customer name',
          controller: _name,
          enabled: !_saving,
          textCapitalization: TextCapitalization.words,
          maxLength: 255,
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Destination',
          controller: _destination,
          enabled: !_saving,
          textCapitalization: TextCapitalization.words,
          maxLength: 255,
        ),
        const SizedBox(height: AppSpacing.x14),
        Text('Travel date', style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        InkWell(
          onTap: _saving ? null : _pickDate,
          borderRadius: BorderRadius.circular(AppRadii.tile),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(AppRadii.tile),
            ),
            child: Row(
              children: [
                const AppIcon(Ic.calendar, size: 15, color: AppColors.muted),
                const SizedBox(width: AppSpacing.x8),
                Text(
                  _travelDate == null ? 'Not set' : AppDate.display(_travelDate),
                  style: _travelDate == null
                      ? AppType.fieldValue.copyWith(color: AppColors.faint)
                      : AppType.fieldValue,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x14),
        Row(
          children: [
            Expanded(
              child: SheetField(
                label: 'Customer amount',
                controller: _amount,
                enabled: !_saving,
                hint: '₹',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                maxLength: 12,
              ),
            ),
            const SizedBox(width: AppSpacing.x10),
            Expanded(
              child: SheetField(
                label: 'Paid now',
                controller: _paid,
                enabled: !_saving,
                hint: '₹ 0',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                maxLength: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x18),
        Text('Vendor', style: AppType.overline),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Optional — arrange it later if nothing is booked yet.',
          style: AppType.captionSm.copyWith(color: AppColors.faint),
        ),
        const SizedBox(height: AppSpacing.x10),
        Builder(
          builder: (context) {
            final vendors = ref.watch(_vendorOptionsProvider);
            final options = vendors.value ?? const <VendorOption>[];
            return SheetPicker<String>(
              label: 'Booked through',
              hint: 'No vendor selected',
              enabled: !_saving,
              value: _vendorName,
              options: AsyncValueLike(
                options: [
                  for (final v in options)
                    DropdownOption(value: 0, label: v.name),
                ],
                loading: vendors.isLoading,
                error: vendors.error,
              ),
              optionValue: (o) => o.label,
              onChanged: (name) => setState(() {
                _vendorName = name;
                // The picker shows the name; the request carries the id.
                _vendorId = options
                    .where((v) => v.name == name)
                    .map((v) => v.id)
                    .firstOrNull;
                if (name == null) _vendorCost.clear();
              }),
            );
          },
        ),
        const SizedBox(height: AppSpacing.x14),
        SheetField(
          label: 'Vendor cost',
          controller: _vendorCost,
          // Nothing to cost until a vendor is named, and the cost is what
          // turns the profit line on — so the two travel together.
          enabled: !_saving && _vendorId != null,
          hint: _vendorId == null ? 'Choose a vendor first' : '₹',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          maxLength: 12,
        ),
        const SizedBox(height: AppSpacing.x18),
        Text('Tax', style: AppType.overline),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Leave these on Default and your agency’s accounting settings decide. '
          'Change one only for this booking.',
          style: AppType.captionSm.copyWith(color: AppColors.faint),
        ),
        const SizedBox(height: AppSpacing.x12),
        _TriToggle(
          label: 'Apply GST',
          value: _applyGst,
          enabled: !_saving,
          onChanged: (v) {
            setState(() => _applyGst = v);
            _preview();
          },
        ),
        const SizedBox(height: AppSpacing.x12),
        _TriToggle(
          label: 'Price includes GST',
          // Worth spelling out: under inclusive pricing the server treats the
          // amount above as the gross and derives the taxable base out of it,
          // so the figure it stamps is lower than the one typed.
          note: 'The amount above is then the gross the customer pays.',
          value: _gstInclusive,
          enabled: !_saving,
          onChanged: (v) {
            setState(() => _gstInclusive = v);
            _preview();
          },
        ),
        const SizedBox(height: AppSpacing.x12),
        _TriToggle(
          label: 'Apply TCS',
          value: _applyTcs,
          enabled: !_saving,
          onChanged: (v) {
            setState(() => _applyTcs = v);
            _preview();
          },
        ),
        const SizedBox(height: AppSpacing.x12),
        SwitchListTile.adaptive(
          value: _overseas,
          onChanged: _saving
              ? null
              : (v) {
                  setState(() => _overseas = v);
                  _preview();
                },
          contentPadding: EdgeInsets.zero,
          title: Text('Overseas tour package', style: AppType.body),
          subtitle: Text(
            'Changes which TCS band applies.',
            style: AppType.captionSm,
          ),
        ),
        const SizedBox(height: AppSpacing.x10),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _saving || _previewing ? null : _preview,
            icon: const AppIcon(Ic.refresh, size: 14, color: AppColors.primary),
            label: Text(_previewing ? 'Working out the tax…' : 'Recalculate'),
          ),
        ),
        if (_financials != null) ...[
          const SizedBox(height: AppSpacing.x8),
          _FinancialsCard(
            financials: _financials!,
            showProfit: (_vendorCostValue ?? 0) > 0,
          ),
        ],
        const SizedBox(height: AppSpacing.x16),
      ],
    );
  }

  Widget _bar(Lead lead) {
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
            if (_error != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppIcon(Ic.alert, size: 16, color: AppColors.danger),
                  const SizedBox(width: AppSpacing.x8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: AppType.bodySm.copyWith(color: AppColors.danger),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x10),
            ],
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _saving ? null : () => _convert(lead),
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onPrimary,
                        ),
                      )
                    : const Text('Create booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The server's figures, shown as they came.
class _FinancialsCard extends StatelessWidget {
  const _FinancialsCard({required this.financials, required this.showProfit});

  final BookingFinancials financials;

  /// Whether a vendor cost was given — which is what makes the profit real.
  final bool showProfit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('What the server will stamp', style: AppType.overline),
              const Spacer(),
              if (financials.paymentStatus != null)
                Text(financials.paymentStatus!, style: AppType.captionSm),
            ],
          ),
          const SizedBox(height: AppSpacing.x10),
          _Line(label: 'Amount', value: financials.customerAmount),
          _Line(label: 'GST', value: financials.gst),
          _Line(label: 'TCS', value: financials.tcs),
          const Divider(height: AppSpacing.x18),
          _Line(label: 'Total payable', value: financials.totalPayable, bold: true),
          _Line(label: 'Pending', value: financials.pendingAmount),
          // Only once a vendor cost is known. Without one the server returns
          // the whole amount as profit, which would read as a margin the agency
          // is not actually making.
          if (showProfit)
            _Line(label: 'Your profit', value: financials.netProfit),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value, this.bold = false});

  final String label;
  final double? value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x6),
      child: Row(
        children: [
          Text(label, style: bold ? AppType.rowTitle : AppType.bodySm),
          const Spacer(),
          Text(
            Inr.format(value!),
            style: bold ? AppType.monoStrong : AppType.monoSm,
          ),
        ],
      ),
    );
  }
}

/// The body for `POST /api/leads/{id}/convert-to-booking`.
///
/// Only three fields are validated — `customerName`, `destination` and
/// `travelDate` — and everything else is optional on purpose: the backend notes
/// that "a booking is routinely taken before the money is settled."
///
/// The customer's phone and email are **not** sent. They are resolved from the
/// lead server-side, and phone is the per-tenant natural key for a customer, so
/// sending a different one here would risk a second customer row.
///
/// The three tax flags are omitted when null, and that omission is the point:
/// `BookingTaxCalculator` treats a null as *inherit the tenant's accounting
/// settings*, which is what should happen unless the agent overrode this one
/// booking. Sending `false` would switch tax off; sending nothing leaves the
/// tenant's own rule in charge.
Map<String, dynamic> buildConversionBody({
  required String customerName,
  required String destination,
  required DateTime travelDate,
  String? quotationId,
  double? customerAmount,
  double? paidAmount,
  String? vendorId,
  double? vendorCost,
  bool? applyGst,
  bool? gstInclusive,
  bool? applyTcs,
  bool? overseasTourPackage,
}) {
  return <String, dynamic>{
    'customerName': customerName.trim(),
    'destination': destination.trim(),
    'travelDate': _wireDate(travelDate),
    if (quotationId != null && quotationId.isNotEmpty)
      'quotationPublicId': quotationId,
    if (customerAmount != null && customerAmount > 0)
      'customerAmount': customerAmount,
    if (paidAmount != null && paidAmount > 0) 'paidAmount': paidAmount,
    // Both omitted when nothing is arranged yet, which is the ordinary case
    // when a booking is taken: the vendor is chosen days later.
    if (vendorId != null && vendorId.isNotEmpty) 'vendorPublicId': vendorId,
    if (vendorCost != null && vendorCost > 0) 'vendorCost': vendorCost,
    'applyGst': ?applyGst,
    'gstInclusive': ?gstInclusive,
    'applyTcs': ?applyTcs,
    'overseasTourPackage': ?overseasTourPackage,
  };
}

String _wireDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

/// Default / On / Off — the three states `BookingTaxCalculator` reads.
///
/// "Default" is null, and it is the resting state: the tenant's accounting
/// settings then decide. Rendering this as a plain two-way switch would force a
/// yes or no onto every booking and quietly override a tenant that had turned
/// the tax off centrally.
class _TriToggle extends StatelessWidget {
  const _TriToggle({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.note,
  });

  final String label;
  final bool? value;
  final bool enabled;
  final ValueChanged<bool?> onChanged;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppType.body),
        if (note != null) ...[
          const SizedBox(height: AppSpacing.x4),
          Text(note!, style: AppType.captionSm.copyWith(color: AppColors.faint)),
        ],
        const SizedBox(height: AppSpacing.x8),
        Wrap(
          spacing: AppSpacing.x8,
          children: [
            for (final option in const [
              (null, 'Default'),
              (true, 'On'),
              (false, 'Off'),
            ])
              SheetChip(
                label: option.$2,
                active: value == option.$1,
                onTap: enabled ? () => onChanged(option.$1) : null,
              ),
          ],
        ),
      ],
    );
  }
}
