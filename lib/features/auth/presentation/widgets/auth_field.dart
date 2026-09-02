import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// The prototype's boxed field: white, 1px #E4E9F2, radius 14, padding 12/14,
/// with a 10px uppercase label above the value.
///
/// Built as a real [TextFormField] — the prototype shows static text, but this
/// screen actually signs the user in.
class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.trailing,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? trailing;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.rField,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x14,
        AppSpacing.x10,
        AppSpacing.x8,
        AppSpacing.x6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label.toUpperCase(), style: AppType.overline),
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  validator: validator,
                  enabled: enabled,
                  textInputAction: textInputAction,
                  onFieldSubmitted: onFieldSubmitted,
                  autofillHints: autofillHints,
                  style: AppType.fieldValue,
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: AppType.fieldValue.copyWith(color: AppColors.faint),
                    isDense: true,
                    filled: false,
                    contentPadding: const EdgeInsets.only(top: AppSpacing.x4, bottom: AppSpacing.x6),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    // Errors are rendered under the box by the form, not inside
                    // it, so the field keeps its fixed prototype height.
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
