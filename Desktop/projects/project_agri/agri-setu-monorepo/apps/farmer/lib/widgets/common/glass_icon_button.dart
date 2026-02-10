import 'package:flutter/material.dart';
import '../../theme/app_design.dart';

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
