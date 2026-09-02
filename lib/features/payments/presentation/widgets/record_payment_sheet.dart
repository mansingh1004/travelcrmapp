import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/formatters/app_date.dart';
import '../../../../core/formatters/inr.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/app_toast.dart';
import '../../providers/payments_controller.dart';

/// Record a receipt against a booking — `POST /api/bookings/{id}/payments`.
///
/// Only the amount is required; the server stamps the current user and today's
/// date when the rest is left blank. The balance shown is the server's
/// `pendingAmount`, and it is re-read after saving rather than adjusted here.
class RecordPaymentSheet extends ConsumerStatefulWidget {
  const RecordPaymentSheet({
    super.key,
    required this.bookingId,
    required this.customerName,
    required this.balance,
  });

  final String bookingId;
  final String customerName;
  final double balance;

  static Future<void> show(
    BuildContext context, {
    required String bookingId,
    required String customerName,
    required double balance,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
        builder: (_) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: RecordPaymentSheet(
            bookingId: bookingId,
            customerName: customerName,
            balance: balance,
          ),
        ),
      );

  @override
  ConsumerState<RecordPaymentSheet> createState() => _RecordPaymentSheetState();
}

class _RecordPaymentSheetState extends ConsumerState<RecordPaymentSheet> {
  static const _methods = ['UPI', 'Bank transfer', 'Cash', 'Card', 'Cheque'];
  static const _types = ['Advance', 'Partial', 'Balance'];

  late final _amount = TextEditingController(
    // Pre-fill the full balance: settling in full is the common case, and it
    // is easy to reduce.
    text: widget.balance > 0 ? widget.balance.toStringAsFixed(0) : '',
  );
  final _reference = TextEditingController();
  final _notes = TextEditingController();

  String? _method;
  String? _type;
  DateTime _date = DateTime.now();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amount.text.trim().replaceAll(',', ''));

    // The server enforces >= 0.01; catching it here saves a round trip.
    if (amount == null || amount < 0.01) {
      setState(() => _error = 'Enter an amount of at least ₹1.');
      return;
    }
    if (widget.balance > 0 && amount > widget.balance) {
      setState(() => _error =
          'That is more than the ${Inr.format(widget.balance)} outstanding.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await ref.read(paymentActionsProvider).record(
            widget.bookingId,
            amount: amount,
            paymentType: _type,
            method: _method,
            reference: _reference.text.trim().isEmpty ? null : _reference.text.trim(),
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
            date: _date,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      AppToast.success(
        context,
        'Payment recorded',
        '${Inr.format(amount)} from ${widget.customerName}.',
      );
    } on Failure catch (f) {
      if (mounted) setState(() => _error = f.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              Text('Record payment', style: AppType.h2),
              const SizedBox(height: AppSpacing.x4),
              Text(
                widget.balance > 0
                    ? '${widget.customerName} · ${Inr.format(widget.balance)} outstanding'
                    : widget.customerName,
                style: AppType.bodySm,
              ),
              const SizedBox(height: AppSpacing.x16),
              Text('Amount', style: AppType.overline),
              const SizedBox(height: AppSpacing.x8),
              TextField(
                controller: _amount,
                enabled: !_busy,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: AppType.monoStrong.copyWith(fontSize: 20),
                cursorColor: AppColors.primary,
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  fillColor: AppColors.canvas,
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x16),
              Text('Type', style: AppType.overline),
              const SizedBox(height: AppSpacing.x8),
              Wrap(
                spacing: AppSpacing.x8,
                runSpacing: AppSpacing.x8,
                children: [
                  for (final type in _types)
                    _Chip(
                      label: type,
                      active: _type == type,
                      onTap: () => setState(() => _type = _type == type ? null : type),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.x16),
              Text('Method', style: AppType.overline),
              const SizedBox(height: AppSpacing.x8),
              Wrap(
                spacing: AppSpacing.x8,
                runSpacing: AppSpacing.x8,
                children: [
                  for (final method in _methods)
                    _Chip(
                      label: method,
                      active: _method == method,
                      onTap: () =>
                          setState(() => _method = _method == method ? null : method),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.x16),
              InkWell(
                onTap: _busy ? null : _pickDate,
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
                      const AppIcon(Ic.calendar, size: 17, color: AppColors.muted),
                      const SizedBox(width: AppSpacing.x10),
                      Text(AppDate.display(_date), style: AppType.fieldValue),
                      const Spacer(),
                      const AppIcon(Ic.chevronRight, size: 16, color: AppColors.faint),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x12),
              TextField(
                controller: _reference,
                enabled: !_busy,
                maxLength: 120,
                style: AppType.fieldValue,
                cursorColor: AppColors.primary,
                decoration: const InputDecoration(
                  hintText: 'Reference / UTR (optional)',
                  fillColor: AppColors.canvas,
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x12),
              TextField(
                controller: _notes,
                enabled: !_busy,
                maxLines: 2,
                maxLength: 500,
                style: AppType.fieldValue,
                cursorColor: AppColors.primary,
                decoration: const InputDecoration(
                  hintText: 'Notes (optional)',
                  fillColor: AppColors.canvas,
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.x8),
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
              ],
              const SizedBox(height: AppSpacing.x18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : const Text('Save payment'),
                ),
              ),
              const SizedBox(height: AppSpacing.x8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.canvas,
            borderRadius: BorderRadius.circular(AppRadii.chip),
            border: Border.all(color: active ? AppColors.primary : AppColors.border),
          ),
          child: Text(
            label,
            style: AppType.tab.copyWith(
              color: active ? AppColors.onPrimary : AppColors.body,
            ),
          ),
        ),
      ),
    );
  }
}
