import 'package:flutter/material.dart';

/// Design tokens used across the UI.
/// Treat these as the single source of truth — never hard-code raw hex elsewhere.
abstract final class AppColors {
  /// Splash background, app bar, FAB, cancel/delete buttons, list chevron.
  static const Color primary = Color(0xFFF44336);

  /// Save / update buttons, selected meal chip.
  static const Color success = Color(0xFF4CAF50);

  /// Unselected meal chips.
  static const Color chipOff = Color(0xFF9E9E9E);

  /// Splash "Food Tracker" title and the splash progress arc.
  static const Color wordmark = Color(0xFFFFEB3B);

  /// List and form scaffold background.
  static const Color surface = Color(0xFFFEF7FF);

  /// Alternating list cards (first, third, fifth, ...).
  static const Color cardGreen = Color(0xFFE8F5E9);

  /// Alternating list cards (second, fourth, sixth, ...).
  static const Color cardGray = Color(0xFFF5F5F5);

  /// App bar title, button labels, chip labels, FAB "+".
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Field labels, card titles.
  static const Color onSurface = Color(0xFF1D1B20);

  /// Card subtitles, hints.
  static const Color onSurfaceVariant = Color(0xFF49454F);

  /// Outlined text-field borders.
  static const Color outline = Color(0xFF79747E);

  /// Camera placeholder glyph in the add screen.
  static const Color cameraPlaceholder = Color(0xFF9E9E9E);
}

/// Spacing / radius / size constants used across the UI.
abstract final class AppDims {
  /// Horizontal padding: cards sit at 18dp from the edge.
  static const double screenPadH = 18;
  static const double cardRadius = 18;
  static const double cardGap = 9.5;

  /// Card is 66dp tall with a 46dp square thumbnail.
  static const double cardHeight = 66;
  static const double thumbSize = 46;
  static const double cardPadH = 15;

  static const double fieldRadius = 8;
  static const double buttonRadius = 8;
  static const double buttonHeight = 52;

  /// FAB is a rounded square (~50dp), horizontally centered near the bottom.
  static const double fabSize = 50;
  static const double fabRadius = 15;
  static const double fabBottomPad = 26;

  /// Logo renders ~118dp wide on the list (art fills 91% of the asset).
  static const double logoListSize = 129;

  /// Splash art is ~165dp.
  static const double logoSplashSize = 181;
}

/// The meal values persisted into `foodMeal` — exact Thai words, in chip order.
const List<String> kMeals = <String>['เช้า', 'กลางวัน', 'เย็น', 'ว่าง'];
