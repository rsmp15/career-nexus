import 'package:flutter/material.dart';

/// AgriSetu Provider Premium Color Palette
/// Inspired by professional agricultural dashboards with a modern touch.
class ProviderColors {
  ProviderColors._();

  // Primary: Deep Forest Green - Represents trust, growth, and nature
  static const Color primary = Color(0xFF1A4D2E);
  static const Color primaryLight = Color(0xFF4F7355);
  static const Color primaryDark = Color(0xFF0D2A17);

  // Secondary: Warm Sage - Earthy and calming
  static const Color secondary = Color(0xFF6B8A7A);
  static const Color secondaryLight = Color(0xFF9AB6A6);

  // Accent: Harvest Gold - Premium and warm
  static const Color accent = Color(0xFFE8AA42);
  static const Color accentLight = Color(0xFFFFC96B);
  static const Color accentDark = Color(0xFFBF8A30);

  // Surface & Background
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F4F1);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1D1E);
  static const Color textSecondary = Color(0xFF5C6B73);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF0F4F1)],
  );

  // Card Shadows
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get primaryShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.25),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}
