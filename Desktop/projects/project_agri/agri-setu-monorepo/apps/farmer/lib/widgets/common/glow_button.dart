import 'package:flutter/material.dart';
import '../../theme/app_design.dart';

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
