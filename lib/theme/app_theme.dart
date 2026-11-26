import 'package:flutter/material.dart';

import 'tokens.dart';

/// One ThemeData built from the tokens in [AppColors].
/// Prompt is bundled with the app so Thai renders offline.
abstract final class AppTheme {
  static const String fontFamily = 'Prompt';

  static ThemeData build() {
    final ColorScheme scheme = const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.success,
      onSecondary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      error: AppColors.primary,
      onError: AppColors.onPrimary,
    );

    final TextTheme base = Typography.material2021().black.apply(
      bodyColor: AppColors.onSurface,
      displayColor: AppColors.onSurface,
      fontFamily: fontFamily,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: base.copyWith(
        titleLarge: base.titleLarge?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.onPrimary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: AppColors.onPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.onPrimary, size: 26),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        hintStyle: const TextStyle(
          fontFamily: fontFamily,
          color: AppColors.onSurfaceVariant,
          fontSize: 15,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDims.fieldRadius),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDims.fieldRadius),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDims.fieldRadius),
          borderSide: const BorderSide(color: AppColors.outline, width: 1.6),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.onSurface,
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: AppColors.onPrimary,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size.fromHeight(AppDims.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDims.buttonRadius),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
      ),
    );
  }
}
