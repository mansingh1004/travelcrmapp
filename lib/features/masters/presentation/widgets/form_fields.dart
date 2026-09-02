import 'package:flutter/material.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../api/masters_api.dart';

/// The chrome every master form sheet shares: grab handle, title, the fields,
/// the error line and the submit button.
///
/// Three catalogs are edited from three sheets that differ only in their
/// fields, so the frame lives here once rather than three times.
class SheetScaffold extends StatelessWidget {
  const SheetScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.submitLabel,
    required this.onSubmit,
    required this.busy,
    this.error,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;
  final String submitLabel;
  final VoidCallback onSubmit;
  final bool busy;
  final String? error;

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
              Text(title, style: AppType.h2),
              const SizedBox(height: AppSpacing.x4),
              Text(subtitle, style: AppType.bodySm),
              const SizedBox(height: AppSpacing.x16),
              ...children,
              if (error != null) ...[
                const SizedBox(height: AppSpacing.x10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppIcon(Ic.alert, size: 16, color: AppColors.danger),
                    const SizedBox(width: AppSpacing.x8),
                    Expanded(
                      child: Text(
                        error!,
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
                  onPressed: busy ? null : onSubmit,
                  child: busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : Text(submitLabel),
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

/// A labelled text field in the sheet's style.
class SheetField extends StatelessWidget {
  const SheetField({
    super.key,
    required this.label,
    required this.controller,
    required this.enabled,
    this.hint,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.maxLength,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String? hint;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          maxLength: maxLength,
          style: AppType.fieldValue,
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: AppColors.canvas,
            counterText: '',
            border: const OutlineInputBorder(
              borderRadius: AppRadii.rTile,
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: AppRadii.rTile,
              borderSide: BorderSide.none,
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: AppRadii.rTile,
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

/// A dropdown fed by `/api/masters/dropdown/*`.
///
/// [T] is what the request carries — a destination's numeric id for a hotel,
/// but a *name* for the city and for sightseeing, because that is what those
/// endpoints resolve against.
class SheetPicker<T> extends StatelessWidget {
  const SheetPicker({
    super.key,
    required this.label,
    required this.hint,
    required this.enabled,
    required this.value,
    required this.options,
    required this.optionValue,
    required this.onChanged,
    this.fallbackLabel,
  });

  final String label;
  final String hint;
  final bool enabled;
  final T? value;
  final AsyncValueLike options;
  final T Function(DropdownOption) optionValue;
  final ValueChanged<T?> onChanged;

  /// Shown when the saved value is not in the loaded list, so editing a row
  /// never silently drops the destination or city it already has.
  final String? fallbackLabel;

  @override
  Widget build(BuildContext context) {
    final loaded = options.options;
    final known = loaded.any((o) => optionValue(o) == value);
    final loading = options.loading && loaded.isEmpty;
    final failure = options.error == null ? null : asFailure(options.error!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        // A plain DropdownButton, not the FormField flavour: the latter keeps
        // its own copy of the value and ignores a changed `initialValue`, so
        // clearing the city when the destination changes would leave a stale
        // selection showing — and then assert, because it is no longer among
        // the items.
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
          decoration: const BoxDecoration(
            color: AppColors.canvas,
            borderRadius: AppRadii.rTile,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.surface,
              borderRadius: AppRadii.rTile,
              style: AppType.fieldValue,
              icon: const AppIcon(Ic.chevronDown, size: 16, color: AppColors.faint),
              hint: Text(
                loading ? 'Loading…' : hint,
                style: AppType.fieldValue.copyWith(color: AppColors.faint),
                overflow: TextOverflow.ellipsis,
              ),
              items: [
                if (value != null && !known)
                  DropdownMenuItem<T>(
                    value: value,
                    child: Text(
                      fallbackLabel ?? '$value',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                for (final option in loaded)
                  DropdownMenuItem<T>(
                    value: optionValue(option),
                    child: Text(option.label, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: enabled && !loading ? onChanged : null,
            ),
          ),
        ),
        if (failure != null) ...[
          const SizedBox(height: AppSpacing.x6),
          Text(
            failure.message,
            style: AppType.captionSm.copyWith(color: AppColors.danger),
          ),
        ],
      ],
    );
  }
}

/// The three states of a dropdown's data, flattened.
///
/// The picker only needs "what is loaded", "is it still loading" and "did it
/// fail"; taking a Riverpod `AsyncValue` directly would drag the whole package
/// into a plain widget file for nothing.
class AsyncValueLike {
  const AsyncValueLike({
    this.options = const [],
    this.loading = false,
    this.error,
  });

  final List<DropdownOption> options;
  final bool loading;
  final Object? error;
}

/// A selectable pill, used for star ratings and vehicle-type shortcuts.
class SheetChip extends StatelessWidget {
  const SheetChip({
    super.key,
    required this.label,
    required this.active,
    this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x14),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.canvas,
            borderRadius: BorderRadius.circular(AppRadii.chip),
            border: Border.all(color: active ? AppColors.primary : AppColors.border),
          ),
          // `Center(widthFactor: 1)`, not `alignment: Alignment.center`: a
          // Container with an alignment grows to the width it is offered, and
          // a Wrap offers the full line — the chips came out full-width rows.
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: AppType.tab.copyWith(
                color: active ? AppColors.onPrimary : AppColors.body,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
