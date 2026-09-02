import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/app_card.dart';

/// The boxed, labelled text field used across the create-lead wizard.
///
/// Same visual language as the auth screens' field — white card, 1px border,
/// radius 16, a 10px uppercase label above the value — but with room for
/// multi-line input and inline validation messages.
class AppField extends StatelessWidget {
  const AppField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.maxLines = 1,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (_) => validator?.call(controller.text),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x14,
                AppSpacing.x10,
                AppSpacing.x14,
                AppSpacing.x8,
              ),
              borderColor: field.hasError ? AppColors.danger : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label.toUpperCase(), style: AppType.overline),
                  TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    textInputAction: textInputAction,
                    maxLines: maxLines,
                    enabled: enabled,
                    style: AppType.fieldValue,
                    cursorColor: AppColors.primary,
                    onChanged: (value) {
                      // Re-run validation as the user types once an error is
                      // showing, so the message clears as soon as it is fixed.
                      if (field.hasError) field.didChange(value);
                    },
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: AppType.fieldValue.copyWith(color: AppColors.faint),
                      isDense: true,
                      filled: false,
                      contentPadding: const EdgeInsets.only(
                        top: AppSpacing.x4,
                        bottom: AppSpacing.x4,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.x6,
                  left: AppSpacing.x4,
                ),
                child: Text(
                  field.errorText!,
                  style: AppType.caption.copyWith(color: AppColors.danger),
                ),
              ),
          ],
        );
      },
    );
  }
}
