import 'package:flutter/material.dart';

/// Application color palette for the Glowify skin care app.
///
/// Based on a soft pastel palette that conveys calm, beauty, and self-care.
/// All UI elements should use these colors exclusively.
class AppColors {
  AppColors._();

  // ─── Primary Palette (5 Core Colors) ──────────────────────────

  /// Mint Teal — Primary actions, buttons, main highlights
  static const Color mintTeal = Color(0xFFAAC9CE);

  /// Lavender — Secondary elements, tags, badges
  static const Color lavender = Color(0xFFB6B4C2);

  /// Mauve — Tertiary accents, links, decorative elements
  static const Color mauve = Color(0xFFC9BBC8);

  /// Soft Pink — Elevated containers, cards, banners
  static const Color softPink = Color(0xFFE5C1CD);

  /// Peach — Scaffold background, base surface
  static const Color peach = Color(0xFFF3DBCF);

  // ─── Derived Dark Shades (for legible text on pastel surfaces) ─

  /// Dark Teal — Text on mint teal backgrounds
  static const Color darkTeal = Color(0xFF2D5158);

  /// Dark Lavender — Text on lavender backgrounds
  static const Color darkLavender = Color(0xFF3A3846);

  /// Dark Mauve — Text on mauve backgrounds
  static const Color darkMauve = Color(0xFF443944);

  /// Dark Pink — Text on soft pink backgrounds
  static const Color darkPink = Color(0xFF5C3A45);

  /// Dark Warm — General dark text for warm backgrounds
  static const Color darkWarm = Color(0xFF3B2C2C);

  // ─── Lighter Tints (for containers, cards, lighter surfaces) ───

  /// Very light peach — Lightest surface, almost white
  static const Color lightPeach = Color(0xFFFFF5F0);

  /// Cream — Light warm surface
  static const Color cream = Color(0xFFFFF0EB);

  /// Light Mint — Lighter teal for containers
  static const Color lightMint = Color(0xFFD5E8EB);

  /// Light Lavender — Lighter lavender for containers
  static const Color lightLavender = Color(0xFFDCDBE6);

  /// Light Mauve — Lighter mauve for containers
  static const Color lightMauve = Color(0xFFE6DCE5);
}
