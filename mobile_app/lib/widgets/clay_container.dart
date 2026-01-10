import 'package:flutter/material.dart';
import 'package:mobile_app/theme/app_theme.dart';

class ClayContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final Color? color;
  final Color? surfaceColor;
  final double borderRadius;
  final double spread;
  final double
  depth; // Positive for convex (floating), Negative for concave (pressed)
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const ClayContainer({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.color,
    this.surfaceColor,
    this.borderRadius = 20,
    this.spread = 6,
    this.depth = 10,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // If depth is negative, we simulate "Pressed" (Concave/Inner Shadow)
    // However, true inner shadow is complex in Flutter without packages like `neumorphism` or `clay_containers`.
    // Since I cannot use extra packages easily without pub add, I will simulate it
    // or just stick to "Floating" (Convex) vs "Flat".
    // Or I can simulate pressed state by inverting shadow positions and colors or removing shadow.

    // For this implementation, I will focus on the "Floating" (Convex) look described by Claymorphism.
    // "Pressed" will just be lower depth or flat.

    final baseColor = color ?? AppTheme.clayBase;

    // Light source top-left
    final shadowOffset = Offset(spread / 2, spread / 2);
    final lightOffset = Offset(-spread / 2, -spread / 2);

    /* 
      Claymorphism logic: 
      Background same color as container, 
      Bottom-Right Shadow: Darker
      Top-Left Shadow: Lighter (White)
      Rounded Borders: High
    */

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            // Dark Shadow (Bottom Right)
            BoxShadow(
              color: AppTheme.clayShadowDark.withOpacity(0.4),
              offset: shadowOffset,
              blurRadius: spread,
            ),
            // Light Shadow (Top Left)
            BoxShadow(
              color: AppTheme.clayShadowLight,
              offset: lightOffset,
              blurRadius: spread,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
