import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// World-Class Design System - Dark Theme with Vibrant Accents
/// Inspired by Dribbble's best equipment rental and social media designs
class AppDesign {
  // ════════════════════════════════════════════════════════════════════════════
  // COLOR PALETTE - Equipment Booking (Forest/Emerald Theme)
  // ════════════════════════════════════════════════════════════════════════════
  static const Color booking = Color(0xFF1A7F64); // Emerald
  static const Color bookingDark = Color(0xFF0D4A3C); // Deep Forest
  static const Color bookingLight = Color(0xFF3DDC84); // Electric Green
  static const Color bookingAccent = Color(0xFFFFD93D); // Golden Yellow

  static const LinearGradient bookingGradient = LinearGradient(
    colors: [Color(0xFF0D4A3C), Color(0xFF1A7F64)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bookingAccentGradient = LinearGradient(
    colors: [Color(0xFF1A7F64), Color(0xFF3DDC84)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ════════════════════════════════════════════════════════════════════════════
  // COLOR PALETTE - Social Media (Ocean/Indigo Theme)
  // ════════════════════════════════════════════════════════════════════════════
  static const Color social = Color(0xFF4338CA); // Royal Blue
  static const Color socialDark = Color(0xFF1E1B4B); // Deep Indigo
  static const Color socialLight = Color(0xFF818CF8); // Soft Violet
  static const Color socialAccent = Color(0xFFF472B6); // Pink

  static const LinearGradient socialGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF4338CA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient socialAccentGradient = LinearGradient(
    colors: [Color(0xFF4338CA), Color(0xFF818CF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ════════════════════════════════════════════════════════════════════════════
  // NEUTRALS - Dark Theme
  // ════════════════════════════════════════════════════════════════════════════
  static const Color background = Color(0xFF0A0A0B); // Almost Black
  static const Color surface = Color(0xFF161618); // Dark Gray
  static const Color card = Color(0xFF1F1F23); // Elevated Surface
  static const Color cardLight = Color(0xFF2A2A30); // Lighter Card

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);
  static const Color divider = Color(0xFF27272A);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);

  // ════════════════════════════════════════════════════════════════════════════
  // DESIGN TOKENS
  // ════════════════════════════════════════════════════════════════════════════

  // Border Radius
  static const double radiusS = 12.0;
  static const double radiusM = 16.0;
  static const double radiusL = 24.0;
  static const double radiusXL = 32.0;
  static const double radiusFull = 999.0;

  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // ════════════════════════════════════════════════════════════════════════════
  // SHADOWS
  // ════════════════════════════════════════════════════════════════════════════
  static List<BoxShadow> glowShadow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.3),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: color.withOpacity(0.2),
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // ════════════════════════════════════════════════════════════════════════════
  // TEXT STYLES
  // ════════════════════════════════════════════════════════════════════════════
  static TextStyle get displayLarge => GoogleFonts.spaceGrotesk(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -1.5,
    height: 1.1,
  );

  static TextStyle get displayMedium => GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -1,
  );

  static TextStyle get headlineLarge => GoogleFonts.spaceGrotesk(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle get headlineMedium => GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.6,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textMuted,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textMuted,
    letterSpacing: 0.5,
  );

  // ════════════════════════════════════════════════════════════════════════════
  // THEME DATA
  // ════════════════════════════════════════════════════════════════════════════
  static ThemeData theme({required bool isBookingMode}) {
    final primaryColor = isBookingMode ? booking : social;
    final accentColor = isBookingMode ? bookingLight : socialLight;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surface,
        background: background,
        error: error,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: headlineMedium,
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: const CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusL)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryColor,
        unselectedItemColor: textMuted,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// REUSABLE WIDGETS
// ════════════════════════════════════════════════════════════════════════════

/// Glassmorphic Card with blur effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppDesign.spaceL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? AppDesign.radiusL),
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}

/// Gradient Button with glow effect
class GlowButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final LinearGradient? gradient;
  final IconData? icon;
  final double? width;
  final bool isLoading;

  const GlowButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.icon,
    this.width,
    this.isLoading = false,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final grad = widget.gradient ?? AppDesign.bookingAccentGradient;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!widget.isLoading) widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
        decoration: BoxDecoration(
          gradient: grad,
          borderRadius: BorderRadius.circular(AppDesign.radiusM),
          boxShadow: _isPressed ? [] : AppDesign.glowShadow(grad.colors.first),
        ),
        child: widget.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.text,
                    style: AppDesign.labelLarge.copyWith(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Icon button with glass background
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final double size;
  final bool hasBadge;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.size = 44,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppDesign.card,
              borderRadius: BorderRadius.circular(size / 3),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppDesign.textSecondary,
              size: size * 0.45,
            ),
          ),
          if (hasBadge)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppDesign.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppDesign.card, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Status chip (Available, Booked, etc.)
class StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const StatusChip({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppDesign.radiusFull),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: AppDesign.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient text
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final LinearGradient gradient;

  const GradientText({
    super.key,
    required this.text,
    required this.style,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}
