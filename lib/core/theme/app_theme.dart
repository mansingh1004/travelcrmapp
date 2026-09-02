import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

export 'app_colors.dart';
export 'app_radii.dart';
export 'app_shadows.dart';
export 'app_spacing.dart';
export 'app_typography.dart';

/// Material 3 theme, fully overridden so nothing Material-default shows through.
///
/// The prototype is a single light design; there is no dark variant to port, so
/// the app commits to light and pins `brightness` rather than half-supporting a
/// dark mode the design does not define.
abstract final class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryTint,
      onPrimaryContainer: AppColors.primaryDeep,
      secondary: AppColors.purple,
      onSecondary: AppColors.onPrimary,
      secondaryContainer: AppColors.purpleBg,
      onSecondaryContainer: AppColors.purple,
      tertiary: AppColors.teal,
      onTertiary: AppColors.onPrimary,
      error: AppColors.danger,
      onError: AppColors.onPrimary,
      errorContainer: AppColors.dangerBg,
      onErrorContainer: AppColors.danger,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      surfaceContainerLowest: AppColors.surface,
      surfaceContainerLow: AppColors.canvas,
      surfaceContainer: AppColors.canvas,
      outline: AppColors.border,
      outlineVariant: AppColors.line,
      shadow: Color(0x0A101828),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.canvas,
      splashFactory: InkSparkle.splashFactory,
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: AppSpacing.appBarHeight,
        titleTextStyle: AppType.h2,
        iconTheme: const IconThemeData(color: AppColors.ink, size: 22),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
        showDragHandle: false,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rLg),
        titleTextStyle: AppType.h2,
        contentTextStyle: AppType.body,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.faint,
          minimumSize: const Size.fromHeight(AppSpacing.minTouchTarget + 6),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.rButton),
          textStyle: AppType.button,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(AppSpacing.minTouchTarget + 6),
          side: const BorderSide(color: AppColors.border),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.rButton),
          textStyle: AppType.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppType.button,
          minimumSize: const Size(AppSpacing.minTouchTarget, AppSpacing.minTouchTarget),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x14,
          vertical: AppSpacing.x12,
        ),
        hintStyle: AppType.fieldValue.copyWith(color: AppColors.faint),
        labelStyle: AppType.overline,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: _fieldBorder(AppColors.border),
        enabledBorder: _fieldBorder(AppColors.border),
        focusedBorder: _fieldBorder(AppColors.primary, width: 1.5),
        errorBorder: _fieldBorder(AppColors.danger),
        focusedErrorBorder: _fieldBorder(AppColors.danger, width: 1.5),
        errorStyle: AppType.caption.copyWith(color: AppColors.danger),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.slateBg,
        side: BorderSide.none,
        labelStyle: AppType.chip,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x10, vertical: AppSpacing.x6),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rChip),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: AppType.bodySm.copyWith(color: AppColors.onPrimary),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rTile),
        elevation: 0,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.line,
        circularTrackColor: AppColors.line,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.onPrimary : AppColors.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.border,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) => OutlineInputBorder(
        borderRadius: AppRadii.rField,
        borderSide: BorderSide(color: color, width: width),
      );

  static TextTheme get _textTheme => TextTheme(
        displayLarge: AppType.display,
        headlineLarge: AppType.h1,
        headlineMedium: AppType.h2,
        titleLarge: AppType.h2,
        titleMedium: AppType.h3,
        bodyLarge: AppType.fieldValue,
        bodyMedium: AppType.body,
        bodySmall: AppType.bodySm,
        labelLarge: AppType.button,
        labelMedium: AppType.tab,
        labelSmall: AppType.overline,
      );
}
