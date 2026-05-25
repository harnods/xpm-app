import 'package:flutter/material.dart';

// ============================================================
// XPM Project-local color constants
// These do NOT exist in Mekari Pixel — defined here as app theme constants.
// See DESIGN.md §5.6
// ============================================================

abstract class XpmColors {
  XpmColors._();

  /// Page background, separators, neutral surfaces.
  /// CSS: --XpmColors-bg-base | #F2F3F9
  static const Color bgBase = Color(0xFFF2F3F9);

  /// Budget summary card dark navy background.
  /// CSS: --XpmColors-budget-cardBg | #1C3A6F
  static const Color budgetCardBg = Color(0xFF1C3A6F);

  /// Budget progress track background (on dark card).
  /// CSS: --XpmColors-budget-trackBg | #4B618C
  static const Color budgetTrackBg = Color(0xFF4B618C);
}
